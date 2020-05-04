#' @title get_flights_data
#' @name get_flights_data
#' @description Retrieve flights for a certain airport which arrived
#'  within a given time interval. If no flights are found for the given
#'  period, HTTP stats 404 - Not found is returned with an empty response body.
#'
#' @param username Your 'OpenSky Network' username.
#' @param password Your 'OpenSky Network' password.
#' @param icao24 Unique ICAO 24-bit address of the transponder in hex string
#'  representation. All letters need to be lower case.
#' @param begin Start of time interval to retrieve flights for as Unix time
#'  (seconds since epoch).
#' @param end End of time interval to retrieve flights for as Unix time
#'  (seconds since epoch).
#'
#' @return A dataframe with the list of flights arriving to the airport
#'  defined during the period specified in begin and end.
#'
#' @examples
#' \dontrun{get_flights_data(username = "your_username", password = "your_password",
#'  icao24 = 3c675a , begin = 1517227200, end = 1517230800)}
#'
#' @export
#' @import httr



get_flights_data <- function(username = NULL, password = NULL,
                             icao24 = NULL, begin = NULL, end = NULL) {

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
        stop("OpenSky API needs login data to get this information",
             call. = FALSE)
    }

    response_init <- GET(url_request,
                         authenticate(username, password),
                         query = params_list)
    capture_error(response_init)
    response <- content(response_init)
    m_response <- suppressWarnings(data.frame(Reduce(rbind, response),
                                              row.names = NULL))
    colnames(m_response) <- recover_names("flight_names")
    return(m_response)
}
