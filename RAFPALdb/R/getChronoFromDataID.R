#' Extract datasets from the database
#'
#' This function allows you to extract the chronology of a dataset identified by its ID.
#' @param Dataset_ID ID of the dataset that needs its little chronology.
#' @param Uncertainties Boolean value for the extraction of chronological uncertainties.
#' @keywords Dataset, Chronology
#' @export
#' @examples
#' chrono1=getChronoFromDataID(49)
#' chrono2=getChronoFromDataID(49,TRUE)


getChronoFromDataID <- function(Dataset_ID,Uncertainties=FALSE){
    d=.executeSQL(paste("SELECT * FROM ChronoData,Chronology WHERE ChronoData.Chrono_ID=Chronology.Chrono_ID AND Dataset_ID=",Dataset_ID,sep=""))
    if(d[[1]]==TRUE){
        d=d[[2]]
        if(nrow(d) == 1){
            if(Uncertainties){
                uncer=t(do.call(rbind.data.frame, rjson::fromJSON(d[,"Uncertainties"]))) ; rownames(uncer)=1:nrow(uncer)
                return(list("Chronology"=unlist(rjson::fromJSON(d[,"Chronology"])[[1]]),"Uncertainties"=uncer))
            }else{
                return(unlist(rjson::fromJSON(d[,"Chronology"])[[1]]))
            }
        }
        
        cat("\n")
        print(d[,c("Dataset_ID","Chrono_ID","Citation_Key","Model")])
        cat("\n")
 
        a <- .readinteger(txt=paste("Which Chronology is being requested [A(ll)/Q(uit)/",paste(1:nrow(d),collapse="/"),"]: ",sep=""),limit=nrow(d))
        
        if(a == "A"){
            out=list()
            if(Uncertainties){
                for(i in 1:nrow(d)){
                    out[[str(d[i,"Chrono_ID"])]]=list()
                    uncer=t(do.call(rbind.data.frame, rjson::fromJSON(d[i,"Uncertainties"]))) ; rownames(uncer)=1:nrow(uncer)
                    out[[str(d[i,"Chrono_ID"])]][["Chronology"]]=unlist(rjson::fromJSON(d[i,"Chronology"])[[1]])
                    out[[str(d[i,"Chrono_ID"])]][["Uncertainties"]]=uncer
                }
            }else{
                for(i in 1:nrow(d)){
                    out[[str(d[i,"Chrono_ID"])]]=unlist(rjson::fromJSON(d[i,"Chronology"])[[1]])
                }
            }
            return(out)
        }
        if(a == "Q") return(NULL)
        
        if(Uncertainties){
            uncer=t(do.call(rbind.data.frame, rjson::fromJSON(d[a,"Uncertainties"]))) ; rownames(uncer)=1:nrow(uncer)
            return(list("Chronology"=unlist(rjson::fromJSON(d[a,"Chronology"])[[1]]),"Uncertainties"=uncer)) 
        }else{
            return(unlist(rjson::fromJSON(d[a,"Chronology"])[[1]]))
        }
    }
   
}

