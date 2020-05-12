#' @title get_airport_data
#' @name get_airport_data
#' @description Retrieve flights for a certain airport which arrived within
#'  a given time interval. You should specified if you want departure or
#'  arrival flights in the function.
#'
#' @param username Your 'OpenSky Network' username.
#' @param password Your 'OpenSky Network' password.
#' @param airport ICAO identifier for the airport.
#' @param begin Start of time interval to retrieve flights for as Unix
#'  time (seconds since epoch).
#' @param end End of time interval to retrieve flights for as Unix time
#'  (seconds since epoch).
#' @param option String indicating whether you want to request the departure
#'  or arrival flights. "arrivals" or "departures".
#' @return A dataframe with the list of flights arriving to the airport defined
#'  in airport in the period specified between begin and end.
#'
#' @examples
#' \dontrun{get_airport_data(username = "your_username", password = "your_password",
#'  airport = "EDDF", begin = 1517227200, end = 1517230800, option = "arrivals")}
#' \dontrun{get_airport_data(username = "your_username", password = "your_password",
#'  airport = "EDDF", begin = 1517227200, end = 1517230800, option = "departures")}
#'
#' @export
#' @import httr



get_airport_data <- function(username = NULL, password = NULL,
                             airport = NULL, begin = NULL, end = NULL,
                             option = c("departures", "arrivals")) {
    # Build list of the params specified in the function input:
    params_list <- list(airport = airport, begin = begin, end = end)
    params_list <- params_list[vapply(params_list, Negate(is.null), NA)]
    if (!is.null(username) && !is.null(password)) {
        # If username and password are specified
        if (option == "departures") {
            url_request <- "https://opensky-network.org/api/flights/departure"
        } else if (option == "arrivals") {
            url_request <- "https://opensky-network.org/api/flights/arrival"
        } else { #Other option throws an error
            stop("Option don't recognized", call. = FALSE)
        }
        # Request
        response_init <- GET(url_request,
                                   authenticate(username, password),
                                   query = params_list)
        # Test if the response throw any error
        capture_error(response_init)
        # Get the data from the response
        response <- content(response_init)
        # Prepare the output
        m_response <- purrr::map_df(response, purrr::flatten)
    } else {
        # If Login data is not provided, it will throw an error.
        stop("OpenSky API needs login data to get this information",
             call. = FALSE)
    }
    return(m_response)
}
