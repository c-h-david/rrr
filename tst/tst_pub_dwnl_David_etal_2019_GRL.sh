#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_David_etal_2019_GRL.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#David, Cédric H., Jonathan M. Hobbs, Michael J. Turmon, Charlotte M. Emery,
#John T. Reager, and James S. Famiglietti (2019), Analytical Propagation of
#Runoff Uncertainty into Discharge Uncertainty through a Large River Network,
#Geophysical Research Letters.
#DOI: 10.1029/2019GL083342
#The files used are available from:
#David, Cédric H., Jonathan M. Hobbs, Michael J. Turmon, Charlotte M. Emery,
#John T. Reager, and James S. Famiglietti (2019), RRR/RAPID input and output
#files corresponding to "Analytical Propagation of Runoff Uncertainty into
#Discharge Uncertainty through a Large River Network", Zenodo.
#DOI: 10.5281/zenodo.2665084
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#Cedric H. David, 2016-2019.


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#wget -q -nc           --> Quiet, No-clobber (don't overwrite) 
#wget -r               --> Turn on recursive retrieving. 
#wget -nH              --> Disable generation of host-prefixed directories. 
#wget ---cut-dirs=i    --> Ignore i directory components when saving files. 
#wget -P               --> Directory prefix where everything is downloaded


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Downloading files from:   http://dx.doi.org/10.5281/zenodo.2665084"
echo "which correspond to   :   http://dx.doi.org/10.1029/2019GL083342"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these two DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download NLDAS2 files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="ftp://hydro1.sci.gsfc.nasa.gov/data/s4pa/NLDAS/"
model="                                                                        \
       VIC                                                                     \
      "
year="                                                                         \
      1997                                                                     \
      1998                                                                     \
     "
folder="../input/WSWM_GRL/NLDAS2"

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
for model in $model
do
mkdir -p $folder"/NLDAS_"$model"0125_H.002/"
for year in $year
do
     wget -q -nc -r -nH --cut-dirs=5 -A grb                                    \
          $URL"/NLDAS_"$model"0125_H.002/"$year                                \
          -P $folder"/NLDAS_"$model"0125_H.002/"
     if [ $? -gt 0 ] ; then echo "Problem downloading $year" >&2 ; exit 44 ; fi
done
done


#*******************************************************************************
#Convert legacy files
#*******************************************************************************
#N/A


#*******************************************************************************
#Done
#*******************************************************************************
