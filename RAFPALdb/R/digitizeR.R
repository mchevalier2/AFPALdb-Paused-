#' DigitizeR software
#'
#' Starts the digitizeR software.
#' @keywords
#' @export
#' @examples
#' digitizeR()


digitizeR <- function(){
    if (!requireNamespace("digitizeR", quietly = TRUE)) {
        stop("'digitizeR' package needed for this function to work. Please install it from github: 'devtools::install_github(\"ankitrohatgi/digitizeR\"').",
             call. = FALSE)
    }
    return(digitizeR::wpd.launch())
}

