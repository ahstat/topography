rm(list = ls())
#setwd("E:/blogprojects/2014-1-11-Topography/code/")
source("helpers/filled_contour_no_legend.R")
source("helpers/topography_plot.R")
source("helpers/topography_plot_all.R")
# install.packages("data.table")
library(data.table)

##
# Parameters
##
#name of the objects
space_names=c("world", "moon", "mars", "venus")

#data directory for the objects
datas=c("data/world/etopo10_bedrock.xyz",
        "data/moon/moonReduced1-1.txt",
        "data/mars/megt90n000cb_xyz.txt",
        "data/venus/MagellanReduced2-2.txt")

# data unit is kilometers? (instead of meters)
is_values_kilometres=c(FALSE,TRUE,FALSE,FALSE)

# plot 1000m by 1000m or 100m by 100m
shift_types=c("1000by1000_and_100by100", rep("1000by1000",3))
#shift_types=rep("",4) # other option

# shift in meters defined to have about 70% of the surface covered by water
values0=c(0,305,1436,965)

# size of outputs
list_sizes=list(c(480, 270), c(1024, 576),
                c(1280, 720), c(1920, 1080))

##
# Code
##
for(k in 1:length(space_names)) {
  space_name=space_names[k]
  df=fread(datas[k])
  value0=values0[k]
  is_values_kilometre=is_values_kilometres[k]
  shift_type=shift_types[k]
  
  print(paste("Plotting ", space_name, "...", sep = ""))
  
  ## Extract (x,y,z) position from df
  #we put in order to have increasing longitude and latitude vectors
  df=df[order(df$V2),]
  df=as.matrix(df)
  x=unique(df[,1]) #longitude
  y=unique(df[,2]) #latitude
  z=matrix(df[,3],ncol=length(y)) #height for each ordered pair (x,y)
  
  topography.plot.all(x, y, z,
                      space_name,
                      is_values_kilometre,
                      shift_type,
                      value0,
                      list_sizes)
}