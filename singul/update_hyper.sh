#!/bin/bash --login

#SBATCH --account=pawsey0973
#SBATCH --time=01:00:00
#SBATCH --export=NONE
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --partition=copy
#SBATCH --mem=20000

module load singularity/4.1.0-slurm


singularity pull --force --dir $MYSOFTWARE/sif_lib docker:ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev-python

singularity pull --force --dir $MYSOFTWARE/sif_lib docker:ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev
