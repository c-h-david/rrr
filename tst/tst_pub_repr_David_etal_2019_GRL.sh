#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_2019_GRL.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#David, Cédric H., Jonathan M. Hobbs, Michael J. Turmon, Charlotte M. Emery,
#John T. Reager, and James S. Famiglietti (2019), Analytical Propagation of
#Runoff Uncertainty into Discharge Uncertainty through a Large River Network,
#Geophysical Research Letters.
#DOI: xx.xxxx/xxxxxx
#The files used are available from:
#David, Cédric H., Jonathan M. Hobbs, Michael J. Turmon, Charlotte M. Emery,
#John T. Reager, and James S. Famiglietti (2019), RRR/RAPID input and output
#files corresponding to "Analytical Propagation of Runoff Uncertainty into
#Discharge Uncertainty through a Large River Network", Zenodo.
#DOI: 10.5281/zenodo.2665084
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
#Cedric H. David, 2016-2019


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
     ../input/WSWM_GRL/NHDFlowline_WSWM_Sort.dbf                               \
     ../input/WSWM_GRL/PlusFlowlineVAA_WSWM_Sort_fixed_Node_50233399.dbf       \
     12                                                                        \
     ../output/WSWM_GRL/rapid_connect_WSWM_tst.csv                             \
     ../output/WSWM_GRL/kfac_WSWM_1km_hour_tst.csv                             \
     ../output/WSWM_GRL/xfac_WSWM_0.1_tst.csv                                  \
     ../output/WSWM_GRL/sort_WSWM_hydroseq_tst.csv                             \
     ../output/WSWM_GRL/coords_WSWM_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/rapid_connect_WSWM.csv                                 \
     ../output/WSWM_GRL/rapid_connect_WSWM_tst.csv                             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/kfac_WSWM_1km_hour.csv                                 \
     ../output/WSWM_GRL/kfac_WSWM_1km_hour_tst.csv                             \
     1e-9                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/xfac_WSWM_0.1.csv                                      \
     ../output/WSWM_GRL/xfac_WSWM_0.1_tst.csv                                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/sort_WSWM_hydroseq.csv                                 \
     ../output/WSWM_GRL/sort_WSWM_hydroseq_tst.csv                             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/coords_WSWM.csv                                        \
     ../output/WSWM_GRL/coords_WSWM_tst.csv                                    \
     1e-9                                                                      \
     1e-6                                                                      \
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

echo "- Creating parameters pag files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/WSWM_GRL/kfac_WSWM_1km_hour.csv                                 \
     ../output/WSWM_GRL/xfac_WSWM_0.1.csv                                      \
     0.3                                                                       \
     3.0                                                                       \
     ../output/WSWM_GRL/k_WSWM_pag_tst.csv                                     \
     ../output/WSWM_GRL/x_WSWM_pag_tst.csv                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_pag files"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/k_WSWM_pag.csv                                         \
     ../output/WSWM_GRL/k_WSWM_pag_tst.csv                                     \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_pag files"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/x_WSWM_pag.csv                                         \
     ../output/WSWM_GRL/x_WSWM_pag_tst.csv                                     \
     1e-6                                                                      \
     1e-2                                                                      \
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
     ../input/WSWM_GRL/NHDFlowline_WSWM_Sort.dbf                               \
     ../output/WSWM_GRL/rapid_connect_WSWM.csv                                 \
     ../output/WSWM_GRL/sort_WSWM_hydroseq.csv                                 \
     ../output/WSWM_GRL/riv_bas_id_WSWM_hydroseq_tst.csv                       \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/riv_bas_id_WSWM_hydroseq.csv                           \
     ../output/WSWM_GRL/riv_bas_id_WSWM_hydroseq_tst.csv                       \
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
     ../input/WSWM_GRL/Catchment_WSWM_Sort.dbf                                 \
     ../output/WSWM_GRL/rapid_catchment_WSWM_tst.csv                           \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/rapid_catchment_WSWM_arc.csv                           \
     ../output/WSWM_GRL/rapid_catchment_WSWM_tst.csv                           \
     1e-5                                                                      \
     1e-3                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Process Land surface model (LSM) data - Monthly
#*******************************************************************************


#*******************************************************************************
#Process Land surface model (LSM) data
#*******************************************************************************


#*******************************************************************************
#Coupling - Monthly
#*******************************************************************************

#-------------------------------------------------------------------------------
#Create coupling file
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coupling file"
../src/rrr_cpl_riv_lsm_lnk.py                                                  \
     ../output/WSWM_GRL/rapid_connect_WSWM.csv                                 \
     ../output/WSWM_GRL/rapid_catchment_WSWM_arc.csv                           \
     ../output/WSWM_GRL/NLDAS_MOS0125_M_19970101_19981231_utc_cfc.nc4          \
     ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2.csv                         \
     ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file, MOS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file, MOS"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
   ../output/WSWM_GRL/rapid_connect_WSWM.csv                                   \
   ../output/WSWM_GRL/coords_WSWM.csv                                          \
   ../output/WSWM_GRL/NLDAS_MOS0125_M_19970101_19981231_utc_cfc.nc4            \
   ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2.csv                           \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_MOS0125_M_utc_tst.nc4      \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file, MOS"
./tst_cmp_ncf.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_MOS0125_M_utc.nc4          \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_MOS0125_M_utc_tst.nc4      \
   1e-6                                                                        \
   50                                                                          \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file, NOAH
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file, NOAH"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
   ../output/WSWM_GRL/rapid_connect_WSWM.csv                                   \
   ../output/WSWM_GRL/coords_WSWM.csv                                          \
   ../output/WSWM_GRL/NLDAS_NOAH0125_M_19970101_19981231_utc_cfc.nc4           \
   ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2.csv                           \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_NOAH0125_M_utc_tst.nc4     \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file, NOAH"
./tst_cmp_ncf.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_NOAH0125_M_utc.nc4         \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_NOAH0125_M_utc_tst.nc4     \
   1e-6                                                                        \
   50                                                                          \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file, VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file, VIC"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
   ../output/WSWM_GRL/rapid_connect_WSWM.csv                                   \
   ../output/WSWM_GRL/coords_WSWM.csv                                          \
   ../output/WSWM_GRL/NLDAS_VIC0125_M_19970101_19981231_utc_cfc.nc4            \
   ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2.csv                           \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_M_utc_tst.nc4      \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file, VIC"
./tst_cmp_ncf.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_M_utc.nc4          \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_M_utc_tst.nc4      \
   1e-6                                                                        \
   50                                                                          \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create ensemble file, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file, ENS"

../src/rrr_cpl_riv_lsm_ens.py                                                  \
     ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_NOAH0125_M_utc.nc4       \
     ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_MOS0125_M_utc.nc4        \
     ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_M_utc.nc4        \
     ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ENS0125_M_utc_tst.nc4    \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file, ENS"
./tst_cmp_ncf.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ENS0125_M_utc.nc4          \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ENS0125_M_utc_tst.nc4      \
   1e-6                                                                        \
   50                                                                          \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Compute biases, error variances, and error covariances
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creatingting biases, error variances, and error covariances"

../src/rrr_cpl_riv_lsm_bvc.py                                                  \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_M_utc.nc4          \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ENS0125_M_utc.nc4          \
   1.0                                                                         \
   once                                                                        \
   ../output/WSWM_GRL/rapid_connect_WSWM.csv                                   \
   50                                                                          \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ERR0125_M_vol_R50_tst.csv  \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing biases, error variances, and error covariances"
./tst_cmp_csv.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ERR0125_M_vol_R50.csv      \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ERR0125_M_vol_R50_tst.csv  \
   1e-6                                                                        \
   1e-2                                                                        \
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
#Create coupling file
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coupling file"
../src/rrr_cpl_riv_lsm_lnk.py                                                  \
     ../output/WSWM_GRL/rapid_connect_WSWM.csv                                 \
     ../output/WSWM_GRL/rapid_catchment_WSWM_arc.csv                           \
     ../output/WSWM_GRL/NLDAS_VIC0125_3H_19970101_19981231_cst_cfc.nc4         \
     ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2.csv                         \
     ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
   ../output/WSWM_GRL/rapid_connect_WSWM.csv                                   \
   ../output/WSWM_GRL/coords_WSWM.csv                                          \
   ../output/WSWM_GRL/NLDAS_VIC0125_3H_19970101_19981231_cst_cfc.nc4           \
   ../output/WSWM_GRL/rapid_coupling_WSWM_NLDAS2.csv                           \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst_tst.nc4     \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst.nc4         \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst_tst.nc4     \
   1e-6                                                                        \
   50                                                                          \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Update netCDF attributes
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst.nc4         \
   'RAPID data corresponding to the Western States Water Mission'              \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   6378137                                                                     \
   298.257222101                                                               \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Add estimate of errors
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Adding estimate of errors"
../src/rrr_cpl_riv_lsm_err.py                                                  \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst.nc4         \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_ERR0125_M_vol_R50.csv      \
   1.0                                                                         \
   1.0                                                                         \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst_err_tst.nc4 \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing estimate of errors"
./tst_cmp_n1d.py                                                               \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst_err.nc4     \
   ../output/WSWM_GRL/m3_riv_WSWM_19970101_19981231_VIC0125_3H_cst_err_tst.nc4 \
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
     ../input/WSWM_GRL/GageLoc_WSWM_with_dir.shp                               \
     1997-01-01                                                                \
     1998-12-31                                                                \
     ../output/WSWM_GRL/obs_tot_id_WSWM_1997_1998_full_tst.csv                 \
     ../output/WSWM_GRL/Qobs_WSWM_1997_1998_full_tst.csv                       \
     ../output/WSWM_GRL/GageLoc_WSWM_with_dir_1997_1998_full_tst.shp           \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing gauges"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/obs_tot_id_WSWM_1997_1998_full.csv                     \
     ../output/WSWM_GRL/obs_tot_id_WSWM_1997_1998_full_tst.csv                 \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing observed flows"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/Qobs_WSWM_1997_1998_full.csv                           \
     ../output/WSWM_GRL/Qobs_WSWM_1997_1998_full_tst.csv                       \
     1e-5                                                                      \
     1e-6                                                                      \
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
     ../output/WSWM_GRL/GageLoc_WSWM_with_dir_1997_1998_full.shp               \
     ../output/WSWM_GRL/obs_tot_id_WSWM_1997_1998_full.csv                     \
     ../output/WSWM_GRL/Qobs_WSWM_1997_1998_full.csv                           \
     1997-01-01                                                                \
     1                                                                         \
     USGS                                                                      \
     ../output/WSWM_GRL/analysis/timeseries_obs_tst.csv                        \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for observations"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/analysis/timeseries_obs.csv                            \
     ../output/WSWM_GRL/analysis/timeseries_obs_tst.csv                        \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations, with parameters pag, initialized
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations, with parameters pag, initialized"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/WSWM_GRL/GageLoc_WSWM_with_dir_1997_1998_full.shp               \
     ../output/WSWM_GRL/Qout_WSWM_729days_pag_dtR900s_n1_preonly_init_err.nc   \
     RAPID_init                                                                \
     8                                                                         \
     ../output/WSWM_GRL/analysis/timeseries_rap_pag_init_tst.csv               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations, with parameters pag, initialized"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/analysis/timeseries_rap_pag_init.csv                   \
     ../output/WSWM_GRL/analysis/timeseries_rap_pag_init_tst.csv               \
     1e-3                                                                      \
     2e-3                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations, with parameters pag, initialized
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations, with parameters pag, initialized"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/WSWM_GRL/GageLoc_WSWM_with_dir_1997_1998_full_Sort.shp          \
     ../output/WSWM_GRL/analysis/timeseries_obs.csv                            \
     ../output/WSWM_GRL/analysis/timeseries_rap_pag_init.csv                   \
     ../output/WSWM_GRL/analysis/stats_rap_pag_init_tst.csv                    \
     1997-01-01                                                                \
     1998-12-30                                                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations, with parameters pag, initialized"
./tst_cmp_csv.py                                                               \
     ../output/WSWM_GRL/analysis/stats_rap_pag_init.csv                        \
     ../output/WSWM_GRL/analysis/stats_rap_pag_init_tst.csv                    \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations with, parameters pag, initialized
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations, with parameters pag, initialized"
../src/rrr_anl_hyd_plt.py                                                      \
     ../output/WSWM_GRL/GageLoc_WSWM_with_dir_1997_1998_full_plot.shp          \
     ../output/WSWM_GRL/analysis/timeseries_obs.csv                            \
     ../output/WSWM_GRL/analysis/timeseries_rap_pag_init.csv                   \
     ../output/WSWM_GRL/analysis/stats_rap_pag_init.csv                        \
     ../output/WSWM_GRL/analysis/hydrographs_rap_pag_init_tst/                 \
     1997-01-01                                                                \
     1998-12-30                                                                \
     25000                                                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/WSWM_GRL/analysis/hydrographs_rap_pag_init_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Error CDFs for model simulations with, parameters pag, initialized
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Error CDFs for model simulations, with parameters pag, initialized"
../src/./rrr_anl_hyd_cdf.py                                                    \
     ../output/WSWM_GRL/analysis/stats_rap_pag_init.csv                        \
     ../output/WSWM_GRL/analysis/cdf_rap_pag_init_tst/                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/WSWM_GRL/analysis/cdf_rap_pag_init_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
rm -f ../output/WSWM_GRL/*_tst.csv
rm -f ../output/WSWM_GRL/*_tst.nc4
rm -f ../output/WSWM_GRL/analysis/*_tst*.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
