#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_202x_MIP.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#David, Cédric H., et al. (202x)
#DOI: xx.xxxx/xxxxxxxxxxxx
#The files used are available from:
#David, Cédric H., et al. (202x)
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
#Cedric H. David, 2020-2020


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#N/A


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing results of:   http://dx.doi.org/xx.xxxx/xxxxxxxxxxxx"
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
../src/rrr_riv_tot_gen_all_hydrosheds.py                                       \
     ../input/HSmsp_MIP/riv_HSmsp.shp                                          \
     4                                                                         \
     esri:102008                                                               \
     ../output/HSmsp_MIP/rapid_connect_HSmsp_tst.csv                           \
     ../output/HSmsp_MIP/kfac_HSmsp_1km_hour_tst.csv                           \
     ../output/HSmsp_MIP/xfac_HSmsp_0.1_tst.csv                                \
     ../output/HSmsp_MIP/sort_HSmsp_topo_tst.csv                               \
     ../output/HSmsp_MIP/coords_HSmsp_tst.csv                                  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     ../output/HSmsp_MIP/rapid_connect_HSmsp_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/kfac_HSmsp_1km_hour.csv                               \
     ../output/HSmsp_MIP/kfac_HSmsp_1km_hour_tst.csv                           \
     1e-6                                                                      \
     1e-1                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/xfac_HSmsp_0.1.csv                                    \
     ../output/HSmsp_MIP/xfac_HSmsp_0.1_tst.csv                                \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/sort_HSmsp_topo.csv                                   \
     ../output/HSmsp_MIP/sort_HSmsp_topo_tst.csv                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/coords_HSmsp.csv                                      \
     ../output/HSmsp_MIP/coords_HSmsp_tst.csv                                  \
     1e-11                                                                     \
     1e-9                                                                      \
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
     ../input/HSmsp_MIP/riv_HSmsp.shp                                          \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     ../output/HSmsp_MIP/sort_HSmsp_topo.csv                                   \
     ../output/HSmsp_MIP/riv_bas_id_HSmsp_topo_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_HSmsp_topo.csv                             \
     ../output/HSmsp_MIP/riv_bas_id_HSmsp_topo_tst.csv                         \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=231083
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=231083 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     231083                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_231083_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_231083_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_231083_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_231083_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_231083_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_231083_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=266984
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=266984 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     266984                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_266984_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_266984_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_266984_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_266984_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_266984_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_266984_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=328965
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=328965 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     328965                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_328965_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_328965_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_328965_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_328965_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_328965_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_328965_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=339344
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=339344 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     339344                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_339344_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_339344_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_339344_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_339344_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_339344_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_339344_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=341237
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=341237 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     341237                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_341237_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_341237_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_341237_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_341237_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_341237_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_341237_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=363260
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=363260 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     363260                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_363260_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_363260_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_363260_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_363260_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_363260_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_363260_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=367121
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=367121 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     367121                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_367121_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_367121_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_367121_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_367121_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_367121_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_367121_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=368199
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=368199 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     368199                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_368199_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_368199_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_368199_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_368199_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_368199_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_368199_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=373295
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=373295 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     373295                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_373295_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_373295_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_373295_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_373295_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_373295_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_373295_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=389189
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=389189 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     389189                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_389189_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_389189_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_389189_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_389189_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_389189_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_389189_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=389491
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=389491 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     389491                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_389491_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_389491_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_389491_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_389491_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_389491_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_389491_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=407204
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=407204 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     407204                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_407204_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_407204_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_407204_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_407204_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_407204_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_407204_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=420653
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=420653 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     420653                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_420653_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_420653_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_420653_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_420653_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_420653_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_420653_ups_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Tracing downstream/upstream: rivid=440065
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Tracing downstream/upstream: rivid=440065 - all reaches"
../src/rrr_riv_tot_net_nav.py                                                  \
     ../output/HSmsp_MIP/rapid_connect_HSmsp.csv                               \
     1000                                                                      \
     440065                                                                    \
     ../output/HSmsp_MIP/riv_bas_id_440065_dwn_all_tst.csv                     \
     ../output/HSmsp_MIP/riv_bas_id_440065_ups_all_tst.csv                     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing downstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_440065_dwn_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_440065_dwn_all_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing upstream"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/riv_bas_id_440065_ups_all.csv                         \
     ../output/HSmsp_MIP/riv_bas_id_440065_ups_all_tst.csv                     \
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
     ../input/HSmsp_MIP/riv_HSmsp.dbf                                          \
     ../output/HSmsp_MIP/rapid_catchment_HSmsp_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing catchment file"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/rapid_catchment_HSmsp.csv                             \
     ../output/HSmsp_MIP/rapid_catchment_HSmsp_tst.csv                         \
     1e-11                                                                     \
     1e-9                                                                     \
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
#Concatenating multiple files - Monthly - MOS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Concatenating multiple files - Monthly - MOS"

../src/rrr_lsm_tot_cmb_acc.sh                                                  \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2000/NLDAS_MOS0125_M.A2000*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2001/NLDAS_MOS0125_M.A2001*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2002/NLDAS_MOS0125_M.A2002*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2003/NLDAS_MOS0125_M.A2003*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2004/NLDAS_MOS0125_M.A2004*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2005/NLDAS_MOS0125_M.A2005*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2006/NLDAS_MOS0125_M.A2006*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2007/NLDAS_MOS0125_M.A2007*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2008/NLDAS_MOS0125_M.A2008*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_MOS0125_M.002/2009/NLDAS_MOS0125_M.A2009*.002.grb.SUB.nc4 \
     1                                                                         \
     ../output/HSmsp_MIP/NLDAS_MOS0125_M_20000101_20091231_utc_tst.nc4         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Making concatenated file CF compliant - Monthly - MOS"

../src/rrr_lsm_tot_add_cfc.py                                                  \
     ../output/HSmsp_MIP/NLDAS_MOS0125_M_20000101_20091231_utc_tst.nc4         \
     2000-01-01T00:00:00                                                       \
     2628000                                                                   \
     1                                                                         \
     ../output/HSmsp_MIP/NLDAS_MOS0125_M_20000101_20091231_utc_cfc_tst.nc4     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing concatenated file CF compliant - Monthly - MOS"

./tst_cmp_n3d.py                                                               \
     ../output/HSmsp_MIP/NLDAS_MOS0125_M_20000101_20091231_utc_cfc.nc4         \
     ../output/HSmsp_MIP/NLDAS_MOS0125_M_20000101_20091231_utc_cfc_tst.nc4     \
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
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Concatenating multiple files - Monthly - NOAH"

../src/rrr_lsm_tot_cmb_acc.sh                                                  \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2000/NLDAS_NOAH0125_M.A2000*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2001/NLDAS_NOAH0125_M.A2001*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2002/NLDAS_NOAH0125_M.A2002*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2003/NLDAS_NOAH0125_M.A2003*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2004/NLDAS_NOAH0125_M.A2004*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2005/NLDAS_NOAH0125_M.A2005*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2006/NLDAS_NOAH0125_M.A2006*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2007/NLDAS_NOAH0125_M.A2007*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2008/NLDAS_NOAH0125_M.A2008*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_NOAH0125_M.002/2009/NLDAS_NOAH0125_M.A2009*.002.grb.SUB.nc4 \
     1                                                                         \
     ../output/HSmsp_MIP/NLDAS_NOAH0125_M_20000101_20091231_utc_tst.nc4        \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Making concatenated file CF compliant - Monthly - NOAH"

../src/rrr_lsm_tot_add_cfc.py                                                  \
     ../output/HSmsp_MIP/NLDAS_NOAH0125_M_20000101_20091231_utc_tst.nc4        \
     2000-01-01T00:00:00                                                       \
     2628000                                                                   \
     1                                                                         \
     ../output/HSmsp_MIP/NLDAS_NOAH0125_M_20000101_20091231_utc_cfc_tst.nc4    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing concatenated file CF compliant - Monthly - NOAH"

./tst_cmp_n3d.py                                                               \
     ../output/HSmsp_MIP/NLDAS_NOAH0125_M_20000101_20091231_utc_cfc.nc4        \
     ../output/HSmsp_MIP/NLDAS_NOAH0125_M_20000101_20091231_utc_cfc_tst.nc4    \
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
echo "Running unit test $unt/99"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Concatenating multiple files - Monthly - VIC"

../src/rrr_lsm_tot_cmb_acc.sh                                                  \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2000/NLDAS_VIC0125_M.A2000*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2001/NLDAS_VIC0125_M.A2001*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2002/NLDAS_VIC0125_M.A2002*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2003/NLDAS_VIC0125_M.A2003*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2004/NLDAS_VIC0125_M.A2004*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2005/NLDAS_VIC0125_M.A2005*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2006/NLDAS_VIC0125_M.A2006*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2007/NLDAS_VIC0125_M.A2007*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2008/NLDAS_VIC0125_M.A2008*.002.grb.SUB.nc4 \
     ../input/NLDAS/NLDAS_VIC0125_M.002/2009/NLDAS_VIC0125_M.A2009*.002.grb.SUB.nc4 \
     1                                                                         \
     ../output/HSmsp_MIP/NLDAS_VIC0125_M_20000101_20091231_utc_tst.nc4         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Making concatenated file CF compliant - Monthly - VIC"

../src/rrr_lsm_tot_add_cfc.py                                                  \
     ../output/HSmsp_MIP/NLDAS_VIC0125_M_20000101_20091231_utc_tst.nc4         \
     2000-01-01T00:00:00                                                       \
     2628000                                                                   \
     1                                                                         \
     ../output/HSmsp_MIP/NLDAS_VIC0125_M_20000101_20091231_utc_cfc_tst.nc4     \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing concatenated file CF compliant - Monthly - VIC"

./tst_cmp_n3d.py                                                               \
     ../output/HSmsp_MIP/NLDAS_VIC0125_M_20000101_20091231_utc_cfc.nc4         \
     ../output/HSmsp_MIP/NLDAS_VIC0125_M_20000101_20091231_utc_cfc_tst.nc4     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Process Land surface model (LSM) data - hourly
#*******************************************************************************

#-------------------------------------------------------------------------------
#Concatenating multiple files - hourly - VIC
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/39"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

#echo "- Concatenating multiple files - hourly - VIC"
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2000/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20000101_20001231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2001/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20010101_20011231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2002/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20020101_20021231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2003/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20030101_20031231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2004/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20040101_20041231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2005/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20050101_20051231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2006/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20060101_20061231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2007/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20070101_20071231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2008/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20080101_20081231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_cmb_acc.sh                                                  \
#     ../input/NLDAS/NLDAS_VIC0125_H.002/2009/*/NLDAS_VIC0125_H.A*.002.grb.SUB.nc4 \
#     24                                                                        \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20090101_20091231_utc_tst.nc4         \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi




#echo "- Making concatenated file CF compliant - hourly - VIC"
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20000101_20001231_utc_tst.nc4         \
#     2000-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20000101_20001231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20010101_20011231_utc_tst.nc4         \
#     2001-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20010101_20011231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20020101_20021231_utc_tst.nc4         \
#     2002-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20020101_20021231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20030101_20031231_utc_tst.nc4         \
#     2003-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20030101_20031231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20040101_20041231_utc_tst.nc4         \
#     2004-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20040101_20041231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20050101_20051231_utc_tst.nc4         \
#     2005-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20050101_20051231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20060101_20061231_utc_tst.nc4         \
#     2006-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20060101_20061231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20070101_20071231_utc_tst.nc4         \
#     2007-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20070101_20071231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20080101_20081231_utc_tst.nc4         \
#     2008-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20080101_20081231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi
#
#../src/rrr_lsm_tot_add_cfc.py                                                  \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20090101_20091231_utc_tst.nc4         \
#     2009-01-01T00:00:00                                                       \
#     86400                                                                      \
#     1                                                                         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_D_20090101_20091231_utc_cfc_tst.nc4     \
#     > $run_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi


#time ncrcat -h NLDAS_VIC0125_D_200* NLDAS_VIC0125_D_20000101_20091231_utc_cfc.nc4
#time ncrcat -h NLDAS_VIC0125_3H_200* NLDAS_VIC0125_3H_20000101_20091231_utc_cfc.nc4
#time ncrcat -h NLDAS_VIC0125_H_200* NLDAS_VIC0125_H_20000101_20091231_utc_cfc.nc4


#echo "- Comparing concatenated file CF compliant - hourly - VIC"
#
#./tst_cmp_n3d.py                                                               \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_H_20000101_20091231_utc_cfc.nc4         \
#     ../output/HSmsp_MIP/NLDAS_VIC0125_H_20000101_20091231_utc_cfc_tst.nc4     \
#     1e-7                                                                      \
#     1e-6                                                                      \
#     > $cmp_file
#x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

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
     ../input/HSmsp_MIP/obs_HSmsp.shp                                          \
     2000-01-01                                                                \
     2009-12-31                                                                \
     ../output/HSmsp_MIP/obs_tot_id_HSmsp_2000_2009_full_tst.csv               \
     ../output/HSmsp_MIP/Qobs_HSmsp_2000_2009_full_tst.csv                     \
     ../output/HSmsp_MIP/obs_HSmsp_2000_2009_full_tst.shp                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing gauges"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/obs_tot_id_HSmsp_2000_2009_full.csv                   \
     ../output/HSmsp_MIP/obs_tot_id_HSmsp_2000_2009_full_tst.csv               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing shapefiles"
./tst_cmp_shp.py                                                               \
     ../output/HSmsp_MIP/obs_HSmsp_2000_2009_full.shp                          \
     ../output/HSmsp_MIP/obs_HSmsp_2000_2009_full_tst.shp                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing observed flows"
./tst_cmp_csv.py                                                               \
     ../output/HSmsp_MIP/Qobs_HSmsp_2000_2009_full.csv                         \
     ../output/HSmsp_MIP/Qobs_HSmsp_2000_2009_full_tst.csv                     \
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
rm -f ../output/HSmsp_MIP/*_tst.csv
#rm -f ../output/HSmsp_MIP/*_tst.nc4
rm -f ../output/HSmsp_MIP/analysis/*_tst*.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
