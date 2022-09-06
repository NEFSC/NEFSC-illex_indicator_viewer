setwd('C:/Users/sarah.salois/Documents/squid_data/data')
library('tidyverse')
library(lubridate)
library(ggplot2)
library(dplyr)
library(hrbrthemes)
library(gtable)
library(grid)
library('gridExtra')
library(ggridges)
library(readxl)
sys_states <- read.csv('sys_states.csv')

# step 1
bodywt <- read.csv("illex_bodywts.csv") %>% 
          as.data.frame() %>%
          mutate(HULLNUM = as.character(HULLNUM),
                 YEAR = lubridate::year(DATE),
                 month = lubridate::month(DATE),
                 week = lubridate::week(DATE))
# step 2
bodywt_subann_stats <- bodywt %>%
  group_by(HULLNUM, YEAR, week) %>%
  summarize(nsample = n()
            , wtmin = min(BODYWT)
            , wtmean = mean(BODYWT)
            , wtmax = max(BODYWT)
            , wtstd = sd(BODYWT))

bodywt_sum <- bodywt %>%
              group_by(HULLNUM, YEAR) %>%
              summarize(nsample = n()
                       , wtmin = min(BODYWT)
                       , wtmean = mean(BODYWT)
                       , wtmax = max(BODYWT)
                       , wtstd = sd(BODYWT))


 # ---- Just some plots to see whats going on ---- # 
         # ignore and keep moving to step 3 #

p1 <- ggplot(data = bodywt_sum,
       mapping = aes(x = YEAR,
                     y = wtmean)) +
  geom_line( color = 'black') +
  geom_point(shape = 21, color = 'black',
             fill = '#69b3a2', size = 4) +
  theme_ipsum() +
  theme_light() +
  labs(title = 'Illex body weight (mean)', subtitle = 'Landings data via various processors', x = 'Year', y = 'Weight (g)')+
  geom_errorbar(aes(ymin = wtmean - wtstd, ymax = wtmean + wtstd), width = .2,
                position = position_dodge(.9))

p2 <- ggplot(bodywt_sum,aes(x = YEAR)) +
  geom_line(aes(y = wtmax), color = 'darkred') + 
  geom_point(aes(y = wtmax),shape = 21, color = 'darkred',
             fill = 'darkred', size = 3) +
  geom_line(aes(y = wtmin), color = "steelblue") +
  geom_point(aes(y = wtmin),shape = 21, color = 'steelblue',
             fill = 'steelblue', size = 3) +
  theme_light() +
  # scale_color_manual(values = c('darkred', 'steelblue')) +
  labs(title = 'Illex body weight (min/max)',
       subtitle = 'Minimum = blue, Maximum = red',
       x = 'Year', y = 'Weight (g)') 
pdf('illex_bodywt_sum.pdf')
g1 <- ggplotGrob(p1)
g2 <- ggplotGrob(p2)
g <- rbind(g1, g2, size = "first")
g$widths <- unit.pmax(g1$widths, g2$widths)
grid.newpage()
grid.draw(g) 
dev.off()

grid.arrange(p1, p2, nrow = 1) 

ggplot(data = bodywt_sum,
       mapping = aes(x = YEAR,
                     y = wtmax)) +
  geom_line( color='black') +
  geom_point(shape=21, color="black", fill="#69b3a2", size=6) +
  geom_line( color='black') +
  geom_point(shape=21, color="black", fill="#69b3a2", size=6) +
  theme_ipsum() +
  labs(title = 'Illex body weight', 
       subtitle = 'Landings data via various processors',
       x = 'Year', y = 'Weight (g)')
  
# Step 3: Read in vessel data
vessinfo <- read.csv("CFDBS_vessels_1997-2019.csv") %>%
             mutate(HULLNUM = as.character(HULLNUM)) 

vessinfo_shorter <- left_join(bodywt, vessinfo, by = c("HULLNUM", "YEAR")) %>%
            dplyr::select(c("YEAR", "HULLNUM", "PERMIT", "VESSNAME")) %>%
            unique() %>% 
            arrange(HULLNUM)

# vess_sum <- vessinfo_shorter %>% 
#   group_by(HULLNUM, PERMIT, VESSNAME) %>% 
#   summarize(NYEARS = n_distinct(YEAR)
#            , FYEAR = min(YEAR)
#            , LYEAR = max(YEAR))


# bodywt_sum2 <- left_join(bodywt_sum, 
#                          vessinfo_shorter[c("HULLNUM", "PERMIT", "VESSNAME")])
# 
# bodywt_wk <- left_join(bodywt_yrwk_stats, 
#                          vessinfo_shorter[c("HULLNUM", "PERMIT", "VESSNAME")])

# Step 4
bodywt_subann <- left_join(bodywt_subann_stats , 
                       vessinfo_shorter[c("HULLNUM", "PERMIT", "VESSNAME")])


### ---- add vessel hold type------------------------ ###
# step 5
vesshold <- read_excel("vessel_type_2021.xlsx",
                       sheet = "vessel_type") %>%
  rename(VESSHOLD = Vess_type_Final) %>%
  mutate(VESSHOLD = str_to_upper(VESSHOLD))

vesshold %>% filter(!(VESSHOLD %in% c("ICE", "FT", "RSW"))) %>% 
  dplyr::select("PERMIT", "COMMENT")


## -------------- By week --------------- ##
# step 6

bodywt_subann <- left_join(bodywt_subann , 
                           vessinfo_shorter[c("HULLNUM", "PERMIT", "VESSNAME")])


bodywt_holdtype_subann <- bodywt_subann %>%
  left_join(vesshold, by = c('PERMIT', 'VESSNAME')) %>%
  mutate(VESSHOLD = replace_na(VESSHOLD, "UNKNOWN")) %>% 
  droplevels()

names(bodywt_holdtype_subann) <- tolower(names(bodywt_holdtype_subann))

bodywt_holdtype_subann$vesshold <- ifelse((bodywt_holdtype_subann$permit == 410371 & 
                                      bodywt_holdtype_subann$year <= 2020),
                                   "FT", bodywt_holdtype_subann$vesshold)
bodywt_holdtype_subann$vesshold <- ifelse((bodywt_holdtype_subann$permit == 410371 & 
                                      bodywt_holdtype_subann$year > 2020), 
                                   "RSW", bodywt_holdtype_subann$vesshold)
bodywt_holdtype_subann$vesshold <- ifelse((bodywt_holdtype_subann$permit == 410403 & 
                                      bodywt_holdtype_subann$year <= 2016), 
                                   "FT", bodywt_holdtype_subann$vesshold)
bodywt_holdtype_subann$vesshold <- ifelse((bodywt_holdtype_subann$permit == 410403 & 
                                      bodywt_holdtype_subann$year > 2016), 
                                   "RSW", bodywt_holdtype_subann$vesshold)

bodywt_holdtype_subann$fleet <- ifelse(bodywt_holdtype_subann$vesshold == 'FT', 
                                yes = 'FREEZE', no = NA)  
bodywt_holdtype_subann$fleet <- ifelse(bodywt_holdtype_subann$vesshold %in% c('ICE', 'RSW'),
                                yes = 'WET', no = bodywt_holdtype_subann$fleet)  


bodywt_holdtype_subann_full <- bodywt_holdtype_subann
bodywt_holdtype_subann <- na.omit(bodywt_holdtype_subann) 
bodywt_holdtype_subann$year <- as.factor(bodywt_holdtype_subann$year)
# Add score
bodywt_holdtype_subann$state <- NA # system state info
bodywt_holdtype_subann <- as.data.frame(bodywt_holdtype_subann)
a <- subset(sys_states, score == 'A', select = 'year')
g <- subset(sys_states, score == 'G', select = 'year')
p <- subset(sys_states, score == 'P', select = 'year')
locs1 <- which(bodywt_holdtype_subann$year %in% a$year)
locs2 <- which(bodywt_holdtype_subann$year %in% g$year)
locs3 <- which(bodywt_holdtype_subann$year %in% p$year)
bodywt_holdtype_subann[locs1,17] <- 'Avg'
bodywt_holdtype_subann[locs2,17] <- 'Good'
bodywt_holdtype_subann[locs3,17] <- 'Poor'
setwd('C:/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/general_info')

## --- This is the one I used
# Calculate proportion of each level
# Need to fix this - its across year so the nrow(bodywt_holdtype_subann) 
# should reflect the nrow of that week across years - not total nrow of dataset
proportion <- table(bodywt_holdtype_subann$nsample)/nrow(bodywt_holdtype_subann)

#Draw the boxplot, with the width proportional to the occurence !
# Sub only fishing season
boxplot(data$value ~ data$names , width=proportion , col=c("orange" , "seagreen"))
g <- ggplot(bodywt_holdtype_subann %>% filter(week %in% c(18:44)), 
            aes(x = factor(week), y = wtmean,
                col = fleet), width = proportion) + 
  labs(x = 'Week', y = 'Mean weight (g)') +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  theme_classic() + 
  facet_wrap(~factor(fleet))
png('W_wt_box.png')
g + geom_boxplot()
dev.off()
## ----------------- Other plots -------------------------------- ## 

ggplot(bodywt_holdtype_subann %>% filter(year %in% c(2015,2018,2019)), 
       aes(x = wtmean, y = factor(week), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Mean body weight (g)', y = 'Week',
       title = 'Subsamples from landings') +
  theme_ridges() +
  facet_wrap(~factor(year))

ggplot(bodywt_holdtype_subann %>% filter(year %in% c(2015,2018,2019)), 
       aes(x = wtmean, y = factor(week))) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Mean body weight (g)', y = 'Week',
       title = 'Subsamples from landings across Poor years') +
  theme_ridges() +
  facet_wrap(~factor(fleet))

ggplot(bodywt_holdtype_subann %>% filter(year %in% c(2015,2018,2019)), 
       aes(x = wtmean, y = factor(week))) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Mean body weight (g)', y = 'Week',
       title = 'Subsamples from landings across Good years') +
  theme_ridges() +
  facet_wrap(~factor(fleet))

p3 <- ggplot(bodywt_holdtype_subann %>% filter(fleet == 'WET'), 
       aes(x = wtmean, y = factor(week))) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Mean body weight (g)', y = 'Week',
       title = 'Subsamples from landings: Wet Boats') +
  theme_ridges() +
  facet_wrap(~factor(state))

p4 <-ggplot(bodywt_holdtype_subann %>% filter(fleet == 'FREEZE'), 
       aes(x = wtmean, y = factor(week))) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Mean body weight (g)', y = 'Week',
       title = 'Subsamples from landings: Freezer Trawlers') +
  theme_ridges() +
  facet_wrap(~factor(state))
grid.arrange(p3, p4, ncol = 1) 



p5 <- ggplot(bodywt_holdtype_subann, 
       aes(x = wtmean, y = factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Weight (g)', y = 'Year',
       title = 'Mean body weight') +
  theme_ridges() +
  facet_wrap(~factor(state))


p6 <- ggplot(bodywt_holdtype_subann, 
             aes(x = wtmin, y = factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Weight (g)', y = 'Year',
       title = 'Min body weight') +
  theme_ridges() +
  guides(fill = FALSE) +
    facet_wrap(~factor(state))

p7 <- ggplot(bodywt_holdtype_subann, 
             aes(x = wtmax, y = factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Weight (g)', y = 'Year',
       title = 'Max body weight') +
  theme_ridges() +
  guides(fill = FALSE) +
  facet_wrap(~factor(state))



grid.arrange(p5, p6, p7, nrow = 3) 

### Mean, max, min  ###
ggplot(bodywt_holdtype_subann, 
       aes(x = wtmean, y = factor(year), fill = state)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Weight (g)', y = 'Year',
       title = 'Mean body weight weekly landings') +
  theme_ridges()
# ------- This is for original - not subannual ------ ###
bodywt_holdtype <- bodywt_sum2 %>%
  left_join(vesshold, by = c('PERMIT', 'VESSNAME')) %>%
  mutate(VESSHOLD = replace_na(VESSHOLD, "UNKNOWN")) %>% 
  droplevels()

names(bodywt_holdtype) <- tolower(names(bodywt_holdtype))

bodywt_holdtype$vesshold <- ifelse((bodywt_holdtype$permit == 410371 & 
                                      bodywt_holdtype$year <= 2020),
                                   "FT", bodywt_holdtype$vesshold)
bodywt_holdtype$vesshold <- ifelse((bodywt_holdtype$permit == 410371 & 
                                      bodywt_holdtype$year > 2020), 
                                   "RSW", bodywt_holdtype$vesshold)
bodywt_holdtype$vesshold <- ifelse((bodywt_holdtype$permit == 410403 & 
                                      bodywt_holdtype$year <= 2016), 
                                   "FT", bodywt_holdtype$vesshold)
bodywt_holdtype$vesshold <- ifelse((bodywt_holdtype$permit == 410403 & 
                                      bodywt_holdtype$year > 2016), 
                                   "RSW", bodywt_holdtype$vesshold)

bodywt_holdtype$fleet <- ifelse(bodywt_holdtype$vesshold == 'FT', 
                                yes = 'FREEZE', no = NA)  
bodywt_holdtype$fleet <- ifelse(bodywt_holdtype$vesshold %in% c('ICE', 'RSW'),
                                yes = 'WET', no = bodywt_holdtype$fleet)  


bodywt_wet <- bodywt_holdtype %>% filter(fleet == 'WET')
bodywt_frz <- bodywt_holdtype %>% filter(fleet == 'FREEZE')


bodywt_holdtype_full <- bodywt_holdtype
bodywt_holdtype <- na.omit(bodywt_holdtype_full) 
ggplot(bodywt_holdtype, aes(x = wtmean, y = as.factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Mean body weight (g)', y = 'Year',
       title = 'Subsamples from landings') +
  theme_ridges() 

ggplot(bodywt_holdtype, aes(x = wtstd, y = as.factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Sd of body weight (g)', y = 'Year',
       title = 'Subsamples from landings') +
  theme_ridges() 

ggplot(bodywt_holdtype, aes(x = wtmax, y = as.factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Max body weight (g)', y = 'Year',
       title = 'Subsamples from landings') +
  theme_ridges() 


ggplot(bodywt_holdtype, aes(x = wtmin, y = as.factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Min body weight (g)', y = 'Year',
       title = 'Subsamples from landings') +
  theme_ridges() 

ggplot(bodywt_holdtype, aes(x = wtmax, y = as.factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Max body weight (g)', y = 'Year',
       title = 'Subsamples from landings') +
  theme_ridges() 


ggplot(bodywt_holdtype, aes(x = wtmin, y = as.factor(year), fill = fleet)) +
  geom_density_ridges(alpha = .8, color = 'white',
                      scale = 2.5, rel_min_height = .01) +
  labs(x = 'Min body weight (g)', y = 'Year',
       title = 'Subsamples from landings') +
  theme_ridges() 

###  BOXPLOTS and VIOLIN ###

g <- ggplot(bodywt_holdtype_subann, aes(x = factor(year), y = wtmean, col = fleet))+ 
  labs(x = 'Year', y = 'Mean weight (g)') +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  theme_classic() + 
  facet_wrap(~factor(fleet))

g + geom_boxplot()



g <- ggplot(bodywt_holdtype_subann, aes(x = factor(week), y = wtmean, col = fleet))+ 
  labs(x = 'Week', y = 'Mean weight (g)') +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  theme_classic() + 
  facet_wrap(~factor(state))

g + geom_boxplot()

g <- ggplot(bodywt_holdtype_subann, aes(x = factor(year), y = wtmean, 
                                        col = fleet))+ 
  labs(x = 'Year', y = 'Mean weight (g)') +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  theme_classic() +
  facet_wrap(~factor(state))

g + geom_violin(fill = "gray80", size = 1, alpha = .5)


g <- ggplot(bodywt_holdtype_subann %>% filter(state == 'Good'),
              aes(x = factor(year), y = wtmean, 
                                        col = fleet))+ 
  labs(x = 'Year', y = 'Mean weight (g)') +
  scale_color_brewer(palette = "Dark2", guide = "none") +
  theme_classic() +
  facet_wrap(~factor(state))

g + geom_violin(fill = 'lightgrey', size = 1, alpha = .5)



g + geom_point()
g + geom_jitter(width = .3, alpha = .5)
g + geom_violin(fill = "gray80", size = 1, alpha = .5)
g + geom_violin(fill = "gray80", size = 1, alpha = .5) +
  geom_jitter(alpha = .25, width = .3) +
  facet_wrap(~ factor(state))
#coord_flip()
g + geom_violin(aes(fill = fleet), size = 1, alpha = .5) +
  # geom_boxplot(outlier.alpha = 0, coef = 0,
  #              color = "gray40", width = .2) +
  scale_fill_brewer(palette = "Dark2", guide = "none") +
  coord_flip()






