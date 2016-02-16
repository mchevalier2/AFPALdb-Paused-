#' Connection to the database
#'
#' This function allows you to connect to AFPALdb.
#' @param user User.
#' @param pass Password.
#' @param host Adresse of the server. Default 'localhost'.
#' @keywords connection
#' @export
#' @examples
#' Connect(user="root",pass="root123")

Connect=function(user=-1,pass=-1,host=-1){
    cat("\n    --- Connection to the database ---\n")
    if(user==-1){  cat("    User: ")  ;  user=readline()  }
    if(host==-1){  cat("    Host (leave empty for localhost): ")  ;  a=readline()  ;  if(a!="") host=a else host="localhost" }
    if(pass==-1) pass=.get_password()
    cat("    ----------------------------------\n\n")
    assign("AFPALdb",RMySQL::dbConnect(RMySQL::MySQL(), dbname="AFPALdb",user=user,password=pass,host=host),envir=.GlobalEnv)
}


#' Disconnect the user from the database
#'
#' This function disconnects the AFPALdb.
#' @keywords connection
#' @export
#' @examples
#' Disconnect()

Disconnect=function(){
    RMySQL::dbDisconnect(AFPALdb)
    rm("AFPALdb")
}


