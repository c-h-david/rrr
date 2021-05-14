#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Sikder_etal_2020_WRR.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (2020), A Synthetic
#Data Set Inspired by Satellite Altimetry and Impacts of Sampling on Global
#Spaceborne Discharge Characterization.
#DOI: 10.1029/2020WR029035
#The files used are available from:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (202x), Input and
#output files corresponding to "A Synthetic Data Set Inspired by Satellite
#Altimetry and Impacts of Sampling on Global Spaceborne Discharge
#Characterization", Zenodo.
#DOI: 10.5281/zenodo.3542269
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
echo "Downloading files from:   https://doi.org/10.5281/zenodo.3542269"
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
URL="https://zenodo.org/record/4064188/files"
folder="../input/MERIT_WRR"
list="                                                                         \
      GRADES_Q_125cms_20000101_20091231.tar.gz                                 \
      orbit_shp_SARAL.tar.gz                                                   \
      orbit_shp_Sentinel3.tar.gz                                               \
      orbit_shp_SWOT_swath.tar.gz                                              \
      orbit_shp_JASON.tar.gz                                                   \
      orbit_shp_Sentinel3A.tar.gz                                              \
      orbit_shp_SWOT_nadir.tar.gz                                              \
      riv_network_shp.tar.gz                                                   \
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
URL="https://zenodo.org/record/4064188/files"
folder="../output/MERIT_WRR"
list="                                                                         \
      orbit_coverage_JASON.tar.gz                                              \
      orbit_coverage_Sentinel3A.tar.gz                                         \
      orbit_coverage_SWOT_nadir.tar.gz                                         \
      orbit_coverage_SARAL.tar.gz                                              \
      orbit_coverage_Sentinel3.tar.gz                                          \
      orbit_coverage_SWOT_swath.tar.gz                                         \
      sampling_csv_orbit.tar.gz                                                \
      orbit_spl_JASON.tar.gz                                                   \
      orbit_spl_SARAL.tar.gz                                                   \
      orbit_spl_Sentinel3.tar.gz                                               \
      orbit_spl_Sentinel3A.tar.gz                                              \
      orbit_spl_SWOT_nadir.tar.gz                                              \
      orbit_spl_SWOT_swath.tar.gz                                              \
      sampling_csv_regular.tar.gz                                              \
      regular_spl_3day.tar.gz                                                  \
      regular_spl_5day.tar.gz                                                  \
      regular_spl_10day.tar.gz                                                 \
      regular_spl_21day.tar.gz                                                 \
      regular_spl_27day.tar.gz                                                 \
      regular_spl_35day.tar.gz                                                 \
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
