#!/bin/bash --login


cd ~/batch/acacia

module load singularity/4.1.0-slurm


export dataset="SEALEVEL_GLO_PHY_L4"

rm -rf $MYSCRATCH/$dataset.parquet || true

singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev-python.sif   python3 altimetry-virtualize.py  > altimetry-virtualize.pyout


module load awscli/1.29.41

if [ -d "$MYSCRATCH/$dataset.parquet"  ]; then
  aws s3 cp --endpoint-url  https://projects.pawsey.org.au --profile pawsey0973 $MYSCRATCH/$dataset.parquet  s3://vzarr/$dataset.parquet --recursive
fi

