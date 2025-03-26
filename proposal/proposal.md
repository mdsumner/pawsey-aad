## Draft proposal for Australian research institutions and ARCO practices

We propose a project to promote usage of new workflows that cross compute
facility boundaries, based on Zarr and related technologies. The project will
involve working with Australian institutions and a commercial company. The
plan is  a staged pilot working on  example datasets to improve the
understanding of these new technologies in Australian research,  illustrate
their usage, flush out existing gaps and problems, and encourage adoption of
ARCO (analysis ready cloud-optimized)  data access patterns.

The key benefits: 

- Shared learnings between the institutions regarding cloud-oriented publishing
and analysis of data. This will help understand current practices, how they
could be improved, and how to proceed, determined with a view to identifying
shared needs across disciplines
- A better understanding of how data can be stored in order to support such
workflows, including the advantages of material reformatting (i.e. changed
format and re-stored on disk) compared to virtual reformatting (files remain in
their original format on disk but are reformatted on the fly as required).
- Ability to reformat data files materially or only virtually, and to determine at
a cross-discipline level which is preferable under which circumstances
- Improved access to the Australian research community to  ARCO data, and 
improved publication-control for providers of ARCO data

We expect variety in details of the compute and storage, no prescription is made
because we expect to learn about the best approaches available from each
example.

## STAGE 1

The first stage is exploratory, and closely related to existing activities for
each institution. Investigate the process of virtualizing an existing data set
as a ZARR store.  The result is a single-endpoint index (such as a VirtualiZarr
json or Parquet) useable in-context, opened by xarray.  Identify questions that
would relate to STAGE 2, with particular value in sharing the common threads and
specific approaches required for each example.

Possible example datasets, to be run on existing compute/storage platform as convenient: 

### AAD

CMEMS global gridded SSH reprocessed altimetry (daily multi-variable netcdfs with varied formatting and resolution in the timeline)

Artist AMSR2 near-real-time 3.125km sea ice concentration

Bluelink ocean temperature across 2020/2023 versions


### institution 1

details wip

### institution 2

details wip

### institution 3

details wip


## STAGE 2

Applying the process of STAGE 1 to some operational examples. 


## STAGE 3


