#' 
#'
#' This function sends a request to the database and tests the result.
#' @keywords unpackJSON
#' @export
#' @examples
#' .unpackJSON("")


.unpackJSON <- function(json)
{
    if(is.na(json)) return(NULL)
    dat=rjson::fromJSON(json)
    if(length(dat)==1) return(as.vector(unlist(dat[[1]])))
    dat=t(do.call(rbind.data.frame, dat)) ; rownames(dat)=1:nrow(dat)
    return(dat)
}
