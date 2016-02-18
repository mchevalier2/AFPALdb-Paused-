#' Get a list of references associated to a given site.
#'
#' This function allows you to get a list of references associated to a given site.
#' @param Citation_Key Citation key.
#' @param fullRef Boolean. TRUE returns all the details of the site.
#' @param ORDERBY Field name to sort the output table. Default 'Site_Name'.
#' @keywords getSite
#' @export
#' @examples
#' getSiteFromReference("Chase_etal_2013")
#' getSiteFromReference("Tierney_etal_2008",TRUE)

getSiteFromReference <- function(Citation_Key, fullRef=FALSE, ORDERBY="Site_Name"){
    if(fullRef){  sql="SELECT Reference.Citation_Key,Site.* "
    }else{  sql="SELECT Reference.Citation_Key,Site_ID,Site_Name,Site.Record_Name,Lon,Lat,Archive "  }
    sql=paste(sql,"FROM Reference,RefSite,Site WHERE Reference.Citation_Key=RefSite.Citation_KEY AND RefSite.Record_Name=Site.Record_name AND Reference.Citation_Key ='",Citation_Key,"' ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])
}  

#' Get a list of studies performed in a given area.
#'
#' This function allows you to get a list of studies performed in a given area.
#' @param xmn Lower bound of the longitudinal range.
#' @param xmx Upper bound of the longitudinal range.
#' @param ymn Lower bound of the latitudinal range.
#' @param ymx Upper bound of the latitudinal range.
#' @param fullRef Boolean. TRUE returns all the details of the site.
#' @param ORDERBY Field name to sort the output table. Default 'Site_Name'.
#' @keywords getSite
#' @export
#' @examples
#' getSiteFromXY(20,30,-30,-20)
#' getSiteFromXY(25,30,-30,-20)
#' getSiteFromXY(25,20,-30,-20,ORDERBY="Lat")

getSiteFromXY <- function(xmn,xmx,ymn,ymx,fullRef=FALSE, ORDERBY="Site_Name"){
    if(xmx <= xmn){  tmp=xmx  ;  xmx=xmn  ;  xmn=tmp  }
    if(ymx <= ymn){  tmp=ymx  ;  ymx=ymn  ;  ymn=tmp  }
    if(fullRef){  sql="SELECT * "
    }else{  sql="SELECT Site_ID,Site_Name,Record_Name,Lon,Lat,Archive "  }
    sql=paste(sql,"FROM Site WHERE Lon >= ",xmn," AND Lon <= ",xmx," AND Lat >= ",ymn, " AND Lat <= ",ymx," ORDER BY ",ORDERBY,sep="")
    return(.executeSQL(sql)[[2]])   
}

#' Get a list of sites part of a given Region.
#'
#' This function allows you to get a list of sites part of a given Region.
#' @param Region Name of the region.
#' @param fullRef Boolean. TRUE returns all the details of the reference.
#' @param ORDERBY Field name to sort the output table. Default 'Site_Name'.
#' @keywords getSite
#' @export
#' @examples
#' getSiteFromRegion("SRZ")
#' getSiteFromRegion("WRZ",TRUE)

getSiteFromRegion <- function(Region,fullRef=FALSE,ORDERBY="Site_Name"){
    if(fullRef){  sql="SELECT Region,Site.* "
    }else{  sql="SELECT Region,Site_ID,Site_Name,Site.Record_Name,Lon,Lat,Archive "  }
    sql=paste(sql,"FROM Site,SiteRegion WHERE Site.Record_Name=SiteRegion.Record_Name AND SiteRegion.Region='",Region,"' ORDER BY ",ORDERBY,sep="")
    print(sql)
    return(.executeSQL(sql)[[2]])   
}

#' Get the site associated to a dataset.
#'
#' This function allows you to get the site associated to a dataset.
#' @param Region Name of the region.
#' @param fullRef Boolean. TRUE returns all the details of the site.
#' @keywords getSite
#' @export
#' @examples
#' getSiteFromDataID(1)
#' getSiteFromDataID(2,TRUE)

getSiteFromDataID <- function(Dataset_ID,fullRef=FALSE){
    if(fullRef){  sql="SELECT Dataset_ID,Site.* "
    }else{  sql="SELECT Dataset_ID,Site_ID,Site_Name,Site.Record_Name,Lon,Lat,Archive "  }
    sql=paste(sql,"FROM Site,Dataset WHERE Site.Record_Name=Dataset.Record_Name AND Dataset_ID=",Dataset_ID,sep="")
    return(.executeSQL(sql)[[2]])   
}




