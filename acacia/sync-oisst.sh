#!/bin/bash --login


echo "runing oisst convert to sst tif"
cd ~/batch/acacia

module load singularity/4.1.0-slurm
singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev.sif  R CMD BATCH --no-save --no-restore sync-oisst.R


echo "oisst convert done"

