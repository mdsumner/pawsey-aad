from virtualizarr import open_virtual_dataset
import pyarrow.parquet as pq
from pyarrow import fs

import dask.multiprocessing
import os

if __name__ == '__main__':
  dataset = "oisst-avhrr-v02r01"
  bucket = "idea-10.7289-v5sq8xb5"

  n = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])

  dask.config.set(num_workers = int(os.environ["SLURM_JOB_CPUS_PER_NODE"]), scheduler = "processes")  

  print(f'running with {n} cpus')

  aws_credentials = {"endpoint_url": "https://projects.pawsey.org.au",  "anon": True}

  print("reading idea objects list from Parquet")
  s3 = fs.S3FileSystem(endpoint_override = "projects.pawsey.org.au")
  s3table = pq.read_table("idea-objects/idea-curated-objects.parquet", filesystem = s3, filters=[('Dataset','==', dataset)])

  print(f"obtaining list of netcdf files for {dataset}")
  keylist = s3table.to_pandas().Key.tolist()
  buckets = s3table.to_pandas().Bucket.tolist()
  nc = [f's3://{bucket}/{key}' for bucket,key in zip(buckets, keylist)]
  nc.sort()

  def open_virtual(filepath, creds):
    return open_virtual_dataset(filepath, indexes = {}, 
                                loadable_variables=['lon', 'lat', 'time'], drop_variables = ['zlev'],
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
  vds = xarray.concat(vd[0], dim = 'time', coords = 'minimal', compat = 'override')

  print(f"writing virtual zarr to SCRATCH/{dataset}")
  vds.virtualize.to_kerchunk(f'/scratch/pawsey0973/mdsumner/{dataset}.parquet', format='parquet')

  print("Finished!")



