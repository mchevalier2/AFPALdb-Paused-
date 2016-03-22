#' Performs a moving average. 
#'
#' This function performs a mpoving average.
#' @export
#' @examples
#' .mov.avg(1:100)

.mov.avg=function(x,n=11){filter(x,rep(1/n,n), sides=2)}
