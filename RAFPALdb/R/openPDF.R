#' Function that opens pdf files from a reference or an author.
#'
#' Function that opens pdf files from a reference or an author.
#' @param Citation_Key Key of the reference.
#' @param Author Name of the author. Selection on the terminal possible if many references correspond to the name.
#' @keywords openPDF
#' @export
#' @examples
#' openArticle("Baker_etal_2014")
#' openArticle(Author="Scott")



openArticle <- function(Citation_Key="",Author=""){
    if(paste(Citation_Key,".pdf",sep="") %in% list.files("/Users/chevalier/Workspace/AFPALdb/Articles/")){
        .openPDF(paste("/Users/chevalier/Workspace/AFPALdb/Articles/",Citation_Key,".pdf",sep=""))
    }else{
        cat(paste("\n -> No file associated with the Citation_Key '",Citation_Key,"' available.\n",sep=""))
    }
    if(Author != ""){
        sql=paste("SELECT Citation_Key,Authors,Journal,Year FROM Reference WHERE Authors LIKE '%",Author,"%'",sep="")
        print(sql)
        d=.executeSQL(sql)
        if(d[[1]]){
            if(nrow(d[[2]])==1) .openPDF(paste("/Users/chevalier/Workspace/AFPALdb/Articles/",d[[2]][,"Citation_Key"],".pdf",sep=""))
            print(d[[2]])
            a <- .readinteger(txt=paste("Which Paper is being requested [",paste(1:nrow(d[[2]]),collapse="/"),"]: ",sep=""),limit=nrow(d[[2]]))
            openArticle(d[[2]][a,"Citation_Key"])
        }
    }
}



.openPDF <- function(file, bg=TRUE) {
   OST <- .Platform$OS.type
   if (OST=="windows")
      shell.exec(file)
   else
      if (OST == "unix") {
         bioCOpt <- getOption("BioC")
         pdf <- getOption("pdfviewer")
         msg <- NULL
         if (is.null(pdf))
             msg <- "getOption('pdfviewer') is NULL"
         else if (length(pdf)==1 && nchar(pdf[[1]])==0)
             msg <- "getOption('pdfviewer') is ''"
         if (!is.null(msg))
             stop(msg, "; please use 'options(pdfviewer=...)'")
         cmd <- paste(pdf,file)
         if( bg )
            cmd <- paste(cmd, "&")
         system(cmd)
      }
    return(TRUE)
}
