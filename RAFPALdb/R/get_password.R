#' Get a password without echoing 
#'
#' This function allows you to get a password without echoing.
#' @keywords password
#' @export
#' @examples
#' pass=get_password()


get_password <- function() {
    cat("    Password: ")
    system("stty -echo")
    a <- readline()
    system("stty echo")
    cat("\n")
    return(a)
}
