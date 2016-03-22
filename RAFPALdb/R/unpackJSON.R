
#' #' 
#'
#' This function sends a request to the database and tests the result.
#' @keywords JSON
#' @export
#' @examples
#' .unpackJSON("")


.unpackJSON <- function(json)
{
    if(is.na(json)) return(NULL)
    dat=rjson::fromJSON(json)
    if(length(dat)==1) return(as.numeric(as.vector(unlist(dat[[1]]))))
    dat=lapply(dat,function(x) return(lapply(x,function(y) return(ifelse(is.null(y),NA,y)))))
    dat=t(do.call(rbind.data.frame, dat)) ; rownames(dat)=1:nrow(dat)
    cc=colnames(dat)
    if(sum(sapply(cc,function(x) return(is.na(as.numeric(x)))))==0){ # If there is no conversion of a string to a float
        dat=dat[,order(as.numeric(cc))]
    }
    dat2=matrix(0,ncol=ncol(dat),nrow=nrow(dat))
    for(i in 1:ncol(dat)) dat2[,i]=as.vector(as.numeric(dat[,i]))
    colnames(dat2)=colnames(dat)
    return(dat2)
}
