#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_2013_EMS.sh
#*******************************************************************************

#Purpose:
#
#Author:
#Cedric H. David, 2017-2020


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: http://dx.doi.org/10.1016/j.envsoft.2012.12.011"
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
     ../input/Reg12_EMS/NHDFlowline.dbf                                        \
     ../input/Reg12_EMS/NHDFlowlineVAA.dbf                                     \
     4                                                                         \
     ../output/Reg12_EMS/rapid_connect_Reg12_tst.csv                           \
     ../output/Reg12_EMS/kfac_Reg12_1km_hour_tst.csv                           \
     ../output/Reg12_EMS/xfac_Reg12_0.1_tst.csv                                \
     ../output/Reg12_EMS/sort_Reg12_hydroseq_tst.csv                           \
     ../output/Reg12_EMS/coords_Reg12_tst.csv                                  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/Reg12_EMS/rapid_connect_Reg12.csv                               \
     ../output/Reg12_EMS/rapid_connect_Reg12_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/Reg12_EMS/kfac_Reg12_1km_hour.csv                               \
     ../output/Reg12_EMS/kfac_Reg12_1km_hour_tst.csv                           \
     1e-15                                                                     \
     1e-10                                                                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/Reg12_EMS/xfac_Reg12_0.1.csv                                    \
     ../output/Reg12_EMS/xfac_Reg12_0.1_tst.csv                                \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/Reg12_EMS/sort_Reg12_hydroseq.csv                               \
     ../output/Reg12_EMS/sort_Reg12_hydroseq_tst.csv                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/Reg12_EMS/coords_Reg12.csv                                      \
     ../output/Reg12_EMS/coords_Reg12_tst.csv                                  \
     1e-11                                                                     \
     1e-10                                                                     \
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
     ../input/Reg12_EMS/NHDFlowline.dbf                                        \
     ../output/Reg12_EMS/rapid_connect_Reg12.csv                               \
     ../output/Reg12_EMS/sort_Reg12_hydroseq.csv                               \
     ../output/Reg12_EMS/basin_id_Reg12_hydroseq_tst.csv                       \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/Reg12_EMS/basin_id_Reg12_hydroseq.csv                           \
     ../output/Reg12_EMS/basin_id_Reg12_hydroseq_tst.csv                       \
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
rm -f ../output/Reg12_EMS/*_tst.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
