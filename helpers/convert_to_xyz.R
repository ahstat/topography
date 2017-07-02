convert_to_xyz = function(file, extension = "pgm") {
  file_out = gsub(extension, "xyz", file)
  if(!file.exists(file_out)) {
    print(paste("Converting", file, "to .xyz."))
    
    if(extension == "pgm") {
      # The third line of the file contains the size of the image
      size = as.integer((strsplit(readLines(file, 3)[3]," "))[[1]])
    } else if(extension == "asc") {
      size = strsplit(readLines(file, 2)," ")
      size = as.integer(sapply(size, function(x){x[length(x)]}))
    }
    
    ncol = size[1]
    nrow = size[2]
    
    x = rep(1:ncol, nrow)
    y = -as.vector(sapply(1:nrow, function(x) {rep(x,ncol)}))
    
    if(extension == "pgm") {
      z =fread(file, skip=4)[[1]]  # the lines after row 4 are the content
    } else if(extension == "asc") {
      z = read.table(file, skip=6)
      z = unlist(t(z))
    }
    
    write.table(matrix(c(x,y,z),ncol=3), file=file_out, 
                col.names=FALSE, row.names=FALSE)
  }
}

pgm_files = function() {
  all_data_files = list.files("data/", recursive = TRUE)
  extension_name = sapply(all_data_files, function(x) {
    split = strsplit(x, ".", fixed = TRUE)[[1]]
    split[length(split)]
  })
  pgm_files = all_data_files[which(extension_name == "pgm")]
  pgm_files = file.path("data", pgm_files)
  return(pgm_files)
}