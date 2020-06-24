


library(tidyverse)
library(feather)
library(viridis)
library(sf)
library(rgdal)
library(maps)
library(magrittr)
library(purrr)
library(data.table)
library(tmap)
library(ggthemes)
library(dplyr)
library(ggplot2)
library(mapview)
library(fs)
library(httr)
library(leaflet)
library(USAboundaries)
library(rgeos)
library(lwgeom)


### Practice 3


# load in river flow data for the three rivers (Neuse, Potomac, Pamlico)

Q <- read_feather(".../discharge.feather")

tss_year <- read_feather("D:/GoogleDrive/IDEA_2020/data/tss_coastal_year.feather")

flowlines_coast <-st_read("D:/GoogleDrive/IDEA_2020/data/flowline_coastal.gpkg")


# look at the structure
str(Q)

# find the unique river names. 
unique(Q$Name)

# find unique gaging sites
unique(Q$site_no)

# So we have long dataframe with daily flow data from three river gages
# from 3 different rivers


### FINSH THIS CODE, Plot the daily flow data for all 3 rivers
# using facet_wrap

ggplot(Q) +
  geom_line(aes(x= flow_cms , y=    )) +
  facet_wrap(~Name, scales="free_y")

# Try plotting now by removing the "scales" argument in facet_wrap
# what happens?

ggplot(Q) +
  geom_line(aes(x= flow_cms , y=  Date   )) +
  facet_wrap(~Name)


### Make an annual summary of the flow data. If you use group_by() combined
### with summarise(), you can do any statistic over each group, rather than repeating the
### summary stats for individual dataframes 

# this code groupa the flow data by site (or river Name) 
# and calculates summary statistics. But first with some filters
# to make sure the data is high quality for each year

Q_annual <- Q %>%
  # group data by river and year
  group_by(LvlPthI, Name, year) %>%
  # add column of number of observations per year
  mutate(n_year = n()) %>%
  # filter to years that have greater than 350 days (out of 365) of flow data
  filter(n_year > 350) %>%
  # summarise the flow column calculating mean, median and std dev.
  summarise(Q_mean = mean(flow_cms, na.rm=T), 
            Q_median = median(flow_cms, na.rm=T), 
            Q_sd = sd(flow_cms, na.rm=T))
           
  
### FINISH THIS CODE. make a line plot of the annual mean discharge
# for each year for all thre rivers using facet_wrap
ggplot(Q_annual) +
  geom_line(aes(x= , y= ))+
  facet_wrap(~Name, scales="free")

  
### FINISH THIS CODE. Do a monthly summary, and filter to data that 
# has at least 27 days of flow data for each month using the example above

Q_month <- Q %>%
  group_by(Name, month) %>%
  


# Join the annual flow data and the flowlines to the
# annual tss data for the neuse river

tss_Q_neuse <- tss_year %>%
# join flowlines_coast
  left_join(flowlines_coast %>%
              st_set_geometry(NULL), by= "ID") %>%
  filter(LvlPthI == 250004217) %>%
  #  you can join by multiple columns such as year AND river
  inner_join(Q_annual, by=c( "LvlPthI", "year"))

### FINISH THIS CODE. Repeat for the Pamlico and Potomac rivers
tss_Q_pot <- tss_year %>%
  # join flowlines_coast
  left_join(   ) %>%
  filter(LvlPth==200004858) %>%
  inner_join(   )

tss_Q_pam <- tss_year %>%
  # join flowlines_coast
  left_join() %>%
  filter(LvlPth==250005875) %>%
  inner_join()


### make a plot of the tss profiles for each river, but 
# make the color by the Q_mean (or mean annual flow)

ggplot(tss_Q_neuse) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group= Q_mean, color=Q_mean),
                lwd=1.01) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

### FINISH THIS CODE. Now repeat for the pamlico and potomac riovers

ggplot(tss_Q_pam) 
  
  
ggplot(tss_Q_pot) 
  

###loading the full tss data and join the daily flow data
# to daily estimates of tss

tss_all <- read_feather("D:/GoogleDrive/IDEA_2020/data/sr_tss_nhd_coast.feather")

tss_all_Q <- tss_all %>%
  filter(LvlPthI %in% c(250004217,200004858,250005875)) %>%
  left_join(Q %>%
              rename(date= Date) %>%
              select(date, flow_cms, site_no, LvlPthI),
            by=c("LvlPthI", "date" ))

### CODE CHALLENGE. MAKE NEW CODE
# Try filtering to dates that have tss data over many reaches
# for each river.
# Then make similar plots of the TSS longitudinal profile 
# color coded by flow_cms










