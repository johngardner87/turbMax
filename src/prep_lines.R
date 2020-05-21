
###################################################
### load libraries
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
###################################################

### read data
flowline <- st_read('D:/GIS/river_networks/nhd_grwl_collapse_20191002.shp') 


flowlines_coastal <- flowline %>%
  filter(Tidal==1) %>%
  group_by(TermnlP) %>%
  filter(TermnlP ==LvlPthI) %>%
  mutate(tidal_length = sum(LENGTHKM_)) %>%
  ungroup() 

length(unique(flowlines_coastal$LvlPthI))
length(unique(flowlines_coastal$tidal_length))

### look at tidal flowlines
mapview(flowlines_coastal)+
  mapview(flowlines_coastal %>%
            group_by(LvlPthI) %>%
            filter(Pthlngt == max(Pthlngt, na.rm=T)), color="red")

### find the most upstream reach for each mainstem
max_tidal <-flowlines_coastal %>%
  group_by(LvlPthI) %>%
  summarise(tidal_Pthlngt = max(Pthlngt, na.rm = T ), 
            tidal_length=tidal_length[1]) 

###
flowlines_coastal_2 <-flowline %>% 
  filter(LvlPthI %in% flowlines_coastal$LvlPthI) %>%
  left_join(max_tidal %>%
              st_set_geometry(NULL), by="LvlPthI") %>%
  group_by(LvlPthI) %>%
  filter(Tidal ==1 | Tidal ==0 & Pthlngt < (tidal_Pthlngt +50)) %>%
  mutate(river_length = sum(LENGTHKM_, na.rm=T)) %>%
  filter(river_length >20) %>%
  ungroup()

### plot the flowliens again to make sure data 50 km upstream
### of tidal rivers was included

mapview(flowlines_coastal_2) +
  mapview(flowlines_coastal, color="red")

### write data to file
st_write(flowlines_coastal_2, "D:/Dropbox/projects/turbMax/out/flowline_coastal.shp")

st_write(flowlines_coastal_2, "D:/Dropbox/projects/turbMax/out/flowline_coastal.gpkg")


#############################################
### prep tss data

#sr_tss <- read_feather("D:/Dropbox/projects/riverTSS/4_model/out/sr_tss_20191125.feather")

#sr_tss_nhd <-readRDS("D:/Dropbox/projects/riverTSSout/sr_tss_nhd_huc.RData")

sr_coastal_nhd <- sr_tss_nhd %>%
  filter(ID %in% flowlines_coastal_2$ID)

sr_coastal <- sr_tss %>%
  filter(ID %in% flowlines_coastal_2$ID)


#save(sr_coastal_nhd, file="D:/Dropbox/projects/turbMax/out/sr_tss_nhd_coast.RData")

#save(sr_coastal, file="D:/Dropbox/projects/turbMax/out/sr_tss_coast.RData")



