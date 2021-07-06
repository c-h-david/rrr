#!/bin/bash
#*******************************************************************************
#tst_pub_repr_Sikder_etal_2021_WRR.sh
#*******************************************************************************

#Purpose:
#This script reproduces all RRR pre- and post-processing steps used in the
#writing of:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (2021), A Synthetic
#Data Set Inspired by Satellite Altimetry and Impacts of Sampling on Global
#Spaceborne Discharge Characterization.
#DOI: 10.1029/2020WR029035
#The files used are available from:
#Sikder, M. Safat, Matthew Bonnema, Charlotte M. Emery, Cédric H. David, Peirong
#Lin, Ming Pan, Sylvain Biancamaria, and Michelle M. Gierach (2021), Input and
#output files corresponding to "A Synthetic Data Set Inspired by Satellite
#Altimetry and Impacts of Sampling on Global Spaceborne Discharge
#Characterization", Zenodo.
#DOI: 10.5281/zenodo.3542269
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
echo "Reproducing files for: https://doi.org/10.1029/2020WR029035"
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
#Sequence and coverage files in .csv and .shp formats
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sequence and coverage files for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence and coverage files for TOPJAS"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/TOPJAS.shp                                             \
     ../output/MERIT_WRR/coverage_TOPJAS_tst.shp                               \
     ../output/MERIT_WRR/seq_TOPJAS_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_TOPJAS_chd.shp                               \
     ../output/MERIT_WRR/coverage_TOPJAS_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_TOPJAS_chd.csv                                    \
     ../output/MERIT_WRR/seq_TOPJAS_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence and coverage files for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence and coverage files for SENT3A"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SENT3A.shp                                             \
     ../output/MERIT_WRR/coverage_SENT3A_tst.shp                               \
     ../output/MERIT_WRR/seq_SENT3A_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SENT3A_chd.shp                               \
     ../output/MERIT_WRR/coverage_SENT3A_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SENT3A_chd.csv                                    \
     ../output/MERIT_WRR/seq_SENT3A_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence and coverage files for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence and coverage files for S3AS3B"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/S3AS3B.shp                                             \
     ../output/MERIT_WRR/coverage_S3AS3B_tst.shp                               \
     ../output/MERIT_WRR/seq_S3AS3B_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_S3AS3B_chd.shp                               \
     ../output/MERIT_WRR/coverage_S3AS3B_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_S3AS3B_chd.csv                                    \
     ../output/MERIT_WRR/seq_S3AS3B_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence and coverage files for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence and coverage files for ENVSRL"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/ENVSRL.shp                                             \
     ../output/MERIT_WRR/coverage_ENVSRL_tst.shp                               \
     ../output/MERIT_WRR/seq_ENVSRL_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_ENVSRL_chd.shp                               \
     ../output/MERIT_WRR/coverage_ENVSRL_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_ENVSRL_chd.csv                                    \
     ../output/MERIT_WRR/seq_ENVSRL_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence and coverage files for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence and coverage files for SWOT_N"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SWOT_N.shp                                             \
     ../output/MERIT_WRR/coverage_SWOT_N_tst.shp                               \
     ../output/MERIT_WRR/seq_SWOT_N_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SWOT_N_chd.shp                               \
     ../output/MERIT_WRR/coverage_SWOT_N_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SWOT_N_chd.csv                                    \
     ../output/MERIT_WRR/seq_SWOT_N_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence and coverage files for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence and coverage files for SWOT_S"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms.shp                             \
     ../input/MERIT_WRR/SWOT_S.shp                                             \
     ../output/MERIT_WRR/coverage_SWOT_S_tst.shp                               \
     ../output/MERIT_WRR/seq_SWOT_S_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing coverage file (.shp)"
./tst_cmp_shp.py                                                               \
     ../output/MERIT_WRR/coverage_SWOT_S_chd.shp                               \
     ../output/MERIT_WRR/coverage_SWOT_S_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SWOT_S_chd.csv                                    \
     ../output/MERIT_WRR/seq_SWOT_S_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Sequence files in .csv formats
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sequence file for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPATPJ"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_TOPJAS_chd.csv                                    \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPATPJ_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPATPJ_chd.csv                                    \
     ../output/MERIT_WRR/seq_SPATPJ_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence file for SPAS3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPAS3A"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_SENT3A_chd.csv                                    \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPAS3A_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPAS3A_chd.csv                                    \
     ../output/MERIT_WRR/seq_SPAS3A_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence file for SPA3AB
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPA3AB"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_S3AS3B_chd.csv                                    \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPA3AB_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPA3AB_chd.csv                                    \
     ../output/MERIT_WRR/seq_SPA3AB_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence file for SPAEVS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPAEVS"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_ENVSRL_chd.csv                                    \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPAEVS_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPAEVS_chd.csv                                    \
     ../output/MERIT_WRR/seq_SPAEVS_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence file for SPASWN
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPASWN"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_SWOT_N_chd.csv                                    \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPASWN_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPASWN_chd.csv                                    \
     ../output/MERIT_WRR/seq_SPASWN_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sequence file for SPASWS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPASWS"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_SWOT_S_chd.csv                                    \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPASWS_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPASWS_chd.csv                                    \
     ../output/MERIT_WRR/seq_SPASWS_tst.csv                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Sampling river discharge simulations for multiple temporal sampling sequences
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
     ../output/MERIT_WRR/seq_TIM03D_chd.csv                                    \
     259200                                                                    \
     ../output/MERIT_WRR/Qout_TIM03D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM03D_chd.nc                                    \
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
     ../output/MERIT_WRR/seq_TIM05D_chd.csv                                    \
     432000                                                                    \
     ../output/MERIT_WRR/Qout_TIM05D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM05D_chd.nc                                    \
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
     ../output/MERIT_WRR/seq_TIM10D_chd.csv                                    \
     864000                                                                    \
     ../output/MERIT_WRR/Qout_TIM10D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM10D_chd.nc                                    \
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
     ../output/MERIT_WRR/seq_TIM21D_chd.csv                                    \
     1814400                                                                   \
     ../output/MERIT_WRR/Qout_TIM21D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM21D_chd.nc                                    \
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
     ../output/MERIT_WRR/seq_TIM27D_chd.csv                                    \
     2332800                                                                   \
     ../output/MERIT_WRR/Qout_TIM27D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM27D_chd.nc                                    \
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
     ../output/MERIT_WRR/seq_TIM35D_chd.csv                                    \
     3024000                                                                   \
     ../output/MERIT_WRR/Qout_TIM35D_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_TIM35D_chd.nc                                    \
     ../output/MERIT_WRR/Qout_TIM35D_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Sampling river discharge simulations for multiple spatial sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sampling for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPATPJ"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPATPJ_chd.csv                                    \
     86400                                                                     \
     ../output/MERIT_WRR/Qout_SPATPJ_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SPATPJ_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SPATPJ_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SPAS3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPAS3A"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPAS3A_chd.csv                                    \
     86400                                                                     \
     ../output/MERIT_WRR/Qout_SPAS3A_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SPAS3A_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SPAS3A_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SPA3AB
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPA3AB"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPA3AB_chd.csv                                    \
     86400                                                                     \
     ../output/MERIT_WRR/Qout_SPA3AB_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SPA3AB_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SPA3AB_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SPAEVS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPAEVS"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPAEVS_chd.csv                                    \
     86400                                                                     \
     ../output/MERIT_WRR/Qout_SPAEVS_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SPAEVS_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SPAEVS_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SPASWN
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPASWN"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPASWN_chd.csv                                    \
     86400                                                                     \
     ../output/MERIT_WRR/Qout_SPASWN_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SPASWN_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SPASWN_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Sampling for SPASWS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPASWS"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPASWS_chd.csv                                    \
     86400                                                                     \
     ../output/MERIT_WRR/Qout_SPASWS_tst.nc                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sampled netCDF"
./tst_cmp_ncf.py                                                               \
     ../output/MERIT_WRR/Qout_SPASWS_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SPASWS_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Sampling river discharge simulations for multiple satellite sampling sequences
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
#Analyzing magnitude metrics for reference
#*******************************************************************************
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for GRADES"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     75                                                                        \
     GRADES                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing magnitude metrics for multiple temporal sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TIM03D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM03D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM03D.nc                                        \
     75                                                                        \
     TIM03D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TIM05D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM05D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM05D.nc                                        \
     75                                                                        \
     TIM05D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TIM10D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM10D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM10D.nc                                        \
     75                                                                        \
     TIM10D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TIM21D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM21D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM21D.nc                                        \
     75                                                                        \
     TIM21D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TIM27D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM27D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM27D.nc                                        \
     75                                                                        \
     TIM27D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TIM35D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM35D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM35D.nc                                        \
     75                                                                        \
     TIM35D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing magnitude metrics for multiple spatial sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPATPJ"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPATPJ.nc                                        \
     75                                                                        \
     SPATPJ                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SPAS3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPAS3A"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPAS3A.nc                                        \
     75                                                                        \
     SPAS3A                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SPA3AB
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPA3AB"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPA3AB.nc                                        \
     75                                                                        \
     SPA3AB                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SPAEVS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPAEVS"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPAEVS.nc                                        \
     75                                                                        \
     SPAEVS                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SPASWN
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPASWN"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPASWN.nc                                        \
     75                                                                        \
     SPASWN                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SPASWS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPASWS"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPASWS.nc                                        \
     75                                                                        \
     SPASWS                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing magnitude metrics for multiple satellite sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TOPJAS"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TOPJAS.nc                                        \
     75                                                                        \
     TOPJAS                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SENT3A"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SENT3A.nc                                        \
     75                                                                        \
     SENT3A                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for S3AS3B"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_S3AS3B.nc                                        \
     75                                                                        \
     S3AS3B                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for ENVSRL"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_ENVSRL.nc                                        \
     75                                                                        \
     ENVSRL                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SWOT_N"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SWOT_N.nc                                        \
     75                                                                        \
     SWOT_N                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing magnitude metrics for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$lst"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SWOT_S"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SWOT_S.nc                                        \
     75                                                                        \
     SWOT_S                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_tst.csv                   \
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
rm -f ../output/MERIT_WRR/analysis/*_tst.*


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
