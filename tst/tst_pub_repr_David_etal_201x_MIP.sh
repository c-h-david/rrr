#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_201x_MIP.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#David, Cédric H., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
#The files used are available from:
#David, Cédric H., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
#The following are the possible arguments:
# - No argument: all unit tests are run
# - One unique unit test number: this test is run
# - Two unit test numbers: all tests between those (included) are run
#The script returns the following exit codes
# - 0  if all experiments are successful 
# - 22 if some arguments are faulty 
# - 33 if a search failed 
# - 99 if a comparison failed 
#Author:
#Cedric H. David, 2016-2017


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#N/A


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: http://dx.doi.org/xx.xxxx/xxxxxx"
echo "********************"


#*******************************************************************************
#Select which unit tests to perform based on inputs to this shell script
#*******************************************************************************
if [ "$#" = "0" ]; then
     fst=1
     lst=99
     echo "Performing all unit tests: 1-99"
     echo "********************"
fi 
#Perform all unit tests if no options are given 

if [ "$#" = "1" ]; then
     fst=$1
     lst=$1
     echo "Performing one unit test: $1"
     echo "********************"
fi 
#Perform one single unit test if one option is given 

if [ "$#" = "2" ]; then
     fst=$1
     lst=$2
     echo "Performing unit tests: $1-$2"
     echo "********************"
fi 
#Perform all unit tests between first and second option given (both included) 

if [ "$#" -gt "2" ]; then
     echo "A maximum of two options can be used" 1>&2
     exit 22
fi 
#Exit if more than two options are given 


#*******************************************************************************
#Initialize count for unit tests
#*******************************************************************************
unt=0


#*******************************************************************************
#Timeseries, hydrographs and statistics
#*******************************************************************************

#-------------------------------------------------------------------------------
#Timeseries for observations
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for observations"
../src/rrr_anl_hyd_obs.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/Qobs_HSmsp_2000_2009.csv                                 \
     2000-01-01                                                                \
     1                                                                         \
     USGS                                                                      \
     ../output/RivMIP/analysis/timeseries_USGS_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for observations"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_USGS_tst.csv                         \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for RAPID
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for RAPID"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/Qout_HSmsp_2000_2009_VIC_NASA_sgl_pa_phi1_2008_1_n1_preonly_ilu.nc \
     RAPID                                                                     \
     8                                                                         \
     ../output/RivMIP/analysis/timeseries_RAPID_201411xx_pa_phi1_2008_1_tst.csv \
     '2000-01-01T00:00:00'                                                     \
     10800                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for RAPID"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/timeseries_RAPID_201411xx_pa_phi1_2008_1.csv    \
     ../output/RivMIP/analysis/timeseries_RAPID_201411xx_pa_phi1_2008_1_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for CaMa-Flood 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for CaMa-Flood 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_CaMa-Flood_20170116.csv              \
     ../output/RivMIP/analysis/stats_10yrs_CaMa-Flood_20170116_tst.csv         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for CaMa-Flood 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_CaMa-Flood_20170116.csv             \
     ../output/RivMIP/analysis/stats_10yrs_CaMa-Flood_20170116_tst.csv         \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for CTRIP 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for CTRIP 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_CTRIP_20171006_vitVAR_groundwDEF_floodT.csv \
     ../output/RivMIP/analysis/stats_10yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT_tst.csv \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for CTRIP 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT.csv \
     ../output/RivMIP/analysis/stats_10yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for HRR 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for HRR 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_HRR_20170212.csv                     \
     ../output/RivMIP/analysis/stats_10yrs_HRR_20170212_tst.csv                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for HRR 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_HRR_20170212.csv                    \
     ../output/RivMIP/analysis/stats_10yrs_HRR_20170212_tst.csv                \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for LISFLOOD 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for LISFLOOD 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_LISFLOOD_20170607.csv                \
     ../output/RivMIP/analysis/stats_10yrs_LISFLOOD_20170607_tst.csv           \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for LISFLOOD 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_LISFLOOD_20170607.csv               \
     ../output/RivMIP/analysis/stats_10yrs_LISFLOOD_20170607_tst.csv           \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for MGB 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for MGB 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_MGB_20170202_HD_H95_W_CS_10_CB_10.csv \
     ../output/RivMIP/analysis/stats_10yrs_MGB_20170202_HD_H95_W_CS_10_CB_10_tst.csv \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for MGB 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_MGB_20170202_HD_H95_W_CS_10_CB_10.csv \
     ../output/RivMIP/analysis/stats_10yrs_MGB_20170202_HD_H95_W_CS_10_CB_10_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for RAPID 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for RAPID 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_RAPID_201411xx_pa_phi1_2008_1.csv    \
     ../output/RivMIP/analysis/stats_10yrs_RAPID_201411xx_pa_phi1_2008_1_tst.csv \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for RAPID 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_RAPID_201411xx_pa_phi1_2008_1.csv   \
     ../output/RivMIP/analysis/stats_10yrs_RAPID_201411xx_pa_phi1_2008_1_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for RVIC 10 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for RVIC 10 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_RVIC_20170609.csv                    \
     ../output/RivMIP/analysis/stats_10yrs_RVIC_20170609_tst.csv               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for RVIC 10 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_10yrs_RVIC_20170609.csv                   \
     ../output/RivMIP/analysis/stats_10yrs_RVIC_20170609_tst.csv               \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for CaMa-Flood 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for CaMa-Flood 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_CaMa-Flood_20170116.csv              \
     ../output/RivMIP/analysis/stats_02yrs_CaMa-Flood_20170116_tst.csv         \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for CaMa-Flood 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_CaMa-Flood_20170116.csv             \
     ../output/RivMIP/analysis/stats_02yrs_CaMa-Flood_20170116_tst.csv         \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for CTRIP 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for CTRIP 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_CTRIP_20171006_vitVAR_groundwDEF_floodT.csv \
     ../output/RivMIP/analysis/stats_02yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT_tst.csv \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for CTRIP 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT.csv \
     ../output/RivMIP/analysis/stats_02yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for HRR 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for HRR 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_HRR_20170212.csv                     \
     ../output/RivMIP/analysis/stats_02yrs_HRR_20170212_tst.csv                \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for HRR 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_HRR_20170212.csv                    \
     ../output/RivMIP/analysis/stats_02yrs_HRR_20170212_tst.csv                \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for LISFLOOD 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for LISFLOOD 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_LISFLOOD_20170607.csv                \
     ../output/RivMIP/analysis/stats_02yrs_LISFLOOD_20170607_tst.csv           \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for LISFLOOD 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_LISFLOOD_20170607.csv               \
     ../output/RivMIP/analysis/stats_02yrs_LISFLOOD_20170607_tst.csv           \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for MGB 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for MGB 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_MGB_20170202_HD_H95_W_CS_10_CB_10.csv \
     ../output/RivMIP/analysis/stats_02yrs_MGB_20170202_HD_H95_W_CS_10_CB_10_tst.csv \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for MGB 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_MGB_20170202_HD_H95_W_CS_10_CB_10.csv \
     ../output/RivMIP/analysis/stats_02yrs_MGB_20170202_HD_H95_W_CS_10_CB_10_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for RAPID 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for RAPID 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_RAPID_201411xx_pa_phi1_2008_1.csv    \
     ../output/RivMIP/analysis/stats_02yrs_RAPID_201411xx_pa_phi1_2008_1_tst.csv \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for RAPID 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_RAPID_201411xx_pa_phi1_2008_1.csv   \
     ../output/RivMIP/analysis/stats_02yrs_RAPID_201411xx_pa_phi1_2008_1_tst.csv \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for RVIC 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for RVIC 02 years"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_RVIC_20170609.csv                    \
     ../output/RivMIP/analysis/stats_02yrs_RVIC_20170609_tst.csv               \
     2000-01-01                                                                \
     2001-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for RVIC 02 years"
./tst_cmp_csv.py                                                               \
     ../output/RivMIP/analysis/stats_02yrs_RVIC_20170609.csv                   \
     ../output/RivMIP/analysis/stats_02yrs_RVIC_20170609_tst.csv               \
     1e-5                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for CaMa-Flood 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for CaMa-Flood 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_CaMa-Flood_20170116.csv              \
     ../output/RivMIP/analysis/stats_02yrs_CaMa-Flood_20170116.csv             \
     ../output/RivMIP/analysis/hydrographs_CaMa-Flood_20170116/                \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for CTRIP 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for CTRIP 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_CTRIP_20171006_vitVAR_groundwDEF_floodT.csv \
     ../output/RivMIP/analysis/stats_02yrs_CTRIP_20171006_vitVAR_groundwDEF_floodT.csv \
     ../output/RivMIP/analysis/hydrographs_CTRIP_20171006_vitVAR_groundwDEF_floodT/ \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for HRR 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for HRR 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_HRR_20170212.csv                     \
     ../output/RivMIP/analysis/stats_02yrs_HRR_20170212.csv                    \
     ../output/RivMIP/analysis/hydrographs_HRR_20170212/                       \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for LISFLOOD 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for LISFLOOD 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_LISFLOOD_20170607.csv                \
     ../output/RivMIP/analysis/stats_02yrs_LISFLOOD_20170607.csv               \
     ../output/RivMIP/analysis/hydrographs_LISFLOOD_201706078/                 \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for MGB 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for MGB 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_MGB_20170202_HD_H95_W_CS_10_CB_10.csv \
     ../output/RivMIP/analysis/stats_02yrs_MGB_20170202_HD_H95_W_CS_10_CB_10.csv \
     ../output/RivMIP/analysis/hydrographs_MGB_20170202_HD_H95_W_CS_10_CB_10/  \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for RAPID 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for RAPID 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_RAPID_201411xx_pa_phi1_2008_1.csv    \
     ../output/RivMIP/analysis/stats_02yrs_RAPID_201411xx_pa_phi1_2008_1.csv   \
     ../output/RivMIP/analysis/hydrographs_RAPID_201411xx_pa_phi1_2008_1/      \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for RVIC 02 years
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for RVIC 02 years"
../src/./rrr_anl_hyd_plt.py                                                    \
     ../output/RivMIP/obs_HSmsp_Merge_Spatial_Join_Sort.shp                    \
     ../output/RivMIP/analysis/timeseries_USGS.csv                             \
     ../output/RivMIP/analysis/timeseries_RVIC_20170609.csv                    \
     ../output/RivMIP/analysis/stats_02yrs_RVIC_20170609.csv                   \
     ../output/RivMIP/analysis/hydrographs_RVIC_20170609/                      \
     2000-01-01                                                                \
     2001-12-31                                                                \
     30000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
rm -f ../output/RivMIP/analysis/*_tst.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
