#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Emery_etal_2020_JHM2.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#Emery, Charlotte M., Cedric H. David, Kostas M. Andreadis, Michael J. Turmon,
#John T. Reager, Jonathan M. Hobbs, Ming Pan, James S. Famiglietti,
#R. Edward Beighley, and Matthew Rodell (2020), Underlying Fundamentals of
#Kalman Filtering for River Network Modeling, Journal of Hydrometeorology, 21,
#453-474
#DOI: 10.1175/JHM-D-19-0084.1
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
#Emery, Charlotte M., Cedric H. David, Kostas M. Andreadis, Michael J. Turmon,
#John T. Reager, Jonathan M. Hobbs, Ming Pan, James S. Famiglietti,
#R. Edward Beighley, and Matthew Rodell (2020), RRR/RAPID input and output files
#for "Underlying Fundamentals of Kalman Filtering for River Network Modeling",
#Zenodo.
#DOI: 10.5281/zenodo.3688690
#and from:
#Xia, Youlong, Kenneth Mitchell, Michael Ek, Justin Sheffield, Brian Cosgrove,
#Eric Wood, Lifeng Luo, Charles Alonge, Helin Wei, Jesse Meng, Ben Livneh, 
#Dennis Lettenmaier, Victor Koren, Qingyun Duan, Kingtse Mo, Yun Fan, and David 
#Mocko (2012), Continental-scale water and energy flux analysis and validation 
#for the North American Land Data Assimilation System project phase 2 (NLDAS-2).
#https://urs.earthdata.nasa.gov
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#Cedric H. David, 2016-2022


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
echo "Downloading files from:   https://dx.doi.org/10.5281/zenodo.3688690"
echo "                          https://urs.earthdata.nasa.gov"
echo "which correspond to   :   https://dx.doi.org/10.1175/JHM-D-19-0084.1"
echo "                          https://dx.doi.org/10.1029/2011JD016048"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these four DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download RRR input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/6789028/files"
folder="../input/San_Guad_JHM2"
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
URL="https://zenodo.org/record/6789028/files"
folder="../output/San_Guad_JHM2"
list="                                                                         \
      coords_San_Guad.csv                                                      \
      kfac_San_Guad_1km_hour.csv                                               \
      k_San_Guad_2004_1.csv                                                    \
      m3_riv_San_Guad_20100101_20131231_ENS0125_D_utc.nc                       \
      m3_riv_San_Guad_20100101_20131231_ENS0125_M_utc.nc                       \
      m3_riv_San_Guad_20100101_20131231_ERR0125_D_flw_R286.csv                 \
      m3_riv_San_Guad_20100101_20131231_ERR0125_M_flw_R286.csv                 \
      m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D.nc           \
      m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D_scl.nc       \
      m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_M.nc           \
      m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc.nc                      \
      m3_riv_San_Guad_20100101_20131231_VIC0125_D_utc.nc                       \
      m3_riv_San_Guad_20100101_20131231_VIC0125_M_utc.nc                       \
      NLDAS_ENS0125_D_20100101_20131231_utc_cfc.nc4                            \
      NLDAS_ENS0125_M_20100101_20131231_utc_cfc.nc4                            \
      NLDAS_VIC0125_3H_20100101_20131231_utc_cfc.nc4                           \
      NLDAS_VIC0125_D_20100101_20131231_utc_cfc.nc4                            \
      NLDAS_VIC0125_M_20100101_20131231_utc_cfc.nc4                            \
      obs_tot_id_San_Guad_2010_2013_full.csv                                   \
      obs_use_id_San_Guad_2010_2013_23.csv                                     \
      Qobs_San_Guad_2010_2013_full.csv                                         \
      Qout_San_Guad_exp00_err_D.nc                                             \
      Qout_San_Guad_exp00_err_D_scl.nc                                         \
      Qout_San_Guad_exp00_err_M.nc                                             \
      Qout_San_Guad_exp00.nc                                                   \
      Qout_San_Guad_exp01.nc                                                   \
      Qout_San_Guad_exp02.nc                                                   \
      Qout_San_Guad_exp03.nc                                                   \
      Qout_San_Guad_exp04.nc                                                   \
      Qout_San_Guad_exp05.nc                                                   \
      Qout_San_Guad_exp06.nc                                                   \
      Qout_San_Guad_exp07.nc                                                   \
      Qout_San_Guad_exp08.nc                                                   \
      Qout_San_Guad_exp09.nc                                                   \
      Qout_San_Guad_exp10.nc                                                   \
      Qout_San_Guad_exp11.nc                                                   \
      Qout_San_Guad_exp12.nc                                                   \
      Qout_San_Guad_exp13.nc                                                   \
      Qout_San_Guad_exp14.nc                                                   \
      Qout_San_Guad_exp15.nc                                                   \
      Qout_San_Guad_exp16.nc                                                   \
      Qout_San_Guad_exp17.nc                                                   \
      Qout_San_Guad_exp18.nc                                                   \
      Qout_San_Guad_exp19.nc                                                   \
      Qout_San_Guad_exp20.nc                                                   \
      Qout_San_Guad_exp21.nc                                                   \
      rapid_catchment_Reg12.csv                                                \
      rapid_connect_San_Guad.csv                                               \
      rapid_coupling_San_Guad_NLDAS.csv                                        \
      riv_bas_id_1639225_dwn_25.csv                                            \
      riv_bas_id_1639225_dwn_50.csv                                            \
      riv_bas_id_1639225_ups_25.csv                                            \
      riv_bas_id_1639225_ups_50.csv                                            \
      riv_bas_id_3840125_dwn_25.csv                                            \
      riv_bas_id_3840125_dwn_50.csv                                            \
      riv_bas_id_3840125_ups_25.csv                                            \
      riv_bas_id_3840125_ups_50.csv                                            \
      riv_bas_id_San_Guad_hydroseq.csv                                         \
      sort_San_Guad_hydroseq.csv                                               \
      StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.zip                \
      xfac_San_Guad_0.1.csv                                                    \
      x_San_Guad_2004_1.csv                                                    \
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
URL="https://zenodo.org/record/6789028/files"
folder="../output/San_Guad_JHM2/analysis"
list="                                                                         \
      nash_table_exp00_exp21.csv                                               \
      stats_rap_exp00_BUG_DO_NOT_USE.csv                                       \
      stats_rap_exp00.csv                                                      \
      stats_rap_exp00_err_D.csv                                                \
      stats_rap_exp00_err_D_scl.csv                                            \
      stats_rap_exp00_err_M.csv                                                \
      stats_rap_exp00_monthly_BUG_DO_NOT_USE.csv                               \
      stats_rap_exp00_monthly.csv                                              \
      stats_rap_exp01_BUG_NETCDF4.csv                                          \
      stats_rap_exp01.csv                                                      \
      stats_rap_exp02.csv                                                      \
      stats_rap_exp03.csv                                                      \
      stats_rap_exp04.csv                                                      \
      stats_rap_exp05.csv                                                      \
      stats_rap_exp06.csv                                                      \
      stats_rap_exp07.csv                                                      \
      stats_rap_exp08.csv                                                      \
      stats_rap_exp09.csv                                                      \
      stats_rap_exp10.csv                                                      \
      stats_rap_exp11.csv                                                      \
      stats_rap_exp12.csv                                                      \
      stats_rap_exp13.csv                                                      \
      stats_rap_exp14.csv                                                      \
      stats_rap_exp15.csv                                                      \
      stats_rap_exp16.csv                                                      \
      stats_rap_exp17.csv                                                      \
      stats_rap_exp18.csv                                                      \
      stats_rap_exp19.csv                                                      \
      stats_rap_exp20.csv                                                      \
      stats_rap_exp21.csv                                                      \
      timeseries_obs_BUG_DO_NOT_USE.csv                                        \
      timeseries_obs.csv                                                       \
      timeseries_obs_monthly_BUG_DO_NOT_USE.csv                                \
      timeseries_obs_monthly.csv                                               \
      timeseries_rap_exp00.csv                                                 \
      timeseries_rap_exp00_monthly.csv                                         \
      timeseries_rap_exp01_BUG_NETCDF4.csv                                     \
      timeseries_rap_exp01.csv                                                 \
      timeseries_rap_exp02.csv                                                 \
      timeseries_rap_exp03.csv                                                 \
      timeseries_rap_exp04.csv                                                 \
      timeseries_rap_exp05.csv                                                 \
      timeseries_rap_exp06.csv                                                 \
      timeseries_rap_exp07.csv                                                 \
      timeseries_rap_exp08.csv                                                 \
      timeseries_rap_exp09.csv                                                 \
      timeseries_rap_exp10.csv                                                 \
      timeseries_rap_exp11.csv                                                 \
      timeseries_rap_exp12.csv                                                 \
      timeseries_rap_exp13.csv                                                 \
      timeseries_rap_exp14.csv                                                 \
      timeseries_rap_exp15.csv                                                 \
      timeseries_rap_exp16.csv                                                 \
      timeseries_rap_exp17.csv                                                 \
      timeseries_rap_exp18_BUG_NETCDF4.csv                                     \
      timeseries_rap_exp18.csv                                                 \
      timeseries_rap_exp19.csv                                                 \
      timeseries_rap_exp20.csv                                                 \
      timeseries_rap_exp21.csv                                                 \
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
unzip -nq ../input/San_Guad_JHM2/catchment_Reg12.zip -d ../input/San_Guad_JHM2/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

unzip -nq ../input/San_Guad_JHM2/NHDFlowline_San_Guad.zip -d ../input/San_Guad_JHM2/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

unzip -nq ../input/San_Guad_JHM2/StreamGageEvent_San_Guad_comid.zip -d ../input/San_Guad_JHM2/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi

unzip -nq ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.zip -d ../output/San_Guad_JHM2/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi


#*******************************************************************************
#Done
#*******************************************************************************
