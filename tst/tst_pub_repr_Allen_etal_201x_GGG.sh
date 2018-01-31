#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Allen_etal_201x_XYZ.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
# 
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
#Authors:
#Allen H. Allen, Cedric H. David, 2016-2018


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#N/A


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: Allen_etal_201x_XYZ.sh"
echo "********************"


##*******************************************************************************
##Select which unit tests to perform based on inputs to this shell script
##*******************************************************************************
#if [ "$#" = "0" ]; then
#     fst=1
#     lst=99
#     echo "Performing all unit tests: 1-99"
#     echo "********************"
#fi 
##Perform all unit tests if no options are given 
#
#if [ "$#" = "1" ]; then
#     fst=$1
#     lst=$1
#     echo "Performing one unit test: $1"
#     echo "********************"
#fi 
##Perform one single unit test if one option is given 
#
#if [ "$#" = "2" ]; then
#     fst=$1
#     lst=$2
#     echo "Performing unit tests: $1-$2"
#     echo "********************"
#fi 
##Perform all unit tests between first and second option given (both included) 
#
#if [ "$#" -gt "2" ]; then
#     echo "A maximum of two options can be used" 1>&2
#     exit 22
#fi 
##Exit if more than two options are given 
#
#
##*******************************************************************************
##Initialize count for unit tests
##*******************************************************************************
#unt=0
#
#
##*******************************************************************************
##River network details
##*******************************************************************************
#
##-------------------------------------------------------------------------------
##Connectivity, base parameters, coordinates, sort
##-------------------------------------------------------------------------------
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/x"
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt

mkdir -p '../output/MIGBM/'

echo "- Creating all domain files"
../src/rrr_riv_tot_gen_all_hydrosheds.py                                       \
     ../input/hydroSHEDS/MIGBM_flowlines.shp                                   \
     4                                                                         \
     esri:102025                                                               \
     ../output/MIGBM/rapid_connect_MIGBM.csv                                   \
     ../output/MIGBM/kfac_MIGBM_1km_hour.csv                                   \
     ../output/MIGBM/xfac_MIGBM_0.1.csv                                        \
     ../output/MIGBM/sort_MIGBM_topo.csv                                       \
     ../output/MIGBM/coords_MIGBM.csv                                          \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

#echo "- Comparing connectivity"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/rapid_connect_HSmsp.csv                               \
#     ../output/HSmsp_WRR/rapid_connect_HSmsp_tst.csv                           \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing kfac"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/kfac_HSmsp_1km_hour.csv                               \
#     ../output/HSmsp_WRR/kfac_HSmsp_1km_hour_tst.csv                           \
#     1e-6                                                                      \
#     1e-1                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing xfac"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/xfac_HSmsp_0.1.csv                                    \
#     ../output/HSmsp_WRR/xfac_HSmsp_0.1_tst.csv                                \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing sorted IDs"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/sort_HSmsp_topo.csv                                   \
#     ../output/HSmsp_WRR/sort_HSmsp_topo_tst.csv                               \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing coordinates"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/coords_HSmsp.csv                                      \
#     ../output/HSmsp_WRR/coords_HSmsp_tst.csv                                  \
#     1e-10                                                                     \
#     1e-8                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
##-------------------------------------------------------------------------------
##Parameters
##-------------------------------------------------------------------------------
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/x"
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_0 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/MIGBM/kfac_MIGBM_1km_hour.csv                                   \
     ../output/MIGBM/xfac_MIGBM_0.1.csv                                        \
     0.2                                                                       \
     3                                                                         \
     ../output/MIGBM/k_MIGBM_scl.csv                                           \
     ../output/MIGBM/x_MIGBM_scl.csv                                           \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing k_0 files"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_0.csv                            \
#     0.296875                                                                  \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_0_tst.csv                        \
#     ../output/HSmsp_WRR/x_HSmsp_pa_phi1_2008_0_tst.csv                        \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing k_0 files"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_0.csv                            \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_0_tst.csv                        \
#     1e-6                                                                      \
#     2e-2                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing x_0 files"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/x_HSmsp_pa_phi1_2008_0.csv                            \
#     ../output/HSmsp_WRR/x_HSmsp_pa_phi1_2008_0_tst.csv                        \
#     1e-6                                                                      \
#     2e-2                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
##-------------------------------------------------------------------------------
##Parameters 1
##-------------------------------------------------------------------------------
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/x"
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt
#
#echo "- Creating p_1 files"
#../src/rrr_riv_tot_scl_prm.py                                                  \
#     ../output/HSmsp_WRR/kfac_HSmsp_1km_hour.csv                               \
#     ../output/HSmsp_WRR/xfac_HSmsp_0.1.csv                                    \
#     0.210876                                                                  \
#     0.341400                                                                  \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_1_tst.csv                        \
#     ../output/HSmsp_WRR/x_HSmsp_pa_phi1_2008_1_tst.csv                        \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing k_1 files"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_1.csv                            \
#     ../output/HSmsp_WRR/k_HSmsp_pa_phi1_2008_1_tst.csv                        \
#     1e-6                                                                      \
#     2e-2                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#echo "- Comparing x_1 files"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/x_HSmsp_pa_phi1_2008_1.csv                            \
#     ../output/HSmsp_WRR/x_HSmsp_pa_phi1_2008_1_tst.csv                        \
#     1e-6                                                                      \
#     2e-2                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
##-------------------------------------------------------------------------------
##Sorted subset
##-------------------------------------------------------------------------------
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/x"
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt

echo "- Creating sorted basin file"
../src/rrr_riv_bas_gen_one_hydrosheds.py                                       \
     ../input/hydroSHEDS/MIGBM_flowlines.shp                                   \
     ../output/MIGBM/rapid_connect_MIGBM.csv                                   \
     ../output/MIGBM/sort_MIGBM_topo.csv                                       \
     ../output/MIGBM/riv_bas_id_MIGBM_topo.csv                                 \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing sorted basin file"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/riv_bas_id_HSmsp_topo.csv                             \
#     ../output/HSmsp_WRR/riv_bas_id_HSmsp_topo_tst.csv                         \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
#
##*******************************************************************************
##Contributing catchment information
##*******************************************************************************
#unt=$((unt+1))
#if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
#echo "Running unit test $unt/x"
#run_file=tmp_run_$unt.txt
#cmp_file=tmp_cmp_$unt.txt

echo "- Creating catchment file"
../src/rrr_cat_tot_gen_one_hydrosheds.py                                       \
     ../input/hydroSHEDS/MIGBM_flowlines.dbf                                   \
     ../output/MIGBM/rapid_catchment.csv                                       \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#echo "- Comparing catchment file"
#./tst_cmp_csv.py                                                               \
#     ../output/HSmsp_WRR/rapid_catchment_na_riv_15s.csv                        \
#     ../output/HSmsp_WRR/rapid_catchment_na_riv_15s_tst.csv                    \
#     1e-5                                                                      \
#     1e-3                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
#
#rm -f $run_file
#rm -f $cmp_file
#echo "Success"
#echo "********************"
#fi
#
