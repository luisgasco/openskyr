#' @title get_state_vectors
#' @name get_state_vectors
#' @description Retrieve any state vector at the 'OpenSky Network' API.
#'  Depending on whether you use your personal credentials or not,
#' you will have some limitations rate limits as explained in
#'  ['OpenSky Network' documentation](https://bit.ly/2SgxFY6)
#'
#' @param username Your 'OpenSky Network' username.
#' @param password Your 'OpenSky Network' password.
#' @param ... Optional parameters to introduce in the request. This parameters
#' are time, icao24, lamin, lomin, lamax, and lomax. These parameters are
#' specified in [ 'OpenSky Network' REST API - All State Vectors](https://bit.ly/3cMb2CS)
#'
#' @return A data.frame with fields specified in the 'OpenSky Network' REST API
#'  [documentation](https://bit.ly/3aLraD0).
#'
#'
#' @examples
#' \donttest{get_state_vectors()}
#' \dontrun{get_state_vectors(username = "your_username", password = "your_password")}
#'
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
    # Prepare the output
    response2 <- purrr::modify_depth(response$states, 2, function(x) ifelse(is.null(x), NA, x))

    # Prepare the output
    m_response <-   tibble::as_tibble(data.table::rbindlist(response2))
    colnames(m_response) <- recover_names("statevector_names")
    return(m_response)
}
