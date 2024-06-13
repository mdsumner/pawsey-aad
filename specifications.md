WIP draft, Michael Sumner



 

- how does scheduling (or leapfrogging) the task work, expect we will batch each data source (and group within)
- how to set `module load singularity/4.1.0-slurm` in just one place?
- what is user exp like with Setonix? We have multiple expert users in our project for intensive use of Pawsey, they can schedule interactive or batch jobs
- can we connect to a session with VSCode?
- can we streamline the user-connect experience (currently start a batch job, reverse proxy)
- file-listing and public-acessibility of links on Acacia 
- rsync the component that overlaps with nilas to nci (this is outside the Setonix tent, but enabled by Acacia as the most up to date )
- rsync the bulk to rdsi, it simplifies our Nectar footprint immensely (it's just an rsync + webserver)





## Random thoughts

how is our docker image? It's large, not multi-stage build, there's some issues with installing stuff as a user (do we insert .libPaths("/home/mdsumner/R/x86_64-pc-linux-gnu-library/4.4") equiv?)

 what is results like for a user, published to Acacia, how to download, is that part of th batch task, can outputs be pushed to Acacia for a user-auth etc

do we write to scratch then upload to Acacia

how do we treat active use, does it intermingle what's on scratch with syncs from Acacia? Can these be seamless

  - the really pressing need is to be able to read *any* file from bowerbird, but to then say "actually I want this block of *spacetime* from *these datasets*
  - in IDEA terms, this is about how we remove friction from users  - they know bowerbird has the data or knows how to get it
 
users outside of setonix: I think we can just put this aside for now


