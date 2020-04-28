
<!-- README.md is generated from README.Rmd. Please edit that file -->

# openskyr <img src="man/figures/logo.png" align="right"  height = 150/>

<!-- badges: start -->

![R build
status](https://github.com/luisgasco/openskyr/workflows/R-CMD-check/badge.svg)
[![Coverage
Status](https://codecov.io/gh/luisgasco/openskyr/branch/master/graph/badge.svg)](https://codecov.io/gh/luisgasco/openskyr)
<!-- badges: end -->

This package provides a list of functions to facilitate access to the
data offered by [OpenSky-Network](https://opensky-network.org/) in its
[REST API](https://opensky-network.org/apidoc/rest.html).

## Installation

You can install the latest version of openskyr from Github with the
following command. In the future, you can install the library from CRAN.

``` r
# Install the development version from GitHub:
# install.packages("devtools")
devtools::install_github("luisgasco/openskyr")
```

## Usage

Retrieve any state vector of the OpenSky data without authentication:

``` r
state_vectors_df <- get_state_vectors()
```

Retrieve any state vector of the OpenSky data with authentication (you
need to register in opensky-network):

``` r
state_vectors_df <- get_state_vectors(username="your_username",password="your_password")
```

Retrieve flights for a certain airport which departed within a given
time interval \[begin, end\]:

``` r
data_airport_df <- get_airport_data(username="your_username",password="your_password",
                                     option="departures",airport="EDDF",
                                     begin=1517227200,end=1517230800)
```

Retrieve flights for a particular aircraft within a certain time
interval:

``` r
data_specific_flight <- get_flights_data(username="your_username",password="your_password",
                                         icao24="3c675a",begin=1517184000,end=1517270400)
```

Retrieves flights for a certain time interval \[begin, end\]:

``` r
data_all_flight <- get_flights_data(username="your_username",password="your_password",
                                    begin=1517227200,end=1517230800)
```

Retrieve the trajectory for a certain aircraft at a given time:

``` r
data_flight_track <- get_track_data(username=username,password="your_password",
                                    icao24="494103",time=1587126600)
```

## You may also like…

  - [Noytext](https://github.com/luisgasco/Ropensky) - A web-based
    platform for annotating short-text documents to be used in applied
    text-mining based research.

-----

> [luisgasco.es](http://luisgasco.es/) · GitHub:
> [@luisgasco](https://github.com/luisgasco) · Twitter:
> [@luisgasco](https://twitter.com/luisgasco) · Facebook: [Luis Gascó
> Sánchez
> page](https://www.facebook.com/Luis-Gasco-Sanchez-165003227504667)
