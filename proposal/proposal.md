## Draft proposal for Australian research institutions and ARCO practices

### Preamble

Historically, scientific data in earth-observation disciplines have been stored
in files, stored on a file system that the end-user was directly connected to
(i.e. their own machine, or local network). Direct access to files stored on a
remote server was possible (using e.g. openDap) but difficult and not widely
used. The advent of object storage and other cloud technologies has made remote
file access (for general files) commonplace: however, remote access to
earth-observation and similar scientific data files brings additional
challenges, including the ability to efficiently extract and work with subsets
of files (e.g. a spatial subset of a global file, or a subset of depths from a
three-dimensional ocean model, or a subset of variables from a multivariate
file).

One of the most promising solutions to this is Zarr, a format for
multidimensional data arrays that is particularly designed for cloud storage and
for efficient remote querying. However, Zarr is relatively recent and suffers
from poor R support, no version control, and issues with transactional
reliability. New technologies VirtualiZarr and Icechunk promise to greatly
improve this going forward. 

### Proposal

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


