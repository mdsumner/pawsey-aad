from virtualizarr import open_virtual_dataset
import pyarrow.parquet as pq
from pyarrow import fs

import dask.multiprocessing
import os


if __name__ == '__main__':
  dataset = "SEALEVEL_GLO_PHY_L4"
  bucket = "idea-sealevel-glo-phy-l4-nrt-008-046"

  ncpus = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])

  dask.config.set(num_workers = ncpus, scheduler = "processes")  

  print(f'running with {ncpus} cpus')

  aws_credentials = {"endpoint_url": "https://projects.pawsey.org.au",  "anon": True}

  print("reading idea objects list from Parquet")
  s3 = fs.S3FileSystem(endpoint_override = "projects.pawsey.org.au")

  s3table = pq.read_table("idea-objects/idea-curated-objects.parquet", filesystem = s3, filters=[('Dataset','==', dataset)])
  p = s3table.to_pandas()

  print("obtaining list of netcdf files for OISST")
  keylist =  s3table.to_pandas().Key.tolist()
  buckets =  s3table.to_pandas().Bucket.tolist()

  nc = [f's3://{bucket}/{key}' for bucket,key in zip(buckets,keylist)]
  #nc.sort()
  #nc = [nc[0], nc[-1]]  
  def open_virtual(filepath, creds):
    return open_virtual_dataset(filepath, indexes = {}, 
                                loadable_variables=['longitude', 'latitude', 'time'], drop_variables = ['nv', 'err_sla', 'err_ugosa', 'err_vgosa', 'flag_ice',  'tpa_correction', 'err' ], 
                                decode_times = True, reader_options={'storage_options': creds})
  print("virtualizing netcdfs with VirtualiZarr")
  vdd = [
    dask.delayed(open_virtual)(filepath, aws_credentials)
    for filepath in nc
  ]

  print("computing")
  vd = dask.compute(vdd)
  
  print("concatenating virtual zarrs with xarray")
  import xarray
  ## different syntax for dask
  vds = xarray.concat(vd[0], dim = 'time', coords = 'minimal', compat = 'override')

  print("writing virtual zarr to SCRATCH")
  vds.virtualize.to_kerchunk(f'/scratch/pawsey0973/mdsumner/{dataset}.parquet', format='parquet')

  print("Finished!")



