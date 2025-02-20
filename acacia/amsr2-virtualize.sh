#!/bin/bash --login


cd ~/batch/acacia

module load singularity/4.1.0-slurm


export datalabel=antarctica-asi-AMSR2-s3125-tif

rm -rf $MYSCRATCH/$datalabel.parquet || true

singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev-python.sif python3 amsr2-virtualize.py  > amsr2-virtualize.pyout

#pangeo-notebook_latest.sif  
#gdal-builds_rocker-gdal-dev-python.sif


module load awscli/1.29.41

if [ -d "$MYSCRATCH/$datalabel.parquet"  ]; then
  aws s3 cp --endpoint-url  https://projects.pawsey.org.au --profile pawsey0973 $MYSCRATCH/$datalabel.parquet  s3://vzarr/$datalabel.parquet --recursive
fi

