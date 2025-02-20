to_cog <- function(x) {
  gdal_options <- c(
    "-co", "COMPRESS=ZSTD",
    "-of", "COG",
    "-co", "BLOCKSIZE=512",
    #"-co", "NUM_THREADS=4",
    "-co", "PREDICTOR=STANDARD",
    "-co", "RESAMPLING=AVERAGE",
    "-co", "SPARSE_OK=YES")
  
  bucket <- "idea-oisst"
  out <- sprintf("/vsis3/idea-oisst/%s", gsub("\\.nc$", "_sst.tif", basename(x)))
  x <- sprintf("vrt://%s?a_srs=EPSG:4326&sd_name=sst", x)
  
  chk <- try(gdalraster::translate(x, out, cl_arg = gdal_options))
  if (inherits(chk, "try-error")) return(NA_character_)
  out
}

library(sooty)

netcdfbucket <- "idea-10.7289-v5sq8xb5"
netcdffiles <- dplyr::filter(sooty::sooty_files(TRUE), Bucket == netcdfbucket)
tiffiles <- sprintf("/vsis3/idea-oisst/%s", gsub("\\.nc$", "_sst.tif", basename(netcdffiles$Key)))

existingfiles <- dplyr::filter(sooty::sooty_files(TRUE), Bucket == "idea-oisst")

dothese <- which(is.na(match(tiffiles, existingfiles$source)))


for (i in dothese) {
 x <-  to_cog(netcdffiles$source[i])
 print(i)
 print(x)
}
