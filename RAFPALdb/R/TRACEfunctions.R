#' Open a TRACE file
#'
#' Open a TRACE file.
#' @param var Variable of interest (TS/PRECC/PRECT/AI/MAP/MAT/PET/TSMN/TSMX/SOLIN).
#' @param month A value between 1 and 12.
#' @param decadal Boolean to select between annual (FALSE) or averaged by decade (TRUE, default) timeseries.
#' @param layer The layer to extract from the netcdf file.
#' @keywords TRaCE
#' @export
#' @examples
#' TS=.openTRACE("TS",month=4,decadal=TRUE)


.openTRACE <- function(var,month=1,decadal=TRUE,layer=""){
    month=c("01.jan","02.feb","03.mar","04.apr","05.may","06.jun","07.jul","08.aug","09.sep","10.oct","11.nov","12.dec")[month]
    if(var %in% c("MAT","MAP","AI")) month=""
    ncdf=nc_open(paste("/Users/chevalier/ISEM/Data/GCMs/TRACE21k/TRACE21Monthly/",var,ifelse(month=="","","."),month,ifelse(decadal,".10yrs.avg",""),".nc",sep=""))
    if(!(layer %in% names(ncdf$var))){
        if(length(names(ncdf$var))==1) return(ncvar_get(ncdf,names(ncdf$var)))
        print(as.data.frame(names(ncdf$var)))
        a <- .readinteger(txt=paste("Which layer is being requested [",paste(1:length(names(ncdf$var)),collapse="/"),"]: ",sep=""),limit=length(names(ncdf$var)))
        layer=names(ncdf$var)[as.integer(a)]
    }
    return(ncvar_get(ncdf,layer))
}


#' Rotate a TRACE file to center the dataset on Greenwich. Only works with the full dataset!
#'
#' Rotate a TRACE file to center the dataset on Greenwich. Only works with the full dataset!
#' @param dat matrix to rotate.
#' @keywords TRaCE
#' @export
#' @examples
#' TS=.openTRACE("TS",month=4,decadal=TRUE)
#' .rotateTRACE(TS[,,1])

.rotateTRACE <- function(dat){
    d.tmp=matrix(0,ncol=nrow(dat),nrow=ncol(dat))
    for(i in 1:ncol(dat)){
        d.tmp[49-i,]=dat[,i]
    }
    return(d.tmp[,c(49:96,1:48)])
}


.cellFromXY <- function(x,y){ # Lon Lat
    if(x==180){return(.cellFromXY(179,y))}
    if(y==-90){return(.cellFromXY(x,-89))}
    return(c(x%/%3.75+49,(-y)%/%3.75+25)) # Col Ligne
}

.XYFromCell <- function(i,j){ # Ligne Col
    return(c(90-(i-1)*3.75,(j-1)*3.75-180)) # Lat Lat
}

.cutTRACE <- function(xmin,xmax,ymin,ymax,d){
    XYmin=cellFromXY(xmin,ymin)
    XYmax=cellFromXY(xmax,ymax)

    return(d[XYmax[2]:XYmin[2],XYmin[1]:XYmax[1]])
}
