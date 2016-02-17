#' Extract chronologies from the database
#'
#' This function allows you to extract JSON objects (chronology containers) from AFPALdb.
#' @param Site_Name Name of the site.
#' @param Record_Name Name of the specific record requested.
#' @param Citation_Key Reference associated to the dataset requested.
#' @param Proxy Type of proxy of dataset requested.
#' @param Chrono_ID ID of the requested dataset.
#' @keywords getData
#' @export
#' @examples
#' d0=getData() # Returns NULL
#' d1=getData(Site_Name="Seweweekspoort")
#' d2=getData(Proxy="d13C")
#' d3=getData(Citation_Key="Chase_etal_2013")
#' d4=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-1")


getData=function(Site_Name="", Record_Name="", Citation_Key="", Proxy="", Dataset_ID=-1, Chronology=TRUE){
    if(!exists("AFPALdb")) Connect()
    if(Site_Name=="" & Record_Name=="" & Citation_Key=="" & Proxy=="" & Dataset_ID==-1) return(NULL)
    sql="SELECT * FROM Dataset,Site,Reference WHERE Site.Record_Name=Dataset.Record_Name AND Reference.Citation_Key=Dataset.Citation_Key AND "
     
    if(Site_Name != "") sql=paste(sql,"Site_Name='",Site_Name,"' AND ",sep="")
    if(Record_Name != "") sql=paste(sql,"Site.Record_Name='",Record_Name,"' AND ",sep="")
    if(Citation_Key!= "") sql=paste(sql,"Reference.Citation_Key='",Citation_Key,"' AND ",sep="")
    if(Proxy!= "") sql=paste(sql,"Proxy='",Proxy,"' AND ",sep="")
    if(Dataset_ID != -1) sql=paste(sql,"Dataset_ID=",Dataset_ID," AND ",sep="")
    
    sql=substr(sql,1,nchar(sql)-5) # Removing " AND "
    d=RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, sql))
    if(nrow(d) == 1) return(rjson::fromJSON(d[,"Dataset"])[[1]])
    cat("\n")
    print(d[,c("Dataset_ID","Site_Name","Record_Name","Citation_Key","Proxy")])
    cat("\n")
    a <- .readinteger(txt=paste("Which dataset is being requested [A(ll)/Q(uit)/",paste(1:nrow(d),collapse="/"),"]: ",sep=""))
    if(grepl("^[0-9]+$",a)){
        if(as.integer(a) > nrow(d) | as.integer(a) <= 0){
            cat("Invalid selection.\n")
            a <- .readinteger(txt=paste("Which dataset is being requested [A(ll)/Q(uit)/",paste(1:nrow(d),collapse="/"),"]: ",sep=""))
        }
    }
    if(a == "A") return(rjson::fromJSON(d[,"Dataset"]))
    if(a == "Q") return(NULL)
    return(rjson::fromJSON(d[a,"dataset"])[[1]])
}


