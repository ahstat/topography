rm(list = ls())
setwd("~/Documents/GitHub/topography/")
#setwd("E:/gitperso/topography/")
#setwd("E:/to/your/directory/")
source("helpers/convert_to_xyz.R")
source("helpers/filled_contour_no_legend.R")
source("helpers/topography_plot.R")
source("helpers/topography_plot_all.R")
# install.packages("data.table")
library(data.table)
options("max.contour.segments"= 300000)

# This code can plot topographic map of all data saved the xyz format, 
# i.e. a file with 3 columns, respectively related to the longitude, latitude
# and altitude.
#
# If we only have an image (such as .png of .jpg) of the topography, we can 
# use GIMP to export this image in the .pgm format, then convert this .pgm file
# to a .xyz one. See https://ahstat.github.io/Topography/ for pre-process info.
#
# The main function is topography_load_and_plot, here are the parameters:
#
# - space_name: name of the object,
#
# - data: file path to the xyz object,
#
# - coeff: such that 1 raw = coeff meters
# Example: when coeff = 1000, a value of z=1 in the xyz file corresponds
# to 1000 meters.
#
# - shift: the value z=shift in the xyz object corresponds to the sea level.
# It can be numeric or a string of the form "quantile level" where "level" is
# between 0 and 1.
# Example: when shift=0.305, the sea corresponds to all values in the xyz
# object lower than 0.305.
# Example: when shift="quantile 0.75", we take the 0.75 quantile of z and
# define this value as the shift.
#
# - shift_type: the three options are "", "1000by1000" and "finer".
# * When shift_type = "", we draw only the plot with a shift of `shift`,
# * When shift_type = "1000by1000", we draw all possible plots with a shift of
# `shift ± k*1000/coeff`. 
# Example: For the Earth and `shift = 0`, we draw plots with a shift of:
# -10000, -9000, ..., 6000.
# * When shift_type = "finer", we draw the plots with shift_type = "1000by1000",
# and add plots with a shift between -1000m and 1000m by steps of 100m, 
#                    a shift between -100m and 100m by steps of 10m, 
#                    a shift between -10m and 10m by steps of 1m.
#
# - list_sizes: a list of size of outputs of the form c(width, height)
#
# - subfolder: If NA, let the outputs in the directory: `outputs/space_name`,
# Otherwise, let the outputs in: `outputs/subfolder/space_name`.
#
# - function_on_z: If non NA, we apply a function on the altitude z before
# plotting. This is used for reversed world and sub world plots.
#
# - new_intervals: If non NA, new_intervals should be a numeric vector of 
# size 30 remapping the interval related to each color.
#
# - contour_level: By default, the contour is related to the sea level. This
# can be changed to any other level.

#######################################
# Convert .pgm and .asc files to .xyz #
#######################################
for(file in pgm_files()) {
  convert_to_xyz(file)
}

file = "data/others/earth_density/glds00g15.asc"
convert_to_xyz(file, extension = "asc")

#########################
# Plot topographic maps #
#########################
##
# World
##
space_name = "world"
data = "data/world/etopo10_bedrock.xyz"
coeff = 1
shift = 0

shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

shift_type = "finer"
list_sizes = list(c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

##
# Moon
##
space_name = "moon"
data = "data/moon/moonReduced2-2.xyz" # moonReduced1-1.xyz
coeff = 1000
shift = 0.305 # defined to have about 70% of the surface covered by water

shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

shift_type = "1000by1000"
list_sizes = list(c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

##
# Mars
##
space_name = "mars"
data = "data/mars/megt90n000cb.xyz"
coeff = 1
shift = 1436 # defined to have about 70% of the surface covered by water

shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

shift_type = "1000by1000"
list_sizes = list(c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

##
# Venus
##
space_name = "venus"
data = "data/venus/Magellan.txt" # MagellanReduced2-2.xyz
#data = "data/venus/MagellanReduced3-3.xyz"
coeff = 1
shift = 965 # defined to have about 70% of the surface covered by water
shift_type = ""
list_sizes = list(c(8*1920, 8*1080))
system.time(
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)
)

shift_type = "1000by1000"
list_sizes = list(c(1920, 1080))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

##
# Mercury beyond 55N
##
# The altitude in the .xyz file is encoded in [0, 255]
# We take `coeff` such that 255 raw = 255*coeff meters = 9500 meters,
# the highest altitude of Mercury
space_name = "mercury_polar55N"
data = "data/mercury_polar55N/mercury_polar55N.xyz"
coeff = 37.2549
shift = 125 # defined to have about 70% of the north hemisphere covered by water

shift_type = ""
list_sizes = list(c(480, 480), c(1024, 1024), c(1280, 1280), c(1920, 1920))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

shift_type = "1000by1000"
list_sizes = list(c(1920, 1920))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

##
# Mercury north hemisphere
##
space_name = "mercury_north_hemisphere"
data = "data/mercury_north_hemisphere/mercury_north_hemisphere-4096.xyz"
coeff = 37.2549
shift = 125 # defined to have about 70% of the north hemisphere covered by water

shift_type = ""
list_sizes = list(c(480, 126), c(1024, 269), c(1280, 337), c(1920, 505), c(4096, 1077))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

shift_type = "1000by1000"
list_sizes = list(c(1920, 505))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, list_sizes)

##
# Astres
##
space_names = list.dirs("data/others", recursive = FALSE, full.names = FALSE)
datas = list.dirs("data/others", recursive = FALSE)

# Only take 'astre'
type_object = sapply(strsplit(space_names, "_"), function(x){x[[1]]})
space_names = space_names[type_object == "astre"]
datas = datas[type_object == "astre"]

# Remove titan (this object will be managed with different coefficients)
idx_to_remove = which(space_names == "astre_titan")
space_names = space_names[-idx_to_remove]
datas = datas[-idx_to_remove]

for(i in 1:length(datas)) {
  space_name = space_names[i]
  data = file.path(datas[i], paste(space_name, ".xyz", sep = ""))
  print(space_name)
  coeff = 25 # let's say all those objects have 6375m altitude (=25*255)
  shift = "quantile 0.75" # the sea level corresponds to the 0.75 quantile of z
  shift_type = ""
  list_sizes = list(c(480, 270))
  topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                           list_sizes, subfolder = "others")
}

##
# Titan
##
space_name = "astre_titan"
data = "data/others/astre_titan/astre_titan.xyz"
coeff = 9.4488
shift = 188
shift_type = ""
list_sizes = list(c(480, 270))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = "others")

##
# Simulation of the dark matter
##
space_name = "universe_dark_matter"
data = "data/others/universe_dark_matter/universe_dark_matter.xyz"
coeff = 15
shift = 155
shift_type = ""
list_sizes = list(c(480, 360), c(1024, 768), c(1280, 960), c(1920, 1440))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = "others")

##
# Cosmic microwave background with Planck
##
space_name = "universe_planck"
data = "data/others/universe_planck/universe_planck.xyz"
coeff = 2
shift = 127
shift_type = ""
list_sizes = list(c(1280, 640), c(1920, 960))
topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = "others")

##
# Reversed world
##
space_name = "reversed_world"
data = "data/world/etopo10_bedrock.xyz"
coeff = 1
shift = 0
shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
function_on_z = function(z){return(-z)}

new_intervals = c(-100000, -3500, -3000, -2500, -2000,
                  -1500, -1000, -750, -500, -200, 
                  0, 50, 150, 300, 600,
                  1300, 2000, 2600, 3000, 3500,
                  4000, 4200, 4400, 4700, 4900,
                  5100, 5300, 5500, 5700, 100000)

topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = NA, function_on_z,
                         new_intervals)

##
# Sub world
##
space_name = "sub_world"
data = "data/world/etopo10_bedrock.xyz"
coeff = 1
shift = 0
shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
function_on_z = function(z){return(-abs(z+1)-1)}

topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = NA, function_on_z)

##
# No water world
##
space_name = "up_world"
data = "data/world/etopo10_bedrock.xyz"
coeff = 1
shift = 0
shift_type = ""
list_sizes = list(c(1920, 1080))
#list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
function_on_z = function(z){return(z)} # function(z){return(-abs(z+1)-1)}

# new_intervals = c(-100000, -3500, -3000, -2500, -2000,
#                   -1500, -1000, -750, -500, -200, 
#                   0, 50, 150, 300, 600,
#                   1300, 2000, 2600, 3000, 3500,
#                   4000, 4200, 4400, 4700, 4900,
#                   5100, 5300, 5500, 5700, 100000)
new_intervals = c(-100000, -3500, -3000, -2500, -2000,
              -1500, -1000, -750, -500, -200,
              0, 50, 100, 250, 500,
              750, 1000, 1250, 1500, 1750,
              2000, 2250, 2500, 2750, 3000,
              3250, 3500, 3750, 4000, 100000)
# new_intervals = c(-100000, -9900, -9800, -9700, -9600,
#               -9500, -9400, -9300, -9200, -9100,
#               0, # --> 0
#               2000, 3000, 4000, 5000, # 50, 100, 250, 500
#               7500, 10000, 12500, 15000, 17500, # 750, 1000, 1250, 1500, 1750
#               20000, 22500, 25000, 27500, 30000, # 2000, 2250, 2500, 2750, 3000
#               32500, 35000, 37500, 40000, 100000) # 3250, 3500, 3750, 4000, 100000


topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = NA, function_on_z,
                         new_intervals)

##
# No water world 2
##
# How to color the map?
colorsSea=c("#71ABD8", "#79B2DE", "#84B9E3", "#8DC1EA", "#96C9F0", 
            "#A1D2F7", "#ACDBFB", "#B9E3FF", "#C6ECFF", "#D8F2FE")
colorsEarth=c("#ACD0A5", "#94BF8B", "#A8C68F", "#BDCC96", "#D1D7AB", 
              "#E1E4B5", "#EFEBC0", "#E8E1B6", "#DED6A3", "#D3CA9D", 
              "#CAB982", "#C3A76B", "#B9985A", "#AA8753", "#AC9A7C", 
              "#BAAE9A", "#CAC3B8", "#E0DED8", "#F5F4F2")
colorsSea = rev(colorsEarth)
# colorsSea=c("#D8F2FE")
# colorsEarth=c("#ACD0A5", "#94BF8B", "#A8C68F", "#BDCC96", "#D1D7AB", 
#               "#E1E4B5", "#EFEBC0", "#E8E1B6", "#DED6A3", "#D3CA9D", 
#               "#CAB982", "#C3A76B", "#B9985A", "#AA8753", "#AC9A7C", 
#               "#BAAE9A", "#CAC3B8", "#E0DED8", "#F5F4F2")
colors=c(colorsSea,colorsEarth)

# To which interval each color is related?
# intervals = c(-100000, 
#               0, 50, 100, 250, 500,
#               750, 1000, 1250, 1500, 1750,
#               2000, 2250, 2500, 2750, 3000,
#               3250, 3500, 3750, 4000, 100000)
# intervals = c(-100000, -3500, -3000, -2500, -2000,
#               -1500, -1000, -750, -500, -200,
#               0, 50, 100, 250, 500,
#               750, 1000, 1250, 1500, 1750,
#               2000, 2250, 2500, 2750, 3000,
#               3250, 3500, 3750, 4000, 100000)
intervals = c(-100000, 
              #rep(-10000, 9)+1:9, 
              -6500, -6000, -5750, -5500, -5250, -5000, -4750, -4500, -4250,
              -4000, -3500, -3000, -2500,
              -2000, -1000, -750, -500, -200,
              0, 50, 100, 250, 500,
              750, 1000, 1250, 1500, 1750,
              2000, 2250, 2500, 2750, 3000,
              3250, 3500, 3750, 4000, 100000)
# hist(z[z < 0], breaks = 1000)
# Plotting
png(nameOutput, width=list_sizes[[j]][1], height=list_sizes[[j]][2])
par(mar=c(0,0,0,0))
#contour_level = -0.001
contour_level = -20000
filled.contour_nolegend(x, y, z+shift, col=colors, levels=intervals, axes=FALSE)
contour(x, y, z+shift, add=T,levels=contour_level, col="#0978AB", drawlabels=FALSE)
dev.off()

##
# Earth's city lights
##
space_name = "earth_light_world"
data = "data/others/earth_light_world/earth_light_world.xyz"
coeff = 1
shift = 3
shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))
new_intervals=c(-100000, -4.5, -4, -3.5, -3.35,
                -3.25, -3, -2.5, -2, -1,
                0, 1, 2, 3, 4,
                5, 6, 7, 8, 9,
                10, 11, 12, 13, 14,
                15, 16, 17, 18, 100000)

topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = "others", function_on_z = NA,
                         new_intervals = new_intervals)

##
# Density of population
##
space_name = "earth_density"
data = "data/others/earth_density/glds00g15.xyz"
coeff = 1
shift = 0
shift_type = ""
function_on_z = function(z){z[which(z==-9999)]=-550; return(z)}
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))

new_intervals =c(-100000, -3500, -3000, -2500, -2000,
                 -1500, -1000, -750, -500, 0,
                 1, 2, 7, 15, 30,
                 50, 100, 200, 300, 400,
                 500, 600, 700, 800, 900,
                 1000, 2000, 4000, 8000, 100000)

topography_load_and_plot(space_name , data, coeff, shift , shift_type,
                         list_sizes, subfolder = "others", function_on_z,
                         new_intervals, contour_level = 1)

##
# Lightning
##
space_name = "earth_lightning"
data = "data/others/earth_lightning/earth_lightning.xyz"
coeff = 1
shift = 6
shift_type = ""
list_sizes = list(c(480, 270), c(1024, 576), c(1280, 720), c(1920, 1080))

new_intervals=c(-100000, -8, -7, -6, -5,
                -4, -3, -2, -1, 0,
                1, 2, 3, 4, 5,
                6, 7, 8, 9, 10,
                11, 12, 13, 14, 15,
                16, 17, 18, 19, 100000)

topography_load_and_plot(space_name , data, coeff, shift , shift_type, 
                         list_sizes, subfolder = "others", function_on_z = NA,
                         new_intervals, contour_level = 1)