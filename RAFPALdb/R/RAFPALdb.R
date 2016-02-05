#' A Cat Function
#'
#' This function allows you to express your love of cats.
#' @param love Do you love cats? Defaults to TRUE.
#' @keywords cats
#' @export
#' @examples
#' cat_function()

test_fct=function(){
    #library(RMySQL)
    #library(rjson)
    
    con=dbConnect(MySQL(), "AFPALdb","Manuu","cgkrggjn")
    
    
    rs=dbSendQuery(con, "select * from dataset where Dataset_ID=1")
    d1=dbFetch(rs)
    fromJSON(d1[6][1,])
    
    
    
    rs=dbSendQuery(con, "select * from dataset where Dataset_ID=2")
    d1=dbFetch(rs)
    fromJSON(d1[6][1,])
}
