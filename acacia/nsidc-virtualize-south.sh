#!/bin/bash --login


cd ~/batch/acacia

module load singularity/4.1.0-slurm


export dataname=NSIDC_SEAICE_PS_S25km
rm -rf $MYSCRATCH/$dataname.parquet || true


#singularity exec $MYSOFTWARE/sif_lib/pangeo-notebook_latest.sif  python3 nsidc-virtualize-south.py  > nsidc-virtualize-south.pyout
singularity exec $MYSOFTWARE/sif_lib/gdal-builds_rocker-gdal-dev-python.sif   /workenv/bin/python   nsidc-virtualize-south.py  > nsidc-virtualize-south.pyout


module load awscli/1.29.41

if [ -d "$MYSCRATCH/$dataname.parquet"  ]; then
  aws s3 cp --endpoint-url  https://projects.pawsey.org.au --profile pawsey0973 $MYSCRATCH/$dataname.parquet  s3://vzarr/$dataname.parquet --recursive
fi

