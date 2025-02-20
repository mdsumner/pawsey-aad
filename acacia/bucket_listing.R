
.libPaths("/software/projects/pawsey0973/mdsumner/R/4.4.1/lib64/R/library")

library(minioclient)

print("mc loaded")
mc_alias_set("pawsey", "projects.pawsey.org.au", "", "")
buckets <- c("idea-10.5067-mpyg15waa4wx",
             "idea-10.7289-v5sq8xb5",
             #"idea-objects"
             "idea-sealevel-glo-phy-l4-nrt-008-046",
             "idea-sealevel-glo-phy-l4-rep-observations-008-047", 
             "idea-amsr2-asi-s3125", 
             "idea-ghrsst", 
             "idea-oisst")

l <- vector("list", length(buckets))
for (i in seq_along(l)) {
  l[[i]] <- tibble::tibble(Bucket = buckets[i], Key = mc_ls(sprintf("pawsey/%s", buckets[i]), recursive = T))
}

d <- do.call(rbind, l)
print(sprintf("buckets listed: %i", nrow(d)))

arrow::write_parquet(d, "/scratch/pawsey0973/mdsumner/idea-objects.parquet")

print("scratch file written")


