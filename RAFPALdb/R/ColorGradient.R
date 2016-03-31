#' Open a SSH tunnel with the server to open a distant file.
#'
#' This functions opens a SSH tunnel with the server to open a distant file.
#' @param name Name of the gradient. If empty or mispelled, the user will have to select from the list of available gradients.
#' @param reverse Boolean to reverse the color gradient.
#' @keywords Plot
#' @export
#' @examples
#' getColorGradient()

getColorGradient <- function(name="",reverse=FALSE){
    colorlist=list()
    colorlist[["Rd2Bl20"]]=c(rgb(202,0,32,maxColorValue=252),rgb(210,34,52,maxColorValue=252),rgb(219,69,73,maxColorValue=252),rgb(228,104,93,maxColorValue=252),rgb(237,138,114,maxColorValue=252),rgb(244,169,136,maxColorValue=252),rgb(244,186,160,maxColorValue=252),rgb(245,203,185,maxColorValue=252),rgb(246,221,210,maxColorValue=252),rgb(246,238,234,maxColorValue=252),rgb(236,241,244,maxColorValue=252),rgb(215,231,239,maxColorValue=252),rgb(193,220,233,maxColorValue=252),rgb(172,210,228,maxColorValue=252),rgb(151,199,223,maxColorValue=252),rgb(123,183,214,maxColorValue=252),rgb(94,166,205,maxColorValue=252),rgb(64,148,195,maxColorValue=252),rgb(34,130,185,maxColorValue=252),rgb(5,113,176,maxColorValue=252))
    colorlist[["Brown2Green20"]]=c(rgb(166,97,26,maxColorValue=255),rgb(178,117,46,maxColorValue=255),rgb(190,137,67,maxColorValue=255),rgb(202,158,88,maxColorValue=255),rgb(214,178,109,maxColorValue=255),rgb(226,196,131,maxColorValue=255),rgb(228,207,156,maxColorValue=255),rgb(233,218,181,maxColorValue=255),rgb(238,228,207,maxColorValue=255),rgb(242,239,232,maxColorValue=255),rgb(232,240,239,maxColorValue=255),rgb(208,232,228,maxColorValue=255),rgb(183,223,217,maxColorValue=255),rgb(158,215,206,maxColorValue=255),rgb(134,207,195,maxColorValue=255),rgb(107,193,180,maxColorValue=255),rgb(81,178,163,maxColorValue=255),rgb(54,163,146,maxColorValue=255),rgb(27,148,129,maxColorValue=255),rgb(1,133,113,maxColorValue=255))
    colorlist[["Rainfall20"]]=c(rgb(247,251,255,maxColorValue=255),rgb(236,244,251,maxColorValue=255),rgb(226,238,248,maxColorValue=255),rgb(216,231,245,maxColorValue=255),rgb(207,225,242,maxColorValue=255),rgb(197,218,233,maxColorValue=255),rgb(180,211,232,maxColorValue=255),rgb(164,204,227,maxColorValue=255),rgb(145,195,222,maxColorValue=255),rgb(125,183,217,maxColorValue=255),rgb(105,172,213,maxColorValue=255),rgb(88,161,203,maxColorValue=255),rgb(71,149,200,maxColorValue=255),rgb(57,137,193,maxColorValue=255),rgb(43,123,186,maxColorValue=255),rgb(31,110,179,maxColorValue=255),rgb(20,96,168,maxColorValue=255),rgb(9,82,157,maxColorValue=255),rgb(8,65,132,maxColorValue=255),rgb(8,48,107,maxColorValue=255))
    if(name=="" | !(name %in% names(colorlist))){
        df=as.data.frame(names(colorlist))  ;  colnames(df)=""
        print(df)
        cat("\n")
        a <- .readinteger(txt=paste("Which gradient is being requested [",paste(1:length(names(colorlist)),collapse="/"),"]: ",sep=""),limit=length(names(colorlist)))
        name=names(colorlist)[as.integer(a)]
        cat("\n")
    }
    if(reverse) return(rev(colorlist[[name]]))
    return(colorlist[[name]])
}

