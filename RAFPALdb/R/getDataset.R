#' Get a list of datasets associated to a given reference.
#'
#' This function allows you to get a list of datasets associated to a given reference. This function DOES NOT return data, just information about the dataset.
#' @param Citation_Key Citation key.
#' @param fullRef Boolean. TRUE returns all the details of the site.
#' @param ORDERBY Field name to sort the output table. Default 'Record_Name'.
#' @keywords getDataset
#' @export
#' @examples
#' getDatasetFromReference("Chase_etal_2013")
#' getDatasetFromReference("Tierney_etal_2008",ORDERBY="Proxy")

getDatasetFromReference <- function(Citation_Key, fullRef=FALSE, ORDERBY="Record_Name"){
    if(fullRef){  sql="SELECT Reference.Citation_Key,Dataset.* "
    }else{  sql="SELECT Reference.Citation_Key,Dataset_ID,Record_Name,Proxy,Digitized "  }
    sql=paste(sql,"FROM Reference,Dataset WHERE Reference.Citation_Key=Dataset.Citation_KEY AND Dataset.Citation_Key ='",Citation_Key,"' ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])
}  

#' Get a list of datasets associated to a given site.
#'
#' This function allows you to get a list of datasets associated to a given site. This function DOES NOT return data, just information about the dataset.
#' @param Citation_Key Citation key.
#' @param fullRef Boolean. TRUE returns all the details of the site.
#' @param ORDERBY Field name to sort the output table. Default 'Record_Name'.
#' @keywords getDataset
#' @export
#' @examples
#' getDatasetFromSite(Site_ID=1)
#' getDatasetFromSite(Site_Name="Seweweekspoort")
#' getDatasetFromSite(Record_Name="SWP-1-1")

getDatasetFromSite <- function(Site_ID=-1, Site_Name="", Record_Name="", fullRef=FALSE, ORDERBY="Record_Name"){
    if(fullRef){  sql="SELECT Site_ID, Site_Name, Site.Record_Name,Dataset.* "
    }else{  sql="SELECT Site_ID, Site_Name, Site.Record_Name,Dataset_ID,Citation_Key,Proxy,Digitized "  }
    sql=paste(sql,"FROM Dataset,Site WHERE Dataset.Record_Name=Site.Record_name AND ",sep="")
    if(Site_Name != "") sql=paste(sql,"Site_Name='",Site_Name,"' AND ",sep="")
    if(Record_Name != "") sql=paste(sql,"Site.Record_Name='",Record_Name,"' AND ",sep="")
    if(Site_ID != -1) sql=paste(sql,"Site.Site_ID=",Site_ID," AND ",sep="")
    sql=substr(sql,1,nchar(sql)-5) # Removing " AND "
    sql=paste(sql," ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])
}  
