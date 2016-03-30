#' Open a TRACE file
#'
#' Open a TRACE file.
#' @param var Variable of interest (TS/PRECC/PRECL/AI/MAP/MAT/PET/TSMN/TSMX/SOLIN).
#' @param month A value between 1 and 12.
#' @param decadal Boolean to select between annual (FALSE) or averaged by decade (TRUE, default) timeseries.
#' @param layer The layer to extract from the netcdf file.
#' @keywords TRaCE
#' @export
#' @examples
#' TS=openTRACE("TS",month=4,decadal=TRUE)

openTRACE <- function(var,month=1,decadal=TRUE,layer=""){
    month=c("01.jan","02.feb","03.mar","04.apr","05.may","06.jun","07.jul","08.aug","09.sep","10.oct","11.nov","12.dec")[month]
    if(var %in% c("MAT","MAP","AI")) month=""
    ncdf=ncdf4::nc_open(paste("/Users/chevalier/ISEM/Data/GCMs/TRACE21k/TRACE21Monthly/",var,ifelse(month=="","","."),month,ifelse(decadal,".10yrs.avg",""),".nc",sep=""))
    if(!(layer %in% names(ncdf$var))){
        if(length(names(ncdf$var))==1) return(ncdf4::ncvar_get(ncdf,names(ncdf$var)))
        print(as.data.frame(names(ncdf$var)))
        a <- .readinteger(txt=paste("Which layer is being requested [",paste(1:length(names(ncdf$var)),collapse="/"),"]: ",sep=""),limit=length(names(ncdf$var)))
        layer=names(ncdf$var)[as.integer(a)]
    }
    return(ncdf4::ncvar_get(ncdf,layer))
}


#' Rotate a TRACE file to center the dataset on Greenwich. Only works with the full dataset!
#'
#' Rotate a TRACE file to center the dataset on Greenwich. Only works with the full dataset!
#' @param dat matrix to rotate.
#' @keywords TRaCE
#' @export
#' @examples
#' TS=openTRACE("TS",month=4,decadal=TRUE)
#' .rotateTRACE(TS[,,1])

.rotateTRACE <- function(dat){
    d.tmp=matrix(0,ncol=nrow(dat),nrow=ncol(dat))
    for(i in 1:ncol(dat)){
        d.tmp[49-i,]=dat[,i]
    }
    return(d.tmp[,c(49:96,1:48)])
}


#' Convert a set of coordinates into index to extract TRACE's data.
#'
#' Rotate a TRACE file to center the dataset on Greenwich. Only works with the full dataset!
#' @param x Longitude of the point.
#' @param y Latitude of the point.
#' @keywords TRaCE
#' @export
#' @examples

.cellFromXY <- function(x,y){ # Lon Lat
    if(x==180){return(.cellFromXY(179,y))}
    if(y==-90){return(.cellFromXY(x,-89))}
    return(c(x%/%3.75+49,(-y)%/%3.75+25)) # Col Ligne
}


#' Convert a set of index into the corresponding coordinates of the top left corner.
#'
#' Convert a set of index into the corresponding coordinates of the top left corner.
#' @param i Index of the longitude.
#' @param j Index of the latitude.
#' @keywords TRaCE
#' @export
#' @examples

.XYFromCell <- function(i,j){ # Ligne Col
    return(c(90-(i-1)*3.75,(j-1)*3.75-180)) # Lat Lon
}


#' Cut a matrix of data from TRACE.
#'
#' Cut a matrix of data from TRACE.
#' @param dat Matrix to cut.
#' @param xmin Lower longitude.
#' @param xmax Higher longitude.
#' @param ymin Lower latitude.
#' @param ymin Higher latitude.
#' @keywords TRaCE
#' @export
#' @examples

.cutTRACE <- function(dat,xmin,xmax,ymin,ymax){
    XYmin=.cellFromXY(xmin,ymin)
    XYmax=.cellFromXY(xmax,ymax)
    return(dat[XYmax[2]:XYmin[2],XYmin[1]:XYmax[1]])
}

#' Get the list of longitudes of TRACE's grid cells.
#'
#' Get the list of longitudes of TRACE's grid cells.
#' @param center Boolean to indicate whether the returned longitude should indicate the center of the grid cell (center=TRUE) or its topleft corner (center=FALSE, default).
#' @keywords TRaCE
#' @export
#' @examples
#' .getLonTRACE()

.getLonTRACE <- function(center=FALSE){
    return(seq(-180,179,resol)+ifelse(center,3.75/2,0))
}

#' Get the list of latitudes of TRACE's grid cells.
#'
#' Get the list of latitudes of TRACE's grid cells.
#' @param center Boolean to indicate whether the returned latitude should indicate the center of the grid cell (center=TRUE) or its topleft corner (center=FALSE, default).
#' @keywords TRaCE
#' @export
#' @examples
#' .getLatTRACE()

.getLatTRACE <- function(center=FALSE){
    return(seq(90,-86.25,-resol)-ifelse(center,3.75/2,0))
}
