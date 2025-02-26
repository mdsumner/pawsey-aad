This text describes the scrontab on pawsey project. Scripts run from ~/batch dirs acacia/ (relating to object storage) and singul/ (relating to docker image for Singularity). 

don't yet know how to template the account, so it's listed as `{account}` and we just run relative to user home. 


```
#SCRON --account={account}
#SCRON --time=00:25:00
#SCRON --export=NONE
#SCRON --ntasks=1
#SCRON --cpus-per-task=1
#SCRON --partition=copy
#SCRON -o ~/batch/cronjobs/cron-update_hyper_cron-%j.out
#SCRON --mem=20000
0 0 * * 0  ~/batch/singul/update_hyper_cron.sh


#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --cpus-per-task=1
#SCRON --mem=24Gb
#SCRON --time 00:10:00
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-00_bowerbird_sync-%j.out
#SCRON --open-mode=append
00  03  * * *  ~/batch/acacia/00_bowerbird_sync.sh

#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --cpus-per-task=1
#SCRON --mem=6Gb
#SCRON --time 01:00:00
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-sync-ghrsst_sync-%j.out
#SCRON --open-mode=append
23  13  * * *  ~/batch/acacia/sync-ghrsst.sh


#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --cpus-per-task=1
#SCRON --mem=2Gb
#SCRON --time 00:10:00
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-sync-oisst-%j.out
#SCRON --open-mode=append
00  05  * * * ~/batch/acacia/sync-oisst.sh



#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --cpus-per-task=1
#SCRON --mem=2Gb
#SCRON --time 00:04:00
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-curated_listing-%j.out
#SCRON --open-mode=append
24,26  *  * * * ~/batch/acacia/curated_listing.sh



#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --mem=230Gb
#SCRON --time=00:05:00
#SCRON --cpus-per-task=128
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-oisst-virtualiZing-%j.out
#SCRON --open-mode=append
24 21 * * * ~/batch/acacia/oisst-virtualize.sh



#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --mem=230Gb
#SCRON --time=00:05:00
#SCRON --cpus-per-task=128
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-nsidc-south-virtualiZing-%j.out
#SCRON --open-mode=append
35 11  * * * ~/batch/acacia/nsidc-virtualize-south.sh


#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --mem=230Gb
#SCRON --time=00:05:00
#SCRON --cpus-per-task=128
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-nsidc-north-virtualiZing-%j.out
#SCRON --open-mode=append
35 11  * * * ~/batch/acacia/nsidc-virtualize-north.sh


#SCRON --account={account}
#SCRON --ntasks=1
#SCRON --mem=230Gb
#SCRON --time=00:30:00
#SCRON --cpus-per-task=128
#SCRON --partition work
#SCRON -o ~/batch/cronjobs/cron-altimetry-virtauliZing-%j.out
#SCRON --open-mode=append
26 14  * * * ~/batch/acacia/altimetry-virtualize.sh

```
