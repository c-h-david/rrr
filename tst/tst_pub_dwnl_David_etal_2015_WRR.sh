#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_David_etal_2015_WRR.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#David, Cédric H., James S. Famiglietti, Zong-Liang Yang, and Victor Eijkhout 
#(2015), Enhanced fixed-size parallel speedup with the Muskingum method using a 
#trans-boundary approach and a large sub-basins approximation, Water Resources 
#Research, 51(9), 1-25, 
#DOI: 10.1002/2014WR016650.
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
#David, Cédric H., James S. Famiglietti, Zong-Liang Yang, and Victor Eijkhout 
#(2015),
#xxx
#DOI: xx.xxxx/xxxxxx
#and from:
#Xia, Youlong, Kenneth Mitchell, Michael Ek, Justin Sheffield, Brian Cosgrove,
#Eric Wood, Lifeng Luo, Charles Alonge, Helin Wei, Jesse Meng, Ben Livneh, 
#Dennis Lettenmaier, Victor Koren, Qingyun Duan, Kingtse Mo, Yun Fan, and David 
#Mocko (2012), Continental-scale water and energy flux analysis and validation 
#for the North American Land Data Assimilation System project phase 2 (NLDAS-2).
#ftp://hydro1.sci.gsfc.nasa.gov/data/s4pa/NLDAS/
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#Cedric H. David, 2016-2017.


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
echo "                          ftp://hydro1.sci.gsfc.nasa.gov/data/s4pa/NLDAS/"
echo "which correspond to   :   http://dx.doi.org/10.1002/2014WR016650"
echo "                          http://dx.doi.org/10.1029/2011JD016048"
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
     if [ "$1" == "nldas" ] || [ "$1" == "rrr" ]; then 
          dwnl=$1
     else
          echo "The option $1 does not exist" 1>&2
          exit 22
     fi
fi
#Make sure the command line option given exists


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
      2000                                                                     \
      2001                                                                     \
      2002                                                                     \
      2003                                                                     \
      2004                                                                     \
      2005                                                                     \
      2006                                                                     \
      2007                                                                     \
      2008                                                                     \
      2009                                                                     \
     "
folder="../input/HSmsp_WRR/NLDAS2"

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
if [ "$dwnl" == "nldas" ] || [ "$dwnl" == "" ]; then
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
fi


#*******************************************************************************
#Download RRR input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://rapid-hub.org/data/CI/HSmsp_WRR"
folder="../input/HSmsp_WRR"
list="                                                                         \
      riv_HSmsp.zip                                                            \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
if [ "$dwnl" == "rrr" ] || [ "$dwnl" == "" ]; then
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done
fi


#*******************************************************************************
#Download RRR output files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://rapid-hub.org/data/CI/HSmsp_WRR"
folder="../output/HSmsp_WRR"
list="                                                                         \
      coords_HSmsp.csv                                                         \
      k_HSmsp_pa_phi1_2008_0.csv                                               \
      k_HSmsp_pa_phi1_2008_1.csv                                               \
      kfac_HSmsp_1km_hour.csv                                                  \
      rapid_connect_HSmsp.csv                                                  \
      riv_bas_id_HSmsp_topo.csv                                                \
      sort_HSmsp_topo.csv                                                      \
      xfac_HSmsp_0.1.csv                                                       \
      x_HSmsp_pa_phi1_2008_0.csv                                               \
      x_HSmsp_pa_phi1_2008_1.csv                                               \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
if [ "$dwnl" == "rrr" ] || [ "$dwnl" == "" ]; then
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done
fi


#*******************************************************************************
#Convert legacy files
#*******************************************************************************
if [ "$dwnl" == "rrr" ] || [ "$dwnl" == "" ]; then
unzip -nq ../input/HSmsp_WRR/riv_HSmsp.zip -d ../input/HSmsp_WRR/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
fi


#*******************************************************************************
#Done
#*******************************************************************************
