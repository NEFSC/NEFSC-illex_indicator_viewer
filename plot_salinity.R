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
# Inshore
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

# Offshore
pa_offsh_22 <- read.csv('PIONEER_OFFSHORE_SURFACE_2022.csv')
pa_offsh_22 <- pa_offsh_22[-1,]
pa_offsh_22$date <- ymd_hms(pa_offsh_22$time)
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
pa_offsh_22 <- pa_offsh_22 %>%
  group_by(date) %>%
  mutate(msal = mean(salinity))
hist(pa_offsh_22$pressure)
length(unique(pa_offsh_22$pressure));mean(pa_offsh_22$pressure)
min(pa_offsh_22$pressure);median(pa_offsh_22$pressure);max(pa_offsh_22$pressure)
pa_offsh_22_ts <- pa_offsh_22 %>%
  dplyr::group_by(year, month, week) %>%
  dplyr::summarise(msal = mean(na.omit(salinity)), 
                   mden = mean(density),
                   mdepth = mean(pressure),
                   mtmp = mean(temperature))

ann_sal_offsh <- pa_offsh_22_ts %>%
  dplyr::group_by(year) %>%
  summarise(mean_sal = mean(msal))

p1 <- pa_offsh_22 %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch=21,size=3,colour='black') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Salinity: Offshore Surface Mooring: Near Surface', 
       subtitle = paste0('Depth:', round(min(pa_offsh_22$pressure),2),':', 
                         round(max(pa_offsh_22$pressure),2), ' M, Mean:', 
                         round(mean(pa_offsh_22$pressure),2), ' M')) +
  ylab('Salinity') +
  scale_fill_discrete(guide='none') +
  theme_minimal()

p2 <- pa_offsh_22 %>%
  ggplot(aes(x = date, y = msal)) +
  geom_line(lwd = 1.4, color = 'darkblue') +
  geom_point(aes(fill = 'darkblue'),pch = 21, size = 3,colour = 'black') +
  geom_hline(yintercept = as.numeric(ann_sal_offsh[1,2]), 
             lty = 2, col = 'darkblue', lwd = 1) +
  labs(title = 'Week 18, 2022', subtitle ='May 01- 07') +
  ylab('Salinity') + 
  xlab('Date') +
  scale_fill_discrete(guide='none') +
  scale_x_date(limit=c(as.Date('2022-05-01'), 
                       as.Date('2022-05-07'))) +
  theme_minimal()

(plot_spacer() + p2) /  (p1)

# Central 
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
