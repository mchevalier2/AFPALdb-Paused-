#' 
#'
#' This function sends a request to the database and tests the result.
#' @keywords executeSQL
#' @export
#' @examples
#' .executeSQL("SHOW TABLES")


.executeSQL <- function(sql)
{
    if(!exists("AFPALdb")) Connect()
    op=options(warn = (-1))
    d=RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb,sql))
    options(op)
    if(nrow(d)==0){
        cat("\nNo data associated with this request.\n  --> ",sql,"\n\n")
        return(list(FALSE,NULL))
    }
    return(list(TRUE,d))
}
