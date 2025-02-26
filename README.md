# pawsey-aad

The Pawsey preparatory access scheme project "Climate output processing for the Integrated Digital East Antarctica program". 

This project demonstrated migrating a data science toolkit from its home on Nectar research cloud to Pawsey, using object storage. 

Pawsey is a Tier 1 HPC in Australia, funded by the CSIRO, physically housed in Western Australia. The login node is Setonix, it provides lustre scratch, and all permanent storage is on Acacia the object storage. 

We have configured a number of buckets for public access, to host sets of netcdf remote sensing data we use regularly, to reformat some, and to provide R tools for public access, and Python public access via VirtualiZarr-parquet. 

## jobs on Pawsey 

There are regular tasks run (see [crontab.md](https://github.com/mdsumner/pawsey-aad/blob/main/crontab.md)), that work on bash scripts in the acacia/ and singul/ directories. 

These scripts: 

- synchronize data from online sources directly to object storage using [bowerbird](https://docs.ropensci.org/bowerbird/) see [00_bowerbird_sync.sh](https://github.com/mdsumner/pawsey-aad/blob/main/acacia/00_bowerbird_sync.sh)
- convert select datasets from NetCDF to GeoTIFF COG in object storage see [sync-ghrsst.sh](https://github.com/mdsumner/pawsey-aad/blob/main/acacia/sync-ghrsst.sh) and [sync-oisst.sh](https://github.com/mdsumner/pawsey-aad/blob/main/acacia/sync-oisst.sh)
- virtualize select datasets by writing [VirtualiZarr](https://virtualizarr.readthedocs.io/en/stable/index.html) Parquet stores, which can be opened as a single endpoint by [xarray](https://xarray.dev) see [nsidc-virtualize-south.sh](https://github.com/mdsumner/pawsey-aad/blob/main/acacia/nsidc-virtualize-south.sh) and other '-virutalize.sh' scripts
- list the contents of the buckets in full [bucket_listing.sh](https://github.com/mdsumner/pawsey-aad/blob/main/acacia/bucket_listing.sh) and in *curated form* (organized by dataset-identifier, sorted by date and ready for downstream use) [curated_listing.sh](https://github.com/mdsumner/pawsey-aad/blob/main/acacia/curated_listing.sh)
- each script invokes a Python or R script, run in the context of a specialized docker image with all dependencies installed

This is very much an ongoing exploration, we are learning a lot and uncovering a lot of questions and ways of proceeding. 

## datasets

The datasets involved are primarily daily remote sensing:  sea ice concentrations, sea surface temperature, altimetry and surface currents. 

### R

The R project [sooty](https://github.com/mdsumner/sooty/) represents a way of working with these files by obtaining them with a simple configuration. (This would be used to replace or upgrade-to-public-accessiblity the older [raadtools](https://github.com/AustralianAntarcticDivision/raadtools) software that is only available within our Nectar context currently). 

### Python

The virtualized forms of these data can be accessed directly by Python, via kerchunk/VirtualiZarr: 

Using this docker. 

```
docker run --rm -ti ghcr.io/mdsumner/gdal-builds:rocker-gdal-dev-python bash
python
```
Run this python: 

```python
import xarray

## public bucket on Pawsey endpoint
so = {"endpoint_url": "https://projects.pawsey.org.au",  "anon": True}

datasetlist = ['SEALEVEL_GLO_PHY_L4', 'NSIDC_SEAICE_PS_S25km', 'NSIDC_SEAICE_PS_N25km', 'oisst-avhrr-v02r01']

for id in datasetlist: 
   ds = xarray.open_dataset(f's3://vzarr/{id}.parquet', engine = "kerchunk", chunks = {}, storage_options={"remote_options": so})
   print(ds)

```

Output of these single-endpoint datacubes, compatible with more traditional ways of working with the same data in R that we have. (R support for Zarr is coming). 

```
<xarray.Dataset> Size: 574GB
Dimensions:    (time: 11538, latitude: 720, longitude: 1440, nv: 2)
Coordinates:
  * latitude   (latitude) float32 3kB -89.88 -89.62 -89.38 ... 89.38 89.62 89.88
  * longitude  (longitude) float32 6kB -179.9 -179.6 -179.4 ... 179.6 179.9
  * time       (time) datetime64[ns] 92kB 1993-01-01 1993-01-02 ... 2024-11-25
Dimensions without coordinates: nv
Data variables:
    adt        (time, latitude, longitude) float64 96GB dask.array<chunksize=(1, 50, 50), meta=np.ndarray>
    crs        (time) float64 92kB dask.array<chunksize=(11538,), meta=np.ndarray>
    lat_bnds   (time, latitude, nv) float32 66MB dask.array<chunksize=(1, 50, 2), meta=np.ndarray>
    lon_bnds   (time, longitude, nv) float32 133MB dask.array<chunksize=(1, 50, 2), meta=np.ndarray>
    sla        (time, latitude, longitude) float64 96GB dask.array<chunksize=(1, 50, 50), meta=np.ndarray>
    ugos       (time, latitude, longitude) float64 96GB dask.array<chunksize=(1, 50, 50), meta=np.ndarray>
    ugosa      (time, latitude, longitude) float64 96GB dask.array<chunksize=(1, 50, 50), meta=np.ndarray>
    vgos       (time, latitude, longitude) float64 96GB dask.array<chunksize=(1, 50, 50), meta=np.ndarray>
    vgosa      (time, latitude, longitude) float64 96GB dask.array<chunksize=(1, 50, 50), meta=np.ndarray>
Attributes: (12/44)
    Conventions:                     CF-1.6
    Metadata_Conventions:            Unidata Dataset Discovery v1.0
    cdm_data_type:                   Grid
    comment:                         Sea Surface Height measured by Altimetry...
    contact:                         servicedesk.cmems@mercator-ocean.eu
    creator_email:                   servicedesk.cmems@mercator-ocean.eu
    ...                              ...
    summary:                         SSALTO/DUACS Delayed-Time Level-4 sea su...
    time_coverage_duration:          P1D
    time_coverage_end:               1993-01-01T12:00:00Z
    time_coverage_resolution:        P1D
    time_coverage_start:             1992-12-31T12:00:00Z
    title:                           DT merged all satellites Global Ocean Gr...
<xarray.Dataset> Size: 13GB
Dimensions:  (time: 15249, y: 332, x: 316)
Coordinates:
  * time     (time) datetime64[ns] 122kB 1978-10-26 1978-10-28 ... 2025-02-06
  * x        (x) float64 3kB -3.938e+06 -3.912e+06 ... 3.912e+06 3.938e+06
  * y        (y) float64 3kB 4.338e+06 4.312e+06 ... -3.912e+06 -3.938e+06
Data variables:
    ICECON   (time, y, x) float64 13GB dask.array<chunksize=(1, 332, 316), meta=np.ndarray>
    crs      (time) object 122kB dask.array<chunksize=(15249,), meta=np.ndarray>
Attributes: (12/49)
    Conventions:               CF-1.6, ACDD-1.3
    acknowledgment:            These data are produced by the NASA Cryospheri...
    cdm_data_type:             grid
    citation:                  DiGirolamo, N. E., C. L. Parkinson, D. J. Cava...
    contributor_name:          Nicolo E. DiGirolamo, Claire Parkinson, Per Gl...
    contributor_role:          project_scientist, project_scientist, project_...
    ...                        ...
    summary:                   This data set is generated from brightness tem...
    time_coverage_duration:    1978-10-26T00:00P1D
    time_coverage_end:         1978-10-26 23:59.99
    time_coverage_resolution:  P1D
    time_coverage_start:       1978-10-26 00:00.00
    title:                     Sea Ice Concentrations from Nimbus-7 SMMR and ...
<xarray.Dataset> Size: 17GB
Dimensions:  (time: 15249, y: 448, x: 304)
Coordinates:
  * time     (time) datetime64[ns] 122kB 1978-10-26 1978-10-28 ... 2025-02-06
  * x        (x) float64 2kB -3.838e+06 -3.812e+06 ... 3.712e+06 3.738e+06
  * y        (y) float64 4kB 5.838e+06 5.812e+06 ... -5.312e+06 -5.338e+06
Data variables:
    ICECON   (time, y, x) float64 17GB dask.array<chunksize=(1, 448, 304), meta=np.ndarray>
    crs      (time) object 122kB dask.array<chunksize=(15249,), meta=np.ndarray>
Attributes: (12/49)
    Conventions:               CF-1.6, ACDD-1.3
    acknowledgment:            These data are produced by the NASA Cryospheri...
    cdm_data_type:             grid
    citation:                  DiGirolamo, N. E., C. L. Parkinson, D. J. Cava...
    contributor_name:          Nicolo E. DiGirolamo, Claire Parkinson, Per Gl...
    contributor_role:          project_scientist, project_scientist, project_...
    ...                        ...
    summary:                   This data set is generated from brightness tem...
    time_coverage_duration:    1978-10-26T00:00P1D
    time_coverage_end:         1978-10-26 23:59.99
    time_coverage_resolution:  P1D
    time_coverage_start:       1978-10-26 00:00.00
    title:                     Sea Ice Concentrations from Nimbus-7 SMMR and ...
<xarray.Dataset> Size: 527GB
Dimensions:  (time: 15876, zlev: 1, lat: 720, lon: 1440)
Coordinates:
  * lat      (lat) float32 3kB -89.88 -89.62 -89.38 -89.12 ... 89.38 89.62 89.88
  * lon      (lon) float32 6kB 0.125 0.375 0.625 0.875 ... 359.4 359.6 359.9
  * time     (time) datetime64[ns] 127kB 1981-09-01T12:00:00 ... 2025-02-17T1...
Dimensions without coordinates: zlev
Data variables:
    anom     (time, zlev, lat, lon) float64 132GB dask.array<chunksize=(1, 1, 720, 1440), meta=np.ndarray>
    err      (time, zlev, lat, lon) float64 132GB dask.array<chunksize=(1, 1, 720, 1440), meta=np.ndarray>
    ice      (time, zlev, lat, lon) float64 132GB dask.array<chunksize=(1, 1, 720, 1440), meta=np.ndarray>
    sst      (time, zlev, lat, lon) float64 132GB dask.array<chunksize=(1, 1, 720, 1440), meta=np.ndarray>
Attributes: (12/37)
    title:                      NOAA/NCEI 1/4 Degree Daily Optimum Interpolat...
    source:                     ICOADS, NCEP_GTS, GSFC_ICE, NCEP_ICE, Pathfin...
    id:                         oisst-avhrr-v02r01.19810901.nc
    naming_authority:           gov.noaa.ncei
    summary:                    NOAAs 1/4-degree Daily Optimum Interpolation ...
    cdm_data_type:              Grid
    ...                         ...
    metadata_link:              https://doi.org/10.25921/RE9P-PT57
    ncei_template_version:      NCEI_NetCDF_Grid_Template_v2.0
    comment:                    Data was converted from NetCDF-3 to NetCDF-4 ...
    sensor:                     Thermometer, AVHRR
    Conventions:                CF-1.6, ACDD-1.3
    references:                 Reynolds, et al.(2007) Daily High-Resolution-...


```
