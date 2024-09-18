library(bowerbird)
library(blueant)

datadir <- file.path(Sys.getenv("MYSCRATCH"), "bowerbird_files")
if (!file.exists(datadir)) dir.create(datadir)
bucketname <- function(x) {
  glue::glue("idea-{x}")
}


src <- blueant::sources("NOAA OI 1/4 Degree Daily SST AVHRR")

global_s3_args <- list(base_url = "projects.pawsey.org.au", key = "BB_ACACIA_BUCKET_KEY", secret = "BB_ACACIA_BUCKET_SECRET", region = "")

cf <- bb_config(local_file_root = datadir, target_s3_args = global_s3_args)


years <- 2024
srcslist <- purrr::map(years, \(.x) {
  src |>
    bb_modify_source(method = list(accept_follow = sprintf("avhrr/%i.*", .x), accept_download = sprintf(".*%i.*nc$", .x), 
                                   no_host = FALSE, target_s3_args = list(bucket = bucketname(httr::parse_url(src$source_url[[1]])$host))))
})

cflist<- lapply(srcslist, \(.x) bb_add(cf, .x))

library(furrr)
plan(multicore)
statuses <- future_map(cflist, \(.cf) bb_sync(.cf, verbose = TRUE, confirm_downloads_larger_than = -1))
plan(sequential)

