#!/bin/bash --login


cd ~/batch/acacia

export LD_LIBRARY_PATH=
module load singularity/4.1.0-slurm


export sstname=oisst-avhrr-v02r01
rm -rf $MYSCRATCH/$sstname.parquet || true

singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev-python.sif python3 oisst-virtualize.py  > oisst-virtualize.pyout

#pangeo-notebook_latest.sif  
#gdal-builds_rocker-gdal-dev-python.sif


module load awscli/1.29.41

if [ -d "$MYSCRATCH/$sstname.parquet"  ]; then
  aws s3 cp --endpoint-url  https://projects.pawsey.org.au --profile pawsey0973 $MYSCRATCH/$sstname.parquet  s3://vzarr/$sstname.parquet --recursive
fi

