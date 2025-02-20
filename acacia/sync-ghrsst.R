
dosst <- function(date, do_temp  = FALSE) {
  ymd <- format(date, "%Y%m%d")
  file <-  glue::glue("{ymd}090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc")
  base  <-  "https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/MUR-JPL-L4-GLOB-v4.1"
  #https://archive.podaac.earthdata.nasa.gov/podaac-ops-cumulus-protected/MUR-JPL-L4-GLOB-v4.1/20241027090000-JPL-L4_GHRSST-SSTfnd-MUR-GLOB-v02.0-fv04.1.nc
  
  gdal_options <- c(
    "-co", "COMPRESS=ZSTD",
    "-of", "COG",
    "-co", "BLOCKSIZE=512",
    "-co", "PREDICTOR=STANDARD",
    "-co", "RESAMPLING=AVERAGE",
    "-co", "SPARSE_OK=YES")
  
  
  folderdate <- date - 1
  year <- format(folderdate, "%Y")
  month <- format(folderdate, "%m")
  day <- sprintf("%02i", as.integer(format(folderdate, "%d")))
  ymdpath = glue::glue("{year}/{month}/{day}")
  
  output_path <- file.path("/vsimem",  gsub(".nc$", "_analysed_sst.tif", file))
    if (basename(output_path)   %in% basename(existingfiles$source)) return(NULL)
    

    if (do_temp) {
       #tf <- tempfile(fileext = ".nc")
       tmpdir <- Sys.getenv("MYSCRATCH")
       if (!nzchar(tmpdir)) {
        tmpdir <- tempdir()
        }

       tf <- tempfile(fileext = ".nc", tmpdir = tmpdir)
    on.exit(unlink(tf), add = TRUE)
       curl::curl_download(file.path(base, file), tf, handle = h)
       input_path <- tf
       dsn = glue::glue("vrt://NetCDF:{input_path}:analysed_sst?a_ullr=-179.995,89.995,180.0050,-89.995&a_offset=25&a_scale=0.001&a_srs=EPSG:4326")
       
    } else {
        input_path <- sprintf("%s/%s", base, file)
        dsn = glue::glue("vrt://NetCDF:\"/vsicurl/{input_path}\":analysed_sst?a_ullr=-179.995,89.995,180.0050,-89.995&a_offset=25&a_scale=0.001&a_srs=EPSG:4326")
  
 }


 gdalraster::translate(dsn, output_path, cl_arg = gdal_options)


 con <- new(VSIFile, output_path, "r")
 bytes <- con$ingest(-1)
 con$close()
 vsi_unlink(output_path)

 s3path <- gsub("/vsimem", file.path("/vsis3/idea-ghrsst",ymdpath), output_path)

 con <- new(VSIFile, s3path, "w")
 con$write(bytes)
 con$close()
 rm(bytes); gc()
 s3path
}



 existingfiles <- sooty::ghrsstfiles()
 maxdate <- Sys.Date() 
 if (as.Date(max(existingfiles$date)) >= maxdate) {
   print("no ghrsst dates to do")
 } else {

 dates <- seq(as.Date(max(existingfiles$date)), maxdate, by = "1 day")

 authorization <- trimws(readr::read_file("~/earthdata"))

 h <- curl::new_handle()
 curl::handle_setopt(h,  customrequest = "GET")
 curl::handle_setheaders(h, "Authorization" = gsub("Authorization: ", "", authorization))


 library(gdalraster)
 Sys.setenv("VSIS3_CHUNK_SIZE" = "50")



 for (i in seq_along(dates)) {
   try(dosst(dates[i], do_temp = TRUE))
 }

}
