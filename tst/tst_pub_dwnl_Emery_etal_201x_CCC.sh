#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Emery_etal_201x_CCC.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#Emery, Charlotte M., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
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
#Emery, Charlotte M., et al. (201x)
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
#Cedric H. David, 2016-2018.


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
echo "which correspond to   :   http://dx.doi.org/xx.xxxx/xxxxxx"
echo "                          http://dx.doi.org/10.1029/2011JD016048"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these four DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download NLDAS2 hourly files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
fld="../input/NLDAS"
exp="NLDAS"
frq="H"
mod="                                                                          \
     VIC                                                                       \
    "
str=(                                                                          \
    "2010-01-01T00:00:00"                                                      \
    "2010-01-02T00:00:00"                                                      \
    )
end=(                                                                          \
    "2010-01-01T23:59:59"                                                      \
    "2010-01-02T23:59:59"                                                      \
    )

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $fld
ndl=${#str[@]}
#ndl is the number of download intervals

for mod in $mod
do
for (( idl=0; idl<${ndl}; idl++ ));
do
     echo "Downloading NLDAS2 hourly data for $mod, from" ${str[$idl]} "to"    \
           ${end[$idl]}
     ../src/rrr_lsm_tot_ldas.py $exp $mod $frq ${str[$idl]} ${end[$idl]} $fld > tmp_dwl
     if [ $? -gt 0 ] ; then echo "Problem downloading" && cat tmp_dwl >&2 ; exit 44 ; fi
     rm tmp_dwl
done
done


#*******************************************************************************
#Download NLDAS2 monthly files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
fld="../input/NLDAS"
exp="NLDAS"
frq="M"
mod="                                                                          \
     MOS                                                                       \
     NOAH                                                                      \
     VIC                                                                       \
    "
str=(                                                                          \
    "2010-01-01T00:00:00"                                                      \
    "2011-01-01T00:00:00"                                                      \
    "2012-01-01T00:00:00"                                                      \
    "2013-01-01T00:00:00"                                                      \
    )
end=(                                                                          \
    "2010-12-31T23:59:59"                                                      \
    "2011-12-31T23:59:59"                                                      \
    "2012-12-31T23:59:59"                                                      \
    "2013-12-31T23:59:59"                                                      \
    )

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $fld
ndl=${#str[@]}
#ndl is the number of download intervals

for mod in $mod
do
for (( idl=0; idl<${ndl}; idl++ ));
do
     echo "Downloading NLDAS2 monthly data for $mod, from" ${str[$idl]} "to"   \
           ${end[$idl]}
     ../src/rrr_lsm_tot_ldas.py $exp $mod $frq ${str[$idl]} ${end[$idl]} $fld > tmp_dwl
     if [ $? -gt 0 ] ; then echo "Problem downloading" && cat tmp_dwl >&2 ; exit 44 ; fi
     rm tmp_dwl
done
done


#*******************************************************************************
#Download RRR input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://rapid-hub.org/data/CI/San_Guad_CCC"
folder="../input/San_Guad_CCC"
list="                                                                         \
      catchment_Reg12.zip                                                      \
      NHDFlowline_San_Guad.zip                                                 \
      NHDFlowlineVAA_Reg12.dbf                                                 \
      StreamGageEvent_San_Guad_comid.zip                                       \
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
#Download RRR pre-processing files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://rapid-hub.org/data/CI/San_Guad_CCC"
folder="../output/San_Guad_CCC"
list="                                                                         \
      coords_San_Guad.csv                                                      \
      k_San_Guad_pa_guess.csv                                                  \
      kfac_San_Guad_1km_hour.csv                                               \
      m3_riv_San_Guad_20100101_20131231_ENS0125_M_utc.nc4                      \
      m3_riv_San_Guad_20100101_20131231_MOS0125_M_utc.nc4                      \
      m3_riv_San_Guad_20100101_20131231_NOAH0125_M_utc.nc4                     \
      m3_riv_San_Guad_20100101_20131231_VIC0125_M_utc.nc4                      \
      m3_riv_San_Guad_20100101_20131231_bvc_300.csv                            \
      m3_riv_San_Guad_20100101_20131231_VIC0125_cst.nc                         \
      obs_tot_id_San_Guad_2010_2013_full.csv                                   \
      Qobs_San_Guad_2010_2013_full.csv                                         \
      rapid_catchment_Reg12.csv                                                \
      rapid_connect_San_Guad.csv                                               \
      rapid_coupling_San_Guad_NLDAS.csv                                        \
      riv_bas_id_San_Guad_hydroseq.csv                                         \
      sort_San_Guad_hydroseq.csv                                               \
      StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.zip                \
      x_San_Guad_pa_guess.csv                                                  \
      xfac_San_Guad_0.1.csv                                                    \
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
URL="http://rapid-hub.org/data/CI/San_Guad_CCC"
folder="../output/San_Guad_CCC/analysis"
list="                                                                         \
      timeseries_obs.csv                                                       \
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
unzip -nq ../input/San_Guad_CCC/catchment_Reg12.zip -d ../input/San_Guad_CCC/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

unzip -nq ../input/San_Guad_CCC/NHDFlowline_San_Guad.zip -d ../input/San_Guad_CCC/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

unzip -nq ../input/San_Guad_CCC/StreamGageEvent_San_Guad_comid.zip -d ../input/San_Guad_CCC/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

unzip -nq ../output/San_Guad_CCC/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.zip -d ../output/San_Guad_CCC/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi


#*******************************************************************************
#Done
#*******************************************************************************
