#' Connection to the database
#'
#' This function allows you to connect to AFPALdb.
#' @param user User.
#' @param pass Password. Default triggers the prompt.
#' @param host Adresse of the server. Default 'localhost'.
#' @keywords connect
#' @export
#' @examples
#' con=Connect(user="root",pass="root")

Connect=function(user,pass=-1,host="localhost"){
    if(pass==-1) pass=.get_password()
    assign("AFPALdb",RMySQL::dbConnect(RMySQL::MySQL(), dbname="AFPALdb",user=user,password=pass,host=host),envir=.GlobalEnv)
}


#' Connection to the database
#'
#' This function forces a connection to AFPALdb. Called by any function if the user didn't use the Connect() function.
#' @param user User.
#' @param pass Password. Default triggers the prompt.
#' @param host Adresse of the server. Default 'localhost'.
#' @keywords forceConnect
#' @export
#' @examples
#' con=forceConnect()

forceConnect=function(user=-1,pass=-1,host=-1){
    cat("\n    --- Connection to the database ---\n")
    cat("    User: ")
    user=readline()
    cat("    Host: ")
    host=readline()
    pass=.get_password()
    cat("    ----------------------------------\n\n")
    assign("AFPALdb",RMySQL::dbConnect(RMySQL::MySQL(), dbname="AFPALdb",user=user,password=pass,host=host),envir=.GlobalEnv)
}
