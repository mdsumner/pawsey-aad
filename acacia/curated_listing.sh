#!/bin/bash --login


echo "runing bucket listing"
cd ~/batch/acacia

module load singularity/4.1.0-slurm
singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev.sif  R CMD BATCH --no-save --no-restore bucket_listing.R

module load awscli/1.29.41
aws s3 cp --endpoint-url  https://projects.pawsey.org.au --profile pawsey0973 $MYSCRATCH/idea-objects.parquet  s3://idea-objects/idea-objects.parquet

echo "bucket listing done"


echo "running curated listing"
cd ~/batch/acacia

module load singularity/4.1.0-slurm
singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev.sif  R CMD BATCH --no-save --no-restore curated_listing.R

module load awscli/1.29.41
aws s3 cp --endpoint-url  https://projects.pawsey.org.au --profile pawsey0973 $MYSCRATCH/idea-curated-objects.parquet  s3://idea-objects/idea-curated-objects.parquet

echo "curated listing done"









