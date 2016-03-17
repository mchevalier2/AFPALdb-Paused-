#' Open a TRACE file
#'
#' Open a TRACE file.
#' @param gridcells Coordinates of the pixels of interest (lon1, lat1, lon2, lat2, ...).
#' @param var Variable of interest (TS/PRECC/PRECT/AI/MAP/MAT/PET/TSMN/TSMX/SOLIN).
#' @param month A vector of values comprised between 1 and 12.
#' @param decadal Boolean to select between annual (FALSE) or averaged by decade (TRUE, default) timeseries.
#' @param layer The layer to extract from the netcdf file.
#' @param exportCSV Boolean to export the results in a csv.
#' @param saveCSV Address of the file. Default is "Extract_var.csv" in the working directory.
#' @param tmin Subset of the 22,000 years of simulation.
#' @param tmax Subset of the 22,000 years of simulation.
#' @keywords TRaCE
#' @export
#' @examples
#' TS=extractTRACE(c(0,0,5,5),"TS",month=4:6,exportCSV=TRUE)


extractTRACE <- function(gridcells,var,month=1,decadal=TRUE,layer="",exportCSV=FALSE,saveCSV=paste(getwd(),"/Extract_",var,".csv",sep=""),tmin=-50,tmax=22000){
    if(is.vector(gridcells)){
        gridcells=matrix(gridcells,ncol=2,byrow=TRUE)
    }
    for(i in 1:nrow(gridcells)){
        gridcells[i,]=.cellFromXY(gridcells[i,1],gridcells[i,2])
    }
    dat.in=list()
    for(i in 1:length(month)){
        dat.in[[i]]=.openTRACE(var,month[i],decadal,layer)
    }
    dat.out=matrix(0,nrow=dim(dat.in[[1]])[3],ncol=length(month))
    for(p in 1:nrow(gridcells)){
        for(i in 1:nrow(dat.out)){
            for(j in 1:length(month)){
                dat.out[i,j]=dat.out[i,j]+dat.in[[j]][gridcells[p,1],gridcells[p,2],i]/nrow(gridcells)
            }
        }
    }
    dat.out=cbind(seq(22000,ifelse(decadal,-30,-39),ifelse(decadal,-10,-1)),dat.out)
    dat.out=dat.out[which(dat.out[,1]>= tmin & dat.out[,1]>= tmax),]
    dat.out=dat.out[nrow(dat.out):1,]
    colnames(dat.out)=c("Time",month)
    if(exportCSV) write.csv(dat.out,saveCSV,row.names=FALSE)
    return(dat.out)
}


