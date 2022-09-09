library(dplyr)
library(lubridate)
library(ggridges)
library(ggplot2)
library(viridis)
library(hrbrthemes)
library(scales)
library(patchwork)

# Note:
# 1 decibar [dbar] = 1 meter sea water [msw]
### -------------- Looking for SMax Intrusions ### -----------------------###
# Check 2 instruments (upstream inshore, near surface frame 7 m depth)
# ---- Upstream Inshore ----# 
up_insh_22 <- read.csv('PIONEER_UPSTREAM_INSHORE_2022.csv') # updated weekly 
up_insh_22 <- up_insh_22[-1,] # remove row of metadata
# up_insh_21 <- read.csv('PIONEER_UPSTREAM_INSHORE_20221.csv') # updated weekly 
# up_insh_21 <- up_off_21[-1,] # remove row of metadata
# adjust / add columns to create time steps of interest
up_insh_22$date <- ymd_hms(up_insh_22$time) # convert to date
up_insh_22$date <- as.Date(up_insh_22$date)

#up_insh_21$date <- ymd_hms(up_off_21$time) # convert to date
# 2022
up_insh_22 <- up_insh_22 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature), 
         depth = as.numeric(depth)) %>%
  as.data.frame()

# Calculate daily mean at 100 meter depth
# 2022
up_insh_22_100m <- up_insh_22 %>% # range is -128 to -26
  dplyr::filter(depth >= -30 & depth <= -20) %>%
  group_by(date) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
ui_100m_22 <- up_insh_22_100m %>%
  group_by(week) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
# # 2021
# up_insh_21_100m <- up_insh_21 %>%
#   dplyr::filter(depth >= -72 & depth <= -68 & month == c(1:5)) %>%
#   group_by(date) %>%
#   mutate(msal = mean(salinity), 
#          mtmp = mean(temperature))
# ui_100m_21 <- up_insh_21_100m %>%
#   group_by(week) %>%
#   mutate(msal = mean(salinity), 
#          mtmp = mean(temperature))

ann_sal_insh <- up_insh_22_100m %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal), 
            mean_tmp = mean(mtmp))
## Plot ##


p1 = up_insh_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 19, size = 1.2,colour = 'darkblue') +
  geom_hline(yintercept = as.numeric(ann_sal_insh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Upstream Inshore Profiler Mooring: 28 M', 
       subtitle = paste0('Depth:', round(min(up_insh_22_100m$depth),2),':', 
                         round(max(up_insh_22_100m$depth),2), ' M, Mean:', 
                         round(mean(up_insh_22_100m$depth),2), ' M')) +
  ylab('Mean Salinity') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()
p2 = up_insh_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_insh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 35, 2022', subtitle ='August 28 - September 03') + # Change date 
  ylab('Mean Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-08-28'), # Change date range
                       as.Date('2022-09-03'))) +
  theme_minimal() + 
  ecodata::theme_ts()
p1t = up_insh_22_100m %>%
  ggplot(aes(x = date, y = mtmp)) +
  geom_line(lwd = 1.4, color = 'darkred') +
  geom_point(aes(fill = 'darkred'),pch = 19, size = 1.2,colour = 'darkred') +
  geom_hline(yintercept = as.numeric(ann_sal_insh[1,3]), 
             lty = 2, col = 'darkred', lwd = 1) +
  labs(title = 'Temperature: Upstream Inshore Profiler Mooring: 28 M', 
       subtitle = paste0('Depth:', round(min(up_insh_22_100m$depth),2),':', 
                         round(max(up_insh_22_100m$depth),2), ' M, Mean:', 
                         round(mean(up_insh_22_100m$depth),2), ' M')) +
  ylab('Mean Temperature') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()

p2t = up_insh_22_100m %>%
  ggplot(aes(x = date, y = mtmp)) +
  geom_line(lwd = 1.4, color = 'darkred') +
  geom_point(aes(fill = 'darkred'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_insh[1,3]), 
             lty = 2, col = 'darkred', lwd = 1) +
  labs(title = 'Week 35, 2022', subtitle ='August 28 - September 03') + # Change date 
  ylab('Mean Temperature') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-08-28'), # Change date range
                       as.Date('2022-09-03'))) +
  theme_minimal() + 
  ecodata::theme_ts()

(p1 + p2) /  (p1t + p2t)



# ---- Near Surface Frame  ----# 
insh_surface_22 <- read.csv('PIONEER_INSHORE_SURFACE_FRAME_2022.csv') # updated weekly 
insh_surface_22 <- insh_surface_22[-1,] # remove row of metadata
# up_insh_21 <- read.csv('PIONEER_UPSTREAM_INSHORE_20221.csv') # updated weekly 
# up_insh_21 <- up_off_21[-1,] # remove row of metadata
# adjust / add columns to create time steps of interest
insh_surface_22$date <- ymd_hms(insh_surface_22$time) # convert to date
insh_surface_22$date <- as.Date(insh_surface_22$date)
#up_insh_21$date <- ymd_hms(up_off_21$time) # convert to date
# 2022
insh_surface_22 <- insh_surface_22 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature), 
         depth = as.numeric(depth)) %>%
  as.data.frame()

# Calculate daily mean at 100 meter depth
# 2022
insh_surface_22_100m <- insh_surface_22 %>% 
  group_by(date) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
ui_100m_22 <- insh_surface_22_100m %>%
  group_by(week) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
# # 2021
# up_insh_21_100m <- up_insh_21 %>%
#   dplyr::filter(depth >= -72 & depth <= -68 & month == c(1:5)) %>%
#   group_by(date) %>%
#   mutate(msal = mean(salinity), 
#          mtmp = mean(temperature))
# ui_100m_21 <- up_insh_21_100m %>%
#   group_by(week) %>%
#   mutate(msal = mean(salinity), 
#          mtmp = mean(temperature))

ann_sal_insh_surf <- insh_surface_22_100m %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal), 
            mean_tmp = mean(mtmp))
## Plot ##


p3 = insh_surface_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 19, size = 1.2,colour = 'darkblue') +
  geom_hline(yintercept = as.numeric(ann_sal_insh_surf[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Inshore Near Surface Frame: 7 M', 
       subtitle = paste0('Depth:', round(min(insh_surface_22_100m$depth),2),':', 
                         round(max(insh_surface_22_100m$depth),2), ' M, Mean:', 
                         round(mean(insh_surface_22_100m$depth),2), ' M')) +
  ylab('Mean Salinity') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()


p4 = insh_surface_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_insh_surf[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 35, 2022', subtitle ='August 28 - September 03') + # Change date 
  ylab('Mean Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-08-28'), # Change date range
                       as.Date('2022-09-03'))) +
  theme_minimal() + 
  ecodata::theme_ts()

p3t = insh_surface_22_100m %>%
  ggplot(aes(x = date, y = mtmp)) +
  geom_line(lwd = 1.4, color = 'darkred') +
  geom_point(aes(fill = 'darkred'),pch = 19, size = 1.2,colour = 'darkred') +
  geom_hline(yintercept = as.numeric(ann_sal_insh_surf[1,3]), 
             lty = 2, col = 'darkred', lwd = 1) +
  labs(title = 'Temperature: Inshore Near Surface Frame: 7 M', 
       subtitle = paste0('Depth:', round(min(insh_surface_22_100m$depth),2),':', 
                         round(max(insh_surface_22_100m$depth),2), ' M, Mean:', 
                         round(mean(insh_surface_22_100m$depth),2), ' M')) +
  ylab('Mean Temperature') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()


p4t = insh_surface_22_100m %>%
  ggplot(aes(x = date, y = mtmp)) +
  geom_line(lwd = 1.4, color = 'darkred') +
  geom_point(aes(fill = 'darkred'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_insh_surf[1,3]), 
             lty = 2, col = 'darkred', lwd = 1) +
  labs(title = 'Week 35, 2022', subtitle ='August 28 - September 03') + # Change date 
  ylab('Mean Temperature') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-08-28'), # Change date range
                       as.Date('2022-09-03'))) +
  theme_minimal() + 
  ecodata::theme_ts()

(p3 + p4) /  (p3t + p4t)


#--- Inshore ---# 
pa_insh_22 <- read.csv('PIONEER_INSHORE_SURFACE_2022.csv')
pa_insh_22 <- pa_insh_22[-1,]
pa_insh_22$date <- ymd_hms(pa_insh_22$time)
pa_insh_22 <- pa_insh_22 %>%
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature)) %>%
  as.data.frame()

pa_insh_22 <- pa_insh_22 %>%
  group_by(date) %>%
  mutate(msal = mean(salinity))
hist(pa_insh_22$pressure)
length(unique(pa_insh_22$pressure));mean(pa_insh_22$pressure)
min(pa_insh_22$pressure);median(pa_insh_22$pressure);max(pa_insh_22$pressure)
pa_insh_22_ts <- pa_insh_22 %>%
  dplyr::group_by(year, month, week) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))

ann_sal_insh <- pa_insh_22_ts %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal))

p1 <- pa_insh_22 %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch=21,size=3,colour='black') +
  geom_hline(yintercept = as.numeric(ann_sal_insh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Inshore Surface Mooring: Near Surface', 
       subtitle = paste0('Depth:', round(min(pa_insh_22$pressure),2),':', 
                         round(max(pa_insh_22$pressure),2), ' M, Mean:', 
                         round(mean(pa_insh_22$pressure),2), ' M')) +
  ylab('Salinity') +
  scale_fill_discrete(guide='none') +
  theme_minimal()

p2 <- pa_insh_22 %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_insh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 18, 2022', subtitle ='May 01- 07') +
  ylab('Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-05-01'), 
                       as.Date('2022-05-07'))) +
  theme_minimal()

(plot_spacer() + p2) /  (p1)

# ---- Offshore ----# 
pa_offsh_22 <- read.csv('PIONEER_OFFSHORE_SURFACE_2022.csv') # updated weekly 
pa_offsh_22 <- pa_offsh_22[-1,] # remove row of metadata
pa_offsh_22$date <- ymd_hms(pa_offsh_22$time) # convert to date
# adjust / add columns to create time steps of interest
pa_offsh_22 <- pa_offsh_22 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature)) %>%
  as.data.frame()
# Calculate daily mean 
pa_offsh_22 <- pa_offsh_22 %>%
  group_by(date) %>%
  mutate(msal = mean(salinity))
# Details about depth associated with the OFFSHORE instrument
hist(pa_offsh_22$pressure) # view histogram of depth 
length(unique(pa_offsh_22$pressure));mean(pa_offsh_22$pressure)
min(pa_offsh_22$pressure);median(pa_offsh_22$pressure);max(pa_offsh_22$pressure)
# Calculate annual mean to add as reference point in figures
# pa_offsh_22_ts <- pa_offsh_22 %>%
#   dplyr::group_by(year, month, week) %>%
#   dplyr::summarise(msal = mean(na.omit(salinity)),
#                    mden = mean(density),
#                    mdepth = mean(pressure),
#                    mtmp = mean(temperature))

# Calculate annual mean to add as reference point in figures
ann_sal_offsh <- pa_offsh_22 %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal))
#### USED THIS FOR VIEWER #####
p1 <- pa_offsh_22 %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 19, size = 1.2,colour = 'darkblue') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Offshore Surface Mooring: Near Surface', 
       subtitle = paste0('Depth:', round(min(pa_offsh_22$pressure),2),':', 
                         round(max(pa_offsh_22$pressure),2), ' M, Mean:', 
                         round(mean(pa_offsh_22$pressure),2), ' M')) +
  ylab('Mean Salinity') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()


p2 <- pa_offsh_22 %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 22, 2022', subtitle ='May 29- June 4') + # Change date 
  ylab('Mean Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-05-29'), # Change date range
                       as.Date('2022-05-30'))) +
  theme_minimal() + 
  ecodata::theme_ts()
# Save figure to correct folder 
png(file = here::here('images/salinity/W_202221_SAL_OFFSHORE.png')) ## Change name, also directory
(plot_spacer() + p2) /  (p1)
dev.off()
temperatureColor <- "#69b3a2"
priceColor <- rgb(0.2, 0.6, 0.9, 1)

# ---- Upstream Offshore ----# 
up_off_22 <- read.csv('PIONEER_UPSTREAM_OFFSHORE_2022.csv') # updated weekly 
up_off_22 <- up_off_22[-1,] # remove row of metadata
up_off_21 <- read.csv('PIONEER_UPSTREAM_OFFSHORE_2021.csv') # updated weekly 
up_off_21 <- up_off_21[-1,] # remove row of metadata
# adjust / add columns to create time steps of interest
up_off_22$date <- ymd_hms(up_off_22$time) # convert to date
up_off_21$date <- ymd_hms(up_off_21$time) # convert to date
# 2022
up_off_22 <- up_off_22 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature), 
         depth = as.numeric(depth)) %>%
  as.data.frame()
# 2021
up_off_21 <- up_off_21 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature), 
         depth = as.numeric(depth)) %>%
  as.data.frame()

# Calculate daily mean at 100 meter depth
# 2022
up_off_22_100m <- up_off_22 %>% # range is -128 to -26
  dplyr::filter(depth > -102 & depth < -98) %>%
  group_by(date) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
uo_100m_22 <- up_off_22_100m %>%
  group_by(week) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
# 2021
up_off_21_100m <- up_off_21 %>%
  dplyr::filter(depth > -102 & depth < -98 & month == c(1:5)) %>%
  group_by(date) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
uo_100m_21 <- up_off_21_100m %>%
  group_by(week) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
## Plot ##
ann_sal_offsh <- up_off_22_100m %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal))

p0 = ggplot(up_off_22_100m, aes(x = date)) +
  
  geom_line(aes(y=msal), size=2, color=priceColor) + 
  geom_line(aes(y=mtmp / coeff), size=2, color=temperatureColor) +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Mean Salinity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Mean Temperature (Celsius °)")
  ) + 
  
  theme_classic() +
  
  theme(
    axis.title.y = element_text(color = priceColor, size=13),
    axis.title.y.right = element_text(color = temperatureColor, size=13)
  ) +
  
  ggtitle("2022 Upstream Offshore Profiler Mooring: 100 M")
p1 = up_off_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 19, size = 1.2,colour = 'darkblue') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Upstream Offshore Profiler Mooring: 100 M', 
       subtitle = paste0('Depth:', round(min(up_off_22_100m$pressure),2),':', 
                         round(max(up_off_22_100m$pressure),2), ' M, Mean:', 
                         round(mean(up_off_22_100m$pressure),2), ' M')) +
  ylab('Mean Salinity') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()
p2 = up_off_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 25, 2022', subtitle ='June 19 - June 25') + # Change date 
  ylab('Mean Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-06-18'), # Change date range
                       as.Date('2022-06-24'))) +
  theme_minimal() + 
  ecodata::theme_ts()

p1 = up_off_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 19, size = 1.2,colour = 'darkblue') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Upstream Offshore Profiler Mooring: 100 M', 
       subtitle = paste0('Depth:', round(min(up_off_22_100m$pressure),2),':', 
                         round(max(up_off_22_100m$pressure),2), ' M, Mean:', 
                         round(mean(up_off_22_100m$pressure),2), ' M')) +
  ylab('Mean Salinity') +
  xlab('Date') +
  scale_fill_discrete(guide = 'none') +
  theme_minimal()+
  theme(axis.title.x = element_text(size = 15),
        axis.title.y = element_text(size = 15),
        axis.text = element_text(size = 15)) +
  ecodata::theme_ts()


(plot_spacer() + p2) /  (p1)


# ---- Central Offshore ----# 
c_off_22 <- read.csv('PIONEER_CENTRAL_OFFSHORE_2022.csv') # updated weekly 
c_off_22 <- c_off_22[-1,] # remove row of metadata
c_off_21 <- read.csv('PIONEER_CENTRAL_OFFSHORE_2021.csv') # updated weekly 
c_off_21 <- c_off_21[-1,] # remove row of metadata
c_off_22$date <- ymd_hms(c_off_22$time) # convert to date
c_off_21$date <- ymd_hms(c_off_21$time) # convert to date

# adjust / add columns to create time steps of interest
# 2022
c_off_22 <- c_off_22 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature)) %>%
  as.data.frame()
# 2021
c_off_21 <- c_off_21 %>% 
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature), 
         depth = as.numeric(depth)) %>%
  as.data.frame()

# Calculate daily mean at 100 meter depth
# 2022
c_off_22_100m <- c_off_22 %>% # range is -128 to -26
  dplyr::filter(depth > -102 & depth < -98) %>%
  group_by(date) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
# 2021
c_off_21_100m <- c_off_21 %>%
  dplyr::filter(depth > -102 & depth < -98 & month == c(1:5)) %>%
  group_by(date) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))


# Plot
coeff <- 10

ggplot(c_off_22_100m, aes(x=date)) +
  geom_line(aes(y=msal), size=2, color='darkorange') + 
  geom_line(aes(y=mtmp), size=2, color='darkblue') +
    scale_y_continuous(
    # Features of the first axis
    name = "Mean Salinity",
    # Add a second axis and specify its features
    sec.axis = sec_axis(~., name="Mean Temperature (Celsius °)")) + 
    #theme_ipsum() +
    theme(axis.title.y = element_text(color = 'darkorange', size=13),
    axis.title.y.right = element_text(color = 'darkblue', size=13)) +
    ggtitle("Offshore Surface Mooring: Near Surface")

c0_100m_21 <- c_off_21_100m %>%
  group_by(week) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
c0_100m_22 <- c_off_22_100m %>%
  group_by(week) %>%
  mutate(msal = mean(salinity), 
         mtmp = mean(temperature))
# TEMPERATURE
ggplot() +
  geom_line(data = c0_100m_22, aes(x = week, y = mtmp), 
            size=2, color = 'brown') + 
  geom_line(data = c0_100m_21, aes(x = week, y = mtmp), 
            size=2, color = 'darkblue') +
  labs(title = 'Temperature: Central Offshore Profiler Mooring', 
       subtitle = paste0('Mean Depth : ', round(mean(c0_100m_22$depth),2))) +
  ylab('Mean Salinity') +
  xlab('Week') +
  scale_color_manual(values = tcols, name = "Years") +
  theme_minimal() + 
  ecodata::theme_ts()

# SALINITY 
scols <- c(
  '2022' = "grey60",
  '2021' = "blue"
)
ggplot() +
  geom_line(data = c0_100m_22, aes(x = week, y = msal), 
            size=2, color = 'brown') + 
  geom_line(data = c0_100m_21, aes(x = week, y = msal), 
            size=2, color = 'darkblue') +
  labs(title = 'Salinity: Central Offshore Profiler Mooring', 
       subtitle = paste0('Mean Depth : ', round(mean(c0_100m_22$depth),2))) +
  ylab('Mean Salinity') +
  xlab('Week') +
  scale_color_manual(values = scols, name = "Years")
  theme_minimal() + 
  ecodata::theme_ts()

# Add temperature - ** look for bottom from offshore
# Value used to transform the data
coeff <- .4

# A few constants
temperatureColor <- "#69b3a2"
temperatureColor <- "#69b3a2"
priceColor <- rgb(0.2, 0.6, 0.9, 1)
# ------- This one may go on website
ggplot(c_off_22_100m, aes(x=date)) +
  
  geom_line(aes(y=msal), size=2, color=priceColor) + 
  geom_line(aes(y=mtmp / coeff), size=2, color=temperatureColor) +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Mean Salinity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Mean Temperature (Celsius °)")
  ) + 
  
  theme_classic() +
  
  theme(
    axis.title.y = element_text(color = priceColor, size=13),
    axis.title.y.right = element_text(color = temperatureColor, size=13)
  ) +
  
  ggtitle("2022 Central Offshore Profiler Mooring: 100 M")


## Plot ##
p1 = ggplot(c_off_22_100m, aes(x = date)) +
  
  geom_line(aes(y=msal), size=2, color=priceColor) + 
  geom_line(aes(y=mtmp / coeff), size=2, color=temperatureColor) +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Mean Salinity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Mean Temperature (Celsius °)")
  ) + 
  
  theme_classic() +
  
  theme(
    axis.title.y = element_text(color = priceColor, size=13),
    axis.title.y.right = element_text(color = temperatureColor, size=13)
  ) +
  
  ggtitle("2022 Central Offshore Profiler Mooring: 100 M")
ann_sal_coffsh <- c_off_22_100m %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal))
p2 = c_off_22_100m %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_coffsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 23, 2022', subtitle ='June 05- June 09') + # Change date 
  ylab('Mean Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-06-05'), # Change date range
                       as.Date('2022-06-09'))) +
  theme_minimal() + 
  ecodata::theme_ts()
(plot_spacer() + p2) /  (p1)


# Save figure to correct folder 
# png(file = here::here('images/salinity/W_202225_UP_INSH_SURF_SAL.png')) ## Change name, also directory
# (p1 + p2) /  (p3 + p4)
# dev.off()
# pdf(file = here::here('images/salinity/W_202225_UP_INSH_SURF_SAL.pdf', 
#                       height = 7, width = 10)) ## Change name, also directory
# (p1 + p2) /  (p3 + p4)
# dev.off()

# ------- This is Sal + Temp on same plot --------- #
ggplot(c_off_21_100m, aes(x=date)) +
  
  geom_line(aes(y=msal), size=2, color=priceColor) + 
  geom_line(aes(y=mtmp / coeff), size=2, color=temperatureColor) +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Mean Salinity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~.*coeff, name="Mean Temperature (Celsius °)")
  ) + 
  
  theme_classic() +
  
  theme(
    axis.title.y = element_text(color = priceColor, size=13),
    axis.title.y.right = element_text(color = temperatureColor, size=13)
  ) +
  
  ggtitle("2021 Central Offshore Profiler Mooring: 100 M")


# This one does not change the axis using coeff because temp is lower than sal
ggplot(pa_offsh_22, aes(x=date)) +
  
  geom_line(aes(y=msal), size=2, color=priceColor) + 
  geom_line(aes(y=temperature), size=2, color=temperatureColor) +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Mean Salinity",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~., name="Mean Temperature (Celsius °)")
  ) + 
  
  theme_ipsum() +
  
  theme(
    axis.title.y = element_text(color = priceColor, size=13),
    axis.title.y.right = element_text(color = temperatureColor, size=13)
  ) +
  
  ggtitle("Offshore Surface Mooring: Near Surface")


coeff = 1

ggplot(c0_100m_22, aes(x=date)) +
  
  stat_count(aes(y=mtmp), geom = "bar", size=.1,
            fill=temperatureColor, color="black", alpha=.4) + 
  geom_line( aes(y=msal), size=2, color=priceColor) +
  
  scale_y_continuous(
    
    # Features of the first axis
    name = "Salinity)",
    
    # Add a second axis and specify its features
    sec.axis = sec_axis(~., name="Temperature (Celsius °)")
  ) + 
  
  theme_ipsum() +
  
  theme(
    axis.title.y = element_text(color = temperatureColor, size=13),
    axis.title.y.right = element_text(color = priceColor, size=13)
  ) +
  
  ggtitle("Central")










# ---- Central ----- # 
pa_22 <- read.csv('PIONEER_PMCO_CTD_2022.csv')
pa_22 <- pa_22[-1,]
pa_22$date <- ymd_hms(pa_22$time)
pa_22 <- pa_22 %>%
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature)) %>%
  as.data.frame()

pa_22_ts <- pa_22 %>%
  dplyr::group_by(date) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))


p1 <- pa_22_ts %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch=21,size=3,colour='black') +
  geom_hline(yintercept = as.numeric(ann_sal[2,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Central Offshore Profiler Mooring: Wire-Following Profiler', 
       subtitle = paste0('Depth:', round(min(pa_22$pressure),2),':', 
                         round(max(pa_22$pressure),2), ' M, Mean:', 
                         round(mean(pa_22$pressure),2), ' M')) +  
  ylab('Salinity') + 
  scale_fill_discrete(guide='none') +
  theme_minimal()


p2 <- pa_22_ts %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal[2,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 18, 2022', subtitle ='May 01- 07') +
  ylab('Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-05-01'), 
                       as.Date('2022-05-07'))) +
  theme_minimal()

(plot_spacer() + p2) /  (p1)

##### --- extra ---------- #####
pa_21 <- read.csv('PIONEER_PMCO_CTD_2021.csv')
pa_21$date <- ymd_hms(pa_21$time)
pa_21 <- pa_21[-1,]
pa_21 <- pa_21 %>%
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature)) %>%
  as.data.frame()

pa_21_ts <- pa_21 %>%
  dplyr::group_by(date) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))


pa_min_21_ts <- pa_21 %>%
  filter(pressure %in% c(25:35)) %>%
  dplyr::group_by(year, month, week) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))

pa_med_21_ts <- pa_21 %>%
  filter(pressure %in% c(70:80)) %>%
  dplyr::group_by(year, month, week) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))

pa_max_21_ts <- pa_21 %>%
  filter(pressure %in% c(100:128)) %>%
  dplyr::group_by(year, month, week) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))








unique(pa_21_test$mdepth)
unique(pa_21$pressure)
range(pa_21$pressure)
hist(pa_21$pressure)
min(pa_21$pressure)
median(pa_21$pressure)
max(pa_21$pressure)
mean(pa_21$pressure)

pa_22 <- read.csv('PIONEER_PMCO_CTD_2022.csv')
pa_22 <- pa_22[-1,]
pa_22$date <- ymd_hms(pa_22$time)
pa_22 <- pa_22 %>%
  mutate(year = year(date),
         month = month(date),
         week = week(date), 
         day = day(date),
         date = as.Date(date),
         density = as.numeric(density), 
         pressure = as.numeric(pressure),
         temperature = as.numeric(temperature)) %>%
  as.data.frame()

pa_22_ts <- pa_22 %>%
  dplyr::group_by(date) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))

pa_22_test <- pa_22 %>%
  dplyr::group_by(year, month, week) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))
pa_ts_original <- rbind(pa_21_ts, pa_22_ts)

pa_ts <- rbind(pa_21_test, pa_22_test)
pa_ts <- pa_ts %>%
  mutate(year = year(date),
         month = month(date),
         week = week(date)) 
pa_ts <- pa_ts %>%
  mutate(year = as.factor(year))
hex <- hue_pal()(2)
ann_sal <- pa_ts %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal))

pa_ts %>%
  dplyr::group_by(year) %>%
  dplyr::filter(week %in% c(1:19)) %>%
  ggplot(aes(x = week, y = msal, group = year, 
             color = year, fill = year)) +
  geom_line(lwd = 1.4) +
  geom_point(aes(fill=factor(year)),pch=21,size=3,colour='black') +
  geom_hline(yintercept = as.numeric(ann_sal[1,2]), 
             lty = 2, col = hex[1], lwd = 1) +
  geom_hline(yintercept = as.numeric(ann_sal[2,2]), 
             lty = 2, col = hex[2], lwd = 1) +
  labs(title = 'Salinity: Central Offshore Profiler Mooring: Wire-Following Profiler', 
       subtitle = 'Depth: range (25.6 - 128.8 Meters), mean (72.5 Meters)') +
  ylab('Salinity') + 
  labs(fill = 'Year', color = 'Year') +
  theme_minimal()
pa_ts %>%
  dplyr::group_by(year) %>%
  dplyr::filter(week %in% c(1:19)) %>%
  ggplot(aes(x = week, y = msal, group = year, 
             color = year, fill = year)) +
  geom_line(lwd = 1.4) +
  geom_point(aes(fill=factor(year)),pch=21,size=3,colour='black') +
  geom_hline(yintercept = as.numeric(ann_sal[1,2]), 
             lty = 2, col = hex[1], lwd = 1) +
  geom_hline(yintercept = as.numeric(ann_sal[2,2]), 
             lty = 2, col = hex[2], lwd = 1) +
  labs(title = 'Salinity: Central Offshore Profiler Mooring: Wire-Following Profiler', 
       subtitle = 'Depth: range (25.6 - 128.8 Meters), mean (72.5 Meters)') +
  ylab('Salinity') + 
  labs(fill = 'Year', color = 'Year') +
  theme_minimal()
p0 <- pa_21_ts %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkorange') +
  geom_point(aes(fill = 'darkgreen'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal[1,2]), 
             lty = 2, col = 'darkorange', lwd = 1) +
  ggtitle('Salinity Time Series') +
  ylab('Salinity') + 
  #labs(fill = 'Year', color = 'Year') +
  #guides(fill=FALSE) +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2021-01-01'), 
                       as.Date('2021-05-07'))) + 
  theme_minimal()

ggplot() + 
  geom_line(data = pa_21_ts, aes(x = date, y = msal), color = "darkred") + 
  geom_line(data = pa_22_ts, aes(x = date, y = msal), color="steelblue") +
  theme_minimal()


p1 <- pa_22_ts %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch=21,size=3,colour='black') +
  geom_hline(yintercept = as.numeric(ann_sal[2,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Central Offshore Profiler Mooring: Wire-Following Profiler', 
       subtitle = paste0('Depth:', round(min(pa_22$pressure),2),':', 
                         round(max(pa_22$pressure),2), ' M, Mean:', 
                         round(mean(pa_22$pressure),2), ' M')) +  
  ylab('Salinity') + 
  scale_fill_discrete(guide='none') +
  theme_minimal()

  
p2 <- pa_22_ts %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal[2,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 18, 2022', subtitle ='May 01- 07') +
  ylab('Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-05-01'), 
                       as.Date('2022-05-07'))) +
  theme_minimal()

(plot_spacer() + p2) /  (p1)

# p1 + inset_element(p2, 0.6, 0.6, 1, 1) + theme_classic()
