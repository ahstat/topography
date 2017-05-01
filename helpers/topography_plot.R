##
# Plot the topographic map with a shifted sea-level
##
topography.plot <- function(x, y, z, shift, coeffMultiplying) {
  colorsSea=c("#71ABD8", "#79B2DE", "#84B9E3", "#8DC1EA", "#96C9F0", 
              "#A1D2F7", "#ACDBFB", "#B9E3FF", "#C6ECFF", "#D8F2FE")
  colorsEarth=c("#ACD0A5", "#94BF8B", "#A8C68F", "#BDCC96", "#D1D7AB", 
                "#E1E4B5", "#EFEBC0", "#E8E1B6", "#DED6A3", "#D3CA9D", 
                "#CAB982", "#C3A76B", "#B9985A", "#AA8753", "#AC9A7C", 
                "#BAAE9A", "#CAC3B8", "#E0DED8", "#F5F4F2")
  colors=c(colorsSea,colorsEarth)
  intervals=c(-100000, -3500, -3000, -2500, -2000,
              -1500, -1000, -750, -500, -200,
              0, 50, 100, 250, 500,
              750, 1000, 1250, 1500, 1750,
              2000, 2250, 2500, 2750, 3000,
              3250, 3500, 3750, 4000, 100000)
  intervals=intervals/coeffMultiplying
  par(mar=c(0,0,0,0))
  filled.contour.nolegend(x, y, z+shift, col=colors, 
                          levels=intervals, axes=FALSE)
  # -0.001 instead of 0 to correct contour for the moon
  contour(x, y, z+shift, add=T,levels=c(-0.001), col="#0978AB", drawlabels=FALSE)
}