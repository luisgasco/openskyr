#' Capture error in a GET response
#' @param response of a GET functions
#'
#'@keywords internal
capture_error <- function(response) {
  # IF error in API
  if (http_error(response)) {
    stop(sprintf("OpenSky API request failed [%s]", status_code(response)), call. = FALSE)
  }
}

#' Create a named-list.
#' @param ... list of variables used to create the named-list.
#'
#'@keywords internal
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

#' Recover column names
#' @param option Option of column names recovered
#'
#'@keywords internal
recover_names <- function(option) {

  if(option == "airport_names"){
    colnames <- c("icao24", "firstSeen", "estDepartureAirport", "lastSeen", "estArrivalAirport", "callsign",
                         "estDepartureAirportHorizDistance","estDepartureAirportVertDistance", "estArrivalAirportHorizDistance",
                         "estArrivalAirportVertDistance", "departureAirportCandidatesCount", "arrivalAirportCandidatesCount")
  } else if(option == "flight_names") {
    colnames <- c("icao24", "firstSeen", "estDepartureAirport", "lastSeen", "estArrivalAirport", "callsign",
                          "estDepartureAirportHorizDistance","estDepartureAirportVertDistance", "estArrivalAirportHorizDistance",
                          "estArrivalAirportVertDistance", "departureAirportCandidatesCount", "arrivalAirportCandidatesCount")
  } else if(option == "statevector_names") {
    colnames <- c("icao24", "callsign", "origin_country", "time_position", "last_contact", "longitude", "latitude",
                                "baro_altitude", "on_ground","velocity", "true_track", "vertical_rate", "geo_altitude", "squawk",
                                "spi", "position_source")
  } else if (option == "tracks_names") {
    colnames <- c("icao24","startTime","endTime","callsign")
  } else if (option == "trackdata_names"){
    colnames <- c("time","latitude","longitude","baro_altitude","true_track","on_ground")
  }

  return(colnames)
}
