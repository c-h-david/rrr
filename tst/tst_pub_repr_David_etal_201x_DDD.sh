#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_201x_DDD.sh
#*******************************************************************************

#Purpose:
#
#Author:
#Cedric H. David, 2016


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: http://dx.doi.org/DDD"
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
     ../input/San_Guad_DDD/NHDFlowline_San_Guad.dbf                            \
     ../input/San_Guad_DDD/NHDFlowlineVAA.dbf                                  \
     4                                                                         \
     ../output/San_Guad_DDD/rapid_connect_San_Guad_tst.csv                     \
     ../output/San_Guad_DDD/kfac_San_Guad_1km_hour_tst.csv                     \
     ../output/San_Guad_DDD/xfac_San_Guad_0.1_tst.csv                          \
     ../output/San_Guad_DDD/sort_San_Guad_hydroseq_tst.csv                     \
     ../output/San_Guad_DDD/coords_San_Guad_tst.csv                            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/rapid_connect_San_Guad.csv                         \
     ../output/San_Guad_DDD/rapid_connect_San_Guad_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/kfac_San_Guad_1km_hour.csv                         \
     ../output/San_Guad_DDD/kfac_San_Guad_1km_hour_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/xfac_San_Guad_0.1.csv                              \
     ../output/San_Guad_DDD/xfac_San_Guad_0.1_tst.csv                          \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/sort_San_Guad_hydroseq.csv                         \
     ../output/San_Guad_DDD/sort_San_Guad_hydroseq_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/coords_San_Guad.csv                                \
     ../output/San_Guad_DDD/coords_San_Guad_tst.csv                            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters 1
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_ag files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_DDD/kfac_San_Guad_1km_hour.csv                         \
     ../output/San_Guad_DDD/xfac_San_Guad_0.1.csv                              \
     0.35                                                                      \
     3.0                                                                       \
     ../output/San_Guad_DDD/k_San_Guad_ag_tst.csv                              \
     ../output/San_Guad_DDD/x_San_Guad_ag_tst.csv                              \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_ag files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/k_San_Guad_ag.csv                                  \
     ../output/San_Guad_DDD/k_San_Guad_ag_tst.csv                              \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_ag files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/x_San_Guad_ag.csv                                  \
     ../output/San_Guad_DDD/x_San_Guad_ag_tst.csv                              \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters 2
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_a0 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_DDD/kfac_San_Guad_1km_hour.csv                         \
     ../output/San_Guad_DDD/xfac_San_Guad_0.1.csv                              \
     0.25                                                                      \
     0.875                                                                     \
     ../output/San_Guad_DDD/k_San_Guad_2010_a0_tst.csv                         \
     ../output/San_Guad_DDD/x_San_Guad_2010_a0_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_a0 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/k_San_Guad_2010_a0.csv                             \
     ../output/San_Guad_DDD/k_San_Guad_2010_a0_tst.csv                         \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_a0 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/x_San_Guad_2010_a0.csv                             \
     ../output/San_Guad_DDD/x_San_Guad_2010_a0_tst.csv                         \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
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
     ../input/San_Guad_DDD/NHDFlowline_San_Guad.dbf                            \
     ../output/San_Guad_DDD/rapid_connect_San_Guad.csv                         \
     ../output/San_Guad_DDD/sort_San_Guad_hydroseq.csv                         \
     ../output/San_Guad_DDD/riv_bas_id_San_Guad_hydroseq_tst.csv               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/riv_bas_id_San_Guad_hydroseq.csv                   \
     ../output/San_Guad_DDD/riv_bas_id_San_Guad_hydroseq_tst.csv               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
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
     ../input/San_Guad_DDD/catchment.dbf                                       \
     ../output/San_Guad_DDD/rapid_catchment_Reg12_tst.csv                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/rapid_catchment_Reg12_arc.csv                      \
     ../output/San_Guad_DDD/rapid_catchment_Reg12_tst.csv                      \
     1e-5                                                                      \
     1e-3                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
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
for file in `find '../input/San_Guad_DDD/NLDAS_VIC0125_H.002/2010/'*/          \
                  '../input/San_Guad_DDD/NLDAS_VIC0125_H.002/2011/'*/          \
                  '../input/San_Guad_DDD/NLDAS_VIC0125_H.002/2012/'*/          \
                  '../input/San_Guad_DDD/NLDAS_VIC0125_H.002/2013/'*/          \
                   -name '*.grb'`

do
../src/rrr_lsm_tot_grb_2nc.sh                                                  \
                     $file                                                     \
                     lon_110                                                   \
                     lat_110                                                   \
                     SSRUN_110_SFC_ave2h                                       \
                     BGRUN_110_SFC_ave2h                                       \
                     ../output/San_Guad_DDD/NLDAS_VIC0125_H.002/               \
                     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
done

echo "- Comparing to NOTHING"

rm $run_file
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

echo "- Preparing single netCDF files with averages of multiple files"

for year in `seq 2010 2013`; do
for month in 01 02 03 04 05 06 07 08 09 10 11 12; do

echo "  . Creating a concatenated & accumulated file for $year/$month"
../src/rrr_lsm_tot_cmb_acc.sh                                                  \
../output/San_Guad_DDD/NLDAS_VIC0125_H.002/NLDAS_VIC0125_H.A${year}${month}*.nc\
 3                                                                             \
../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_${year}${month}.nc    \
      > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
done
done

echo "- Comparing to NOTHING"

rm $run_file
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

for year in `seq 2010 2013`; do
for month in 01 02 03 04 05 06 07 08 09 10 11 12; do

echo "  . Creating a CF compliant file for $year/$month"
../src/rrr_lsm_tot_add_cfc.py                                                  \
../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_${year}${month}.nc    \
 "$year-$month-01T00:00:00"                                                    \
 10800                                                                         \
../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_${year}${month}_utc.nc\
      > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
done
done

echo "- Comparing to NOTHING"

rm $run_file
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
nc_file=../output/San_Guad_DDD/NLDAS_VIC0125_3H_20100101_20131231_utc.nc
if [ ! -e "$nc_file" ]; then
ncrcat ../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_2010*_utc.nc   \
       ../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_2011*_utc.nc   \
       ../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_2012*_utc.nc   \
       ../output/San_Guad_DDD/NLDAS_VIC0125_3H/NLDAS_VIC0125_3H_2013*_utc.nc   \
       -o $nc_file                                                             \
        > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
fi

echo "- Comparing to NOTHING"

rm $run_file
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
nc_file=../output/San_Guad_DDD/NLDAS_VIC0125_3H_20100101_20131231_utc.nc
nc_file2=../output/San_Guad_DDD/NLDAS_VIC0125_3H_20100101_20131231_cst.nc
if [ ! -e "$nc_file2" ]; then
../src/rrr_lsm_tot_utc_shf.py                                                  \
       $nc_file                                                                \
       2                                                                       \
       $nc_file2                                                               \
       > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
fi

echo "- Comparing to NOTHING"

rm $run_file
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
     ../output/San_Guad_DDD/rapid_connect_San_Guad.csv                         \
     ../output/San_Guad_DDD/rapid_catchment_Reg12_arc.csv                      \
     ../output/San_Guad_DDD/NLDAS_VIC0125_3H_20100101_20131231_cst.nc          \
     ../output/San_Guad_DDD/rapid_coupling_San_Guad_NLDAS2_tst.csv             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/rapid_coupling_San_Guad_NLDAS2_arc.csv             \
     ../output/San_Guad_DDD/rapid_coupling_San_Guad_NLDAS2_tst.csv             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
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
   ../output/San_Guad_DDD/rapid_connect_San_Guad.csv                           \
   ../output/San_Guad_DDD/coords_San_Guad.csv                                  \
   ../output/San_Guad_DDD/NLDAS_VIC0125_3H_20100101_20131231_cst.nc            \
   ../output/San_Guad_DDD/rapid_coupling_San_Guad_NLDAS2_arc.csv               \
   ../output/San_Guad_DDD/m3_riv_San_Guad_20100101_20131231_VIC0125_cst_tst.nc \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file"
./tst_cmp_ncf.py                                                               \
   ../output/San_Guad_DDD/m3_riv_San_Guad_20100101_20131231_VIC0125_cst.nc     \
   ../output/San_Guad_DDD/m3_riv_San_Guad_20100101_20131231_VIC0125_cst_tst.nc \
   1e-6                                                                        \
   1                                                                           \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm $run_file
rm $cmp_file
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
   ../output/San_Guad_DDD/m3_riv_San_Guad_20100101_20131231_VIC0125_cst_tst.nc \
   'RAPID data corresponding to the San Antonio and Guadalupe Basins'          \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ' '                                                                         \
   6378137                                                                     \
   298.257222101                                                               \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm $run_file
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
     ../input/San_Guad_DDD/StreamGageEvent_San_Guad_comid_withdir.shp          \
     2010-01-01                                                                \
     2013-12-31                                                                \
     ../output/San_Guad_DDD/obs_tot_id_San_Guad_2010_2013_full_tst.csv         \
     ../output/San_Guad_DDD/Qobs_San_Guad_2010_2013_full_tst.csv               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing gauges"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/obs_tot_id_San_Guad_2010_2013_full.csv             \
     ../output/San_Guad_DDD/obs_tot_id_San_Guad_2010_2013_full_tst.csv         \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing observed flows"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_DDD/Qobs_San_Guad_2010_2013_full.csv                   \
     ../output/San_Guad_DDD/Qobs_San_Guad_2010_2013_full_tst.csv               \
     1e-3                                                                      \
     1e-4                                                                      \
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
rm -f ../output/San_Guad_DDD/*_tst.csv
#rm -f ../output/San_Guad_DDD/*_tst.nc


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
