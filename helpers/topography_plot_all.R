##
# Plot topographic map for different sizes and shifts
##
# See the documentation for this function in main.R.
topography_load_and_plot = function(space_name,
                                    data,
                                    coeff=1,
                                    shift=0,
                                    shift_type="",
                                    list_sizes=list(c(480, 270)),
                                    subfolder = NA,
                                    function_on_z = NA,
                                    new_intervals = NA,
                                    contour_level = -0.001) {
  df=fread(data)
  print(paste("Plotting ", space_name, "...", sep = ""))
  
  # Extract (x,y,z) position from df
  # We put in order to have increasing longitude and latitude vectors
  df=df[order(df$V2),]
  df=as.matrix(df)
  x=unique(df[,1]) #longitude
  y=unique(df[,2]) #latitude
  z=matrix(df[,3],ncol=length(y)) #height for each ordered pair (x,y)
  
  if(typeof(function_on_z) == "closure") {
    z = function_on_z(z)
  }
  
  ##
  # Base shift
  ##
  if(is.character(shift)) {
    quant_to_take = as.double(gsub("quantile ", "", shift))
    shift = quantile(z, probs = quant_to_take)
  }
  shift = coeff*shift
  
  ##
  # Vector of shifts
  ##
  minChoice = -floor(-coeff*min(z)/1000)*1000
  maxChoice = floor(coeff*max(z)/1000)*1000
  if(shift_type == "") {
    shiftVector = c(shift)
  } else if(shift_type == "1000by1000") {
    shiftVector = c(shift,
                    seq(from=minChoice, to=maxChoice, by=1000))
  } else if(shift_type == "finer") {
    shiftVector = c(shift,
                    seq(from=minChoice, to=maxChoice, by=1000),
                    seq(from=-1000, to=1000, by=100),
                    seq(from=-100, to=100, by=10),
                    seq(from=-10, to=10, by=1))
  }
  
  # Sort and rescale the shift vector
  shiftVector = sort(unique(shiftVector))
  shiftVector = shiftVector/coeff
  
  ##
  # Create directories
  ##
  dir.create("outputs", showWarnings = FALSE)
  
  if(is.na(subfolder)) {
    dir_folder = file.path("outputs", space_name)
  } else {
    dir_subfolder = file.path("outputs", subfolder)
    dir.create(dir_subfolder, showWarnings = FALSE)
    dir_folder = file.path(dir_subfolder, space_name)
  }
  dir.create(dir_folder, showWarnings = FALSE)
  
  if(length(list_sizes) > 1) {
    dir_names = paste("outputs", sapply(list_sizes, function(x){x[[1]]}), sep = "")
    dir_names = file.path(dir_folder, dir_names)
    for(j in 1:length(list_sizes)) {
      dir.create(dir_names[j], showWarnings = FALSE)
    }
  } else {
    dir_names = dir_folder
  }
  
  ##
  # Plotting for all sizes and all shifts
  ##
  for(i in 1:length(shiftVector)) {
    print(paste(i, "on", length(shiftVector)))
    shift = shiftVector[i] # value of the sea level
    
    file_name = paste(space_name, shift*coeff, ".png", sep = "")
    nameOutputs = file.path(dir_names, file_name)
    
    for(j in 1:length(list_sizes)) {
      nameOutput = nameOutputs[j]
      png(nameOutput, width=list_sizes[[j]][1], height=list_sizes[[j]][2])
      if(is.na(new_intervals[1])) {
        topography_plot(x, y, z, -shift, coeff, contour_level = contour_level)
      } else {
        topography_plot(x, y, z, -shift, coeff, new_intervals, contour_level)
      }
      dev.off()
    }
  }
}