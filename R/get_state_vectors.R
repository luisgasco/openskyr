#' @title get_state_vectors
#' @name get_state_vectors
#' @description Retrieve any state vector at the OpenSky-Network API. Depending on whether you use your personal credentials or not,
#' you will have some limitations rate limits as explained in [opensky-network documentation](https://opensky-network.org/apidoc/rest.html#limitations)
#'
#' @param username Your opensky-network username.
#' @param password Your opensky-network password.
#' @param time (optional) The time in seconds since epoch (Unix time stamp to retrieve states for. Current time will be used if omitted.
#' @param icao24 (optional) One or more ICAO24 transponder addresses represented by a hex string (e.g. abc9f3). To filter multiple ICAO24 append the property once for each address. If omitted, the state vectors of all aircraft are returned.
#' @param lamin (optional) Lower bound for the latitude in decimal degrees.
#' @param lomin (optional) Lower bound for the longitude in decimal degrees.
#' @param lamax (optional) Upper bound for the latitude in decimal degrees.
#' @param lomax (optional) Upper bound for the longitude in decimal degrees.
#'
#' @return A data.frame with fields specified in the opensky-network REST API [documentation](https://opensky-network.org/apidoc/rest.html#response).
#'
#' @export
#' @import httr

col_statevectors_names <- c("icao24", "callsign", "origin_country", "time_position", "last_contact", "longitude", "latitude",
                            "baro_altitude", "on_ground","velocity", "true_track", "vertical_rate", "geo_altitude", "squawk",
                            "spi", "position_source")

get_state_vectors <- function(username = NULL, password = NULL, ...) {
    # Build list of the params specified in the function input:
    params_list <- listn(...)
    if (!is.null(username) && !is.null(password)) {
        # If username and password are specified
        response_init <- GET("https://opensky-network.org/api/states/all",
                                   authenticate(username, password),
                                 query = params_list)
    } else {
        # If username and password are not specified remove the time element of params,since cannot be used
        params_list$time <- NULL
        response_init <- GET("https://opensky-network.org/api/states/all",
                             query = params_list)
    }
    # Test if the response throw any error
    capture_error(response_init)
    # Get the data from the response
    response <- content(response_init)
    # PRepare the output dataframe
    m_response <- suppressWarnings(data.frame(Reduce(rbind, response$states)))
    colnames(m_response) <- col_statevectors_names
    return(m_response)
}
