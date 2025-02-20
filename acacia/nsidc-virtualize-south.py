from virtualizarr import open_virtual_dataset
import pyarrow.parquet as pq
from pyarrow import fs

import dask.multiprocessing
import os

if __name__ == '__main__':
  dataset = "NSIDC_SEAICE_PS_S25km"
  bucket = "idea-10.5067-mpyg15waa4wx"
  ncpus = int(os.environ["SLURM_JOB_CPUS_PER_NODE"])

  dask.config.set(num_workers = ncpus, scheduler = "processes")  

  print(f'running with {ncpus} cpus')

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
                                loadable_variables=['x', 'y', 'time'], 
                                decode_times = True, reader_options={'storage_options': creds})
  print("virtualizing netcdfs with VirtualiZarr")
  vdd = [
    dask.delayed(open_virtual)(filepath, aws_credentials)
    for filepath in nc
  ]

  print("computing")
  vd = dask.compute(vdd)

  vd = [iv for iv in vd[0] if len(iv.items()) > 1]

  ## here  better flush out all that only have 'crs', but then we can drop the extra vars and only keep 1
  i = 0
  for ds in vd:
    all_vals = [(k, v) for (k, v) in ds.items() if k.endswith("ICECON")]
    for (k, v) in all_vals:
      ds = ds.drop_vars(k)
    ds["ICECON"] = sorted(all_vals)[-1][1]
    vd[i] = ds
    i = i + 1
  
  print("concatenating virtual zarrs with xarray")
  import xarray
  ## different syntax for dask
  vds = xarray.concat(vd, dim = 'time', coords = 'minimal', compat = 'override')
  #vds = xarray.concat(vd, dim = 'time', coords = 'minimal', compat = 'override')

  print("writing virtual zarr to SCRATCH")
  vds.virtualize.to_kerchunk(f'/scratch/pawsey0973/mdsumner/{dataset}.parquet', format='parquet')

  print("Finished!")



