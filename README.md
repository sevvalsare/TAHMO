# Overview
This repository stores for scripts related to pre- / post-processing files for Precipitation Defect Detection methods. See manuscript here for more details on the process.
The stations used to import data are TAHMO, GSMAP and CHIRPS. 
GSMAP and CHIRPS data are imported via using google earth engine.

## Matlab
data_comparison.m - this script will take output from Google Earth Engine and Tahmo and it will convert them to daily file formats needed for comparison. Please see the comments at the top of that file.

	call_kstest.m - this script is called by data_comparison.m for the purposes of evaluating ks test.
	call_crosscor.m - this script is called by data_comparison.m for the purposes of evaluating cross correlation.
	callTAHMO.m - this script is called by data_comparison.m for the purposes of converting 5min tahmo data to daily data.

## Google Earth Engine
define_chirps_precipitation.js 
define_gsmap_precipitation.js
1) You will need to be registered with a Google Earth Engine account to run these scripts. If you don't already have an account you can sign up for one here.
In GEE, in the left toolbar, select 'New' - 'File' from the red dropdown box. Enter a path, a filename, and a description.
2) In the code editor (upper center panel of GEE) paste the contents from the define_chirps_precipitation.js and define_gsmap_precipitation.js file provided here in Github. Click on 'Save'
3) Click on 'Run'. At this point you can explore the three tabs in the right toolbar (Inspecctor / Console / Tasks). 
4) Choose 'Console'. You will see a graph with a button to the top right. You must click the button. This will bring up a new page with an option to download data in .csv format.
5) Go to wherever you directed output.(You need to direct the output where your matlab scripts locates.)

## TAHMO
Tahmo weather station data is private and needs permission.


### contact
[Sevval Gulduren](https://bee.oregonstate.edu/users/sevval-sare-gulduren)
