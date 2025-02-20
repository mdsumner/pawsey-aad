#!/bin/bash --login


echo "runing ghrsst sync listing"
cd ~/batch/acacia

module load singularity/4.1.0-slurm
singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev.sif  R CMD BATCH --no-save --no-restore sync-ghrsst.R


echo "ghrsst sync done"

