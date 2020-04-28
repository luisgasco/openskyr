#' @title get_state_vectors
#' @name get_state_vectors
#' @description Retrieve any state vector at the OpenSky-Network API.
#'  Depending on whether you use your personal credentials or not,
#' you will have some limitations rate limits as explained in
#'  [opensky-network documentation](https://bit.ly/2SgxFY6)
#'
#' @param username Your opensky-network username.
#' @param password Your opensky-network password.
#' @param ... Optional parameters to introduce in the request. This parameters
#' are time, icao24, lamin, lomin, lamax, and lomax. These parameters are
#' specified in [opensky-network's REST API - All State Vectors](https://bit.ly/3cMb2CS)
#'
#' @return A data.frame with fields specified in the opensky-network REST API
#'  [documentation](https://bit.ly/3aLraD0).
#'
#' @usage get_state_vectors(username, password, ...)
#'
#' @export
#' @import httr


get_state_vectors <- function(username = NULL, password = NULL, ...) {
    # Build list of the params specified in the function input:
    params_list <- listn(...)
    if (!is.null(username) && !is.null(password)) {
        # If username and password are specified
        response_init <- GET("https://opensky-network.org/api/states/all",
                             authenticate(username, password),
                             query = params_list)
    } else {
        # If username and password are not specified remove the time element of
        # params,since cannot be used
        params_list$time <- NULL
        response_init <- GET("https://opensky-network.org/api/states/all",
                             query = params_list)
    }
    # Test if the response throw any error
    capture_error(response_init)
    # Get the data from the response
    response <- content(response_init)
    # PRepare the output dataframe
    m_response <- suppressWarnings(data.frame(Reduce(rbind, response$states),
                                              row.names = NULL))
    names(m_response) <- recover_names("statevector_names")
    return(m_response)
}
