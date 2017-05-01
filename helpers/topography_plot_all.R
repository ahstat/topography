##
# Plot topographic map for different sizes and shifts
##
# shift_type can be "1000by1000_and_100by100", "1000by1000" or "".
topography.plot.all = function(x, y, z,
                               space_name,
                               is_values_kilometre=FALSE,
                               shift_type="1000by1000_and_100by100",
                               value0=NA,
                               list_sizes=list(c(480, 270))) {
  ##
  # Vector of shifts
  ##
  coeffMultiplying=ifelse(is_values_kilometre, 1000, 1)
  minChoice=-floor(-coeffMultiplying*min(z)/1000)*1000
  maxChoice=floor(coeffMultiplying*max(z)/1000)*1000
  # min(z) #for etopo10_bedrock.xyz : -10421
  # max(z) #for etopo10_bedrock.xyz : 6527
  if(shift_type == "1000by1000") {
    shiftVector=c(seq(from=minChoice, to=maxChoice, by=1000))
  } else if(shift_type == "1000by1000_and_100by100") {
    shiftVector=c(seq(from=minChoice, to=maxChoice, by=1000),
                  seq(from=-1000, to=1000, by=100),
                  seq(from=-100, to=100, by=10))
  } else { # only value0 will be in shiftVector
    shiftVector=c()
  }
  
  # Add the shift defined to have about 70% of the surface covered by water
  shiftVector = c(shiftVector, value0)
  shiftVector=sort(unique(shiftVector))
  
  # Rescale the shift vector
  shiftVector=shiftVector/coeffMultiplying
  
  ##
  # Create directories
  ##
  dir.create("outputs", showWarnings = FALSE)
  dir.create(file.path("outputs", space_name), showWarnings = FALSE)
  
  dir_names=paste("outputs", sapply(list_sizes, function(x){x[[1]]}), sep = "")
  dir_names=file.path("outputs", space_name,dir_names)
  for(j in 1:length(list_sizes)) {
    dir.create(dir_names[j], showWarnings = FALSE)
  }
  
  ##
  # Plotting for all sizes and all shifts
  ##
  for(i in 1:length(shiftVector)) {
    print(paste(i, "on", length(shiftVector)))
    shift=shiftVector[i] #increasing value of the sea level
    
    file_name=paste(space_name, shift*coeffMultiplying, ".png", sep = "")
    nameOutputs=file.path(dir_names, file_name)
    
    for(j in 1:length(list_sizes)) {
      nameOutput=nameOutputs[j]
      png(nameOutput, width=list_sizes[[j]][1], height=list_sizes[[j]][2])
      topography.plot(x,y,z,-shift,coeffMultiplying)
      dev.off()
    }
  }
}