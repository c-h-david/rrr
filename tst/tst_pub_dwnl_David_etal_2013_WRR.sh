#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_David_etal_2013_WRR.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#David, Cédric H., Zong-Liang Yang and James S. Famiglietti (2013), 
#Quantification of the upstream-to-downstream influence in the Muskingum method, 
#and implications for speedup in parallel computations of river flow, Water 
#Resources Research, 49(5), 1-18, 
#DOI: 10.1002/wrcr.20250.
#This script also downloads a subset of the files from:
#Xia, Youlong, Kenneth Mitchell, Michael Ek, Justin Sheffield, Brian Cosgrove,
#Eric Wood, Lifeng Luo, Charles Alonge, Helin Wei, Jesse Meng, Ben Livneh, 
#Dennis Lettenmaier, Victor Koren, Qingyun Duan, Kingtse Mo, Yun Fan, and David 
#Mocko (2012), Continental-scale water and energy flux analysis and validation 
#for the North American Land Data Assimilation System project phase 2 (NLDAS-2):
#1. Intercomparison and application of model products,  Journal of Geophysical 
#Research, 117, D03109
#DOI: 10.1029/2011JD016048
#The files used are available from:
#David, Cédric H., Zong-Liang Yang and James S. Famiglietti (2013), 
#xxx
#DOI: xx.xxxx/xxxxxx
#and from:
#Xia, Youlong, Kenneth Mitchell, Michael Ek, Justin Sheffield, Brian Cosgrove,
#Eric Wood, Lifeng Luo, Charles Alonge, Helin Wei, Jesse Meng, Ben Livneh, 
#Dennis Lettenmaier, Victor Koren, Qingyun Duan, Kingtse Mo, Yun Fan, and David 
#Mocko (2012), Continental-scale water and energy flux analysis and validation 
#for the North American Land Data Assimilation System project phase 2 (NLDAS-2).
#ftp://ldas3.ncep.noaa.gov/nldas2/retrospective/
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#Cedric H. David, 2016-2020.


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#wget -nv -nc          --> Non-verbose (silent), No-clobber (don't overwrite) 
#tar --strip-components--> Remove leading directory components on extraction
#tar -C                --> Specify where to extract 


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Downloading files from:   http://dx.doi.org/xx.xxxx/xxxxxx"
echo "                          ftp://ldas3.ncep.noaa.gov/nldas2/retrospective/"
echo "which correspond to   :   http://dx.doi.org/10.1002/wrcr.20250"
echo "                          http://dx.doi.org/10.1029/2011JD016048"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these four DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download NLDAS2 files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="ftp://ldas3.ncep.noaa.gov/nldas2/retrospective/"
model="                                                                        \
       vic4.0.5                                                                \
      "
year="                                                                         \
      2004                                                                     \
     "
folder="../input/Reg07_WRR/NLDAS2"

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
for model in $model
do
for year in $year
do
     file=$model.$year.tar.gz
     wget -nv -nc $URL/$model/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
     if [ ! -d "$folder/$model/$year" ]; then
          mkdir -p $folder/$model
          tar -xzf $folder/$file --strip-components=3 -C $folder/$model
          if [ $? -gt 0 ] ; then echo "Problem extracting $file" >&2 ; exit 22 ; fi
     fi
done
done


#*******************************************************************************
#Convert legacy files
#*******************************************************************************
#N/A


#*******************************************************************************
#Done
#*******************************************************************************
