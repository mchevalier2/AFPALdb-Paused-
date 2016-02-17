#' Extract datasets from the database
#'
#' This function allows you to extract JSON objects (data containers) from AFPALdb.
#' @param Site_Name Name of the site.
#' @param Record_Name Name of the specific record requested.
#' @param Citation_Key Reference associated to the dataset requested.
#' @param Proxy Type of proxy of dataset requested.
#' @param Dataset_ID ID of the requested dataset.
#' @keywords Dataset, Chronology
#' @export
#' @examples
#' d0=getData() # Returns NULL
#' d1=getData(Site_Name="Seweweekspoort")
#' d2=getData(Proxy="d13C")
#' d3=getData(Citation_Key="Chase_etal_2013")
#' d4=getData(Citation_Key="Chase_etal_2013",Record_Name="SWP-1-1",Proxy.Uncer=TRUE,Chrono.Uncer=TRUE)


getData <- function(Site_Name="", Record_Name="", Citation_Key="", Proxy="", Proxy.Uncer=FALSE, Dataset_ID=-1, Chronology=TRUE, Chrono.Uncer=FALSE){
    if(Site_Name=="" & Record_Name=="" & Citation_Key=="" & Proxy=="" & Dataset_ID==-1) return(NULL)
    sql="SELECT * FROM Dataset,Site,Reference WHERE Site.Record_Name=Dataset.Record_Name AND Reference.Citation_Key=Dataset.Citation_Key AND "
     
    if(Site_Name != "") sql=paste(sql,"Site_Name='",Site_Name,"' AND ",sep="")
    if(Record_Name != "") sql=paste(sql,"Site.Record_Name='",Record_Name,"' AND ",sep="")
    if(Citation_Key!= "") sql=paste(sql,"Reference.Citation_Key='",Citation_Key,"' AND ",sep="")
    if(Proxy!= "") sql=paste(sql,"Proxy='",Proxy,"' AND ",sep="")
    if(Dataset_ID != -1) sql=paste(sql,"Dataset_ID=",Dataset_ID," AND ",sep="")
    
    sql=substr(sql,1,nchar(sql)-5) # Removing " AND "
    d=.executeSQL(sql)
    if(d[[1]]==TRUE){
        d=d[[2]]
        if(nrow(d) == 1){
            if(Proxy.Uncer){
                if(Chronology){
                    out=list()
                    out[["Data"]]=list("Data"=.unpackJSON(d[,"dataset"]),"Uncertainties"=.unpackJSON(d[,"Uncertainties"]))
                    out[["Chronology"]]=getChronoFromDataID(d[,"Dataset_ID"], Chrono.Uncer)
                    return(out)
                }else{
                    return(list("Data"=.unpackJSON(d[,"dataset"]),"Uncertainties"=.unpackJSON(d[,"Uncertainties"])))
                }
            }else{
                if(Chronology){
                    out=list()
                    out[["Data"]]=list("Data"=.unpackJSON(d[,"dataset"]))
                    out[["Chronology"]]=getChronoFromDataID(d[,"Dataset_ID"], Chrono.Uncer)
                    return(out)
                }else{
                    return(unpackJSON(d[,"dataset"]))
                }
            }
        }else{
            cat("\n")
            print(d[,c("Dataset_ID","Site_Name","Record_Name","Citation_Key","Proxy")])
            cat("\n")
            a <- .readinteger(txt=paste("Which dataset is being requested [A(ll)/Q(uit)/",paste(1:nrow(d),collapse="/"),"]: ",sep=""),limit=nrow(d))
            
            if(a == "Q") return(NULL)
            if(a == "A"){a=1:nrow(d)}else{a=as.integer(a)}

            out=list()
            for(i in a){
                print(i)
                if(Proxy.Uncer){
                    if(Chronology){
                        out[[paste(d[i,"Dataset_ID"])]]=list(
                               "Data"=list("Data"=.unpackJSON(d[i,"dataset"]),"Uncertainties"=.unpackJSON(d[i,"Uncertainties"])),
                               "Chronology"=getChronoFromDataID(d[i,"Dataset_ID"], Chrono.Uncer))
                    }else{
                        return(list("Data"=.unpackJSON(d[i,"dataset"]),"Uncertainties"=.unpackJSON(d[i,"Uncertainties"])))
                    }
                }else{
                    if(Chronology){
                        out[[paste(d[i,"Dataset_ID"])]]=list(
                               "Data"=list("Data"=.unpackJSON(d[i,"dataset"])),
                               "Chronology"=getChronoFromDataID(d[i,"Dataset_ID"], Chrono.Uncer))
                    }else{
                        return(unpackJSON(d[,"dataset"]))
                    }
                }
            }
            return(out)
        }
    }
}


