#' Get a list of references associated to a given site.
#'
#' This function allows you to get a list of references associated to a given site.
#' @param Site_ID ID of the site.
#' @param Site_Name Name of the site.
#' @param Record_Name Name of the record.
#' @param fullRef Boolean. TRUE returns all the details of the reference.
#' @param ORDERBY Field name to sort the output table. Default 'Citation_Key'.
#' @keywords getReference
#' @export
#' @examples
#' d1=getReferenceFromSite(Site_Name="Seweweekspoort")
#' d2=getReferenceFromSite(Site_ID=1,fullRef=FALSE,ORDERBY="Journal")
#' d3=getReferenceFromSite(Record_Name="SWP-1-1",fullRef=TRUE)

getReferenceFromSite <- function(Site_ID=-1, Site_Name="", Record_Name="", fullRef=FALSE,ORDERBY="Citation_Key"){
    if(fullRef){  sql="SELECT Site_Name,Site.Record_Name,Reference.* "
    }else{  sql="SELECT Site_Name,Site.Record_Name,Reference.Citation_Key,Journal,Year "  }
    sql=paste(sql,"FROM Reference,RefSite,Site WHERE Reference.Citation_Key=RefSite.Citation_KEY AND RefSite.Record_Name=Site.Record_name AND ",sep="")
    if(Site_Name != "") sql=paste(sql,"Site_Name='",Site_Name,"' AND ",sep="")
    if(Record_Name != "") sql=paste(sql,"Site.Record_Name='",Record_Name,"' AND ",sep="")
    if(Site_ID != -1) sql=paste(sql,"Site.Site_ID=",Site_ID," AND ",sep="")
    sql=substr(sql,1,nchar(sql)-5) # Removing " AND "
    sql=paste(sql," ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])
}  

#' Get a list of studies performed in a given area.
#'
#' This function allows you to get a list of studies performed in a given area.
#' @param xmn Lower bound of the longitudinal range.
#' @param xmx Upper bound of the longitudinal range.
#' @param ymn Lower bound of the latitudinal range.
#' @param ymx Upper bound of the latitudinal range.
#' @param fullRef Boolean. TRUE returns all the details of the reference.
#' @param ORDERBY Field name to sort the output table. Default 'Citation_Key'.
#' @keywords getReference
#' @export
#' @examples
#' getReferenceFromXY(20,30,-30,-20,ORDERBY="Site_Name")
#' getReferenceFromXY(25,30,-30,-20,fullRef=TRUE)
#' getReferenceFromXY(25,20,-30,-20)

getReferenceFromXY <- function(xmn,xmx,ymn,ymx,fullRef=FALSE,ORDERBY="Citation_Key"){
    if(xmx <= xmn){  tmp=xmx  ;  xmx=xmn  ;  xmn=tmp  }
    if(ymx <= ymn){  tmp=ymx  ;  ymx=ymn  ;  ymn=tmp  }
    if(fullRef){  sql="SELECT Site_Name,Site.Record_Name,Reference.* "
    }else{  sql="SELECT Site_Name,Site.Record_Name,Reference.Citation_Key,Journal,Year "  }
    sql=paste(sql,"FROM Reference,RefSite,Site WHERE Reference.Citation_Key=RefSite.Citation_KEY AND RefSite.Record_Name=Site.Record_name AND Lon >= ",xmn," AND Lon <= ",xmx," AND Lat >= ",ymn, " AND Lat <= ",ymx," ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])   
}

#' Get a list of studies performed in a given Region.
#'
#' This function allows you to get a list of studies performed in a given Region.
#' @param Region Name of the region.
#' @param fullRef Boolean. TRUE returns all the details of the reference.
#' @param ORDERBY Field name to sort the output table. Default 'Citation_Key'.
#' @keywords getReference
#' @export
#' @examples
#' getReferenceFromRegion("SRZ")
#' getReferenceFromRegion("WRZ",TRUE,ORDERBY="Site_Name")

getReferenceFromRegion <- function(Region,fullRef=FALSE,ORDERBY="Citation_Key"){
    if(fullRef){  sql="SELECT Site_Name,Site.Record_Name,Reference.* "
    }else{  sql="SELECT Site_Name,Site.Record_Name,Reference.Citation_Key,Journal,Year "  }
    sql=paste(sql,"FROM Reference,RefSite,Site,SiteRegion WHERE Reference.Citation_Key=RefSite.Citation_KEY AND RefSite.Record_Name=Site.Record_name AND Site.Record_Name=SiteRegion.Record_Name AND SiteRegion.Region='",Region,"' ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])   
}

#' Get the reference associated to a dataset.
#'
#' This function allows you to get the reference associated to a dataset.
#' @param Region Name of the region.
#' @param fullRef Boolean. TRUE returns all the details of the reference.
#' @keywords getReference
#' @export
#' @examples
#' getReferenceFromDataID(1)
#' getReferenceFromDataID(2,TRUE)

getReferenceFromDataID <- function(Dataset_ID,fullRef=FALSE){
    if(fullRef){  sql="SELECT Dataset_ID,Reference.* "
    }else{  sql="SELECT Dataset_ID,Reference.Citation_Key,Journal,Year "  }
    sql=paste(sql,"FROM Reference,Dataset WHERE Reference.Citation_Key=Dataset.Citation_Key AND Dataset_ID=",Dataset_ID,sep="")
    return(.executeSQL(sql)[[2]])   
}






