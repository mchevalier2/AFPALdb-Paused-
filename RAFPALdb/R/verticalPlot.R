#' Generate a correlation plot.
#'
#' This figure measures the correlation between two records at different periods and with different time windows.
#' @param dat A list of two-columns matrixes that contains the data to plot. 
#' @param x.range Min and max values to plot on the x-axis. Default values are calculated from the min and max values from 'dat'.
#' @param xstep Distance between vertical lines. 
#' @param reverse Vector of boolean values that indicates whether the record should be plotted upside down. Default is FALSE.
#' @param ystep Vector that contains the distance between tickmarks on the y-axes. Dafault is 1/6th of the total range.
#' @param adjust Set to TRUE (default) to reduce the white space between the curves.
#' @param relativeHeight Vector that indicates the relative height each curve should add. By default, all curves have the same space allocated.
#' @param COL Vector of colors. Random selection of color by default.
#' @param CEX Size of the text. Default to 1.
#' @param exportPDF Boolean to indicate whether the figure should be save in a pdf.
#' @param savePDF Adress and name of the pdf. Default is "VarticalPlot.pdf" in the working directory.
#' @param xlab Label of the x-axis.
#' @param WIDTH Width of the pdf in inches (Default is 3.54in=90mm).
#' @param HEIGHT Height of the pdf in inches (Default is 9in=22-230mm).
#' @keywords Plot
#' @export
#' @examples
#' d1=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-1",Proxy.Uncer=FALSE,Chrono.Uncer=FALSE,Proxy="d15N") ; d1=cbind(d1$Chronology,d1$Data$Data)
#' d2=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-1",Proxy.Uncer=FALSE,Chrono.Uncer=FALSE,Proxy="d13C") ; d2=cbind(d2$Chronology,d2$Data$Data)
#' d3=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-5",Proxy.Uncer=FALSE,Chrono.Uncer=FALSE,Proxy="d13C") ; d3=cbind(d3$Chronology,d3$Data$Data)
#' d4=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-5",Proxy.Uncer=FALSE,Chrono.Uncer=FALSE,Proxy="d15N") ; d4=cbind(d4$Chronology,d4$Data$Data)
#' dat=list("SWP11-d15N"=d1,"SWP11-d13C"=d2,"SWP15-d13C"=d3,"SWP15-d15N"=d4)
#' verticalPlot(dat,adjust=TRUE,reverse=c(TRUE,FALSE,FALSE,TRUE),x.range=c(0,8000),xstep=1000,xlab="Age (Cal BP)",relativeHeight=c(2,2,2,2))


verticalPlot <- function(dat,x.range=range(unlist(lapply(dat,function(z)return(range(z[,1],na.rm=TRUE))))),xstep=1000,reverse=rep(FALSE,length(dat)),ystep=unlist(lapply(dat,function(z) return(round(diff(range(z[,2]))/6,1)))),adjust=TRUE,relativeHeight=rep(1,length(dat)),COL=sample(colors(),length(dat)),CEX=1,exportPDF=TRUE,savePDF=paste(getwd(),"/VerticalPlot.pdf",sep=""),xlab="Age",WIDTH=3.54,HEIGHT=9){

    dat.norm=list()
    for(i in 1:length(dat)){  dat.norm[[i]]=cbind(dat[[i]][,1],(reverse[i]+(-2*reverse[i]+1)*(dat[[i]][,2]-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE)))*relativeHeight[i])  }
    
    correctif=(0:(length(dat)-1))*relativeHeight-0.1
    if(adjust){
        for(i in 2:length(dat)){
            tmp=999
            for(j in 0:20){
                xout1=seq(x.range[1],x.range[2],xstep/100)
                xout2=seq(x.range[1]-xstep/10,x.range[2]+xstep/10,xstep/100)
                tmp=min(tmp,min(correctif[i]+approx(dat.norm[[i]][,1],dat.norm[[i]][,2],xout=xout1)$y-(correctif[i-1]+approx(dat.norm[[i-1]][,1],dat.norm[[i-1]][,2],xout=xout2)$y[(1+j):(length(xout2)-20+j)]),na.rm=TRUE))
            }
            correctif[i]=correctif[i]-tmp+0.15
        }
    }

    if(exportPDF) pdf(savePDF,width=WIDTH,height=HEIGHT)

    par(mar=c(0,0,0,0),oma=c(0,0,0,0))
    layout(matrix(c(1:4,4,4),ncol=3,byrow=TRUE),width=c(1,3.5,1),height=c(14,1))

    plot(0,0,type='n',frame=FALSE,axes=FALSE,xlim=c(0,1),ylim=c(0,rev(correctif)[1]+rev(relativeHeight)[1]))
    for(i in seq(1,length(dat),2)){
        segments(1,correctif[i],1,correctif[i]+1*relativeHeight[i])
        val=((min(dat[[i]][,2])%/%ystep[i])+1)*ystep[i]
        while(val <= max(dat[[i]][,2])){
            segments(1,correctif[i]+(-2*reverse[i]+1)*(val-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE))*relativeHeight[i]+reverse[i]*relativeHeight[i],0.9,correctif[i]+(-2*reverse[i]+1)*(val-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE))*relativeHeight[i]+reverse[i]*relativeHeight[i])
            text(0.88,correctif[i]+(-2*reverse[i]+1)*(val-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE))*relativeHeight[i]+reverse[i]*relativeHeight[i],val,adj=c(1,0.4),col=COL[i],cex=CEX)
            val=val+ystep[i]
        }
        text(0.05,0.5*relativeHeight[i]+correctif[i],names(dat)[i],col=COL[i],cex=CEX+0.1,srt=90,adj=c(0.5,1))
    }
    
    plot(0,0,xlim=x.range,ylim=c(0,rev(correctif)[1]+rev(relativeHeight)[1]),frame=FALSE,axes=FALSE,type='n',main="",xlab="",ylab="")
    for(i in seq(x.range[1],x.range[2],xstep)){  segments(i,-0.15,i,rev(correctif)[1]+rev(relativeHeight)[1],col="grey70",lty=5)  }
    for(i in 1:length(dat)){  points(dat.norm[[i]][,1],dat.norm[[i]][,2]+correctif[i],type='l',col=COL[i])  }

    plot(0,0,type='n',frame=FALSE,axes=FALSE,xlim=c(0,1),ylim=c(0,rev(correctif)[1]+rev(relativeHeight)[1]))
    for(i in seq(2,length(dat),2)){
        segments(0,correctif[i],0,correctif[i]+1*relativeHeight[i])
        val=((min(dat[[i]][,2])%/%ystep[i])+1)*ystep[i]
        while(val <= max(dat[[i]][,2])){
            segments(0,correctif[i]+(-2*reverse[i]+1)*(val-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE))*relativeHeight[i]+reverse[i]*relativeHeight[i],0.1,correctif[i]+(-2*reverse[i]+1)*(val-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE))*relativeHeight[i]+reverse[i]*relativeHeight[i])
            text(0.12,correctif[i]+(-2*reverse[i]+1)*(val-min(dat[[i]][,2],na.rm=TRUE))/diff(range(dat[[i]][,2],na.rm=TRUE))*relativeHeight[i]+reverse[i]*relativeHeight[i],val,adj=c(0,0.4),col=COL[i],cex=CEX)
            val=val+ystep[i]
        }
        text(0.95,0.5*relativeHeight[i]+correctif[i],names(dat)[i],col=COL[i],cex=CEX+0.1,srt=90,adj=c(0.5,0))
    }

    plot(0,0,xlim=c(x.range[1]-diff(x.range)/3.5,x.range[2]+diff(x.range)/3.5),ylim=c(0,1),frame=FALSE,axes=FALSE,type='n',main="",xlab="",ylab="")
    segments(x.range[1],1,x.range[2],1)
    for(i in seq(x.range[1],x.range[2],xstep)){
        segments(i,1,i,0.92-(i%%(2*xstep)==0)*0.05)
        if(i%%(2*xstep)==0){  text(i,0.82,i,adj=c(0.5,1),cex=CEX)  }
    }
    text(x.range[1]+mean(x.range),0.47,xlab,cex=CEX+0.1,adj=c(0.5,1))
    
    if(exportPDF) dev.off()
}
