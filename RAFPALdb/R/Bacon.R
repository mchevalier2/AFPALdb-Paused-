#' Run Bacon.
#'
#' Run Bacon.
#' @param allparameters Usual parameters from the Bacon script. Check the manual.
#' @param saveData Boolean to keep Bacon outputs in the environment. Default: FALSE.
#' @keywords Chronology
#' @keywords Age-depth model
#' @export
#' @examples
#' Bacon()

Bacon <- function(core="MSB2K", thick=5, prob=0.95, d.min=NA, d.max=NA, d.by=1, unit="cm", maxcalc=500, depths.file=FALSE, acc.shape=1.5, acc.mean=20, mem.strength=4, mem.mean=0.7, hiatus.depths=NA, hiatus.shape=1, hiatus.mean=1000, after=.0001, cc=3, cc1="IntCal13", cc2="Marine13", cc3="SHCal13", cc4="ConstCal", postbomb=0, d.R=0, d.STD=0, t.a=3, t.b=4, normal=FALSE, suggest=TRUE, reswarn=c(10,200), remember=TRUE, cleanup=TRUE, ask=TRUE, run=TRUE, defaults="default_settings.txt", sep=",", dec=".", runname="", slump=NA, BCAD=FALSE, ssize=2000, rounded=1, th0=c(), burnin=min(200, ssize), MinYr=c(), MaxYr=c(), find.round=4, bins=c(), cutoff=.001, plot.pdf=TRUE, rotate.axes=FALSE, rev.yr=FALSE, rev.d=FALSE, yr.min=c(), yr.max=c(), normalise.dists=TRUE, plot.title=core, title.location="topleft", d.lab="Depth", yr.lab=c(), d.res=200, yr.res=200, date.res=100, grey.res=100, width=15, dark=1, greyscale=function(x) grey(1-x), C14.col=rgb(0,0,1,.35), C14.border=rgb(0,0,1,.5), cal.col=rgb(0,.5,.5,.35), cal.border=rgb(0,.5,.5,.5), range.col=grey(0.5), range.lty="12", hiatus.col=grey(0.5), hiatus.lty="12", wm.col="red", wm.lty="12", med.col=NA, med.lty="12", mar=c(3,3,1,1), mgp=c(1.5,.7,.0), bty="l", saveDATA=FALSE){
    savewd=getwd()
    setwd("/Users/chevalier/Workspace/AFPALdb/Bacon")

    env=new.env()
    source("Bacon.R",local=env)
    do.call(env$Bacon,list(core, thick, prob, d.min, d.max, d.by, unit, maxcalc, depths.file, acc.shape, acc.mean, mem.strength, mem.mean, hiatus.depths, hiatus.shape, hiatus.mean, after, cc, cc1, cc2, cc3, cc4, postbomb, d.R, d.STD, t.a, t.b, normal, suggest, reswarn, remember, cleanup, ask, run, defaults, sep, dec, runname, slump, BCAD, ssize, rounded, th0, burnin, MinYr, MaxYr, find.round, bins, cutoff, plot.pdf, rotate.axes, rev.yr, rev.d, yr.min, yr.max, normalise.dists, plot.title, title.location, d.lab, yr.lab, d.res, yr.res, date.res, grey.res, width, dark, greyscale, C14.col, C14.border, cal.col, cal.border, range.col, range.lty, hiatus.col, hiatus.lty, wm.col, wm.lty, med.col, med.lty, mar, mgp, bty),envir=env)
    setwd(savewd)
    if(!saveDATA) rm(hists,envir=globalenv())
    if(!saveDATA) rm(info,envir=globalenv())
}

#' Run Clam.
#'
#' Run Clam.
#' @param allparameters Usual parameters from the Clam script. Check the manual.
#' @param saveData Boolean to keep Bacon outputs in the environment. Default: FALSE.
#' @keywords Chronology
#' @keywords Age-depth model
#' @export
#' @examples
#' Clam()

Clam <- function(name="Example", type=1, smooth=c(), prob=0.95, its=1000, wghts=1, cc=3, cc1="IntCal13.14C", cc2="Marine13.14C", cc3="SHCal13.14C", cc4="mixed.14C", cc5="gluedHemispheres.14C", postbomb=FALSE, pb1="postbomb_NH1.14C", pb2="postbomb_NH2.14C", pb3="postbomb_NH3.14C", pb4="postbomb_SH1-2.14C", pb5="postbomb_SH3.14C", outliers=c(), ignore=c(), youngest=c(), extradates=c(), slump=c(), est=1, calibt=FALSE, mixed.effect=FALSE, dmin=c(), dmax=c(), every=1, yrmin=c(), yrmax=c(), yrsteps=1, pbsteps=0.01, hpdsteps=1, BCAD=FALSE, decimals=0, accrate=0, ageofdepth=c(), depth="cm", depthseq=c(), depths.file=FALSE, thickness=1, hiatus=c(), remove.reverse=0.5, times=5, sep=",", ext=".csv", runname=c(), storedat=FALSE, threshold=1e-6, proxies=FALSE, revaxes=FALSE, revd=TRUE, revyr=TRUE, calhght=0.3, maxhght=0.01, mirror=TRUE, plotrange=TRUE, bty="l", mar=c(3.5,3,2,1), mgp=c(2,1,0), plotpdf=TRUE, plotpng=TRUE, greyscale=c(), yrlab=c(), dlab=c(), calcol=rgb(0,0.5,0.5,0.5), C14col=rgb(0,0,1,0.5), outcol="red", outlsize=1, bestcol="black", rangecol=rgb(0,0,0,0.3), slumpcol=grey(0.75), plotname=TRUE, ash=FALSE){
    savewd=getwd()
    setwd("/Users/chevalier/Workspace/AFPALdb/Clam")

    env=new.env()
    source("Clam.R",local=env)
    do.call(env$clam,list(name, type, smooth, prob, its, wghts, cc, cc1, cc2, cc3, cc4, cc5, postbomb, pb1, pb2, pb3, pb4, pb5, outliers, ignore, youngest, extradates, slump, est, calibt, mixed.effect, dmin, dmax, every, yrmin, yrmax, yrsteps, pbsteps, hpdsteps, BCAD, decimals, accrate, ageofdepth, depth, depthseq, depths.file, thickness, hiatus, remove.reverse, times, sep, ext, runname, storedat, threshold, proxies, revaxes, revd, revyr, calhght, maxhght, mirror, plotrange, bty, mar, mgp, plotpdf, plotpng, greyscale, yrlab, dlab, calcol, C14col, outcol, outlsize, bestcol, rangecol, slumpcol, plotname, ash),envir=env)
    setwd(savewd)
}
