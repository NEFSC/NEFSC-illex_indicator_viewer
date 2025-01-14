Weekly Indicators
================

``` r
 # code_fold: hide
 #    toc: true
 #    toc_depth: 2
 #    toc_float: true
 #    number_sections: false
```

``` r
# define paths
#base.dir <- 'https://github.com/khyde/SquidSquad.git'
base.dir <- 'C:/Users/sarah.salois/Desktop/github/khyde/SquidSquad/'
base.url <- '/'
fig.path <- 'images/'

# this is where figures will be sent
paste0(base.dir, fig.path)

# this is where markdown will point for figures
paste0(base.url, fig.path)


#knitr::include_graphics('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/SquidSquadV1.png')
# p5 <- ggdraw() + draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/SquidSquadV1.png', scale = 0.5)
# plot_grid(p5)


# <div style="display: flex;">
```

<img src="/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/SquidSquadV1.png" style="width:20.0%" />

------------------------------------------------------------------------

> Weekly updates for oceanographic indicators for the Northern Shortfin
> Squid, *Illex illecebrosus*.

------------------------------------------------------------------------

This page is aimed to provide near-real-time observations of relevant
oceanographic conditions in the Northwest Atlantic to aid in our
understanding of the patterns of availability of *Illex*. This page will
be updated weekly and weekly observations will be retained and
accessible via the table of contents in the upper left hand corner of
this page. \*\*\*

# May

------------------------------------------------------------------------

> Oceanographic conditions for the month of May 2022

The plots below contain mapped images of Sea Surface Temperature (SST)
and Chlorophyll A (CHL) and the associated frontal dynamics for both.
Additionally, you will find the Jenifer Clark charts for this week.

``` r
# This bit is an updated way to add in .png's, hopefully use to automate
# Need to decide on naming scheme and folder allocation
rundate <- "0505" 
# or maybe we could pull from weekly folder 'runweek'
# here::here("images/desired.png") # gets path 
# here::here("images/chl/chl_0505.png") # gets path 
#knitr::include_graphics(here::here("images/chl/chl_0505.png"))
knitr::include_graphics(here::here(paste0("images/chl/chl_", rundate, ".png")))
# Another way to include images
```

## Week 20 (May 8 - May 14)

<div class="fluid-row">

<div class="col-md-6">

**JCC May 09, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0509.png)

</div>

<div class="col-md-6">

**JCC May 11, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0511.png)

</div>

</div>

## Week 19 (May 2-8)

**Chlorophyll**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/chl/chl_0505.png)

<div class="fluid-row">

<div class="col-md-6">

**JCC May 04, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0504.png)

</div>

<div class="col-md-6">

**JCC May 06, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0506.png)

</div>

</div>

AG: Notes two WCRs in our region – both connected to the Gulf Stream
with individual Squid bridges or streamers.

**Mean Salinity (Pioneer Array, CENTRAL)**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/salinity/W_202219-SAL-CENTRAL.png)

**Mean Salinity (Pioneer Array, INSHORE)**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/salinity/W_202219-SAL-INSH.png)

**Mean Salinity (Pioneer Array, OFFSHORE)**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/salinity/W_202219-SAL-OFFSH.png)

**YTD : Mean Salinity (Pioneer Array, w/2021 reference)**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/salinity/A_2021-2022-SAL-CENTRAL.png)

``` r
# Trial run : 
# This works in chunk but wont knit **
jc_weekly <- list.files(here::here('images/jc_charts'), 
                        pattern = '.png', 
                        full.names = TRUE)
knitr::include_graphics(jc_weekly)
```

``` r
# This works in chunk but wont knit **

knitr::include_graphics(here::here(c("images/jc_charts/jc_0425.jpg", 'images/jc_charts/jc_0427.jpg')))
```

## Week 17 (April 25 - May 1)

<div class="fluid-row">

<div class="col-md-6">

**JCC April 25, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0425.png)

</div>

<div class="col-md-6">

**JCC April 27, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0427.png)

</div>

</div>

# April

------------------------------------------------------------------------

## Week 15 (April 11 - April 17)

<div class="fluid-row">

<div class="col-md-6">

**JCC April 11, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0411.png)

</div>

<div class="col-md-6">

**JCC April 13, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0413.png)

</div>

</div>

AG: Things are heating up with really warm GS water closing in on the
shelf break near 67W!

-   4/11: As Adrienne predicted last week, there might be a ring forming
    near 67W! And look at the temperature difference between the ring
    water (72F) and the shelf water (48F) next to each other!

-   4/13: The Gulf Stream has a mind of its own! Look at the huge trough
    near 69-70W now!

GG: Some remarkable processes revealed in this image, including a
possible squid bridge to the shelfbreak.

AM: Lots going on out there to keep track of as we inch closer to squid
season. No signs of squid yet, other than some large ones in the bellies
of tuna offshore

## Week 14 (April 4 - April 10)

<div class="fluid-row">

<div class="col-md-6">

**JCC April 06, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0406.png)

</div>

<div class="col-md-6">

**JCC April 08, 2022**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_0408.png)

</div>

</div>

AG: (4/6/22) There is one WCR on the shelf break and a large streamer
along the MAB shelf. A lot of activity to the east of the Ring-meander
set up at 65W.

-   Magdalena who just came back visiting the NESC, notes the water is
    warm out there

AG: (4/8/22) WCR forming at 62-64W and the nice shelf-streamers to just
east of it and then down along the GS crest’s leading edge.

-   This shelf water (blue band) is also going to interact with the WCR
    at 60W in the coming week!

**April Salinity Time Series (Pioneer Array, *in-situ* data)**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/salinity/pa_0422.png)

------------------------------------------------------------------------

# General Information

------------------------------------------------------------------------

## Major Canyons

------------------------------------------------------------------------

[Major
Canyons](https://portal.midatlanticocean.org/visualize/#x=-74.00&y=39.00&z=7&logo=true&controls=true&dls%5B%5D=true&dls%5B%5D=1&dls%5B%5D=3944&basemap=ocean&themes%5Bids%5D%5B%5D=28&tab=active&legends=false&layers=true)

![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/general_info/aggCPUEplot_canyons.png)

``` r
# 
```

## Body weight trends across years

------------------------------------------------------------------------

A quick look at the average body weight data from 1997 through 2019. The
data were derived via subsamples collected from landings from various
Illex processors. Colors correspond to Paul Rago’s qualitative measures
of system state, where green indicates a ‘Good’ year, pink an ‘Average’
year and blue a ‘Poor’ year.

![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/general_info/wts_by_state.png)

The figure below parses out the same information (mean body weight) for
each week across individual fishing fleets. Here, Wet boats refer to
vessels with refrigerated sea water or ice holds. ::::
{class=‘fluid-row’}

<div class="col-md-6">

![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/general_info/wts_by_fleet.png)

</div>

<div class="col-md-6">

![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/general_info/wts_by_flt_yr.png)

</div>

::::

## Fishing depths 2021 Fishing Season

------------------------------------------------------------------------

The figure below highlights the 100 meter isobath and associated fishing
depths throughout the 2021 season.

![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/general_info/ft_locs_depth-with_bathy.png)

## NAFO subareas

------------------------------------------------------------------------

This shape file depicts a range of 20 meters inshore of the shelf break
(200m isobath)

``` r
library(mapdata) # dist2isobath
library(marmap)  # getNOAA.bathy
## bring in bathymetry data from marmap package
pt.baty415 <- getNOAA.bathy(lon1 = -66, lon2 = -76, 
                            lat1 = 35, lat2 = 44, 
                            resolution = 1) #41.5
## get coastline from mapdata 
reg = map_data("world2Hires")
reg = subset(reg, region %in% c('Canada', 'USA', 'Mexico'))
reg$long = (360 - reg$long)*-1 
```

``` r
wd =  here::here('shapefiles/')
nafo_shbr <- readOGR(wd,'NAFO_SHELFBREAK', verbose = FALSE)
inshr <- nafo_shbr[nafo_shbr@data$SUBAREA %in% c('NAFO_5ZE_INSHORE', 'NAFO_5ZW_INSHORE','NAFO_6A_INSHORE', 'NAFO_6B_INSHORE','NAFO_6C_INSHORE'),]
```

``` r
# This chunk will extract data across NAFO_SHELFBREAK to get mean values 
# for each subarea

# path = '/nadata/PROJECTS/IDL_PROJECTS/ILLEX_INDICATORS/R_SCRIPTS/SALINITY/RASTERS/WEEKLY'
# bricks <- list.files(path = path,
#                      pattern = glob2rx('b_ww_sal_222m*.tif'),
#                      full.names = TRUE)
# k = 13 # 2020
# btmp <- brick(bricks[k])
# btmp@data@names <- as.numeric(c(1:52))
# tmp2 <- subset(tmp, week == weeks[j])
# rtmp = raster::subset(btmp, which(btmp@data@names == weeks[j]))
# rtmp <- raster('test_inshore.tif')
# sal_222m <-  raster::extract(rtmp, inshr, weights = FALSE,
#                              fun = mean, na.rm = TRUE) 
# #sal_222m[1:5]
```

``` r
ggplot() + 
  geom_polygon(data = reg, aes(x=long, y = lat, group = group), 
               color = "gray20", fill = "wheat3") +
  coord_sf(xlim = c(-80,-66), ylim = c(33,47)) + 
  geom_polygon(data = inshr, aes(x = long, y = lat, 
                                 group = group, fill = id), 
               color = 'black') +
  # geom_polygon(data = mjr_canyons, aes(x = long, y = lat, 
  #                                      group= group, fill = id), 
  #              color = 'black') +
  # scale_fill_discrete(name ='Canyons',
  #                     labels = c('Hudson', 'Wilmington', 'Norfolk')) +
  geom_contour(data = pt.baty415, aes(x = x, y = y, z = z), 
               breaks = c(-100,-200), colour ="gray20", size = 0.7) +
  scale_fill_discrete(name ='NAFO Subareas',  
                      labels = c('5ze', '5zw', '6a', '6b', '6c'))+
  
  ggtitle(paste0('NES Region')) + 
  theme_minimal()
```

![](view_weekly_indicators_files/figure-gfm/unnamed-chunk-8-1.png)<!-- -->

``` r
# wd = ('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad')
# canyons <- readOGR(wd, 'major_canyons')
# # reproject data
# # Transform units from UTC (meters) to LatLon (decimal degrees)
# canyons <- spTransform(canyons, CRS('+init=epsg:4326')) # this worked once and now wont
# canyons <- spTransform(canyons,
#                       CRSobj = '+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
# crs(canyons) # check
# extent(canyons) # check
# mjr_canyons <- canyons[canyons@data$Name %in% c('Norfolk Canyon',
#                                                 'Wilmington Canyon',
#                                                 'Hudson Canyon'),]
# 
# # different trys to fix projection (longitudes are wrong, extent )
# 
# canyons.sf <- st_as_sf(canyons, crs = '+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0')
# extent(canyons) <- c(-74.34716, -65.91845, 33.74994,37.5575) # was -94.34716,  -85.91845
# 
# # Another try
# canyons.sf <- st_set_crs(canyons, "+proj=utm +zone=18 +ellps=GRS80 +datum=NAD83") 
# canyons.sf <- st_set_crs(canyons.sf, 
#                          '+init=epsg:4326 +proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0') 
# test.sp <- canyons.sf %>% as("Spatial") # From sf to spatial
# extent(test.sp)
# 
# canyons@polygons@coords
# canyons$long = (360 - canyons$long)*-1 
# extent(canyons_WGS84)
```

# 2021 Case Study

> JULY 25- 31: Industry noted that squid seemed to have disappeared off
> the shelf after being present in high abundance for the last few
> months.

Looking into the oceanographic conditions, team realized there was an
increase in sea surface temperature of about 5 degrees over the course
of one week. Additionally, they noted continued westward propagation of
warm ring/GS water, hypothesized to be dispersing or redistributing the
squid.

Below are some figures generated and annotated by Avijit Gangopadhyay
and Glen Gawarkiewicz

<div class="fluid-row">

<div class="col-md-6">

**JCC: July 23 2021**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_72321.png)

</div>

<div class="col-md-6">

**JCC: July 26 2021**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_72621.png)

</div>

</div>

<div class="fluid-row">

<div class="col-md-6">

**JCC: August 2 2021**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_8221.png)

</div>

<div class="col-md-6">

**JCC: August 4 2021**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/jc_charts/jc_8421.png)

</div>

</div>

Avijit noted: Temperature along the shelfbreak (from SNE to south of
Georges Bank) was about 75F on 7/23/21, increases to about 78-80 on
7/26/21 with mostly westward flow along the shelf break (below Georges
Bank) with another WCR covering the SNE shelf (this WCR has colder shelf
water in its core – this happened due to the WCR entraining a shelf
streamer the previous week). Finally, the whole shelfbreak seems to be
warm with temperature at about 79-81 all along SNE and South of the
Northeast Channel.

-   There is an overall tendency of the warm GS/Ring water flowing
    westward and flooding the shelfbreak. Is this interacting or part of
    the shelf break jet itself?

-   High temperature all along the shelf break with a train of
    along-shelf features more like a warm blob. Could it be a new marine
    heat wave?

**In-situ Salinity time series for the month of July 2021 (from Pioneer
Array)**
![](/Users/sarah.salois/Documents/github/ssalois1/NEFSC-illex_indicator_viewer/images/salinity/pa_0721.png)

Glen noted: “About a week ago there was a big drop (nearly 1 psu) in
salinity at the inshore Pioneer Array mooring at 7 m depth. This is
indicative of a big retreat of the slope/ring water. The salinity
dropped from around 34.2 to around 33.2 on July 27. Salinities on the
outer shelf were very high during the Armstrong cruise the second half
of June. The shelf break front was in an anomalously shoreward position,
probably 20 NM shoreward of the usual position during the Armstrong
cruise June 18-July 2. The shelf break front also was anomalously
onshore south of Hudson Canyon recently from Rutgers glider transects.
What is interesting over the past 2-3 months is the large number of
rings. Ring influence on the outer shelf has been pronounced throughout
the entire MAB. I wonder if the front popping back to its normal
position has occurred over a large area. We will have to think about
ways to test this (altimeter?).”

-   This is really important to figure out why a pulse would end as well
    as why it would begin.

Avijit’s response: “We should look at altimetry. Contours and their
movement as well as cross track velocities which will resolve the SBF
better. That will tell us a lot. We could also look at winds! And
offshore changes might be captured by the few argo floating in these
rings. Their trajectories might have changed from a ring-silo
configuration to a ring-coalescence configuration.”

> AUGUST 7, 2021 : Industry reports fishing has resumed, starting in a
> piece of water around Wilmington and Spencers canyon.

JM: The fishing was reportedly not as good as it was a month prior and
one harvester reported seeing a change in size frequency of fish
available during the last trip from larger to smaller.

``` r
jc_img <- system.file('jc_0425.jpg', 'jc0427.jpg', package = "cowplot")
plot_grid(
  p + theme(legend.position = c(1, 1), legend.justification = c(1, 1)),
  p2,
  labels = "AUTO"
)

p1 <- ggdraw() +
  draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/jc_425_v2.png', 
             scale = 0.9)
p2 <- ggdraw() + 
  draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/jc0427.jpg', 
             scale = 1.0)
plot_grid(p1, p2)
```

``` r
# Would need to play around with image / grid size, not as flexible as columns
p1 <- ggdraw() + draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/M_201606-MUR-V04.1-NES-SST-STATS-MEAN.png', scale = 1.0)
p2 <- ggdraw() + draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/M_201603-OCCCI-V5.0-NES-CHLOR_A-CCI-STATS-STD.png', scale = 1.0)
p3 <- ggdraw() + draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/W_201638-GLORYS-NES-BOTTOM_TEMPERATURE-WCR-CHLFRONTS.png', scale = 1.0)
# p3 <- ggdraw() + draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/jc0425.jpg', scale = 0.9)

p4 <- ggdraw() + draw_image('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/jc0427.jpg', scale = 1.0)
plot_grid(p1, p2, p3, p4)
```

``` r
# Another way to include images
# knitr::include_graphics('C:/Users/sarah.salois/Documents/github/khyde/SquidSquad/images/M_201606-MUR-V04.1-NES-SST-STATS-MEAN.png')
```
