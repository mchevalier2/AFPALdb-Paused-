#' Extract data from TRACE.
#'
#' Extract data from TRACE.
#' @param dat Matrix to be plotted.
#' @param year Year to plot. (1=22000 cal BP)
#' @param zlim Range of values.
#' @param exportPDF Boolean. TRUE to generate a pdf of the figure.
#' @param savePDF Address and name of the pdf. Default is "plotTRACE.pdf" in the working directory.
#' @param add.contours Boolean to add contours on the figure.
#' @param add.contries Boolean to add country borders on the figure.
#' @param WIDTH The width of the figure in inches.
#' @param HEIGHT The height of the figure in inches.
#' @param legend Position of the legend (top/right/bottom/left/none).
#' @param EXT Extension of the plot( xmin, xmax, ymin, ymax).
#' @keywords Plot
#' @keywords TRaCE
#' @export
#' @examples
#' plotTRACE(dat=openTRACE("TS",month=1,decadal=TRUE),year=1,exportPDF=TRUE,EXT=c(-180,180,-90,90),legend='bottom')
#' plotTRACE(dat=openTRACE("PRECC",month=8,decadal=TRUE),year=1,exportPDF=TRUE,EXT=c(-11.25,56.2,-37.5,41.2),legend='right',COL=getColorGradient("Rainfall20"))


plotTRACE <- function(dat,year=1,zlim=range(dat[,,year]),exportPDF=FALSE,savePDF=paste(getwd(),"/plotTRACE.pdf",sep=""),add.contours=TRUE,add.countries=TRUE,WIDTH=5.51,HEIGHT=5.51,legend='bottom',EXT=c(-180,180,-90,90),COL=rev(getColorGradient("Rd2Bl20"))){
    if(exportPDF) pdf(savePDF,width=WIDTH,height=HEIGHT)

    if(legend %in% c('top','bottom','right','left')){
        if(legend %in% c('top','bottom')) layout(matrix(c(ifelse(legend=='top',2,1),ifelse(legend=='top',1,2)),ncol=1),width=1,height=c(1,ifelse(legend=='top',8,1/8)))
        if(legend %in% c('left','right')) layout(matrix(c(ifelse(legend=='left',2,1),ifelse(legend=='left',1,2)),ncol=2),height=1,width=c(1,ifelse(legend=='left',5,1/5)))
    }else{
        par(mfrow=c(1,1))
    }
    par(mar=c(0,0,0,0))
    resol=3.75
    EXT=c(.XYFromCell(0,.cellFromXY(EXT[1],0)[1])[2],
        .XYFromCell(0,.cellFromXY(EXT[2],0)[1])[2]+resol*(EXT[2]%%resol>0),
        .XYFromCell(.cellFromXY(0,EXT[3])[2],0)[1]-resol*(EXT[3]%%resol>0),
        .XYFromCell(.cellFromXY(0,EXT[4])[2],0)[1])
    plot(0,xlim=c(EXT[1],EXT[2]),ylim=c(EXT[3],EXT[4]),asp=1,frame=FALSE,type='n',axes=FALSE)
    shift.x=(.cellFromXY(EXT[1],0)[1]-1)*resol
    shift.y=(.cellFromXY(0,EXT[4])[2]-1)*resol
    w.lon=which(.getLonTRACE() >= EXT[1] & .getLonTRACE() < EXT[2])
    w.lat=which(.getLatTRACE() > EXT[3] & .getLatTRACE() <= EXT[4])
    if(length(dim(dat))==3){  d=.rotateTRACE(dat[,,year])[w.lat,w.lon]
    }else{  d=.rotateTRACE(dat)[w.lat,w.lon]  }
    dd=(length(COL)*((d-zlim[1])/diff(range(zlim))))%/%1+1
    dd=dd+(dd==0)-(dd>length(COL))
    for(i in 1:nrow(dd)){
        for(j in 1:ncol(dd)){
            p=.XYFromCell(i,j)[c(2,1)]
            rect(p[1]+shift.x,p[2]-shift.y,p[1]+shift.x+resol,p[2]-shift.y-resol,col=COL[dd[i,j]],border=COL[dd[i,j]],lwd=0.2)
        }
    }
    if(add.countries) plotCountries(EXT,TRUE)

    if(add.contours) contour(seq(-180,179,resol)[w.lon]+resol/2,rev(seq(86.25,-90,-resol)[w.lat])+resol/2,z=t(d[nrow(d):1,]),add=TRUE,nlevels=10,lwd=0.5,col="black")

    if(legend %in% c('top','bottom')){    
        plot(0,xlim=c(0,1),ylim=c(0,1.1),frame=FALSE,axes=FALSE,type='n')
        for(i in 1:length(COL)){
            rect(0.2+0.6*(i-1)/length(COL),1,0.2+0.6*i/length(COL),0.6,col=COL[i],border=COL[i])
        }
        NSEGs=seq(0.2,0.8,length.out=length(COL)/2+ifelse(length(COL)%%2==1,0,1))
        for(i in 1:length(NSEGs)){
            segments(NSEGs[i],0.6,NSEGs[i],0.5,lwd=0.5)
            text(NSEGs[i],0.45,signif(zlim[1]+(i-1)*diff(zlim)/length(COL),2),cex=0.6,adj=c(0.5,1))
        }
        rect(0.2,1,0.8,0.6,lwd=0.5)
    }
    if(legend %in% c('left','right')){
        if(legend == 'right')  plot(0,xlim=c(0,1),ylim=c(0,1),frame=FALSE,axes=FALSE,type='n')
        if(legend == 'left')  plot(0,xlim=c(1,0),ylim=c(0,1),frame=FALSE,axes=FALSE,type='n')
        for(i in 1:length(COL)){
            rect(0,0.2+0.6*(i-1)/length(COL),0.2,0.2+0.6*i/length(COL),col=COL[i],border=COL[i])
        }
        NSEGs=seq(0.2,0.8,length.out=length(COL)/2+ifelse(length(COL)%%2==1,0,1))
        for(i in 1:length(NSEGs)){
            segments(0.2,NSEGs[i],0.27,NSEGs[i],lwd=0.5)
            text(0.31,NSEGs[i],signif(zlim[1]+(i-1)*diff(zlim)/length(COL),2),cex=0.6,adj=c(ifelse(legend=='left',1,0),0.4))
        }
        rect(0,0.2,0.2,0.8,lwd=0.5)
    }
    if(exportPDF) dev.off()  
}
