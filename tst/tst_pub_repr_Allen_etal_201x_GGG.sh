#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Allen_etal_201x_GGG.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#Allen, George H., et al. (201x)
#xxx
#DOI: xx.xxxx/xxxxxx
#The files used are available from:
#Allen, George H., et al. (201x)
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
#George H. Allen, Cedric H. David, 2017-2018


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
#Extracting study domain
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Extracting study domain"
../src/rrr_riv_tot_ext_bas_hydrosheds.py                                       \
     ../input/HydroSHEDS/as_bas_15s_beta.shp                                   \
     [218033,225914,405068]                                                    \
     ../input/HydroSHEDS/as_riv_15s.shp                                        \
     ../output/MIGBM_GGG/bas_MIGBM_tst.shp                                     \
     ../output/MIGBM_GGG/riv_MIGBM_tst.shp                                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing basin file"
./tst_cmp_shp.py                                                               \
     ../output/MIGBM_GGG/bas_MIGBM.shp                                         \
     ../output/MIGBM_GGG/bas_MIGBM_tst.shp                                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing river file"
./tst_cmp_shp.py                                                               \
     ../output/MIGBM_GGG/riv_MIGBM.shp                                         \
     ../output/MIGBM_GGG/riv_MIGBM_tst.shp                                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Connectivity, base parameters, coordinates, sort
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating all domain files"
../src/rrr_riv_tot_gen_all_hydrosheds.py                                       \
     ../output/MIGBM_GGG/riv_MIGBM.shp                                         \
     4                                                                         \
     esri:102025                                                               \
     ../output/MIGBM_GGG/rapid_connect_MIGBM_tst.csv                           \
     ../output/MIGBM_GGG/kfac_MIGBM_1km_hour_tst.csv                           \
     ../output/MIGBM_GGG/xfac_MIGBM_0.1_tst.csv                                \
     ../output/MIGBM_GGG/sort_MIGBM_topo_tst.csv                               \
     ../output/MIGBM_GGG/coords_MIGBM_tst.csv                                  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/rapid_connect_MIGBM.csv                               \
     ../output/MIGBM_GGG/rapid_connect_MIGBM_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/kfac_MIGBM_1km_hour.csv                               \
     ../output/MIGBM_GGG/kfac_MIGBM_1km_hour_tst.csv                           \
     1e-6                                                                      \
     1e-1                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/xfac_MIGBM_0.1.csv                                    \
     ../output/MIGBM_GGG/xfac_MIGBM_0.1_tst.csv                                \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/sort_MIGBM_topo.csv                                   \
     ../output/MIGBM_GGG/sort_MIGBM_topo_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/coords_MIGBM.csv                                      \
     ../output/MIGBM_GGG/coords_MIGBM_tst.csv                                  \
     1e-10                                                                     \
     1e-8                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters 0
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_0 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/MIGBM_GGG/kfac_MIGBM_1km_hour.csv                               \
     ../output/MIGBM_GGG/xfac_MIGBM_0.1.csv                                    \
     0.2                                                                       \
     3                                                                         \
     ../output/MIGBM_GGG/k_MIGBM_scl_tst.csv                                   \
     ../output/MIGBM_GGG/x_MIGBM_scl_tst.csv                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_0 files"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/k_MIGBM_scl.csv                                       \
     ../output/MIGBM_GGG/k_MIGBM_scl_tst.csv                                   \
     1e-6                                                                      \
     2e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_0 files"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/x_MIGBM_scl.csv                                       \
     ../output/MIGBM_GGG/x_MIGBM_scl_tst.csv                                   \
     1e-6                                                                      \
     2e-2                                                                      \
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
../src/rrr_riv_bas_gen_one_hydrosheds.py                                       \
     ../output/MIGBM_GGG/riv_MIGBM.shp                                         \
     ../output/MIGBM_GGG/rapid_connect_MIGBM.csv                               \
     ../output/MIGBM_GGG/sort_MIGBM_topo.csv                                   \
     ../output/MIGBM_GGG/riv_bas_id_MIGBM_topo_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/riv_bas_id_MIGBM_topo.csv                             \
     ../output/MIGBM_GGG/riv_bas_id_MIGBM_topo_tst.csv                         \
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
../src/rrr_cat_tot_gen_one_hydrosheds.py                                       \
     ../input/HydroSHEDS/as_riv_15s.dbf                                        \
     ../output/MIGBM_GGG/rapid_catchment_as_riv_15s_tst.csv                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/MIGBM_GGG/rapid_catchment_as_riv_15s.csv                        \
     ../output/MIGBM_GGG/rapid_catchment_as_riv_15s_tst.csv                    \
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
#Clean up
#*******************************************************************************
rm -f ../output/MIGBM_GGG/*_tst.*


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
