global_s3_args <- list(base_url = "projects.pawsey.org.au",
                       key = Sys.getenv("BB_ACACIA_BUCKET_KEY"),
                       secret = Sys.getenv("BB_ACACIA_BUCKET_SECRET"), region = "")

secrets <- read.csv(Sys.getenv("BOWERBIRD_SECRETS"))

library(bowerbird)
library(blueant)

datadir <- file.path(Sys.getenv("MYSCRATCH"), "bowerbird_files")
if (!file.exists(datadir)) dir.create(datadir)

srcset <- NULL


## ----------------------------------------------------------------------------------------------------                                                                                                       -------------------------------------------
src <- blueant::sources("NOAA OI 1/4 Degree Daily SST AVHRR")
year00 <- sprintf("/(%s|%s)", format(Sys.Date(), "%Y%m"), format(Sys.Date()-30, "%Y%m"))
src0 <- src |>
  bb_modify_source(method = list(accept_follow = year00, accept_download = ".*nc$",
                                 no_host = FALSE, target_s3_args = list(bucket = "idea-10.7289-v5sq8xb5                                                                                                       ")))

srcset <- rbind(srcset, src0)

## ----------------------------------------------------------------------------------------------------                                                                                                       -------------------------------------------
year00 <- sprintf("/(%s|%s)", format(Sys.Date(), "%Y.%m"), format(Sys.Date()-30, "%Y.%m"))
secret00 <- secrets[secrets$type == "nsidc", ]
src <- blueant::sources("Near-Real-Time DMSP SSMIS Daily Polar Gridded Sea Ice Concentrations, Version                                                                                                        2")

src0 <- src |>
  bb_modify_source(user = secret00$user, password = secret00$password,
          method = list(clobber = 0, accept_follow = year00, accept_download = ".*nc$", no_host = FALSE                                                                                                       , target_s3_args = list(bucket = "idea-10.5067-mpyg15waa4wx")))

srcset <- rbind(srcset, src0)


##-----------------------------------------------------------------------------------------------------                                                                                                       ------------------------------------------------
rf <- sprintf("/(%s)", paste0(c("Amundsen",  "Antarctic3125NoLandMask", "AntarcticPeninsula",  "Casey-D                                                                                                       umont", "DavisSea", "McMurdo", "Neumayer", "NeumayerEast",
  "Polarstern", "RossSea", "ScotiaSea", "WeddellSea", "WestDavisSea", "netcdf"), collapse = "|"))

##just this year's data
#source_url = paste0("https://seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/s3125/", format(Sys.Dat                                                                                                       e(), "%Y"), "/"),

src0 <- sources("Artist AMSR2 near-real-time 3.125km sea ice concentration") %>%
      bb_modify_source(      source_url = paste0("https://seaice.uni-bremen.de/data/amsr2/asi_daygrid_s                                                                                                       wath/s3125/", format(Sys.Date(), "%Y"), "/"),
      method = list(reject_follow = rf, accept_download = ".*tif$", no_host = FALSE, target_s3_args = l                                                                                                       ist(bucket = "idea-amsr2-asi-s3125")))



srcset <- rbind(srcset, src0)


## ----------------------------------------------------------------------------------------------------                                                                                                       -------------------------------------------
## CMEMS not working for S3 yet
#secret00 <- secrets[secrets$type == "cmems", ]
#year00 <- sprintf("/(%s|%s)", format(Sys.Date(), "%Y/%m"), format(Sys.Date()-30, "%Y/%m"))

#src0 <- blueant::sources("CMEMS global gridded SSH near-real-time") %>% bb_modify_source(user = secret                                                                                                       00$user, password = secret00$password,
#                                                                       method = list(accept_follow = y                                                                                                       ear00, accept_download = ".*nc$", no_host = FALSE,
#                        target_s3_args = list(bucket = "idea-sealevel-glo-phy-l4-nrt-008-046")))
#srcset <- rbind(srcset, src0)

## ----------------------------------------------------------------------------------------------------                                                                                                       -------------------------------------------


cf <- bb_config(local_file_root = datadir, target_s3_args = global_s3_args)
cf <- bb_add(cf, srcset)
status <- bb_sync(cf, confirm_downloads_larger_than = NULL, dry_run = FALSE, verbose = TRUE)
saveRDS(status, file.path(sprintf("statuslogs/%s.rds", format(Sys.Date(), "%Y%m%d"))))


## ----------------------------------------------------------------------------------------------------                                                                                                       -------------------------------------------
