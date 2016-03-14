#' Generate a correlation plot.
#'
#' This figure measures the correlation between two records at different periods and with different time windows.
#' @param x1 Record to be compared. x1 must be a two-column matrix/data frame with time in the first column /and the variable to compare.
#' @param x2 Idem.
#' @param xmn Date of beginning of the comparison.
#' @param xmx Date of end of the comparison.
#' @param xstep Temporal interval between two measures.
#' @param ymn Minimum size of window to be measured.
#' @param ymx Maximum size of window to be measured. Default is a global measure of the correlation of the two records.
#' @param ystep Steps of the correlation window.
#' @param Contour Boolean. If TRUE, contours at every 0.1 point of correlation will be added to the figure.
#' @param exportPDF Boolean. If TRUE, the graphic will be saved in the file named 'savePDF'.
#' @param savePDF Address and Name of the file. Default if 'CorrelationPlot.pdf' in the working directory.
#' @param title Title to display on the graphic.
#' @param xlab Label of the x-axis.
#' @param ylab Label of the y-axis.
#' @keywords Plot
#' @export
#' @examples
#' d1=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-1",Proxy.Uncer=FALSE,Chrono.Uncer=FALSE,Proxy="d15N") ; d1=cbind(d1$Chronology,d1$Data$Data)
#' d2=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-1",Proxy.Uncer=FALSE,Chrono.Uncer=FALSE,Proxy="d13C") ; d2=cbind(d2$Chronology,d2$Data$Data)
#' correlationPlot(d1,d2,3000,8000,100,ymn=0,ystep=100,Contour=TRUE)


correlationPlot <- function(x1,x2,xmn,xmx,xstep,ymn=0,ymx=xmx,ystep,Contour=FALSE,exportPDF=TRUE,savePDF=paste(getwd(),"/CorrelationPlot.pdf",sep=""),title="CorrelationPlot",xlab="Age",ylab="Width"){
    ymx=min(ymx,xmx-xmn)
    
    xx=head(seq(xmn,xmx,xstep),-1)
    yy=seq(ymn,ymx,ystep)

    x1.interp=approx(x1,xout=xx)$y
    x2.interp=approx(x2,xout=xx)$y

    cor.mat=matrix(1.1,nrow=length(yy),ncol=length(xx))
    for(time in yy){
        v1=v2=rep(0,length(xx))
        start=xmn
        while(start<=xmx-time){
            w=which(xx>=start & xx<=start+time)
            if(!is.na(cor(x1.interp[w],x2.interp[w]))){
                v1[w]=v1[w]+cor(x1.interp[w],x2.interp[w])
                v2[w]=v2[w]+1
            }   
            start=start+xstep
        }
        cor.mat[(time-ymn)/ystep+1,]=v1/v2
    }

    rgb.palette <- colorRampPalette(c("red", "grey20", "blue"), space = "rgb")
    col.gradient=rgb.palette(21)
    
    if(exportPDF) pdf(savePDF,width=4+0.21,height=4+0.32)  
    par(mar=c(2.1,2,1.1,0.1),mgp=c(1,0.4,-0.5))
    plot(0,xlim=c(xmn,xmx),ylim=c(ymn,ymx),type='n',axes=FALSE,frame=FALSE,main=title,xlab=xlab,ylab=ylab,cex.lab=0.8)
    rect(xmn,ymn,xmx,ymx+ystep,col="black")
    for(i in 1:length(yy)){
        for(j in 1:length(xx)){
            rect(xx[j],yy[i],xx[j]+xstep,yy[i]+ystep,border=col.gradient[trunc(10*cor.mat[i,j])+11],col=col.gradient[trunc(10*cor.mat[i,j])+11])
        }
    }
    if(Contour){
        contour(xx+xstep/2,yy,z=t(cor.mat),add=TRUE,nlevels=10,lwd=0.3,levels=seq(-0.9,0.9,0.2),labels=seq(-0.9,0.9,0.2),col="grey80")
        contour(xx+xstep/2,yy,z=t(cor.mat),add=TRUE,nlevels=10,lwd=0.3,levels=seq(-0.8,0.8,0.2),drawlabels=FALSE,col="grey80")
    }
    axis(1,at=c(xmn,xmx),labels=c("",""),lwd.ticks=0)
    axis(1,lwd=1,lwd.ticks=1,cex.axis=0.8)
    axis(2,at=c(ymn,ymx+ystep),labels=c("",""),lwd.ticks=0)
    axis(2,lwd=1,lwd.ticks=1,cex.axis=0.8)
    if(exportPDF) dev.off()
    
}

