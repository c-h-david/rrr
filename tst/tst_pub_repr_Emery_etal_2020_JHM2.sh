#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Emery_etal_2020_JHM2.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#Emery, Charlotte M., Cedric H. David, Kostas M. Andreadis, Michael J. Turmon,
#John T. Reager, Jonathan M. Hobbs, Ming Pan, James S. Famiglietti,
#R. Edward Beighley, and Matthew Rodell (2020), Underlying Fundamentals of
#Kalman Filtering for River Network Modeling,
#DOI: 10.1175/JHM-D-19-0084.1
#The files used are available from:
#Emery, Charlotte M., Cedric H. David, Kostas M. Andreadis, Michael J. Turmon,
#John T. Reager, Jonathan M. Hobbs, Ming Pan, James S. Famiglietti,
#R. Edward Beighley, and Matthew Rodell (2020), RRR/RAPID input and output files
#for "Underlying Fundamentals of Kalman Filtering for River Network Modeling",
#Zenodo.
#DOI: xx.xxxx/xxxxxxxxxxxx
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
#Cedric H. David, 2016-2020


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#N/A


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: http://dx.doi.org/10.1175/JHM-D-19-0084.1"
echo "********************"


#*******************************************************************************
#Select which unit tests to perform based on inputs to this shell script
#*******************************************************************************
if [ "$#" = "0" ]; then
     fst=1
     lst=99
     echo "Performing all unit tests: $1-$2"
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
     ../input/San_Guad_JHM2/NHDFlowline_San_Guad.dbf                           \
     ../input/San_Guad_JHM2/NHDFlowlineVAA_Reg12.dbf                           \
     4                                                                         \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad_tst.csv                    \
     ../output/San_Guad_JHM2/kfac_San_Guad_1km_hour_tst.csv                    \
     ../output/San_Guad_JHM2/xfac_San_Guad_0.1_tst.csv                         \
     ../output/San_Guad_JHM2/sort_San_Guad_hydroseq_tst.csv                    \
     ../output/San_Guad_JHM2/coords_San_Guad_tst.csv                           \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad_tst.csv                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/kfac_San_Guad_1km_hour.csv                        \
     ../output/San_Guad_JHM2/kfac_San_Guad_1km_hour_tst.csv                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/xfac_San_Guad_0.1.csv                             \
     ../output/San_Guad_JHM2/xfac_San_Guad_0.1_tst.csv                         \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/sort_San_Guad_hydroseq.csv                        \
     ../output/San_Guad_JHM2/sort_San_Guad_hydroseq_tst.csv                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/coords_San_Guad.csv                               \
     ../output/San_Guad_JHM2/coords_San_Guad_tst.csv                           \
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

echo "- Creating p_2004_1 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_JHM2/kfac_San_Guad_1km_hour.csv                        \
     ../output/San_Guad_JHM2/xfac_San_Guad_0.1.csv                             \
     0.131042                                                                  \
     2.58128                                                                   \
     ../output/San_Guad_JHM2/k_San_Guad_2004_1_tst.csv                         \
     ../output/San_Guad_JHM2/x_San_Guad_2004_1_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_2004_1 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/k_San_Guad_2004_1.csv                             \
     ../output/San_Guad_JHM2/k_San_Guad_2004_1_tst.csv                         \
     1e-6                                                                      \
     1e-3                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_2004_1 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/x_San_Guad_2004_1.csv                             \
     ../output/San_Guad_JHM2/x_San_Guad_2004_1_tst.csv                         \
     1e-6                                                                      \
     1e-3                                                                      \
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
     ../input/San_Guad_JHM2/NHDFlowline_San_Guad.dbf                           \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/sort_San_Guad_hydroseq.csv                        \
     ../output/San_Guad_JHM2/riv_bas_id_San_Guad_hydroseq_tst.csv              \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/riv_bas_id_San_Guad_hydroseq.csv                  \
     ../output/San_Guad_JHM2/riv_bas_id_San_Guad_hydroseq_tst.csv              \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Contributing catchment information
#*******************************************************************************
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating catchment file"
../src/rrr_cat_tot_gen_one_nhdplus.py                                          \
     ../input/San_Guad_JHM2/catchment_Reg12.dbf                                \
     ../output/San_Guad_JHM2/rapid_catchment_Reg12_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/rapid_catchment_Reg12.csv                         \
     ../output/San_Guad_JHM2/rapid_catchment_Reg12_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Coupling
#*******************************************************************************

#-------------------------------------------------------------------------------
#Create coupling file - Monthly - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coupling file - Monthly - VIC"
../src/rrr_cpl_riv_lsm_lnk.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/rapid_catchment_Reg12.csv                         \
     ../output/San_Guad_JHM2/NLDAS_VIC0125_M_20100101_20131231_utc_cfc.nc4     \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file - Monthly - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file - Monthly - VIC"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/coords_San_Guad.csv                               \
     ../output/San_Guad_JHM2/NLDAS_VIC0125_M_20100101_20131231_utc_cfc.nc4     \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_M_utc_tst.nc4 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_M_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_M_utc_tst.nc4 \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file - Monthly - ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file - Monthly - ENS"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/coords_San_Guad.csv                               \
     ../output/San_Guad_JHM2/NLDAS_ENS0125_M_20100101_20131231_utc_cfc.nc4     \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_M_utc_tst.nc4 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_M_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_M_utc_tst.nc4 \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create coupling file - Daily - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coupling file - Daily - VIC"
../src/rrr_cpl_riv_lsm_lnk.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/rapid_catchment_Reg12.csv                         \
     ../output/San_Guad_JHM2/NLDAS_VIC0125_D_20100101_20131231_utc_cfc.nc4     \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file - Daily - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file - Daily - VIC"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/coords_San_Guad.csv                               \
     ../output/San_Guad_JHM2/NLDAS_VIC0125_D_20100101_20131231_utc_cfc.nc4     \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_D_utc_tst.nc4 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_D_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_D_utc_tst.nc4 \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file - Daily - ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file - Daily - ENS"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/coords_San_Guad.csv                               \
     ../output/San_Guad_JHM2/NLDAS_ENS0125_D_20100101_20131231_utc_cfc.nc4     \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_D_utc_tst.nc4 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_D_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_D_utc_tst.nc4 \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create coupling file - 3-hourly - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coupling file - 3-hourly - VIC"
../src/rrr_cpl_riv_lsm_lnk.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/rapid_catchment_Reg12.csv                         \
     ../output/San_Guad_JHM2/NLDAS_VIC0125_3H_20100101_20131231_utc_cfc.nc4    \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file - 3-hourly - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file - 3-hourly - VIC"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     ../output/San_Guad_JHM2/coords_San_Guad.csv                               \
     ../output/San_Guad_JHM2/NLDAS_VIC0125_3H_20100101_20131231_utc_cfc.nc4    \
     ../output/San_Guad_JHM2/rapid_coupling_San_Guad_NLDAS.csv                 \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_tst.nc4 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_tst.nc4 \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Estimating and including runoff errors
#*******************************************************************************

#-------------------------------------------------------------------------------
#Compute bias, error variance, and error covariances - Monthly
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Compute bias, error variance, and error covariances - Monthly"

../src/rrr_cpl_riv_lsm_bvc.py                                                  \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_M_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_M_utc.nc \
     3.805e-7                                                                  \
     once                                                                      \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     286                                                                       \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_M_flw_R286_tst.csv \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing bias, error, variance, and error covariances"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_M_flw_R286.csv \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_M_flw_R286_tst.csv \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Compute bias, error variance, and error covariances - Daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Compute bias, error variance, and error covariances - Daily"

../src/rrr_cpl_riv_lsm_bvc.py                                                  \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_D_utc.nc \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ENS0125_D_utc.nc \
     1.15741e-5                                                                 \
     once                                                                      \
     ../output/San_Guad_JHM2/rapid_connect_San_Guad.csv                        \
     286                                                                       \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_D_flw_R286_tst.csv \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing bias, error, variance, and error covariances"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_D_flw_R286.csv \
     ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_D_flw_R286_tst.csv \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Add estimate of errors - Monthly
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Adding estimate of errors - Monthly"
../src/rrr_cpl_riv_lsm_err.py                                                  \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc.nc \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_M_flw_R286.csv \
   2628028.8                                                                   \
   2628028.8                                                                   \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_M_tst.nc4 \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing estimate of errors"
./tst_cmp_n1d.py                                                               \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_M.nc \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_M_tst.nc4 \
   m3_riv_err                                                                  \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Add estimate of errors - Daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Adding estimate of errors - Daily"
../src/rrr_cpl_riv_lsm_err.py                                                  \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc.nc \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_D_flw_R286.csv \
   86400                                                                       \
   86400                                                                       \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D_tst.nc4 \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing estimate of errors"
./tst_cmp_n1d.py                                                               \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D.nc \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D_tst.nc4 \
   m3_riv_err                                                                  \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Add estimate of errors - Daily scaled
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Adding estimate of errors - Daily scaled"
../src/rrr_cpl_riv_lsm_err.py                                                  \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc.nc \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_ERR0125_D_flw_R286.csv \
   168750                                                                      \
   222910.217                                                                  \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D_scl_tst.nc4 \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing estimate of errors"
./tst_cmp_n1d.py                                                               \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D_scl.nc \
   ../output/San_Guad_JHM2/m3_riv_San_Guad_20100101_20131231_VIC0125_3H_utc_err_R286_D_scl_tst.nc4 \
   m3_riv_err                                                                  \
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
     ../input/San_Guad_JHM2/StreamGageEvent_San_Guad_comid.shp                 \
     2010-01-01                                                                \
     2013-12-31                                                                \
     ../output/San_Guad_JHM2/obs_tot_id_San_Guad_2010_2013_full_tst.csv        \
     ../output/San_Guad_JHM2/Qobs_San_Guad_2010_2013_full_tst.csv              \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013_tst.shp \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing gauges"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/obs_tot_id_San_Guad_2010_2013_full.csv            \
     ../output/San_Guad_JHM2/obs_tot_id_San_Guad_2010_2013_full_tst.csv        \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing observed flows"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/Qobs_San_Guad_2010_2013_full.csv                  \
     ../output/San_Guad_JHM2/Qobs_San_Guad_2010_2013_full_tst.csv              \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing shapefile"
./tst_cmp_shp.py                                                               \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013_tst.shp \
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
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/obs_tot_id_San_Guad_2010_2013_full.csv            \
     ../output/San_Guad_JHM2/Qobs_San_Guad_2010_2013_full.csv                  \
     2010-01-01                                                                \
     1                                                                         \
     USGS                                                                      \
     ../output/San_Guad_JHM2/analysis/timeseries_obs_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for observations"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_obs_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp00, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp00, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp00.nc                            \
     RAPID_exp00                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp00, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp00, monthly
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp00, monthly"
../src/rrr_anl_hyd_avg.py                                                      \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00_monthly_tst.csv     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp00, monthly"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00_monthly.csv         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00_monthly_tst.csv     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp01, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp01, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp01.nc                            \
     RAPID_exp01                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp01_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp01, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp01.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp01_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp02, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp02, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp02.nc                            \
     RAPID_exp02                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp02_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp02, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp02.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp02_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp03, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp03, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp03.nc                            \
     RAPID_exp03                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp03_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp03, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp03.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp03_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp04, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp04, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp04.nc                            \
     RAPID_exp04                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp04_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp04, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp04.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp04_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp05, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp05, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp05.nc                            \
     RAPID_exp05                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp05_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp05, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp05.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp05_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp06, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp06, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp06.nc                            \
     RAPID_exp06                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp06_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp06, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp06.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp06_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp07, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp07, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp07.nc                            \
     RAPID_exp07                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp07_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp07, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp07.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp07_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp08, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp08, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp08.nc                            \
     RAPID_exp08                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp08_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp08, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp08.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp08_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp09, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp09, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp09.nc                            \
     RAPID_exp09                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp09_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp09, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp09.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp09_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp10, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp10, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp10.nc                            \
     RAPID_exp10                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp10_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp10, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp10.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp10_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp11, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp11, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp11.nc                            \
     RAPID_exp11                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp11_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp11, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp11.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp11_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp12, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp12, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp12.nc                            \
     RAPID_exp12                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp12_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp12, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp12.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp12_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp13, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp13, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp13.nc                            \
     RAPID_exp13                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp13_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp13, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp13.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp13_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp14, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp14, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp14.nc                            \
     RAPID_exp14                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp14_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp14, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp14.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp14_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp15, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp15, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp15.nc                            \
     RAPID_exp15                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp15_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp15, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp15.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp15_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp16, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp16, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp16.nc                            \
     RAPID_exp16                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp16_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp16, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp16.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp16_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp17, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp17, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp17.nc                            \
     RAPID_exp17                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp17_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp17, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp17.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp17_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp18, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp18, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp18.nc                            \
     RAPID_exp18                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp18_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp18, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp18.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp18_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp19, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp19, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp19.nc                            \
     RAPID_exp19                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp19_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp19, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp19.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp19_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp20, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp20, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp20.nc                            \
     RAPID_exp20                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp20_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp20, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp20.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp20_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, exp21, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, exp21, daily"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/Qout_San_Guad_exp21.nc                            \
     RAPID_exp21                                                               \
     8                                                                         \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp21_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, exp21, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp21.csv                 \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp21_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp00, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp00, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp00_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp00, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp00.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp00_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp01, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp01, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp01.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp01_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp01, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp01.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp01_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp02, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp02, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp02.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp02_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp02, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp02.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp02_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp03, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp03, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp03.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp03_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp03, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp03.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp03_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp04, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp04, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp04.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp04_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp04, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp04.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp04_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp05, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp05, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp05.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp05_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp05, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp05.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp05_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp06, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp06, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp06.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp06_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp06, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp06.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp06_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp07, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp07, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp07.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp07_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp07, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp07.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp07_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp08, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp08, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp08.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp08_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp08, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp08.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp08_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp09, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp09, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp09.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp09_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp09, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp09.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp09_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp10, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp10, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp10.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp10_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp10, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp10.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp10_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp11, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp11, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp11.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp11_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp11, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp11.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp11_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp12, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp12, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp12.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp12_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp12, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp12.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp12_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp13, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp13, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp13.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp13_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp13, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp13.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp13_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp14, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp14, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp14.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp14_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp14, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp14.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp14_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp15, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp15, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp15.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp15_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp15, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp15.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp15_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp16, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp16, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp16.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp16_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp16, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp16.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp16_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp17, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp17, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp17.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp17_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp17, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp17.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp17_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp18, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp18, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp18.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp18_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp18, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp18.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp18_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp19, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp19, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp19.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp19_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp19, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp19.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp19_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp20, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp20, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp20.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp20_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp20, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp20.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp20_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, exp21, daily
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, exp21, daily"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp21.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp21_tst.csv                  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, exp21, daily"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp21.csv                      \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp21_tst.csv                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations, exp00, full range
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, exp00, full range"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp00.csv                      \
     ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp00_full_range_tst/  \
     2010-01-01                                                                \
     2013-12-31                                                                \
     2000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp00_full_range_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations, exp00
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, exp00"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp00.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp00.csv                      \
     ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp00_tst/               \
     2010-01-01                                                                \
     2011-12-31                                                                \
     1000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp00_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations, exp04
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, exp04"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp04.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp04.csv                      \
     ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp04_tst/               \
     2010-01-01                                                                \
     2011-12-31                                                                \
     1000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp04_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations, exp08
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, exp08"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp08.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp08.csv                      \
     ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp08_tst/               \
     2010-01-01                                                                \
     2011-12-31                                                                \
     1000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp08_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations, exp09
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, exp09"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp09.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp09.csv                      \
     ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp09_tst/               \
     2010-01-01                                                                \
     2011-12-31                                                                \
     1000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp09_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations, exp10
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, exp10"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/San_Guad_JHM2/StreamGageEvent_San_Guad_comid_withdir_full_2010_2013.shp \
     ../output/San_Guad_JHM2/analysis/timeseries_obs.csv                       \
     ../output/San_Guad_JHM2/analysis/timeseries_rap_exp10.csv                 \
     ../output/San_Guad_JHM2/analysis/stats_rap_exp10.csv                      \
     ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp10_tst/               \
     2010-01-01                                                                \
     2011-12-31                                                                \
     1000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/San_Guad_JHM2/analysis/hydrographs_rap_exp10_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
rm -f ../output/San_Guad_JHM2/*_tst.*
rm -f ../output/San_Guad_JHM2/analysis/*_tst*.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
