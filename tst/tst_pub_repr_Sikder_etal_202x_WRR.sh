#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Emery_etal_2020_JHM2.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (202x), A Synthetic
#Dataset Inspired by Satellite Altimetry and Impacts of Sampling on Global
#Spaceborne Discharge Characterization.
#DOI: xx.xxxx/xxxxxxxxxx
#The files used are available from:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (202x), Input and
#output files corresponding to "A Synthetic Dataset Inspired by Satellite
#Altimetry and Impacts of Sampling on Global Spaceborne Discharge
#Characterization", Zenodo.
#DOI: 10.5281/zenodo.4064188
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
#M. Safat Sikder and Cedric H. David, 2020-2020


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#N/A


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: https://dx.doi.org/xx.xxxx/xxxxxxxxxx"
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
#Coverage files in .csv and .shp formats
#*******************************************************************************

#-------------------------------------------------------------------------------
#Coverage files for J3J2J1TP_nadir
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for J3J2J1TP_nadir"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/J3J2J1TP_nadir.shp                                     \
     ../output/MERIT_WRR/coverage_J3J2J1TP_nadir_tst.shp                       \
     ../output/MERIT_WRR/seq_J3J2J1TP_nadir_tst.csv                            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_J3J2J1TP_nadir.shp                           \
     ../output/MERIT_WRR/coverage_J3J2J1TP_nadir_tst.shp                       \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_J3J2J1TP_nadir.csv                                \
     ../output/MERIT_WRR/seq_J3J2J1TP_nadir_tst.csv                            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for S3A_nadir
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for S3A_nadir"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/S3A_nadir.shp                                          \
     ../output/MERIT_WRR/coverage_S3A_nadir_tst.shp                            \
     ../output/MERIT_WRR/seq_S3A_nadir_tst.csv                                 \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_S3A_nadir.shp                                \
     ../output/MERIT_WRR/coverage_S3A_nadir_tst.shp                            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_S3A_nadir.csv                                     \
     ../output/MERIT_WRR/seq_S3A_nadir_tst.csv                                 \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for S3A3Bmerged_nadir
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for S3A3Bmerged_nadir"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/S3AS3Bmerged_nadir.shp                                 \
     ../output/MERIT_WRR/coverage_S3A3Bmerged_nadir_tst.shp                    \
     ../output/MERIT_WRR/seq_S3A3Bmerged_nadir_tst.csv                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_S3A3Bmerged_nadir.shp                        \
     ../output/MERIT_WRR/coverage_S3A3Bmerged_nadir_tst.shp                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_S3A3Bmerged_nadir.csv                             \
     ../output/MERIT_WRR/seq_S3A3Bmerged_nadir_tst.csv                         \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for SaralEnv_nadir
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for SaralEnv_nadir"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SaralEnv_nadir.shp                                     \
     ../output/MERIT_WRR/coverage_SaralEnv_nadir_tst.shp                       \
     ../output/MERIT_WRR/seq_SaralEnv_nadir_tst.csv                            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SaralEnv_nadir.shp                           \
     ../output/MERIT_WRR/coverage_SaralEnv_nadir_tst.shp                       \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SaralEnv_nadir.csv                                \
     ../output/MERIT_WRR/seq_SaralEnv_nadir_tst.csv                            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for swot_nadir
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for swot_nadir"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/swot_science_orbit_sept2015-v2_10s_nadir.shp           \
     ../output/MERIT_WRR/coverage_swot_nadir_tst.shp                           \
     ../output/MERIT_WRR/seq_swot_nadir_tst.csv                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_swot_nadir.shp                               \
     ../output/MERIT_WRR/coverage_swot_nadir_tst.shp                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_swot_nadir.csv                                    \
     ../output/MERIT_WRR/seq_swot_nadir_tst.csv                                \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for swot_swath
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for swot_swath"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/swot_science_orbit_sept2015-v2_10s_swath.shp           \
     ../output/MERIT_WRR/coverage_swot_swath_tst.shp                           \
     ../output/MERIT_WRR/seq_swot_swath_tst.csv                                \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_swot_swath_fix.shp                           \
     ../output/MERIT_WRR/coverage_swot_swath_tst.shp                           \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_swot_swath_fix.csv                                \
     ../output/MERIT_WRR/seq_swot_swath_tst.csv                                \
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
rm -f ../output/MERIT_WRR/*_tst.*


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
