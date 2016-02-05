#' Connection to the database
#'
#' This function allows you to connect to AFPALdb.
#' @param user User.
#' @param pass Password.
#' @keywords connect
#' @export
#' @examples
#' con=Connect(user="root",pass="root")

Connect=function(user,pass){
    return(RMySQL::dbConnect(RMySQL::MySQL(), "AFPALdb",user,pass))
}
