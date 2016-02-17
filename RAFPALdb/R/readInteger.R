#' 
#'
#' This function allows you to get a password without echoing.
#' @keywords password
#' @export
#' @examples
#' pass=get_password()


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
