#' Add countries to a plot.
#'
#' Add countries to a plot.
#' @param EXT Extension of the plot( xmin, xmax, ymin, ymax).
#' @param add Boolean. If TRUE (default), add countries borders to an existing plot.
#' @keywords Plot
#' @export
#' @examples
#' plotCountries(EXT=c(0,40,-40,0),add=FALSE)

plotCountries <- function(EXT=c(-180,180,-90,90),add=FALSE){
    M1=raster::crop(maptools::readShapePoly("/Users/chevalier/ISEM/Scripts/QGIS/Shapefiles/World.shp"),EXT)
    plot(M1,add=add,lwd=0.3,border="grey40",asp=1)
}

#' Add countries to a plot.
#'
#' Add countries to a plot.
#' @param countries List of countries to be plotted.
#' @param add Boolean. If TRUE (default), add countries borders to an existing plot.
#' @keywords Plot
#' @export
#' @examples
#' plotCountriesByName(countries=c("South Africa","Lesotho","Namibia","Botswana","Swaziland"),add=FALSE)


plotCountriesByName <- function(countries=c("South Africa"),add=FALSE){
    M1=maptools::readShapePoly("/Users/chevalier/ISEM/Scripts/QGIS/Shapefiles/World.shp")
    plot(M1[which(M1$CNTRY_NAME %in% countries),],add=add,lwd=0.3,border="grey40",asp=1)
}



#' Add transparency to a color.
#'
#' Add transparency to a color.
#' @param color List of colors.
#' @param alpha Degree of transparency (0: full transparency, 1: no transparency).
#' @keywords Plot
#' @export
#' @examples
#' plot(1:20,1:20,col=getColorGradient("Rd2Bl20"),pch=15,cex=5)
#' points(1:20,1:20+2,col=makeTransparent(getColorGradient("Rd2Bl20"),alpha=0.5),pch=15,cex=5)
#' 

makeTransparent <- function(color, alpha=0.5) {
  #if(alpha<0 | alpha>1) stop("alpha must be between 0 and 1")
    if(alpha>1) alpha=1
    if(alpha<0) alpha=0
    alpha = floor(255*alpha)  
    newColor = col2rgb(col=color, alpha=FALSE)
    .makeTransparent = function(col, alpha) {
        rgb(red=col[1], green=col[2], blue=col[3], alpha=alpha, maxColorValue=255)
    }
    return(apply(newColor, 2, .makeTransparent, alpha=alpha))
}
