library(rgdal)
library(raster)
library(rgeos)
library(sp)
library(splines)

path_app <- 'C:\\R_temp'
world <- raster::getData("countries", path=path_app, download = TRUE)
