#' Capture error in a GET response
#' @param response of a GET functions
#'
capture_error <- function(response) {
  # IF error in API
  if (http_error(response)) {
    stop(sprintf("OpenSky API request failed [%s]", status_code(response)), call. = FALSE)
  }
}

#' Create a named-list.
#' @param ... list of variables used to create the named-list.
#'
listn <- function(...) {
  dots <- list(...)
  if (length(dots) != 0) {
    objs <- as.list(substitute(list(...)))[-1L]
    nm <- as.character(objs)
    v <- lapply(nm, get)
    names(v) <- nm
    # Remove NULLs from list
    v <- v[vapply(v, Negate(is.null), NA)]
  } else {
    v <- list()
  }
  return(v)
}
