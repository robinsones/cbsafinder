
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbsafinder

## Overview

The goal of cbsafinder is finding the CBSA (Census Bureau Statistical
Area) of the US addresses.

CBSA’s represent one or more counties tied to an urban center of a given
size. CBSAs are often used in the retail and real estate industries to
help determine the geographic area of a given address.

While a zip code is usually more readily available, they are poor
representations of a geographic area they sometimes overlap and there
are often many zip codes in a metro area. They were developed solely to
deliver mail and not for geographic analysis, unlike CBSAs.

This package contains no Warby Parker data.

We wrote an R Package so that you can use CBSAs for your geographic
analysis too!

## Installation

Install the development version of the package from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("WarbyParker/cbsafinder", build_vignettes = TRUE)
```

You’ll also need to get a Google API key and enable it to use the
Geocoding API - you can find instructions in our Vignette by running:

``` r
vignette("get_google_api_key", package = "cbsafinder")
```

## Getting Started

First, start by loading the package. The core function in cbsafinder
looks up the CBSA (and a few other bits of handy info) given a U.S.
address. So let’s say that you want to know the CBSA of the giant
Hollywood sign in California. Pass the address as a string to
geocode\_address() and voila! The Hollywood sign is in Los Angeles-Long
Beach-Anaheim, CA.

``` r
library(cbsafinder)
geocode_address("4059 Mount Lee Drive, Hollywood, CA 90068")
#> $address
#> [1] "MOUNT LEE DR, LOS ANGELES, CA 90068"
#> 
#> $cbsa_id
#> [1] "31080"
#> 
#> $cbsa_name
#> [1] "Los Angeles-Long Beach-Anaheim, CA"
#> 
#> $census_tract_id
#> [1] "06037980009"
#> 
#> $census_tract_name
#> [1] "9800.09"
#> 
#> $county_id
#> [1] "06037"
#> 
#> $county_name
#> [1] "Los Angeles"
#> 
#> $latitude
#> [1] 34.13267
#> 
#> $longitude
#> [1] -118.3181
#> 
#> $state_abbr
#> [1] "CA"
#> 
#> $state_id
#> [1] "06"
#> 
#> $state_name
#> [1] "California"
#> 
#> $zip
#> [1] "90068"
```

If you only know part of the address or forget to enter some info, the
function still works!

``` r
geocode_address("4059 Mount Lee Drive")
#> $address
#> [1] "MOUNT LEE DR, LOS ANGELES, CA 90068"
#> 
#> $cbsa_id
#> [1] "31080"
#> 
#> $cbsa_name
#> [1] "Los Angeles-Long Beach-Anaheim, CA"
#> 
#> $census_tract_id
#> [1] "06037980009"
#> 
#> $census_tract_name
#> [1] "9800.09"
#> 
#> $county_id
#> [1] "06037"
#> 
#> $county_name
#> [1] "Los Angeles"
#> 
#> $latitude
#> [1] 34.13267
#> 
#> $longitude
#> [1] -118.3181
#> 
#> $state_abbr
#> [1] "CA"
#> 
#> $state_id
#> [1] "06"
#> 
#> $state_name
#> [1] "California"
#> 
#> $zip
#> [1] "90068"
```

Just be sure to pass the address as a string (i.e. remember your ""), or
the function will fail.

``` r
geocode_address(4059 Mount Lee Drive, Hollywood, CA 90068)
#> Error: <text>:1:22: unexpected symbol
#> 1: geocode_address(4059 Mount
#>                          ^
```

Also, `geocode_address()` takes one address as an argument and no more,
so something like this will also fail.

``` r
geocode_address(c("4059 Mount Lee Drive, Hollywood, CA 90068", "The White House, 1600 Pennsylvania Avenue NW, Washington, DC 20500"))
#> Error in check_address(address): address must be a string of length 1
```

But purrr’s map family of functions comes in handy for passing multiple
addresses at once. Here we use `purrr::map_df()` to return a user
friendly output.

``` r
my_addresses <- c("4059 Mount Lee Drive, Hollywood, CA 90068", "The White House, 1600 Pennsylvania Avenue NW, Washington, DC 20500")

purrr::map_df(my_addresses, ~cbsafinder::geocode_address(.x))
#> # A tibble: 2 × 13
#>   address       cbsa_id cbsa_name     census_tract_id census_tract_na… county_id
#>   <chr>         <chr>   <chr>         <chr>           <chr>            <chr>    
#> 1 MOUNT LEE DR… 31080   Los Angeles-… 06037980009     9800.09          06037    
#> 2 1600 PENNSYL… 47900   Washington-A… 11001980000     9800             11001    
#> # … with 7 more variables: county_name <chr>, latitude <dbl>, longitude <dbl>,
#> #   state_abbr <chr>, state_id <chr>, state_name <chr>, zip <chr>
```

## Where to Find Help

If you find a bug, please file a reproducible example on
[GitHub](https://github.com/WarbyParker/cbsafinder/issues).
