#' DigitizeR software
#'
#' Starts the digitizeR software.
#' @keywords
#' @export
#' @examples
#' digitizeR()




openPDF <- function(file, bg=TRUE) {
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
