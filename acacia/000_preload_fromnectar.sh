#!/bin/bash

cd /rdsi/PUBLIC/raad/data

export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=

## one time create bucket
#aws --profile pawsey0973 --region "" --endpoint-url https://projects.pawsey.org.au s3 mb s3://$dataid

## set bucket policy
#aws s3api put-bucket-policy --bucket $dataid --policy file://bucket_policy.json  --endpoint-url https://projects.pawsey.org.au/

## TRASH THAT BUCKET
## aws --profile pawsey0973 --region "" --endpoint-url https://projects.pawsey.org.au s3 rb s3://$dataid --force

## OISST now done on Pawsey
#export dataid=idea-10.7289-v5sq8xb5
#aws  --region "" --endpoint-url https://projects.pawsey.org.au s3 sync www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation s3://$dataid/www.ncei.noaa.gov/data/sea-surface-temperature-optimum-interpolation  --include '*oisst-avhrr-*.nc'


## NSIDC now done on Pawsey
##export dataid=idea-10.5067-mpyg15waa4wx
##aws  --region ""  --endpoint-url https://projects.pawsey.org.au s3 sync n5eil01u.ecs.nsidc.org s3://$dataid/n5eil01u.ecs.nsidc.org --exclude='*' --include='PM/NSIDC-0051.002/*/*_PS_S25km_*' --include='PM/NSIDC-0081.002/*/*_PS_S25km_*'  --include='PM/NSIDC-0051.002/*/*_PS_N25km_*'  --include='PM/NSIDC-0081.002/*/*_PS_N25km_*'


#export dataid=idea-sealevel-glo-phy-l4-nrt-008-046
#aws  --region "" --endpoint-url https://projects.pawsey.org.au s3 sync data.marine.copernicus.eu/SEALEVEL_GLO_PHY_L4_NRT_008_046 s3://$dataid/data.marine.copernicus.eu/SEALEVEL_GLO_PHY_L4_NRT_008_046 --exclude='*' --include='*nrt_global_allsat_phy_l4_2025*.nc'


#export dataid=idea-sealevel-glo-phy-l4-rep-observations-008-047
#aws  --region "" --endpoint-url https://projects.pawsey.org.au s3 sync data.marine.copernicus.eu/SEALEVEL_GLO_PHY_L4_MY_008_047 s3://$dataid/data.marine.copernicus.eu/SEALEVEL_GLO_PHY_L4_MY_008_047 --exclude='*' --include='cmems_obs-sl_glo_phy-ssh_my_allsat-l4-duacs'


##  AMSR now done on Pawsey
#export  dataid=idea-amsr2-asi-s3125
#aws  --region ""  --endpoint-url https://projects.pawsey.org.au s3 sync seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/s3125  s3://$dataid/seaice.uni-bremen.de/data/amsr2/asi_daygrid_swath/s3125 --exclude='*'  --include='*Antarctic3125/*v5.4.tif'

## CCMP
## export dataid=ccmp-wind-product-v2
## aws  --region ""  --endpoint-url https://projects.pawsey.org.au s3 sync data.remss.com/ccmp/v03.1 s3://$dataid/data.remss.com/ccmp/v03.1 --exclude='*' --include='*.nc'

echo  "FINISHED!!\n"
