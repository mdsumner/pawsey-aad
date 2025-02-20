
#{"name":"SEALEVEL_GLO_PHY_L4","filepattern":["SEALEVEL_GLO_PHY_L4",  "cmems_obs-sl_glo_phy.*_allsat-l4-duacs-0.25deg_P1D", "nc$"],"timepattern":"[0-9]{8}","timeformat":"%Y%m%d"},

x <- jsonlite::fromJSON('[

{"name":"oisst-avhrr-v02r01","filepattern":["avhrr","^.*www.ncei.noaa.gov.*sea-surface-temperature-optimum-interpolation/v2.1/access/avhrr/.*nc$"],"timepattern":"[0-9]{8}","timeformat":"%Y%m%d"},
{"name":"SEALEVEL_GLO_PHY_L4","filepattern":["SEALEVEL_GLO_PHY_L4",  "cmems_obs-sl_glo_phy.*_allsat-l4-duacs-0.*deg_P1D", "nc$"],"timepattern":"[0-9]{8}","timeformat":"%Y%m%d"},
{"name":"NSIDC_SEAICE_PS_S25km","filepattern":["nsidc.org", "NSIDC-00[5,8]1.002", "SEAICE_PS_S25km_[0-9]{8}", "nc$"],"timepattern":"[0-9]{8}","timeformat":"%Y%m%d"}, 
{"name":"NSIDC_SEAICE_PS_N25km","filepattern":["nsidc.org", "NSIDC-00[5,8]1.002", "SEAICE_PS_N25km_[0-9]{8}", "nc$"],"timepattern":"[0-9]{8}","timeformat":"%Y%m%d"}, 
{"name":"antarctica-amsr2-asi-s3125-tif","filepattern":["s3125", "tif$", "seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/s3125.*Antarctic3125"],"timepattern":"[0-9]{8}","timeformat":"%Y%m%d"},
{"name":"ghrsst-tif","filepattern":[".*JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1_analysed_sst.tif$"], "timepattern":"[0-9]{8}","timeformat":"%Y%m%d"}, 
{"name":"oisst-tif","filepattern":[".*oisst-avhrr-v02r01.*.tif$"], "timepattern":"[0-9]{8}","timeformat":"%Y%m%d"}
         ]' )

# {"name":"","filepattern":[""],"timepattern":"","timeformat":""}


get_allobjects <- function() {
  arrow::read_parquet("https://projects.pawsey.org.au/idea-objects/idea-objects.parquet")
}

.ff <- function (pattern) 
{
    files <- get_allobjects()
    for (pattern0 in pattern) {
        files <- dplyr::filter(files, stringr::str_detect(.data$Key, 
            pattern0))
        if (nrow(files) < 1)  {
            
          return(NULL)
        }
    }
    
    files
}

.findfiles <- function(.x) {
  files <- .ff(unlist(.x$filepattern))
  if (is.null(files)) {
    message("no files found with pattern: ", paste0(.x$filepattern, collapse = "; "))
    return(NULL)
  }
  date <- stringr::str_extract(files$Key, .x$timepattern)
  files$date <- as.POSIXct(strptime(date, .x$timeformat), tz = "UTC")
  files$Dataset <- .x$name
  files |> dplyr::arrange(Key, date) |> dplyr::distinct(date, .keep_all = TRUE)  |> dplyr::arrange(date)
}

print("getting curated files")

curated <- do.call(rbind, lapply(split(x, 1:nrow(x)), .findfiles))

## hack for now
curated <- dplyr::filter(curated, !grepl("oldformat/cmems_", Key))

print("writing curated files to scratch")


arrow::write_parquet(curated, "/scratch/pawsey0973/mdsumner/idea-curated-objects.parquet")

print("scratch file written, ready for upload to S3")


