#!/bin/bash --login

cd ~/batch/acacia

module load singularity/4.1.0-slurm



singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev-python.sif   R CMD BATCH --no-restore --no-save  00_bowerbird_sync.R  > 00_bowerbird_sync.Rout



