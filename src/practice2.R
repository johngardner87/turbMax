
#######################################################################################
# install packaages. You only need to ru nthis line of code once.
# Once the packages have been sucessfully installed COMMENT this code
# out with ##, 
# Packages contain R functions that will do math for us, so we do not
# have to write code from scratch

#install.packages(c("tidyverse", "feather", "viridis", "sf", "rgdal",
#                   "maps", "magrittr", "purr", "data.table", "tmap",
#                   "ggthemes", "dplyr", "ggplot2", "mapview", "fs",
#                   "httr", "leaflet", "USAboundaries", "rgeos", "lwgeom",
#                   "plyr", "stringr", "lubridate", "ggmap", "ggthemes", "readr",
 #                  "nhdplusTools", "Rcpp", "remotes","sp", "foreign" ))

# if this doesn't work. Install each package individually. For eaxmaple...
# and run the code. 
install.packages("tidyverse")

# You may need to install more packages that are dependent upon the above packages.
# Errors as you run code will elt you know if you need a pacakge.

# A function takes inputs, and makes output
# for eaxmple. Mean() calculates the arithmetic mean given input some type
# of data. usually a vector. A vector is bascically 1 row or column of data.
# a dataframe or matrix is multiple rows and/or columns of data.

mean(c(4,5,6,7,8))

#########################################################################################
# load packages into the current R studio environment, probably will not use all these

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

##########################################################################################
# load data from our google drive, This is the path on my computer. 
#Maybe different wherever you store the data.

# the data you will be using all comes from these coastal rivers
flowlines_coast <-st_read("D:/GoogleDrive/IDEA_2020/data/flowline_coastal.gpkg")

# click on the flowlines_coast object to upper left hand corner to understand it.
# also can look at strcuture with code. This is a spatial dataset with geometry
str(flowlines_coast)

# and see the column names 
colnames(flowlines_coast)

# this is the data of total suspended solids and remote sensing information that can 
# be joined to the spatial dataset of flowlines
tss_year <- read_feather("D:/GoogleDrive/IDEA_2020/data/tss_coastal_year.feather")

# this is just a dataframe without any spatial information
str(tss_year)

#########################################################################################
# Module 1: Get familiar with flowlines
# we can plot this using ggplot and sf while changin the projection to make it look better to 2163
ggplot() +
  geom_sf(data=flowlines_coast %>%
            st_transform(2163), aes(color=as.factor(StrmOrd))) +
  scale_color_viridis(discrete=T)

# We can also make an interactive plot which will be very useful throughout 
# this summer to reference what is going on in a river when looking at the TSS data.
# If this is a big spatial file, sometimes it takes a few minutes and will pop up in 
# your web browser instead of in R studio
mapview(flowlines_coast)

# an interactive map should show up in your web browser or in the plot window in the
# lower right hand corner.  Explore this map (zoom in out, click on the rivers)

# if you need help with the arguments and inputs of a function,
# you can type in to the console ?FUNCTION NAME() into to console
?mapview()

# or just google R mapview and lots documentation is online for every R function

# here is the data for all Landsat visible (>60 meters in width)
# flowlines that we have TSS and remote sensing data from
flowlines<-st_read("D:/GoogleDrive/IDEA_2020/data/nhd_grwl_collapse_20191002.shp")

#############################################################
### CODE Challenge: Plot flowlines_coat using ggplot. 
### and color code the rivers by their mean discharge (i.e. QE_MA) 
### this is almost the same code as above just with a differnt variable 
## in the color argument.

### FINISH THIS CODE
ggplot() +
  geom_sf(data=flowlines_coast %>%
            st_transform(2163), aes(color=    )) +
  scale_color_viridis(discrete=F)







############################################################
### CODE Challenge: Make a mapview interactive map for just the Neuse, Pamlico, 
### and Potomac rivers only (Hint: names are GNIS_NA, but use the LvlPthI column to subset whole rivers)

# example of subsetting rivers. Make a new R object that is a subset of flowlines_coast

# find what is the ID of the rivers. This code filters to only unique river ID
# so there is one row per unique river. 
names <- flowlines_coast %>%
  distinct(LvlPthI, .keep_all = T)

# click on the names object in the upper right hand corner to view this dataframe
# find the LLook up the LvlPthI associated with the 
# three river names


# Try subsetting data to see it in the console. And you can look up the 
# LvlPtID associated with a river name, for example the Potomac River.
# This is quicker for one river than scrolling through the whole names object

names %>% filter(GNIS_NA =="Potomac River")



# FINSH THIS CODE: to subset three rivers (HINT: insert LvlPthI associated with each
# river in the quoatations in the c() ). You will be subsetting three rivers.
flow_coast_sub <- flowlines_coast %>%
  filter(LvlPthI %in% c("  ", "  ", "  "))



# FINSH THIS CODE: plot flow_coast_sub using mapview.
mapview(data=)



# FINSH THIS CODE: Make a scatter plot of each of these three rivers of elevation 
# (MAXELEVS) vs. distance downstream (Pthlngt). Subset with GNIS_NA or LvlPthI

# example code
ggplot(flow_coast_sub %>%
          filter(GNIS_NA == "Neuse River")) +
  geom_point(aes(x=Pthlngt, y=MAXELEVS))

# Now make this same plot for the Potomac River


# FINSIH THIS CODE:(Hint chose variables for the x and y axis, Pthlngt and MAXELEVS)
# to plot all rivers at once using facet_wrap
ggplot(flow_coast_sub)
  geom_point(aes(x=     , y=   )) +
    facet_wrap(~LvlPthI, scales="free")

?facet_wrap()



# save this plot. there are many ways to save a plot.
# you can so it manually by pressing the export button in the plot window.
# you can write code to save the most recent ggplot plot

## look up the arguments for ggsave. and save the most recent plot to your 
# harddrive. you will need to tell it the filepath and name
# (for example "D:/Desktop/turbMax/plot1.png)
?ggsave()

### FINSH THIS CODE: to save the plot to file of elevation vs distance downstream
ggsave(filename = , width=4, height=4, units="in", dpi=300)

# 


#############################################################################################
# Module 2: Get familiar with TSS (total suspended solids) data

# inspect the structure of tss_year
str(tss_year)

# EXAMPLE: plot tss over time for 1 reach

ggplot(tss_year %>% filter(ID==408)) +
  geom_point(aes(x=year, y=tss_mean, color=count_year)) +
  scale_color_viridis_c() +
  theme_bw()

# WE need more geospatial information for using this data. Lets join it to the flowlines. 
# but drop the actual geometry information for now.
tss_year_join <- tss_year %>%
  left_join(flowlines_coast %>%
              st_set_geometry(NULL), by="ID")


# now we can subset a river and plot the longitudinal profile of TSS along distance downstream. 
# Here for The Neuse river in NC. This will be the basis of many of yoru analysis,
# what is the shape of these profiles.
# Pthlngt is the distance in kilometers from the watershed outlet

ggplot(tss_year_join %>% 
         filter(LvlPthI==250004217)) +
 geom_line(aes(x=Pthlngt, y=tss_mean, group=year, color=year)) +
   scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

ggsave("figs/neuse_tss_year.png", width=6, height=4, units='in', dpi=300)

### CODE Challenge: Make a similar plot for the Pamlico and Potomac rivers. 

## FINISH THIS CODE: Make the same plot but for the Pamlico River.
### Hint: type in the LvlPthI associated with the Pamlico River

ggplot(tss_year_join %>% 
         filter(LvlPthI==        )) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group=year, color=year)) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

#FINISH CODE: to Save this plot
ggsave("figs/tss_year_pamlico.png", width=5, height=5, units='in', dpi=300)


## FINISH THIS CODE: Make the same plot but for the Potomac River
ggplot(tss_year_join %>% 
         filter(LvlPthI==     )) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group=year, color=year)) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

#FINISH CODE: to Save this plot
ggsave("figs/tss_year_potomac.png", width=5, height=5, units='in', dpi=300)


# Make a new R object subsetting these three rivers
tss_year_join_sub <- tss_year_join %>%
  filter(LvlPthI %in% c(250004217, 200004858,250005875 ))



# Example: Plot all three rivers at once by using facet wrap
ggplot(tss_year_join_sub) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group=year, color=year)) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") +
  facet_wrap(~LvlPthI, scales="free")

# FINISH THIS CODE: save this plots 
ggsave("figs/tss_year_3rivers.png", width=8, height=5, units='in', dpi=300)


### CODE Challenge: load in the monthly tss data.  (tss_coastal_month.feather). 
# join to flowlines and make a plot of tss vs distance downstream for the Neuse, Pamlico 
# and Potomac rivers colored by month

### FINISH THIS CODE. type in the file path to tss_cosatal_month.feather
tss_month <- read_feather()

### FINISH THIS CODE. Join the monthly tss data to the flowlines, (HINT: by="ID)

tss_month_join <- tss_month %>%
  left_join(flowlines_coast %>%
              st_set_geometry(NULL), by= "  ")


#FINISH THIS CODE: Subset Neuse, Pamlico, and Potomac rivers (Type in the LvlPthI)
tss_month_join_sub <- tss_month_join %>%
  filter(LvlPthI %in% c(           ))


# FINISH THIS CODE. Make a plot for each river where color=month.
# This is th SAME plot as the tss_year, but group and color = month instead of year.

# Example with Neuse River
ggplot(tss_month_join_sub %>%
         filter(LvlPthI == 250004217)) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group=month, color= month)) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

# FINISH THIS CODE 
ggplot(tss_month_join_sub %>%
         filter()) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group=      , color=       )) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

ggplot(tss_month_join_sub %>%
         filter()) +
  geom_line(aes(x=Pthlngt, y=tss_mean, group=      , color=       )) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 




### CODE Challenge: load in the full dataset (sr_tss_nhd_coast.RData). 
# This already has flowlines joined.  plot of tss vs distance downstream for the Neuse, 
# Pamlico and Potomac rivers with each line representing a separate date (or individual Landsat path). 
# Some rivers may have multiple landsat scenes that cover this stretch of river.
# and therefore the full river is not plotted for each date.

tss_full <- readRDS("data/sr_tss_nhd_coast.RData")


# FINISH THIS CODE. Subset Neuse, Pamlico, and Potomac rivers by typing in the LvlPthI
tss_full <- tss_full %>%
  filter(LvlPthI %in% c(       ))


# Plot each river, with the group= and color= as.factor(date)

# Example with Neuse River
ggplot(tss_full %>%
         filter(LvlPthI == 250004217)) +
  geom_line(aes(x=Pthlngt, y=mean, group=as.factor(date), color= as.factor(date))) +
  scale_color_viridis_c() +
  scale_x_reverse() +
  theme_bw() +
  xlab("Distance from outlet (km)") +
  ylab("TSS (mg/L)") 

# MAKE THE SAME PLOT for the Pamlico and Potomac Rivers




