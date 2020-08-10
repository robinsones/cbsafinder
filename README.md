
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbsafinder

The goal of cbsafinder is finding the CBSA of US addresses, using the
census and Google geocoding APIs.

## Installation

Install the package from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("WarbyParker/cbsafinder")
#> Using github PAT from envvar GITHUB_PAT
#> Downloading GitHub repo WarbyParker/cbsafinder@HEAD
#> sys   (3.3   -> 3.4  ) [CRAN]
#> dplyr (1.0.0 -> 1.0.1) [CRAN]
#> Installing 2 packages: sys, dplyr
#> 
#> The downloaded binary packages are in
#>  /var/folders/mt/p9fvs1693_gbn22n2vz58tv80000gq/T//Rtmpm89Xdj/downloaded_packages
#>      checking for file ‘/private/var/folders/mt/p9fvs1693_gbn22n2vz58tv80000gq/T/Rtmpm89Xdj/remotes125f854861742/WarbyParker-cbsafinder-15d6cc6e9beac476f79e9a0ad87a80b2fb8d4716/DESCRIPTION’ ...  ✓  checking for file ‘/private/var/folders/mt/p9fvs1693_gbn22n2vz58tv80000gq/T/Rtmpm89Xdj/remotes125f854861742/WarbyParker-cbsafinder-15d6cc6e9beac476f79e9a0ad87a80b2fb8d4716/DESCRIPTION’
#>   ─  preparing ‘cbsafinder’:
#>      checking DESCRIPTION meta-information ...  ✓  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building ‘cbsafinder_0.1.0.tar.gz’
#>      
#> 
```

## Example

This is a basic example which shows you how to solve a common problem:

``` r
library(cbsafinder)
## basic example code
```
