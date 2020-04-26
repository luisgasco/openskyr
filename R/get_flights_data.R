#' @title get_flights_data
#' @name get_flights_data
#' @description Retrieve flights for a certain airport which arrived within a given time interval. If no flights are found for the given period, HTTP stats 404 - Not found is returned with an empty response body.
#'
#' @param username Your opensky-network username.
#' @param password Your opensky-network password.
#' @param icao24 Unique ICAO 24-bit address of the transponder in hex string representation. All letters need to be lower case.
#' @param begin Start of time interval to retrieve flights for as Unix time (seconds since epoch).
#' @param end End of time interval to retrieve flights for as Unix time (seconds since epoch).
#'
#' @return A dataframe with the list of flights arriving to the airport defined during the period specified in begin and end.
#'
#' @export
#' @import httr

col_flight_names <- c("icao24", "firstSeen", "estDepartureAirport", "lastSeen", "estArrivalAirport", "callsign",
                      "estDepartureAirportHorizDistance","estDepartureAirportVertDistance", "estArrivalAirportHorizDistance",
                      "estArrivalAirportVertDistance", "departureAirportCandidatesCount", "arrivalAirportCandidatesCount")

get_flights_data <- function(username = NULL, password = NULL, icao24 = NULL, begin = NULL, end = NULL) {

    if (!is.null(icao24) && !is.null(username) && !is.null(password)) {
        # Build list of the GET params:
        params_list <- list(icao24 = icao24, begin = begin, end = end)
        params_list <- params_list[vapply(params_list, Negate(is.null), NA)]
        url_request <- "https://opensky-network.org/api/flights/aircraft"

    } else if (is.null(icao24) && !is.null(username) && !is.null(password)) {
        params_list <- list(begin = begin, end = end)
        params_list <- params_list[vapply(params_list, Negate(is.null), NA)]
        url_request <- "https://opensky-network.org/api/flights/all"
    } else {
        stop("OpenSky API needs login data to get this information", call. = FALSE)
    }

    response_init <- GET(url_request,
                         authenticate(username, password),
                         query = params_list)
    capture_error(response_init)
    response <- content(response_init)
    m_response <- suppressWarnings(data.frame(Reduce(rbind, response)))
    colnames(m_response) <- col_flight_names
    return(m_response)
}
