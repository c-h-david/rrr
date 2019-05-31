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
      PlusFlow_WSWM.zip                                                        \
      PlusFlowlineVAA_WSWM_Sort_fixed_Node_50233399.zip                        \
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
#Download RRR output files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/2665084/files"
folder="../output/WSWM_GRL"
list="                                                                         \
      coords_WSWM.csv                                                          \
      GageLoc_WSWM_with_dir_1997_1998_full_plot.zip                            \
      GageLoc_WSWM_with_dir_1997_1998_full.zip                                 \
      k_WSWM_pag.csv                                                           \
      kfac_WSWM_1km_hour.csv                                                   \
      m3_riv_WSWM_19970101_19981231_ENS0125_M_utc.nc4                          \
      m3_riv_WSWM_19970101_19981231_ERR0125_M_vol_R50.zip                      \
      m3_riv_WSWM_19970101_19981231_MOS0125_M_utc.nc4                          \
      m3_riv_WSWM_19970101_19981231_NOAH0125_M_utc.nc4                         \
      m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst_err.nc4                     \
      m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst.nc4                         \
      m3_riv_WSWM_19970101_19981231_VIC0125_M_utc.nc4                          \
      NLDAS_MOS0125_M_19970101_19981231_utc_cfc.nc4                            \
      NLDAS_NOAH0125_M_19970101_19981231_utc_cfc.nc4                           \
      NLDAS_VIC0125_3H_19970101_19981231_cst_cfc.nc4                           \
      NLDAS_VIC0125_3H_19970101_19981231_utc_cfc.nc4                           \
      NLDAS_VIC0125_M_19970101_19981231_utc_cfc.nc4                            \
      obs_tot_id_WSWM_1997_1998_full.csv                                       \
      Qobs_WSWM_1997_1998_full.csv                                             \
      Qout_WSWM_729days_pag_dtR900s_n1_preonly_init_err.nc                     \
      rapid_catchment_WSWM_arc.csv                                             \
      rapid_connect_WSWM.csv                                                   \
      rapid_coupling_WSWM_NLDAS2.csv                                           \
      riv_bas_id_WSWM_hydroseq.csv                                             \
      sort_WSWM_hydroseq.csv                                                   \
      x_WSWM_pag.csv                                                           \
      xfac_WSWM_0.1.csv                                                        \
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
#Download RRR analysis files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/2665084/files"
folder="../output/WSWM_GRL/analysis"
list="                                                                         \
      stats_rap_pag_init_monthly_err_all_reaches.csv                           \
      stats_rap_pag_init_monthly_err.csv                                       \
      stats_rap_pag_init_monthly.csv                                           \
      stats_rap_pag_init.csv                                                   \
      timeseries_obs_monthly.csv                                               \
      timeseries_obs.csv                                                       \
      timeseries_rap_pag_init_monthly.csv                                      \
      timeseries_rap_pag_init.csv                                              \
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
