#Get bathy data
library(marmap) # bathymetry
library(mapdata)
library(ggplot2) # map_data function
library(RColorBrewer)
library(ggthemes) # for plot functions
library(ggspatial) # for plotting functions
library(dplyr) # for pipes
library(lubridate) # for altering dates
library(rgdal) # OGR function
library(sf) # file converter
library(ggnewscale)
library(patchwork) # layout

## Bring in NAFO shelfbreak shapefiles
wd = here::here("shapefiles")
nafo <- rgdal::readOGR(wd,'NAFO_SHELFBREAK') # wd = working directory
plot(nafo) # just looking
proj4string(nafo) = CRS("+proj=longlat +ellps=WGS84")
proj4string(nafo) <- CRS("+init=epsg:4326")

# save an object with only subareas from southern stock component 
# nes <- nafo[na.omit(nafo@data$ZONE %in% c('5Ze', '5Zw', '6A', '6B', '6C')),]

## bring in bathymetry
atl <- marmap::getNOAA.bathy(-80,-64, 33, 45.5)
atl = fortify.bathy(atl)
blues = colorRampPalette(brewer.pal(9,'Blues'))(25)
depths <- c(0,50,100,200,300,Inf)
blues2 <- blues[c(5,7,9,11,13,24)]

## get coastline from mapdata 
coast = map_data("world2Hires")
coast = subset(coast, region %in% c('Canada', 'USA', 'Mexico'))
coast$long = (360 - coast$long)*-1 


# Bottom temps from emolt
emolt = read.csv('emolt_QCed_telemetry_and_wified.csv')
emolt <- emolt[,-1]
# add additional date variables
emolt$datet <- ymd_hms(emolt$datet)
emolt <- emolt %>% 
  mutate(year = year(datet),
         month = month(datet),
         week = week(datet), 
         day = day(datet)) %>%
  as.data.frame()

e_202235 <- emolt %>% filter(year == 2022 & week == 35)
e_202135 <- emolt %>% filter(year == 2021 & week == 35)


e_202234 <- emolt %>% filter(year == 2022 & week == 34)
e_202134 <- emolt %>% filter(year == 2021 & week == 34)


e_202233 <- emolt %>% filter(year == 2022 & week == 33)
e_202133 <- emolt %>% filter(year == 2021 & week == 33)


e_202232 <- emolt %>% filter(year == 2022 & week == 32)
e_202132 <- emolt %>% filter(year == 2021 & week == 32)

e_202231 <- emolt %>% filter(year == 2022 & week == 31)
e_202131 <- emolt %>% filter(year == 2021 & week == 31)

e_202230 <- emolt %>% filter(year == 2022 & week == 30)
e_202130 <- emolt %>% filter(year == 2021 & week == 30)

e_202229 <- emolt %>% filter(year == 2022 & week == 29)
e_202129 <- emolt %>% filter(year == 2021 & week == 29)

e_202228 <- emolt %>% filter(year == 2022 & week == 28)
e_202128 <- emolt %>% filter(year == 2021 & week == 28)

e_202227 <- emolt %>% filter(year == 2022 & week == 27)
e_202127 <- emolt %>% filter(year == 2021 & week == 27)

e_202226 <- emolt %>% filter(year == 2022 & week == 26)
e_202126 <- emolt %>% filter(year == 2021 & week == 26)

e_202225 <- emolt %>% filter(year == 2022 & week == 25)
e_202125 <- emolt %>% filter(year == 2021 & week == 25)


e_202224 <- emolt %>% filter(year == 2022 & week == 24)
e_202124 <- emolt %>% filter(year == 2021 & week == 24)

e_202223 <- emolt %>% filter(year == 2022 & week == 23)
e_202123 <- emolt %>% filter(year == 2021 & week == 23)

e_202222 <- emolt %>% filter(year == 2022 & week == 22)
e_202122 <- emolt %>% filter(year == 2021 & week == 22)

# scale temps

range(na.omit(e_202235$mean_temp)) # 
range(e_202135$mean_temp) # min max

range(na.omit(e_202234$mean_temp)) # 
range(e_202134$mean_temp) # min max

range(na.omit(e_202233$mean_temp)) # 
range(e_202133$mean_temp) # min max

range(na.omit(e_202232$mean_temp)) # mzx
range(e_202132$mean_temp) # min

range(na.omit(e_202231$mean_temp)) # 
range(e_202131$mean_temp) # min

range(na.omit(e_202230$mean_temp)) # maxmax
range(e_202130$mean_temp) # min

range(e_202229$mean_temp) # max
range(e_202129$mean_temp) # min

range(e_202228$mean_temp) # 
range(e_202128$mean_temp) # min,max

range(e_202227$mean_temp) # 
range(e_202127$mean_temp) # min,max

range(e_202226$mean_temp) # 
range(e_202126$mean_temp) # min,max

range(e_202225$mean_temp) # 
range(e_202125$mean_temp) # min,max

range(e_202224$mean_temp) # max
range(e_202124$mean_temp) # min

range(e_202223$mean_temp) # max
range(e_202123$mean_temp) # min
range(e_202222$mean_temp) # max
range(e_202122$mean_temp) # min

# Plot
p1 <- ggplot() + 
  geom_contour_filled(data = atl,
                      aes(x=x,y=y,z=-1*z),
                      breaks=c(0,50,100,200,500,Inf),
                      size=c(0.3)) +
  scale_fill_manual(values = blues2, # 5:20 blues[5:25]
                    #name = paste("Depth (m)"),
                    #labels = depths, 
                    guide = 'none') +
  geom_contour(data = atl,
               aes(x=x,y=y,z=-1*z),
               breaks=c(0,50,100,200,500,Inf),
               size=c(0.3),
               col = 'darkgrey') +
  # NAFO subareas
  geom_sf(data=nafo %>% st_as_sf(), fill = NA, colour = 'Black') +
  new_scale_fill() +
  # Bottom data as points
  geom_point(data = e_202235,
             aes(x = lon, y = lat, color = mean_temp), 
             size = 3) +
  scale_color_gradient(low = "darkblue", 
                       high = "darkred", 
                       limits = c(min(e_202135$mean_temp),
                                  max(e_202135$mean_temp)),
                       guide = 'none') +
  geom_polygon(data = coast, aes(x=long, y = lat, group = group), 
               color = "gray20", fill = "wheat3", alpha = 0.7) +
  coord_sf(xlim = c(-76,-65), ylim = c(35,45),datum = sf::st_crs(4326)) + 
  labs(title = '2022 Mean Bottom Temperature ',
       subtitle = 'Week 35') +
  xlab('Longitude') +
  ylab('Latitude') +
  scale_fill_discrete(guide = 'none') +
  annotation_scale(location = "tl", width_hint = 0.5) +
  annotation_north_arrow(location = "tl",
                         which_north = "true",
                         pad_x = unit(0.75, "in"),
                         pad_y = unit(0.5, "in"),
                         style = north_arrow_fancy_orienteering) +
  theme_bw()


p2 <- ggplot() + 
  geom_contour_filled(data = atl,
                      aes(x=x,y=y,z=-1*z),
                      breaks=c(0,50,100,250,500,Inf),
                      size=c(0.3)) +
  scale_fill_manual(values = blues2, # 5:20
                    name = paste("Depth (m)"),
                    labels = depths, 
                    position = 'bottom') +
  geom_contour(data = atl,
               aes(x=x,y=y,z=-1*z),
               breaks=c(0,50,100,250,500,Inf),
               size=c(0.3),
               col = 'darkgrey') +
  # NAFO subareas
  geom_sf(data=nafo %>% st_as_sf(), fill = NA, colour = 'Black') +
  new_scale_fill() +
  # Bottom data as points
  geom_point(data = e_202135,
             aes(x = lon, y = lat, color = mean_temp),
             size = 3) + # alpha = 0.5
  scale_color_gradient(low = "darkblue", 
                       high = "darkred",
                       limits = c(min(e_202135$mean_temp), 
                                  max(e_202135$mean_temp)),
                       name = paste('Temperature (°C)')) +
  geom_polygon(data = coast, aes(x=long, y = lat, group = group), 
               color = "gray20", fill = "wheat3", alpha = 0.7)+
  coord_sf(xlim = c(-76,-65), ylim = c(35,45),datum = sf::st_crs(4326)) + 
  labs(title = '2021 Mean Bottom Temperature',
       subtitle = 'Week 35') +
  xlab('Longitude') +
  ylab('') +
  theme(legend.position = 'bottom', 
        legend.box = "horizontal", 
        legend.margin = margin()) +
  theme_bw()

# p2 + scale_fill_continuous(guide = guide_legend()) +
#   theme(legend.position="bottom")
# plot
p1 | p2 
