#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Collins_etal_202x_TBD.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#Collins, E. L.,
#DOI: xx.xxxx/xxxxxxxxxxxx
#The files used are available from:
#Collins, E. L.,
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
#Cedric H. David, 2022-2023


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#N/A


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: https://doi.org/xx.xxxx/xxxxxxxxxxxx"
echo "********************"


#*******************************************************************************
#Select which unit tests to perform based on inputs to this shell script
#*******************************************************************************
tot=99
if [ "$#" = "0" ]; then
     fst=1
     lst=$tot
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating all domain files"
../src/rrr_riv_tot_gen_all_meritbasins.py                                      \
     ../input/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01.shp           \
     5                                                                         \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74_tst.csv                       \
     ../output/MH07B01_TBD/kfac_pfaf_74_1km_hour_tst.csv                       \
     ../output/MH07B01_TBD/xfac_pfaf_74_0.1_tst.csv                            \
     ../output/MH07B01_TBD/sort_pfaf_74_topo_tst.csv                           \
     ../output/MH07B01_TBD/coords_pfaf_74_tst.csv                              \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74.csv                           \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74_tst.csv                       \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/kfac_pfaf_74_1km_hour.csv                           \
     ../output/MH07B01_TBD/kfac_pfaf_74_1km_hour_tst.csv                       \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/xfac_pfaf_74_0.1.csv                                \
     ../output/MH07B01_TBD/xfac_pfaf_74_0.1_tst.csv                            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/sort_pfaf_74_topo.csv                               \
     ../output/MH07B01_TBD/sort_pfaf_74_topo_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/coords_pfaf_74.csv                                  \
     ../output/MH07B01_TBD/coords_pfaf_74_tst.csv                              \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters p_low
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/91"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_low files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/MH07B01_TBD/kfac_pfaf_74_1km_hour.csv                           \
     ../output/MH07B01_TBD/xfac_pfaf_74_0.1.csv                                \
     0.20                                                                      \
     0.00                                                                      \
     ../output/MH07B01_TBD/k_pfaf_74_low_tst.csv                               \
     ../output/MH07B01_TBD/x_pfaf_74_low_tst.csv                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_low files"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/k_pfaf_74_low.csv                                   \
     ../output/MH07B01_TBD/k_pfaf_74_low_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_low files"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/x_pfaf_74_low.csv                                   \
     ../output/MH07B01_TBD/x_pfaf_74_low_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters p_nrm
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/91"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_nrm files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/MH07B01_TBD/kfac_pfaf_74_1km_hour.csv                           \
     ../output/MH07B01_TBD/xfac_pfaf_74_0.1.csv                                \
     0.35                                                                      \
     3.00                                                                      \
     ../output/MH07B01_TBD/k_pfaf_74_nrm_tst.csv                               \
     ../output/MH07B01_TBD/x_pfaf_74_nrm_tst.csv                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_nrm files"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/k_pfaf_74_nrm.csv                                   \
     ../output/MH07B01_TBD/k_pfaf_74_nrm_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_nrm files"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/x_pfaf_74_nrm.csv                                   \
     ../output/MH07B01_TBD/x_pfaf_74_nrm_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters p_hig
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/91"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_hig files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/MH07B01_TBD/kfac_pfaf_74_1km_hour.csv                           \
     ../output/MH07B01_TBD/xfac_pfaf_74_0.1.csv                                \
     0.50                                                                      \
     5.00                                                                      \
     ../output/MH07B01_TBD/k_pfaf_74_hig_tst.csv                               \
     ../output/MH07B01_TBD/x_pfaf_74_hig_tst.csv                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_hig files"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/k_pfaf_74_hig.csv                                   \
     ../output/MH07B01_TBD/k_pfaf_74_hig_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_hig files"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/x_pfaf_74_hig.csv                                   \
     ../output/MH07B01_TBD/x_pfaf_74_hig_tst.csv                               \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sorted basin file"
../src/rrr_riv_bas_gen_one_meritbasins.py                                      \
     ../input/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01.shp           \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74.csv                           \
     ../output/MH07B01_TBD/sort_pfaf_74_topo.csv                               \
     ../output/MH07B01_TBD/riv_bas_id_pfaf_74_topo_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/riv_bas_id_pfaf_74_topo.csv                         \
     ../output/MH07B01_TBD/riv_bas_id_pfaf_74_topo_tst.csv                     \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating catchment file"
../src/rrr_cat_tot_gen_one_meritbasins.py                                      \
     ../input/MH07B01_TBD/cat_pfaf_74_MERIT_Hydro_v07_Basins_v01.shp           \
     ../output/MH07B01_TBD/rapid_catchment_pfaf_74_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/rapid_catchment_pfaf_74.csv                         \
     ../output/MH07B01_TBD/rapid_catchment_pfaf_74_tst.csv                     \
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

#-------------------------------------------------------------------------------
#Concatenating multiple files - Monthly - CLSM
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Concatenating multiple files - Monthly - CLSM"

../src/rrr_lsm_tot_cmb_acc.sh                                                  \
     ../input/GLDAS/GLDAS_CLSM10_M.2.0/198*/GLDAS_CLSM10_M.*.nc4               \
     ../input/GLDAS/GLDAS_CLSM10_M.2.0/199*/GLDAS_CLSM10_M.*.nc4               \
     ../input/GLDAS/GLDAS_CLSM10_M.2.0/200*/GLDAS_CLSM10_M.*.nc4               \
     1                                                                         \
     ../output/MH07B01_TBD/GLDAS_CLSM_M_1980-01_2009-12_utc_tmp_tst.nc4        \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#Using "1" because not averaging any consecutive files.

echo "- Making concatenated file CF compliant - Monthly - CLSM"

../src/rrr_lsm_tot_add_cfc.py                                                  \
     ../output/MH07B01_TBD/GLDAS_CLSM_M_1980-01_2009-12_utc_tmp_tst.nc4        \
     1980-01-01T00:00:00                                                       \
     2629800                                                                   \
     2629800/10800                                                             \
     ../output/MH07B01_TBD/GLDAS_CLSM_M_1980-01_2009-12_utc_tst.nc4            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#Using "2629800" as the number of seconds in average month for 365.25 days/year.
#Using "2629800/10800": monthly GLDAS files are time:mean of 3-hr accumulation.

echo "- Comparing concatenated file CF compliant - Monthly - CLSM"

./tst_cmp_n3d.py                                                               \
     ../output/MH07B01_TBD/GLDAS_CLSM_M_1980-01_2009-12_utc.nc4                \
     ../output/MH07B01_TBD/GLDAS_CLSM_M_1980-01_2009-12_utc_tst.nc4            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Concatenating multiple files - Monthly - NOAH
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Concatenating multiple files - Monthly - NOAH"

../src/rrr_lsm_tot_cmb_acc.sh                                                  \
     ../input/GLDAS/GLDAS_NOAH10_M.2.0/198*/GLDAS_NOAH10_M.*.nc4               \
     ../input/GLDAS/GLDAS_NOAH10_M.2.0/199*/GLDAS_NOAH10_M.*.nc4               \
     ../input/GLDAS/GLDAS_NOAH10_M.2.0/200*/GLDAS_NOAH10_M.*.nc4               \
     1                                                                         \
     ../output/MH07B01_TBD/GLDAS_NOAH_M_1980-01_2009-12_utc_tmp_tst.nc4        \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#Using "1" because not averaging any consecutive files.

echo "- Making concatenated file CF compliant - Monthly - NOAH"

../src/rrr_lsm_tot_add_cfc.py                                                  \
     ../output/MH07B01_TBD/GLDAS_NOAH_M_1980-01_2009-12_utc_tmp_tst.nc4        \
     1980-01-01T00:00:00                                                       \
     2629800                                                                   \
     2629800/10800                                                             \
     ../output/MH07B01_TBD/GLDAS_NOAH_M_1980-01_2009-12_utc_tst.nc4            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#Using "2629800" as the number of seconds in average month for 365.25 days/year.
#Using "2629800/10800": monthly GLDAS files are time:mean of 3-hr accumulation.

echo "- Comparing concatenated file CF compliant - Monthly - NOAH"

./tst_cmp_n3d.py                                                               \
     ../output/MH07B01_TBD/GLDAS_NOAH_M_1980-01_2009-12_utc.nc4                \
     ../output/MH07B01_TBD/GLDAS_NOAH_M_1980-01_2009-12_utc_tst.nc4            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Concatenating multiple files - Monthly - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Concatenating multiple files - Monthly - VIC"

../src/rrr_lsm_tot_cmb_acc.sh                                                  \
     ../input/GLDAS/GLDAS_VIC10_M.2.0/198*/GLDAS_VIC10_M.*.nc4                 \
     ../input/GLDAS/GLDAS_VIC10_M.2.0/199*/GLDAS_VIC10_M.*.nc4                 \
     ../input/GLDAS/GLDAS_VIC10_M.2.0/200*/GLDAS_VIC10_M.*.nc4                 \
     1                                                                         \
     ../output/MH07B01_TBD/GLDAS_VIC_M_1980-01_2009-12_utc_tmp_tst.nc4         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#Using "1" because not averaging any consecutive files.

echo "- Making concatenated file CF compliant - Monthly - VIC"

../src/rrr_lsm_tot_add_cfc.py                                                  \
     ../output/MH07B01_TBD/GLDAS_VIC_M_1980-01_2009-12_utc_tmp_tst.nc4         \
     1980-01-01T00:00:00                                                       \
     2629800                                                                   \
     2629800/10800                                                             \
     ../output/MH07B01_TBD/GLDAS_VIC_M_1980-01_2009-12_utc_tst.nc4             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#Using "2629800" as the number of seconds in average month for 365.25 days/year.
#Using "2629800/10800": monthly GLDAS files are time:mean of 3-hr accumulation.

echo "- Comparing concatenated file CF compliant - Monthly - VIC"

./tst_cmp_n3d.py                                                               \
     ../output/MH07B01_TBD/GLDAS_VIC_M_1980-01_2009-12_utc.nc4                 \
     ../output/MH07B01_TBD/GLDAS_VIC_M_1980-01_2009-12_utc_tst.nc4             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Computing ensemble average
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Computing ensemble average"

../src/rrr_lsm_tot_ens.py                                                      \
     ../output/MH07B01_TBD/GLDAS_CLSM_M_1980-01_2009-12_utc.nc4                \
     ../output/MH07B01_TBD/GLDAS_NOAH_M_1980-01_2009-12_utc.nc4                \
     ../output/MH07B01_TBD/GLDAS_VIC_M_1980-01_2009-12_utc.nc4                 \
     ../output/MH07B01_TBD/GLDAS_ENS_M_1980-01_2009-12_utc_tst.nc4             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing ensemble average"

./tst_cmp_n3d.py                                                               \
     ../output/MH07B01_TBD/GLDAS_ENS_M_1980-01_2009-12_utc.nc4                 \
     ../output/MH07B01_TBD/GLDAS_ENS_M_1980-01_2009-12_utc_tst.nc4             \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Coupling - Monthly
#*******************************************************************************

#-------------------------------------------------------------------------------
#Create coupling file, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coupling file, ENS"
../src/rrr_cpl_riv_lsm_lnk.py                                                  \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74.csv                           \
     ../output/MH07B01_TBD/rapid_catchment_pfaf_74.csv                         \
     ../output/MH07B01_TBD/GLDAS_ENS_M_1980-01_2009-12_utc.nc4                 \
     ../output/MH07B01_TBD/rapid_coupling_pfaf_74_GLDAS_tst.csv                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coupling file"
./tst_cmp_csv.py                                                               \
     ../output/MH07B01_TBD/rapid_coupling_pfaf_74_GLDAS.csv                    \
     ../output/MH07B01_TBD/rapid_coupling_pfaf_74_GLDAS_tst.csv                \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Create volume file, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating volume file, ENS"
../src/rrr_cpl_riv_lsm_vol.py                                                  \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74.csv                           \
     ../output/MH07B01_TBD/coords_pfaf_74.csv                                  \
     ../output/MH07B01_TBD/GLDAS_ENS_M_1980-01_2009-12_utc.nc4                 \
     ../output/MH07B01_TBD/rapid_coupling_pfaf_74_GLDAS.csv                    \
     ../output/MH07B01_TBD/m3_riv_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_tst.nc4 \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing volume file, ENS"
./tst_cmp_ncf.py                                                               \
     ../output/MH07B01_TBD/m3_riv_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc.nc4  \
     ../output/MH07B01_TBD/m3_riv_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_tst.nc4 \
   > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Update netCDF attributes, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes, ENS"
../src/rrr_cpl_riv_lsm_att.py                                                  \
     ../output/MH07B01_TBD/m3_riv_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc.nc4  \
     'RRR data corresponding to MERIT Hydro 07 Basin 01 pfaf_74, GLDAS ENS'    \
     'Jet Propulsion Laboratory, California Institute of Technology'           \
     ''                                                                        \
     6378137                                                                   \
     298.257222101                                                             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Lumped matrix-based routing
#*******************************************************************************

#-------------------------------------------------------------------------------
#Create lumped matrix-based routing, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating lumped matrix-based routing, ENS"
../src/rrr_cpl_riv_lsm_rte.py                                                  \
     ../output/MH07B01_TBD/m3_riv_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc.nc4  \
     ../output/MH07B01_TBD/rapid_connect_pfaf_74.csv                           \
     ../output/MH07B01_TBD/riv_bas_id_pfaf_74_topo.csv                         \
     ../output/MH07B01_TBD/Qout_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_tst.nc4 \
     ../output/MH07B01_TBD/k_pfaf_74_nrm.csv                                   \
     ../output/MH07B01_TBD/V_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_nrm_tst.nc4 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing lumped matrix-based routing, ENS"
./tst_cmp_ncf.py                                                               \
     ../output/MH07B01_TBD/Qout_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc.nc4    \
     ../output/MH07B01_TBD/Qout_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_tst.nc4 \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing water storage, ENS"
./tst_cmp_ncf.py                                                               \
     ../output/MH07B01_TBD/V_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_nrm.nc4   \
     ../output/MH07B01_TBD/V_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_nrm_tst.nc4 \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Update netCDF attributes, discharge, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes, discharge, ENS"
../src/rrr_cpl_riv_lsm_att.py                                                  \
     ../output/MH07B01_TBD/Qout_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc.nc4    \
     'RRR data corresponding to MERIT Hydro 07 Basin 01 pfaf_74, GLDAS ENS'    \
     'Jet Propulsion Laboratory, California Institute of Technology'           \
     ''                                                                        \
     6378137                                                                   \
     298.257222101                                                             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Update netCDF attributes, volume, ENS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes, volume, ENS"
../src/rrr_cpl_riv_lsm_att.py                                                  \
     ../output/MH07B01_TBD/V_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc_nrm.nc4   \
     'RRR data corresponding to MERIT Hydro 07 Basin 01 pfaf_74, GLDAS ENS'    \
     'Jet Propulsion Laboratory, California Institute of Technology'           \
     ''                                                                        \
     6378137                                                                   \
     298.257222101                                                             \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Creating shapefile with average flow
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating shapefile with average flow"

../src/rrr_anl_shp_avg_riv.py                                                  \
     ../input/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01.shp           \
     ../output/MH07B01_TBD/Qout_pfaf_74_GLDAS_ENS_M_1980-01_2009-12_utc.nc4    \
     ../output/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS_tst.shp \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing shapefile"
./tst_cmp_shp.py                                                               \
     ../output/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp \
     ../output/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS_tst.shp \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Observations
#*******************************************************************************

#-------------------------------------------------------------------------------
#Add mean Q to gauge shapefile
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Add mean Q to gauge shapefile"
../src/rrr_anl_shp_avg_obs.py                                                  \
     ../input/MH07B01_TBD/sites_1980-01_2009-12_100cms.shp                     \
     ../input/MH07B01_TBD/Qobs_1980-01_2009-12_100cms.csv                      \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ_tst.shp          \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing shapefile"
./tst_cmp_shp.py                                                               \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ.shp              \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ_tst.shp          \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Add river ID attribute to gauge shapefile
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Add river ID attribute to gauge shapefile"
../src/rrr_obs_tot_snp.py                                                      \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ.shp              \
     ../output/MH07B01_TBD/riv_pfaf_74_MERIT_Hydro_v07_Basins_v01_GLDAS_ENS.shp\
     0.05                                                                      \
     10                                                                        \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ_pfaf_74_tst.shp  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing shapefile"
./tst_cmp_shp.py                                                               \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ_pfaf_74.shp      \
     ../output/MH07B01_TBD/sites_1980-01_2009-12_100cms_meanQ_pfaf_74_tst.shp  \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
rm -f ../output/MH07B01_TBD/*_tst.*
rm -f ../output/MH07B01_TBD/analysis/*_tst.*


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
