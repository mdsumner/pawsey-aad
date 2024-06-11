WIP draft, Michael Sumner



- create the bowerbird data library on Setonix, as persistent storage in Acacia
- bowerbird sync has to run every day, probably each source as a max(24hr) task on its own cpu
- how does scheduling (or leapfrogging) the task work, does it make sense for each data source to have its own scedule (I think so, actually)
- rsync the component that overlaps with nilas to nci (this is outside the Setonix tent, but enabled by Acacia as the most up to date )
- rsync the bulk to rdsi, it simplifies our Nectar footprint immensely (it's just an rsync + webserver)
- what is user exp like with Setonix? We have multiple expert users in our project for intensive use of Pawsey, they can schedule interactive or batch jobs
- what is results like for a user, published to Acacia, how to download, is that part of the batch task, can outputs be pushed to Acacia for a user-auth etc
- file-listing and public-acessibility of links on Acacia 



## Random thoughts

how is our docker image? It's large, not multi-stage build, there's some issues with installing stuff as a user (do we insert .libPaths("/home/mdsumner/R/x86_64-pc-linux-gnu-library/4.4") equiv?)

do we write to scratch then upload to Acacia

how do we treat active use, does it intermingle what's on scratch with syncs from Acacia? Can these be seamless

  - the really pressing need is to be able to read *any* file from bowerbird, but to then say "actually I want this block of *spacetime* from *these datasets*
  - in IDEA terms, this is about how we remove friction from users  - they know bowerbird has the data or knows how to get it
 
users outside of setonix: I think we can just put this aside for now


