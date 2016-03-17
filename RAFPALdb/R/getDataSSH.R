#' Open a SSH tunnel with the server to open a file.
#'
#' This functions opens a SSH tunnel with the server to open a file.
#' @param file Complete address of the file.
#' @param header Boolean (used in read.table).
#' @param sep Column separator (used in read.table).
#' @keywords connection
#' @export
#' @examples
#' head(getDataSSH("/home/emmanuel.chevalier/Bureau/*.csv"))

getDataSSH <- function(file,header=TRUE,sep=","){
    cat("\n  The requested file is not available locally. Let's open a SSH tunnel to get it.\n")
    if(!exists("SSH.user")){
        cat("\n    --- Connection to the server via SSH ---\n")
        cat("    Session name: ")  ;  SSH.user=readline()  ;   assign("SSH.user",SSH.user,envir=.GlobalEnv)
        cat("    ----------------------------------------\n\n")
    }
    cat("  ")
    return(read.table( pipe( paste('ssh ',SSH.user,'@162.38.197.158  "cat ',file,'"',sep="" )),header=header,sep=sep))
}
