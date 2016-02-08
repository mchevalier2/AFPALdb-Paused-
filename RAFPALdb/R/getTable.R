#' Get the Site table.
#'
#' This function allows you to get all the entries from the AFPALdb.Site table.
#' @keywords getSiteList
#' @export
#' @examples
#' sites=getSiteList()

getSiteList=function(){
    if(!exists("AFPALdb")) forceConnect()
    return(RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, "select * from Site")))
}

#' Get the Reference table.
#'
#' This function allows you to get all the entries from the AFPALdb.Reference table.
#' @keywords getReferenceList
#' @export
#' @examples
#' ref=getReferenceList()

getReferenceList=function(){
    if(!exists("AFPALdb")) forceConnect()
    return(RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, "select * from Reference")))
}

#' Get the Dataset table.
#'
#' This function allows you to get all the entries from the AFPALdb.Reference table, except the data.
#' @keywords getDatasetList
#' @export
#' @examples
#' dataset=getDatasetList()

getDatasetList=function(){
    if(!exists("AFPALdb")) forceConnect()
    return(RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, "select Dataset_ID, Site_Name, Citation_Key, Proxy, Digitized from Dataset")))
}

#' Get the Chronology table.
#'
#' This function allows you to get all the entries from the AFPALdb.Chronology table, except the data.
#' @keywords getChronologyList
#' @export
#' @examples
#' dataset=getChronologyList()

getChronologyList=function(){
    if(!exists("AFPALdb")) forceConnect()
    return(RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, "select Chrono_ID, Citation_Key, Site_Name, Chrono_Name, Model, Digitized from Chronology")))
}

#' Get the ChronoData table.
#'
#' This function allows you to get all the entries from the AFPALdb.ChronoData table.
#' @keywords getChronoDataList
#' @export
#' @examples
#' chronodata=getChronoDataList()

getChronoDataList=function(){
    if(!exists("AFPALdb")) forceConnect()
    return(RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, "select * from ChronoData")))
}

#' Get the ChronoC14 table.
#'
#' This function allows you to get all the entries from the AFPALdb.ChronoC14 table.
#' @keywords getChronoC14List
#' @export
#' @examples
#' chronodata=getChronoC14List()

getChronoC14List=function(){
    if(!exists("AFPALdb")) forceConnect()
    return(RMySQL::dbFetch(RMySQL::dbSendQuery(AFPALdb, "select * from ChronoC14")))
}
