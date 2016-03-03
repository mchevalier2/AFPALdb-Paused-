#' 
#'
#' This function allows you to get a password without echoing.
#' @keywords txt
#' @keywords limit
#' @export
#' @examples


.readinteger <- function(txt,limit)
{ 
  n <- readline(prompt=txt)
  if(!grepl("^[0-9,A,Q,a,q]+$",n))    return(.readinteger(txt,limit))
  if(grepl("^[0-9]+$",n)){
        if(as.integer(n) > limit | as.integer(n) <= 0){
            cat("Invalid selection.\n")
            return(.readinteger(txt,limit))
        }
  }
  return(n)
}

#' 
#'
#' This function allows you to get a password without echoing.
#' @keywords txt
#' @keywords limit
#' @export
#' @examples


.readYN <- function(txt)
{ 
  n <- readline(prompt=txt)
  if(!grepl("^[y,n,Y,N]+$",n))    return(.readYN(txt,limit))
  return(n)
}
