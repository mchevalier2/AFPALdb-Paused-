#' Extraction of data
#'
#' This function allows you to extract data.
#' @keywords extract
#' @export
#' @examples
#' Extract_data()

Extract_data=function(){
    rs=RMySQL::dbSendQuery(AFPALdb, "select * from dataset where Dataset_ID=1")
    d1=RMySQL::dbFetch(rs)
    rjson::fromJSON(d1[6][1,])
      
    rs=RMySQL::dbSendQuery(AFPALdb, "select * from dataset where Dataset_ID=2")
    d1=RMySQL::dbFetch(rs)
    rjson::fromJSON(d1[6][1,])
}
