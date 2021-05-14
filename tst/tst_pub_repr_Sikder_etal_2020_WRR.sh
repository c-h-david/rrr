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
#M. Safat Sikder and Cedric H. David, 2020-2021


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
#Coverage files for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for TOPJAS"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/TOPJAS.shp                                             \
     ../output/MERIT_WRR/coverage_TOPJAS_tst.shp                               \
     ../output/MERIT_WRR/seq_TOPJAS_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_TOPJAS.shp                                   \
     ../output/MERIT_WRR/coverage_TOPJAS_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_TOPJAS.csv                                        \
     ../output/MERIT_WRR/seq_TOPJAS_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for SENT3A"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SENT3A.shp                                             \
     ../output/MERIT_WRR/coverage_SENT3A_tst.shp                               \
     ../output/MERIT_WRR/seq_SENT3A_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SENT3A.shp                                   \
     ../output/MERIT_WRR/coverage_SENT3A_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SENT3A.csv                                        \
     ../output/MERIT_WRR/seq_SENT3A_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for S3AS3B"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/S3AS3B.shp                                             \
     ../output/MERIT_WRR/coverage_S3AS3B_tst.shp                               \
     ../output/MERIT_WRR/seq_S3AS3B_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_S3AS3B.shp                                   \
     ../output/MERIT_WRR/coverage_S3AS3B_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_S3AS3B.csv                                        \
     ../output/MERIT_WRR/seq_S3AS3B_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for ENVSRL"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/ENVSRL.shp                                             \
     ../output/MERIT_WRR/coverage_ENVSRL_tst.shp                               \
     ../output/MERIT_WRR/seq_ENVSRL_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_ENVSRL.shp                                   \
     ../output/MERIT_WRR/coverage_ENVSRL_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_ENVSRL.csv                                        \
     ../output/MERIT_WRR/seq_ENVSRL_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for SWOT_N"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SWOT_N.shp                                             \
     ../output/MERIT_WRR/coverage_SWOT_N_tst.shp                               \
     ../output/MERIT_WRR/seq_SWOT_N_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SWOT_N.shp                                   \
     ../output/MERIT_WRR/coverage_SWOT_N_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SWOT_N.csv                                        \
     ../output/MERIT_WRR/seq_SWOT_N_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Coverage files for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating coverage files for SWOT_S"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SWOT_S.shp                                             \
     ../output/MERIT_WRR/coverage_SWOT_S_tst.shp                               \
     ../output/MERIT_WRR/seq_SWOT_S_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SWOT_S.shp                                   \
     ../output/MERIT_WRR/coverage_SWOT_S_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SWOT_S.csv                                        \
     ../output/MERIT_WRR/seq_SWOT_S_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Sampling of river discharge simulations for various regular coverage files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sampling for 3D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for 3D"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TIMXXD.csv                                        \
     259200                                                                    \
     ../output/MERIT_WRR/Qout_TIM03D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM03D.nc                                        \
     ../output/MERIT_WRR/Qout_TIM03D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for 5D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for 5D"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TIMXXD.csv                                        \
     432000                                                                    \
     ../output/MERIT_WRR/Qout_TIM05D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM05D.nc                                        \
     ../output/MERIT_WRR/Qout_TIM05D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for 10D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for 10D"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TIMXXD.csv                                        \
     864000                                                                    \
     ../output/MERIT_WRR/Qout_TIM10D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM10D.nc                                        \
     ../output/MERIT_WRR/Qout_TIM10D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for 21D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for 21D"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TIMXXD.csv                                        \
     1814400                                                                   \
     ../output/MERIT_WRR/Qout_TIM21D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM21D.nc                                        \
     ../output/MERIT_WRR/Qout_TIM21D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for 27D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for 27D"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TIMXXD.csv                                        \
     2332800                                                                   \
     ../output/MERIT_WRR/Qout_TIM27D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM27D.nc                                        \
     ../output/MERIT_WRR/Qout_TIM27D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for 35D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for 35D"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TIMXXD.csv                                        \
     3024000                                                                   \
     ../output/MERIT_WRR/Qout_TIM35D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM35D.nc                                        \
     ../output/MERIT_WRR/Qout_TIM35D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Sampling of river discharge simulations for various satellite coverage files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sampling for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for TOPJAS"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_TOPJAS.csv                                        \
     856706.44                                                                 \
     ../output/MERIT_WRR/Qout_TOPJAS_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TOPJAS.nc                                        \
     ../output/MERIT_WRR/Qout_TOPJAS_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SENT3A"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SENT3A.csv                                        \
     2332800.00                                                                \
     ../output/MERIT_WRR/Qout_SENT3A_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SENT3A.nc                                        \
     ../output/MERIT_WRR/Qout_SENT3A_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for S3AS3B"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_S3AS3B.csv                                        \
     2332800.00                                                                \
     ../output/MERIT_WRR/Qout_S3AS3B_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_S3AS3B.nc                                        \
     ../output/MERIT_WRR/Qout_S3AS3B_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for ENVSRL"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_ENVSRL.csv                                        \
     3023999.928                                                               \
     ../output/MERIT_WRR/Qout_ENVSRL_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_ENVSRL.nc                                        \
     ../output/MERIT_WRR/Qout_ENVSRL_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SWOT_N"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SWOT_N.csv                                        \
     1802700.00                                                                \
     ../output/MERIT_WRR/Qout_SWOT_N_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SWOT_N.nc                                        \
     ../output/MERIT_WRR/Qout_SWOT_N_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SWOT_S"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SWOT_S.csv                                        \
     1802700.00                                                                \
     ../output/MERIT_WRR/Qout_SWOT_S_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SWOT_S.nc                                        \
     ../output/MERIT_WRR/Qout_SWOT_S_tst.nc                                    \
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
