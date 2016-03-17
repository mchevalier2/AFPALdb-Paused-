#' Extract data from TRACE.
#'
#' Extract data from TRACE.
#' @param dat Matrix to be plotted.
#' @param exportPDF Boolean. TRUE to generate a pdf of the figure.
#' @param savePDF Address and name of the pdf. Default is "plotTRACE.pdf" in the working directory.
#' @param add.contours Boolean to add contours on the figure.
#' @param add.contries Boolean to add country borders on the figure.
#' @param WIDTH The width of the figure in inches.
#' @param HEIGHT The height of the figure in inches.
#' @param legend Position of the legend (top/right/bottom/left/none).
#' @param EXT Extension of the plot( xmin, xmax, ymin, ymax).
#' @param COL Color gradient.
#' @keywords TRaCE, Plot
#' @export
#' @examples
#' plotTRACE(dat=openTRACE("TS",month=4,decadal=TRUE))


plotTRACE <- function(dat,exportPDF=FALSE,savePDF=paste(getwd(),"/plotTRACE.pdf",sep=""),add.contours=TRUE,add.countries=TRUE,WIDTH=5.51,HEIGHT=5.51,legend='bottom',EXT=c(-180,180,-90,90),COL=getColorGradient("Rd2Bl20")){
    if(exportPDF) pdf(savePDF,width=WIDTH,height=HEIGHT)

    if(legend %in% c('top','bottom','right','left')){
        if(legend %in% c('top','bottom')) layout(matrix(c(ifelse(legend=='top',2,1),ifelse(legend=='top',1,2)),ncol=1),width=1,height=c(1,ifelse(legend=='top',8,1/8)))
        if(legend %in% c('left','right')) layout(matrix(c(ifelse(legend=='left',2,1),ifelse(legend=='left',1,2)),ncol=2),height=1,width=c(1,ifelse(legend=='left',8,1/8)))
    }else{
        par(mfrow=c(1,1))
    }
    par(mar=rep(0,4))
    resol=3.75
    plot(0,xlim=c(EXT[1],EXT[2]),ylim=c(EXT[3],EXT[4]),asp=1,frame=FALSE,type='n',axes=FALSE)
    shift.x=(.cellFromXY(EXT[1],0)[1])*resol
    shift.y=(.cellFromXY(0,EXT[4])[2]-1)*resol
    w.lon=which(seq(-180,179,resol) >= EXT[1] & seq(-180,179,resol) <= EXT[2])
    w.lat=which(seq(86.25,-90,-resol) >= EXT[3] & seq(86.25,-90,-resol) <= EXT[4])
    d=dat[w.lat,w.lon]
    dd=(length(COL)*((d-zlim[1])/diff(range(zlim))))%/%1+1
    dd=dd+(dd==0)-(dd>length(COL))
    for(i in 1:nrow(dd)){
        for(j in 1:ncol(dd)){
            p=.XYFromCell(i,j)[c(2,1)]
            rect(p[1]+shift.x,p[2]-shift.y,p[1]+shift.x+resol,p[2]-shift.y-resol,col=COL[dd[i,j]],border=NA)
        }
    }
    if(add.countries) plotCountries(EXT,TRUE)

    if(add.contours) contour(seq(-180,179,resol)[w.lon]+resol/2,rev(seq(86.25,-90,-resol)[w.lat])+resol/2,z=t(d[nrow(d):1,]),add=TRUE,nlevels=10,lwd=0.5,col="black") 
            
}
