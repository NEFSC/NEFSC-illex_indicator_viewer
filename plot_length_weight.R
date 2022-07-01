# Length - Weight data
library(dplyr)
library(lubridate)
options(scipen = 100) # to fix VTR serial numbers
ml_wt_wks0510_0608 <- read.csv('ILXSMdata_5-10-22_6-8-22.csv')
ml_wt_wks0609_0616 <- read.csv('ILXSMdata_6-9-22_6-16-22.csv')
ml_wt_wks0617_0622 <- read.csv('ILXSMdata_6-17-22_6-22-22.csv')
ml_wt_wks0623_0630 <- read.csv('ILXSMdata_6-23-22_6-30-22.csv')
# an alternative way to fix 
# lwt_wks23_24 <- lwt_wks23_24 %>%
#   mutate(VTR_SERIAL_NUM = as.numeric(format(VTR_SERIAL_NUM,
#                               scientific = FALSE,
#                               big.mark = '')))

ml_wt_22 <- rbind(ml_wt_wks0510_0608, ml_wt_wks0609_0616,
                  ml_wt_wks0617_0622,ml_wt_wks0623_0630)

vtr_serial_numbers <-unique(ml_wt_22$VTR_SERIAL_NUM)
vessel_names <-unique(ml_wt_22$VESSEL_NAME)

draft_latlons <- read.csv('draft_locations_illex.txt')
for (i in 1:nrow(draft_latlons)){
  draft_latlons$lat[i] <- c(paste0(draft_latlons[i,28],'.',paste0(draft_latlons[i,29])))
  draft_latlons$lon[i] <- c(paste0(draft_latlons[i,31],'.',paste0(draft_latlons[i,32])))
}
tbl_serial_numbers <-unique(draft_latlons$SERIAL_NUM) 
                              
ids <- data.frame(vessel_id = c('STARBRITE', 'DYRSTEN',
                                'PERSISTENCE', 'RELENTLESS',
                                'GABBY G', 'RETRIEVER'),
                  vtr_srl_num = c(33016722060714,
                                  33072500000000,
                                  33059122052212,
                                  41042522052312,
                                  33057522060218, 
                                  41045800000000))
#ENDEAVOUR

draft_latlons$vessel_id <- NA
draft_latlons$VESSEL_NAME <- draft_latlons$vessel_id

# 'TOW_HRS',
dat <- draft_latlons %>%
  dplyr::select(c('IMG_DATE', 'SERIAL_NUM', 'DEPTH',
                'DATE_RECV',  'TENMSQ', 
                'lat', 'lon', 'VESSEL_NAME'))
dat$IMG_DATE <- lubridate::dmy(dat$IMG_DATE)
dat$DATE_RECV <- lubridate::dmy(dat$DATE_RECV)
ml_wt_22$LAND_DATE <-  lubridate::dmy(ml_wt_22$LAND_DATE)

ml_wt_22 <- ml_wt_22 %>%
  mutate(year = year(LAND_DATE),
         month = month(LAND_DATE),
         week = week(LAND_DATE), 
         day = day(LAND_DATE))

dat <- dat %>%
  mutate(year = year(DATE_RECV),
         month = month(DATE_RECV),
         week = week(DATE_RECV), 
         day = day(DATE_RECV))


dt <- left_join(ml_wt_22, dat, by = c('VESSEL_NAME','year','month','week'))
library(RColorBrewer)
library(scales)
library(ggplot2)
library(plotly)
## bring in bathymetry
atl <- marmap::getNOAA.bathy(-80,-63, 33, 46)
atl = fortify.bathy(atl)
blues = colorRampPalette(brewer.pal(9,'Blues'))(25)
bluess = colorRampPalette(brewer.pal(9,'Blues'))(30)
depths <- c(0,50,100,200,300,500,Inf)
blues2 <- blues[c(5,7,9,11,13,24)]
## get coastline from mapdata 
coast = map_data("world2Hires")
coast = subset(coast, region %in% c('Canada', 'USA'))
coast$lon = (360 - coast$long)*-1 




ggplot() +
  geom_contour_filled(data = atl,
                      aes(x=x,y=y,z=-1*z),
                      breaks=c(0,50,100,200,300,500,Inf),
                      size=c(0.3)) + 
  scale_fill_manual(values = blues2, # 5:25
                    name = paste("Depth (m)"),
                    labels = depths) +
  geom_polygon(data = coast, aes(x=lon, y = lat, group = group),
               color = "gray20", fill = "wheat3") +
  coord_sf(xlim = c(-76,-65), ylim = c(35,45),datum = sf::st_crs(4326)) +
  geom_points(data = dt %>% filter(week == 25 & PARAM_TYPE == 'ML'),
               aes(x=lon, y=lat, size = PARAM_VAL_NUM),
               size=c(0.3), 
               col = '#4daf89') + # chl.pal[8] #4daf71
  # NAFO SHELFBREAK 
  geom_polygon(data=shbrk, aes(x=long, y = lat, group = group),
               colour = 'black', fill = NA, lwd = 1.2) +
  xlab('Longitude') + 
  ylab('Latitude') +
  theme_bw()


library(tidyverse)

dt_wt <- dt %>%
  filter(PARAM_TYPE == 'WT') %>%
  rename(weight = PARAM_VALUE_NUM)
dt_ml <- dt %>%
  filter(PARAM_TYPE == 'ML') %>%
  rename(length = PARAM_VALUE_NUM)

dt_wt <- dt_wt[,-c(5:7)]
dt_ml <- dt_ml[,-c(5:7)]

dt2 <- full_join(dt_wt, dt_ml, by = "ORGANISM_ID")
#put all data frames into list
df_list <- list(dt_wt, dt_ml)      

#merge all data frames together
dt2 <- df_list %>% reduce(full_join, by=c('LAND_DATE','AREA_CODE',
                                          'ORGANISM_ID','VESSEL_NAME',
                                          'VTR_SERIAL_NUM','year',
                                          'month','week', 'day.x', 'day.y',
                                          'lat', 'lon',
                                          'IMG_DATE','SERIAL_NUM','DEPTH',
                                          'DATE_RECV', 'TENMSQ'))
write.csv(dt2, 'weight_lengths_22.csv')
library(ggnewscale)

wk25 = dt2 %>% filter(week == 25)
p = ggplot() +
  # geom_contour(data = atl,
  #              aes(x=x,y=y,z=-1*z),
  #              breaks=c(0,50,100,200,500,Inf),
  #              size=c(0.3),
  #              col = 'darkgrey') +
  # geom_contour_filled(data = atl,
  #                                 aes(x=x,y=y,z=-1*z),
  #                                 breaks=c(0,50,100,200,300,500,Inf),
  #                                 size=c(0.3)) +
  # scale_fill_manual(values = blues2, # 5:25
  #                   name = paste("Depth (m)"),
  #                   labels = depths) +
  #new_scale_fill() +
  geom_point(data = wk25,
             aes(x=lon, y=lat, size = length, color = weight)) +
  scale_color_gradient(low = "blue", high = "red") +
  labs(title = 'Week 25', subtitle = '2022') + 
  theme_bw()
ggplot() +
 geom_point(data = wk25,
           aes(x=lon, y=lat, size = length, color = weight)) +
  #scale_color_gradient(low = "blue", high = "red") +
  labs(title = 'Week 25', subtitle = '2022') + 
  theme_bw()             
ggplotly(p)
hist(wk25$length)
hist(wk25$weight)
# Basic histogram
ggplot(wk25, aes(x=weight)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") + 
  labs(title = 'Weights', subtitle = 'Week 25') +
  theme_bw()
ggplot(wk25, aes(x=length)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") + 
  labs(title = 'Length', subtitle = 'Week 25') +
  theme_bw()