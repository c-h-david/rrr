#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Sikder_etal_2021_WRR.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (2021), A Synthetic
#Data Set Inspired by Satellite Altimetry and Impacts of Sampling on Global
#Spaceborne Discharge Characterization.
#DOI: 10.1029/2020WR029035
#The files used are available from:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (2021), Input and
#output files corresponding to "A Synthetic Data Set Inspired by Satellite
#Altimetry and Impacts of Sampling on Global Spaceborne Discharge
#Characterization", Zenodo.
#DOI: 10.5281/zenodo.5515650
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#M. Safat Sikder and Cedric H. David, 2020-2021


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
echo "Downloading files from:   https://doi.org/10.5281/zenodo.5515650"
echo "which correspond to   :   https://doi.org/10.1029/2020WR029035"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these four DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download RRR input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/5515650/files"
folder="../input/MERIT_WRR"
list="                                                                         \
     MERIT_riv_Qmean_125cms.zip                                                \
     MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.zip                     \
     Qout_GRADES_Qmean_125cms_20000101_20091231.nc                             \
     TOPJAS.zip                                                                \
     SENT3A.zip                                                                \
     S3AS3B.zip                                                                \
     ENVSRL.zip                                                                \
     SWOT_N.zip                                                                \
     SWOT_S.zip                                                                \
     Imagery_WGS84_Global.tif                                                  \
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
#Download RRR post-processing files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/5515650/files"
folder="../output/MERIT_WRR"
list="                                                                         \
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
#Convert files
#*******************************************************************************
for file in `ls ../input/MERIT_WRR/*.tar.gz`
do
     tar -xzf $file --skip-old-files --directory ../input/MERIT_WRR/
     if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

for file in `ls ../output/MERIT_WRR/*.tar.gz`
do
     tar -xzf $file --skip-old-files --directory ../output/MERIT_WRR/
     if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done


#*******************************************************************************
#Done
#*******************************************************************************
