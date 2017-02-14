#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_2013_WRR.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#David, Cédric H., Zong-Liang Yang and James S. Famiglietti (2013), 
#Quantification of the upstream-to-downstream influence in the Muskingum method, 
#and implications for speedup in parallel computations of river flow, Water 
#Resources Research, 49(5), 1-18, 
#DOI: 10.1002/wrcr.20250.
#The files used are available from:
#David, Cédric H., Zong-Liang Yang and James S. Famiglietti (2013), 
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
echo "Reproducing files for: http://dx.doi.org/10.1002/wrcr.20250"
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
     ../input/Reg07_WRR/NHDFlowline.dbf                                        \
     ../input/Reg07_WRR/NHDFlowlineVAA.dbf                                     \
     4                                                                         \
     ../output/Reg07_WRR/rapid_connect_Reg07_tst.csv                           \
     ../output/Reg07_WRR/kfac_Reg07_1km_hour_tst.csv                           \
     ../output/Reg07_WRR/xfac_Reg07_0.1_tst.csv                                \
     ../output/Reg07_WRR/sort_Reg07_hydroseq_tst.csv                           \
     ../output/Reg07_WRR/coords_Reg07_tst.csv                                  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/rapid_connect_Reg07.csv                               \
     ../output/Reg07_WRR/rapid_connect_Reg07_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/kfac_Reg07_1km_hour.csv                               \
     ../output/Reg07_WRR/kfac_Reg07_1km_hour_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/xfac_Reg07_0.1.csv                                    \
     ../output/Reg07_WRR/xfac_Reg07_0.1_tst.csv                                \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/sort_Reg07_hydroseq.csv                               \
     ../output/Reg07_WRR/sort_Reg07_hydroseq_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/coords_Reg07.csv                                      \
     ../output/Reg07_WRR/coords_Reg07_tst.csv                                  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters a0
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating pa0 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/Reg07_WRR/kfac_Reg07_1km_hour.csv                               \
     ../output/Reg07_WRR/xfac_Reg07_0.1.csv                                    \
     0.3087                                                                    \
     0.0652                                                                    \
     ../output/Reg07_WRR/k_Reg07_VIC_V4.0.5_pa0_tst.csv                        \
     ../output/Reg07_WRR/x_Reg07_VIC_V4.0.5_pa0_tst.csv                        \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing ka0 files"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/k_Reg07_VIC_V4.0.5_pa0.csv                            \
     ../output/Reg07_WRR/k_Reg07_VIC_V4.0.5_pa0_tst.csv                        \
     1e-4                                                                      \
     2e+0                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xa0 files"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/x_Reg07_VIC_V4.0.5_pa0.csv                            \
     ../output/Reg07_WRR/x_Reg07_VIC_V4.0.5_pa0_tst.csv                        \
     1e-3                                                                      \
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
     ../input/Reg07_WRR/NHDFlowline.dbf                                        \
     ../output/Reg07_WRR/rapid_connect_Reg07.csv                               \
     ../output/Reg07_WRR/sort_Reg07_hydroseq.csv                               \
     ../output/Reg07_WRR/basin_id_Reg07_hydroseq_tst.csv                       \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/basin_id_Reg07_hydroseq.csv                           \
     ../output/Reg07_WRR/basin_id_Reg07_hydroseq_tst.csv                       \
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
     ../input/Reg07_WRR/catchment.dbf                                          \
     ../output/Reg07_WRR/rapid_catchment_Reg07_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/rapid_catchment_Reg07.csv                             \
     ../output/Reg07_WRR/rapid_catchment_Reg07_tst.csv                         \
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
#Process Land surface model (LSM) data
#*******************************************************************************

#-------------------------------------------------------------------------------
#Convert GRIB to netCDF
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt

echo "- Converting GRIB to netCDF"
for file in `find '../input/Reg07_WRR/NLDAS2/vic4.0.5/2004/'*/                 \
                   -name '*.grb'`

do
../src/rrr_lsm_tot_grb_2nc.sh                                                  \
                     $file                                                     \
                     g0_lon_1                                                  \
                     g0_lat_0                                                  \
                     SSRUN_GDS0_SFC_acc1h                                      \
                     BGRUN_GDS0_SFC_acc1h                                      \
                     ../output/Reg07_WRR/NLDAS2/vic4.0.5/                      \
                     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
done

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Prepare single large netCDF files with averages of multiple files
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt

echo "- Preparing a single netCDF file with averages of multiple files"

for year in `seq 2004 2004`; do
for month in 01 02 03 04 05 06 07 08 09 10 11 12; do

echo "  . Creating a concatenated & accumulated file for $year/$month"
../src/rrr_lsm_tot_cmb_acc.sh                                                  \
../output/Reg07_WRR/NLDAS2/vic4.0.5/${year}${month}*.VIC.nc                    \
 3                                                                             \
../output/Reg07_WRR/NLDAS2/vic4.0.5_3H/${year}${month}.VIC_3H.nc               \
      > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
done
done

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Make the single large netCDF files CF compliant
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt

echo "- Making the single netCDF files CF compliant"

for year in `seq 2004 2004`; do
for month in 01 02 03 04 05 06 07 08 09 10 11 12; do

echo "  . Creating a CF compliant file for $year/$month"
../src/rrr_lsm_tot_add_cfc.py                                                  \
../output/Reg07_WRR/NLDAS2/vic4.0.5_3H/${year}${month}.VIC_3H.nc               \
 "$year-$month-01T00:00:00"                                                    \
 10800                                                                         \
../output/Reg07_WRR/NLDAS2/vic4.0.5_3H/${year}${month}.VIC_3H_utc.nc           \
      > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
done
done

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Concatenate several large netCDF files
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt

echo "  . Concatenating all large files"
nc_file=../output/Reg07_WRR/vic4.0.5_3H_20040101_20041231_utc.nc
if [ ! -e "$nc_file" ]; then
ncrcat ../output/Reg07_WRR/NLDAS2/vic4.0.5_3H/*.VIC_3H_utc.nc                  \
       -o $nc_file                                                             \
        > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Shifting to local time
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt

echo "  . Shifting to local time"
nc_file=../output/Reg07_WRR/vic4.0.5_3H_20040101_20041231_utc.nc
nc_file2=../output/Reg07_WRR/vic4.0.5_3H_20040101_20041231_cst.nc
if [ ! -e "$nc_file2" ]; then
../src/rrr_lsm_tot_utc_shf.py                                                  \
       $nc_file                                                                \
       2                                                                       \
       $nc_file2                                                               \
       > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
fi

echo "- Comparing to NOTHING"

rm -f $run_file
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
     ../output/Reg07_WRR/rapid_connect_Reg07.csv                               \
     ../output/Reg07_WRR/rapid_catchment_Reg07.csv                             \
     ../output/Reg07_WRR/vic4.0.5_3H_20040101_20041231_cst.nc                  \
     ../output/Reg07_WRR/rapid_coupling_Reg07_NLDAS2_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/Reg07_WRR/rapid_coupling_Reg07_NLDAS2.csv                       \
     ../output/Reg07_WRR/rapid_coupling_Reg07_NLDAS2_tst.csv                   \
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
   ../output/Reg07_WRR/rapid_connect_Reg07.csv                                 \
   ../output/Reg07_WRR/coords_Reg07.csv                                        \
   ../output/Reg07_WRR/vic4.0.5_3H_20040101_20041231_cst.nc                    \
   ../output/Reg07_WRR/rapid_coupling_Reg07_NLDAS2.csv                         \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_tst.nc      \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst.nc          \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_tst.nc      \
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
#Update netCDF global attributes 
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF global attributes"
../src/rrr_cpl_riv_lsm_att.sh                                                  \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_tst.nc      \
   'RAPID data corresponding to the Upper Mississippi River Basin'             \
   'University of Texas at Austin'                                             \
   ' '                                                                         \
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
#Add estimate of standard error
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Adding estimate of standard error"
../src/rrr_cpl_riv_lsm_avg.py                                                  \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_tst.nc      \
   10                                                                          \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_10p_tst.nc  \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_10p_tst.nc  \
   ../output/Reg07_WRR/m3_riv_Reg07_20040101_20041231_vic4.0.5_cst_10p.nc      \
   1e-6                                                                        \
   50                                                                          \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
rm -f ../output/Reg07_WRR/*_tst.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
