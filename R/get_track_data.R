#' @title get_track_data
#' @name get_track_data
#' @description Retrieve flights for a certain airport which arrived within a given time interval. If no flights are found for the given period, HTTP stats 404 - Not found is returned with an empty response body.
#'
#' @param username Your opensky-network username.
#' @param password Your opensky-network password.
#' @param icao24 Unique ICAO 24-bit address of the transponder in hex string representation. All letters need to be lower case
#' @param time Unix time in seconds since epoch. It can be any time between start and end of a known flight. If time = 0, get the live track if there is any flight ongoing for the given aircraft.
#'
#' @return A dataframe with the trajectory of a certain aircraft at a given time.
#'
#' @usage get_track_data(username, password, icao24, time)
#'
#' @export
#' @import httr



get_track_data <- function(username = NULL, password = NULL, icao24 = NULL, time = NULL) {

  if (!is.null(icao24) && !is.null(time) && !is.null(username) && !is.null(password)) {
    # Build list of the GET params:
    params_list <- list(icao24 = icao24, time = time)
    params_list <- params_list[vapply(params_list, Negate(is.null), NA)]
    url_request <- "https://opensky-network.org/api/tracks/all"
  } else {
    stop("OpenSky API needs login and icao parameters to get this data", call. = FALSE)
  }

  response_init <- GET(url_request, authenticate(username, password), query = params_list)
  capture_error(response_init)
  response <- content(response_init)

  # Put track_data in df format:
  track_data <- as.data.frame(do.call(rbind, lapply(response$path, as.vector)))
  colnames(track_data) <- recover_names("trackdata_names")

  meta_data <- data.frame(response[1:4])
  colnames(meta_data) <- recover_names("tracks_names")

  m_response<-merge(meta_data,track_data)

  return(m_response)
}
