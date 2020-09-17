
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbsafinder

## Overview

The goal of cbsafinder is finding the CBSA of US addresses, using the
census and Google geocoding APIs. CBSAs are core based statistical
areas; they represent one or more counties tied to an urban center of a
given size. CBSAs are often used in the retail and real estate
industries to help determine the geographic area of a given address.

## Installation

Install the development version of the package from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("WarbyParker/cbsafinder")
```

## Getting Started

First, start by loading the package. The core function in cbsafinder
looks up the CBSA (and a few other bits of handy info) given a U.S.
address. So let’s say that you want to know the CBSA of the giant
Hollywood sign in California. Pass the address as a string to
geocode\_address() and voila\! The Hollywood sign is in Los Angeles-Long
Beach-Anaheim, CA.

``` r
library(cbsafinder)
geocode_address("4059 Mount Lee Drive, Hollywood, CA 90068")
#> $address
#> [1] "MT LEE, LOS ANGELES, CA 90068"
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
#> [1] 34.13473
#> 
#> $longitude
#> [1] -118.3209
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
function still works\!

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
```

Lastly, geocode\_address() takes one address as an argument and no more,
so something like this will also
fail.

``` r
geocode_address(c("4059 Mount Lee Drive, Hollywood, CA 90068", "The White House, 1600 Pennsylvania Avenue NW, Washington, DC 20500"))
```

## Where to Find Help

If you find a bug, please file a reproducible example on
[GitHub](https://github.com/WarbyParker/cbsafinder/issues).
