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
#Download RRR input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/2665084/files"
folder="../input/WSWM_GRL"
list="                                                                         \
      Catchment_WSWM_Sort.zip                                                  \
      GageLoc_WSWM_with_dir.zip                                                \
      NHDFlowline_WSWM_Sort.zip                                                \
      PlusFlowlineVAA_WSWM_Sort_fixed_Node_50233399.zip                        \
      PlusFlow_WSWM.zip                                                        \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done


#*******************************************************************************
#Convert legacy files
#*******************************************************************************
#N/A


#*******************************************************************************
#Done
#*******************************************************************************
