#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Emery_etal_201x_CCC.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#Emery, Charlotte M., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
#The files used are available from:
#Emery, Charlotte M., et al. (201x)
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
#Cedric H. David, 2016-2018


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
#River network details
#*******************************************************************************

#-------------------------------------------------------------------------------
#Connectivity, base parameters, coordinates, sort
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating all domain files"
../src/rrr_riv_tot_gen_all_nhdplus.py                                          \
     ../input/San_Guad_CCC/NHDFlowline_San_Guad.dbf                            \
     ../input/San_Guad_CCC/NHDFlowlineVAA_Reg12.dbf                            \
     4                                                                         \
     ../output/San_Guad_CCC/rapid_connect_San_Guad_tst.csv                     \
     ../output/San_Guad_CCC/kfac_San_Guad_1km_hour_tst.csv                     \
     ../output/San_Guad_CCC/xfac_San_Guad_0.1_tst.csv                          \
     ../output/San_Guad_CCC/sort_San_Guad_hydroseq_tst.csv                     \
     ../output/San_Guad_CCC/coords_San_Guad_tst.csv                            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/rapid_connect_San_Guad.csv                         \
     ../output/San_Guad_CCC/rapid_connect_San_Guad_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/kfac_San_Guad_1km_hour.csv                         \
     ../output/San_Guad_CCC/kfac_San_Guad_1km_hour_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/xfac_San_Guad_0.1.csv                              \
     ../output/San_Guad_CCC/xfac_San_Guad_0.1_tst.csv                          \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/sort_San_Guad_hydroseq.csv                         \
     ../output/San_Guad_CCC/sort_San_Guad_hydroseq_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/coords_San_Guad.csv                                \
     ../output/San_Guad_CCC/coords_San_Guad_tst.csv                            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters ag
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_pa_guess files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_CCC/kfac_San_Guad_1km_hour.csv                         \
     ../output/San_Guad_CCC/xfac_San_Guad_0.1.csv                              \
     0.35                                                                      \
     3.00                                                                      \
     ../output/San_Guad_CCC/k_San_Guad_pa_guess_tst.csv                        \
     ../output/San_Guad_CCC/x_San_Guad_pa_guess_tst.csv                        \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_pa_guess files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/k_San_Guad_pa_guess.csv                            \
     ../output/San_Guad_CCC/k_San_Guad_pa_guess_tst.csv                        \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_pa_guess files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/x_San_Guad_pa_guess.csv                            \
     ../output/San_Guad_CCC/x_San_Guad_pa_guess_tst.csv                        \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sorted subset
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sorted basin file"
../src/rrr_riv_bas_gen_one_nhdplus.py                                          \
     ../input/San_Guad_CCC/NHDFlowline_San_Guad.dbf                            \
     ../output/San_Guad_CCC/rapid_connect_San_Guad.csv                         \
     ../output/San_Guad_CCC/sort_San_Guad_hydroseq.csv                         \
     ../output/San_Guad_CCC/riv_bas_id_San_Guad_hydroseq_tst.csv               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/riv_bas_id_San_Guad_hydroseq.csv                   \
     ../output/San_Guad_CCC/riv_bas_id_San_Guad_hydroseq_tst.csv               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Gathering observations
#*******************************************************************************
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Gathering observations"
../src/rrr_obs_tot_nwisdv.py                                                   \
     ../input/San_Guad_CCC/StreamGageEvent_San_Guad_comid.shp                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     ../output/San_Guad_CCC/obs_tot_id_San_Guad_2010_2013_full_tst.csv         \
     ../output/San_Guad_CCC/Qobs_San_Guad_2010_2013_full_tst.csv               \
     ../output/San_Guad_CCC/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013_tst.shp \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing gauges"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/obs_tot_id_San_Guad_2010_2013_full.csv             \
     ../output/San_Guad_CCC/obs_tot_id_San_Guad_2010_2013_full_tst.csv         \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing observed flows"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/Qobs_San_Guad_2010_2013_full.csv                   \
     ../output/San_Guad_CCC/Qobs_San_Guad_2010_2013_full_tst.csv               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing shapefile"
./tst_cmp_shp.py                                                               \
     ../output/San_Guad_CCC/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_CCC/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013_tst.shp \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
echo "Success"
echo "********************"
fi


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
     ../output/San_Guad_CCC/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_CCC/obs_tot_id_San_Guad_2010_2013_full.csv             \
     ../output/San_Guad_CCC/Qobs_San_Guad_2010_2013_full.csv                   \
     2010-01-01                                                                \
     1                                                                         \
     USGS                                                                      \
     ../output/San_Guad_CCC/analysis/timeseries_obs_tst.csv                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for observations"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_CCC/analysis/timeseries_obs.csv                        \
     ../output/San_Guad_CCC/analysis/timeseries_obs_tst.csv                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
rm -f ../output/San_Guad_CCC/*_tst.*
rm -f ../output/San_Guad_CCC/analysis/*_tst*.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
