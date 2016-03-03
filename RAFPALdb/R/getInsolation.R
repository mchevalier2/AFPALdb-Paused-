#' Get monthly insolation values.
#'
#' This function allows to extract monthly insolation values at 500 years resolution between present and 100,000 years ago.
#' @param lat Latitude of the desired insolation. Integer between -90 and 90.
#' @param month Month of the desired insolation. Can be either an integer between 1 and 12 or a string among jan/feb/mar/apr/may/jun/jul/aug/sep/oct/nov/dcm.
#' @param from Beginning of the desired period of time. Default is '0'.
#' @param to End of the desired period of time. Default is '100,000'.
#' @keywords getInsolation
#' @export
#' @examples
#' getInsolation(65,"aug",0,35000)
#' getInsolation(-30,"dec",10000,0000)

getInsolation <- function(lat,month,from=0,to=100000){
    XX=seq(100000,0,-500)  ;  x1=rev(which(XX>=from))[1]  ;  x2=which(XX<=to)[1]
    if(to>from){
     
        MONTH=c("jan","feb","mar","apr","may","jun","jul","aug","sep","oct","nov","dcm")
        if(month %in% 1:12){  month=MONTH[month]  }
        if(month %in% MONTH){
            sql=paste("SELECT ",month," FROM Insolation WHERE lat=",lat,sep="")
            d=.executeSQL(sql)
            if(d[[1]]){
                d=rjson::fromJSON(d[[2]][,month])[seq(x1,x2,-1)]
                return(cbind(XX[seq(x1,x2,-1)],d))
            }
        }else{
            cat("/!\\ +",month,"+ mispelled. The parameter 'month' must be from that list: jan/feb/mar/apr/may/jun/jul/aug/sep/oct/nov/dcm.\n",sep="")
        }
    }else{
       cat("\n")
       a=.readYN(paste("Date of beginning is older than the date of end. Did you mean FROM=",to," AND TO=",from,"? [Y/N]: ",sep=""))
       if(toupper(a)=="Y"){
           return(getInsolation(lat,month,to,from))
       }      
   }
}

