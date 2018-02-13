#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Allen_etal_201x_GGG.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#Allen, George H., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
#This script also downloads a subset of the files from:
#Rodell, M., P. R. Houser, U. Jambor, J. Gottschalck, K. Mitchell, C.-J. Meng, 
#K. Arsenault, B. Cosgrove, J. Radakovich, M. Bosilovich, J. K. Entin, J. P. 
#Walker, D. Lohmann, and D. Toll (2004), The Global Land Data Assimilation 
#System, Bulletin of the American Meteorological Society, 85(3), 381–394.
#DOI: 10.1175/BAMS-85-3-381
#This script also downloads a subset of the files from:
#Lehner, Bernhard, Kristine Verdin, and Andy Jarvis (2008), New Global 
#Hydrography Derived From Spaceborne Elevation Data, Eos Trans. AGU, 89(10), 
#93–94.
#DOI:10.1029/2008EO100001.
#The files used are available from:
#Allen, George H., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
#and from:
#Rodell, M., P. R. Houser, U. Jambor, J. Gottschalck, K. Mitchell, C.-J. Meng, 
#K. Arsenault, B. Cosgrove, J. Radakovich, M. Bosilovich, J. K. Entin, J. P. 
#Walker, D. Lohmann, and D. Toll (2004), The Global Land Data Assimilation 
#System:
#https://hydro1.sci.gsfc.nasa.gov/data/s4pa/GLDAS/
#and from:
#Lehner, Bernhard, Kristine Verdin, and Andy Jarvis (2008), New Global 
#Hydrography Derived From Spaceborne Elevation Data:
#http://earlywarning.usgs.gov/hydrodata/sa_shapefiles_zip
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#George H. Allen, Cedric H. David, 2017-2018.


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
echo "Downloading files from:   http://dx.doi.org/xx.xxxx/xxxxxx"
echo "                          https://hydro1.sci.gsfc.nasa.gov/data/s4pa/GLDAS/"
echo "                          http://earlywarning.usgs.gov/hydrodata/sa_shapefiles_zip"
echo "which correspond to   :   http://dx.doi.org/xx.xxxx/xxxxxx"
echo "                          http://dx.doi.org/10.1175/BAMS-85-3-381"
echo "                          http://dx.doi.org/10.1029/2008EO100001"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these four DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Command line option
#*******************************************************************************
if [ "$#" -gt "1" ]; then
     echo "A maximum of one argument can be given" 1>&2
     exit 22
fi
#Make sure a maximum of one command land line option was given

if [ "$#" -eq "1" ]; then
     if [ "$1" == "nldas" ] || [ "$1" == "hydrosheds" ] ||                     \
        [ "$1" == "rrr" ]; then 
          dwnl=$1
     else
          echo "The option $1 does not exist" 1>&2
          exit 22
     fi
fi
#Make sure the command line option given exists


#*******************************************************************************
#Download GLDAS files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://gaia.geosci.unc.edu/NARWidth/bin/GLDAS_VIC10_3H_V001_links_20171108_112912_testList.txt"
# URL to list of GLDAS files to download. List can be generated here: 
# https://disc.sci.gsfc.nasa.gov/ and search “GLDAS VIC” --> get data
# Dataset: GLDAS VIC Land Surface Model L4 3 Hourly 1.0 x 1.0 degree V001
# Click on "Subset Data":
# Date Range: 2000-01-01  --  2009-12-31
# Spatial Region: 65, 9, 109, 38
# Variables: Surface Runoff and Subsurface Runoff
# Units: kg/m2/s
# Output Format: GRIB

folder="../input/GLDAS-VIC/GRIB/"

#------------------------------------------------------------------------------- 
# Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
touch ~/.netrc
echo "machine urs.earthdata.nasa.gov user YOUR_USERNAME password YOUR_PASSWORD" \
      >> ~/.netrc

chmod 0600 ~/.netrc
touch ~/.urs_cookies
wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies                \
     --auth-no-challenge=on --keep-session-cookies --content-disposition        \
     -i  $URL -P $folder



#*******************************************************************************
#Download HydroSHEDS files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://earlywarning.usgs.gov/hydrodata/sa_shapefiles_zip"
folder="../input/hydroSHEDS/"
list="                                                                         \
      as_riv_15s.zip                                                           \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
if [ "$dwnl" == "hydrosheds" ] || [ "$dwnl" == "" ]; then
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done
fi


##*******************************************************************************
##Download RRR input files
##*******************************************************************************
#
##-------------------------------------------------------------------------------
##Download parameters
##-------------------------------------------------------------------------------
#URL="http://rapid-hub.org/data/CI/HSmsp_WRR"
#folder="../input/HSmsp_WRR"
#list="                                                                         \
#      riv_HSmsp.zip                                                            \
#     "
#
##-------------------------------------------------------------------------------
##Download process
##-------------------------------------------------------------------------------
#if [ "$dwnl" == "rrr" ] || [ "$dwnl" == "" ]; then
#mkdir -p $folder
#for file in $list
#do
#     wget -nv -nc $URL/$file -P $folder
#     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
#done
#fi
#
#
##*******************************************************************************
##Download RRR output files
##*******************************************************************************
#
##-------------------------------------------------------------------------------
##Download parameters
##-------------------------------------------------------------------------------
#URL="http://rapid-hub.org/data/CI/HSmsp_WRR"
#folder="../output/HSmsp_WRR"
#list="                                                                         \
#      coords_HSmsp.csv                                                         \
#      k_HSmsp_pa_phi1_2008_0.csv                                               \
#      k_HSmsp_pa_phi1_2008_1.csv                                               \
#      kfac_HSmsp_1km_hour.csv                                                  \
#      rapid_catchment_na_riv_15s.csv                                           \
#      rapid_connect_HSmsp.csv                                                  \
#      riv_bas_id_HSmsp_topo.csv                                                \
#      sort_HSmsp_topo.csv                                                      \
#      xfac_HSmsp_0.1.csv                                                       \
#      x_HSmsp_pa_phi1_2008_0.csv                                               \
#      x_HSmsp_pa_phi1_2008_1.csv                                               \
#     "
#
##-------------------------------------------------------------------------------
##Download process
##-------------------------------------------------------------------------------
#if [ "$dwnl" == "rrr" ] || [ "$dwnl" == "nldas" ] ||                           \
#   [ "$dwnl" == "hydrosheds" ] || [ "$dwnl" == "" ]; then
#mkdir -p $folder
#for file in $list
#do
#     wget -nv -nc $URL/$file -P $folder
#     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
#done
#fi
#
#
##*******************************************************************************
##Convert legacy files
##*******************************************************************************
#if [ "$dwnl" == "hydrosheds" ] || [ "$dwnl" == "" ]; then
#unzip -nq ../input/HSmsp_WRR/na_riv_15s.zip -d ../input/HSmsp_WRR/
#if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
#fi
#
#if [ "$dwnl" == "rrr" ] || [ "$dwnl" == "" ]; then
#unzip -nq ../input/HSmsp_WRR/riv_HSmsp.zip -d ../input/HSmsp_WRR/
#if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
#fi


#*******************************************************************************
#Done
#*******************************************************************************
