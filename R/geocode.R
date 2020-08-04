#' Geocode an address.
#'
#' @param address A string with the address location
#' @param key An API key for the Google Geocoding API. If NULL,
#' the function looks for a 'GOOGLE_API_KEY' environment variable.
#'
#' @details This function first uses the Google Geocoding API to
#' get lat/lon coordinate for the address, the reverse geocodes those
#' coordinates with the Census geocoding API to find the CBSA and census
#' tract, and fill in any other information missing from the Google
#' geocoder response.
#'
#' @return A list with elements:
#' \itemize{
#' \item address
#' \item cbsa_id
#' \item cbsa_name
#' \item census_tract_id
#' \item census_tract_name
#' \item county_id
#' \item county_name
#' \item latitude
#' \item longitude
#' \item state_abbr
#' \item state_id
#' \item state_name
#' \item zip
#' }
#'
#' cbsa_id, census_tract_id, county_id, state_id are all FIPS codes.
#'
#' @examples
#' \dontrun{
#' hq <- geocode_address('161 Avenue of the Americas New York, NY 10013')
#' }
#'
#' @importFrom purrr discard list_modify
#' @importFrom rlang !!!
#' @export
geocode_address <- function(address, key=NULL) {
  geocode_info <- google_geocode_address(address, key=key)

  missing_cbsa <- TRUE
  try <- 0
  max_tries <- 20

  while (missing_cbsa && try < max_tries) {
    if (try > 0) {
      Sys.sleep(0.1)
      cat('Retrying reverse-geocode:', try, 'of', max_tries, '\n')
    }
    census_info <- census_reverse_geocode(geocode_info$longitude,
                                          geocode_info$latitude)
    missing_cbsa <- is.na(census_info$cbsa_id)
    try <- try + 1
  }
  geocode_info <- list_modify(geocode_info,
                              !!!discard(census_info, is.na))
  geocode_info[order(names(geocode_info))]
}


#' @importFrom googleway google_geocode
#' @importFrom purrr %||% map_lgl
#' @importFrom dplyr %>% select filter slice
#' @importFrom tibble as_data_frame
#' @importFrom stringr str_replace
#' @export
google_geocode_address <- function(address, key=NULL, ...) {

  key = key %||% Sys.getenv('GOOGLE_API_KEY')
  if (key == '') {
    stop('Missing API key for google geocoder.')
  }
  resp <- googleway::google_geocode(address, key=key, ...)
  if (!(resp$status == 'OK') || (length(resp$results) <= 0)) {
    return(list())
  }
  addr_clean <- list(address=googleway::geocode_address(resp)[1] %>%
                       toupper %>%
                       str_replace(', USA$', ''))

  coordinates <- googleway::geocode_coordinates(resp)[1, ] %>%
    setNames(c('latitude', 'longitude'))

  zip <- googleway::geocode_address_components(resp) %>%
    filter(map_lgl(types, ~ 'postal_code' %in% .x)) %>%
    slice(1) %>%
    select(zip=short_name) %>%
    as.list

  state <- googleway::geocode_address_components(resp) %>%
    filter(map_lgl(types, ~ 'administrative_area_level_1' %in% .x)) %>%
    slice(1) %>%
    select(state_name=long_name, state_abbr=short_name) %>%
    as.list

  county <- googleway::geocode_address_components(resp) %>%
    as_data_frame %>%
    filter(map_lgl(types, ~ 'administrative_area_level_2' %in% .x)) %>%
    slice(1) %>%
    select(county_name=long_name) %>%
    as.list

  if (length(county$county_name) <= 0) {
    if (state$state_abbr == 'DC') {
      county$county_name <- 'District of Columbia'
    } else {
      county$county_name <- NA
    }
  }

  county$county_name <- str_replace(county$county_name, '\\s+County$', '')
  c(addr_clean, county, zip, state, coordinates)
}


#' @importFrom purrr list_modify
census_geocode_params <- function(...) {
  default_layers <- c('2010 Census ZIP Code Tabulation Areas',
                      'Census Tracts',
                      'Metropolitan Statistical Areas',
                      'Micropolitan Statistical Areas',
                      'States',
                      'Counties')

  params <- list(format='json',
                 benchmark='Public_AR_Current',
                 vintage='ACS2015_Current',
                 layers=paste(default_layers, collapse=','))
  list_modify(params, ...)
}


#' @importFrom stringr str_replace_all
#' @export
census_reverse_geocode <- function(lon, lat, ...) {
  query <- census_geocode_params(...)
  query <- c(x=lon, y=lat, query)
  query_str <- paste(paste(names(query), as.character(query), sep='='), collapse='&')
  base_url <- 'https://geocoding.geo.census.gov/geocoder/geographies/coordinates'
  full_url <- paste(base_url, query_str, sep='?')
  resp <- httr::GET(full_url)
  httr::stop_for_status(resp)
  parse_census_geocode(httr::content(resp))
}


#' @importFrom purrr set_names
parse_census_geocode <- function(resp) {
  geos <- resp$result$geographies
  state <- get_census_resp_geo_info(geos$States[[1]], 'state')
  state_abbrev <- c('state_abbr' = geos$States[[1]]$STUSAB)
  cbsa <- parse_census_resp_cbsa(geos)
  county <- get_census_resp_geo_info(geos$Counties[[1]] %||% NA, 'county')
  zcta <- c(zcta = geos[['ZIP Code Tablulation Areas']]$ZCTA5 %||% NA)
  tract <- get_census_resp_geo_info(geos$`Census Tract`[[1]], 'census_tract')
  c(tract, zcta, county, cbsa, state, state_abbrev)
}


parse_census_resp_cbsa <- function(geographies) {
  micro <- geographies[['Micropolitan Statistical Areas']]
  metro <- geographies[['Metropolitan Statistical Areas']]
  if (length(micro) > 0 && !is.null(micro[[1]]$GEOID)) {
    cbsa <- micro[[1]]
  } else if (length(metro) > 0 && !is.null(metro[[1]]$GEOID)) {
    cbsa <- metro[[1]]
  } else {
    cbsa <- list()
  }
  get_census_resp_geo_info(cbsa, 'cbsa')
}

#' @importFrom purrr %||%
get_census_resp_geo_info <- function(geography, label) {
  structure(list(geography$BASENAME %||% NA, geography$GEOID %||% NA),
            names=paste(label, c('name', 'id'), sep='_'))
}
