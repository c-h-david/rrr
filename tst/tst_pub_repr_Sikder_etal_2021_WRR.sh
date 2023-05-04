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
#DOI: 10.5281/zenodo.5516592
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
#M. Safat Sikder and Cedric H. David, 2020-2023


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
tot=119
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
#Sequence and coverage files in .csv and .shp formats
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sequence and coverage files for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/coverage_TOPJAS.shp                                   \
     ../output/MERIT_WRR/coverage_TOPJAS_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
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
#Sequence and coverage files for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/coverage_SENT3A.shp                                   \
     ../output/MERIT_WRR/coverage_SENT3A_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
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
#Sequence and coverage files for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/coverage_S3AS3B.shp                                   \
     ../output/MERIT_WRR/coverage_S3AS3B_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
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
#Sequence and coverage files for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/coverage_ENVSRL.shp                                   \
     ../output/MERIT_WRR/coverage_ENVSRL_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
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
#Sequence and coverage files for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/coverage_SWOT_N.shp                                   \
     ../output/MERIT_WRR/coverage_SWOT_N_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
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
#Sequence and coverage files for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/coverage_SWOT_S.shp                                   \
     ../output/MERIT_WRR/coverage_SWOT_S_tst.shp                               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
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
#Sequence files in .csv formats
#*******************************************************************************

#-------------------------------------------------------------------------------
#Sequence file for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPATPJ"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_TOPJAS.csv                                        \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPATPJ_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPATPJ.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPAS3A"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_SENT3A.csv                                        \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPAS3A_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPAS3A.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPA3AB"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_S3AS3B.csv                                        \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPA3AB_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPA3AB.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPAEVS"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_ENVSRL.csv                                        \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPAEVS_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPAEVS.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPASWN"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_SWOT_N.csv                                        \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPASWN_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPASWN.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating sequence file for SPASWS"
../src/rrr_anl_spl_csv.py                                                      \
     ../output/MERIT_WRR/seq_SWOT_S.csv                                        \
     0.0                                                                       \
     ../output/MERIT_WRR/seq_SPASWS_tst.csv                                    \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sequence file (.csv)"
diff                                                                           \
     ../output/MERIT_WRR/seq_SPASWS.csv                                        \
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
echo "Running unit test $unt/$tot"
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
echo "Running unit test $unt/$tot"
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
echo "Running unit test $unt/$tot"
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
echo "Running unit test $unt/$tot"
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
echo "Running unit test $unt/$tot"
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
echo "Running unit test $unt/$tot"
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPATPJ"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPATPJ.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPAS3A"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPAS3A.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPA3AB"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPA3AB.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPAEVS"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPAEVS.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPASWN"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPASWN.csv                                        \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Sampling for SPASWS"
../src/rrr_anl_spl_mod.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/seq_SPASWS.csv                                        \
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
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/Qout_TOPJAS_chd.nc                                    \
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
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/Qout_SENT3A_chd.nc                                    \
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
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/Qout_S3AS3B_chd.nc                                    \
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
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/Qout_ENVSRL_chd.nc                                    \
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
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/Qout_SWOT_N_chd.nc                                    \
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
echo "Running unit test $unt/$tot"
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
     ../output/MERIT_WRR/Qout_SWOT_S_chd.nc                                    \
     ../output/MERIT_WRR/Qout_SWOT_S_tst.nc                                    \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Updating netCDF attributes for all sampling experiments
#*******************************************************************************

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TIM03D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TIM03D"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TIM03D_chd.nc                                      \
   'GRADES - Large Rivers - Sampled every 03 days'                             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TIM05D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TIM05D"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TIM05D_chd.nc                                      \
   'GRADES - Large Rivers - Sampled every 05 days'                             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TIM10D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TIM10D"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TIM10D_chd.nc                                      \
   'GRADES - Large Rivers - Sampled every 10 days'                             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TIM21D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TIM21D"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TIM21D_chd.nc                                      \
   'GRADES - Large Rivers - Sampled every 21 days'                             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TIM27D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TIM27D"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TIM27D_chd.nc                                      \
   'GRADES - Large Rivers - Sampled every 27 days'                             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TIM35D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TIM35D"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TIM35D_chd.nc                                      \
   'GRADES - Large Rivers - Sampled every 35 days'                             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SPATPJ"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SPATPJ_chd.nc                                      \
   'GRADES - Large Rivers - Sampled daily following TOPEX & Jason groundtracks'\
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SPAS3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SPAS3A"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SPAS3A_chd.nc                                      \
   'GRADES - Large Rivers - Sampled daily following Sentinel 3A groundtracks'  \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SPA3AB
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SPA3AB"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SPA3AB_chd.nc                                      \
   'GRADES - Large Rivers - Sampled daily following Sentinel 3A/3B groundtracks'\
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SPAEVS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SPAEVS"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SPAEVS_chd.nc                                      \
   'GRADES - Large Rivers - Sampled daily following ENVISAT & SARAL groundtracks'\
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SPASWN
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SPASWN"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SPASWN_chd.nc                                      \
   'GRADES - Large Rivers - Sampled daily following SWOT nadir groundtracks'   \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SPASWS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SPASWS"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SPASWS_chd.nc                                      \
   'GRADES - Large Rivers - Sampled daily following SWOT swath groundtracks'\
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for TOPJAS"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_TOPJAS_chd.nc                                      \
   'GRADES - Large Rivers - Sampled following TOPEX & Jason orbit'             \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SENT3A"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SENT3A_chd.nc                                      \
   'GRADES - Large Rivers - Sampled following Sentinel 3A orbit'               \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for S3AS3B"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_S3AS3B_chd.nc                                      \
   'GRADES - Large Rivers - Sampled following Sentinel 3A/3B orbit'            \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for ENVSRL"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_ENVSRL_chd.nc                                      \
   'GRADES - Large Rivers - Sampled following ENVISAT & SARAL orbit'           \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SWOT_N"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SWOT_N_chd.nc                                      \
   'GRADES - Large Rivers - Sampled following SWOT nadir orbit'                \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Updating netCDF attributes for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Updating netCDF attributes for SWOT_S"
../src/rrr_cpl_riv_lsm_att.py                                                  \
   ../output/MERIT_WRR/Qout_SWOT_S_chd.nc                                      \
   'GRADES - Large Rivers - Sampled following SWOT swath orbit'                \
   'Jet Propulsion Laboratory, California Institute of Technology'             \
   ''                                                                          \
   ''                                                                          \
   ''                                                                          \
   > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing magnitude metrics for reference
#*******************************************************************************
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
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
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM03D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM03D_chd.nc                                    \
     75                                                                        \
     TIM03D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM05D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM05D_chd.nc                                    \
     75                                                                        \
     TIM05D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM10D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM10D_chd.nc                                    \
     75                                                                        \
     TIM10D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM21D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM21D_chd.nc                                    \
     75                                                                        \
     TIM21D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM27D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM27D_chd.nc                                    \
     75                                                                        \
     TIM27D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TIM35D"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM35D_chd.nc                                    \
     75                                                                        \
     TIM35D                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPATPJ"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPATPJ_chd.nc                                    \
     75                                                                        \
     SPATPJ                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPAS3A"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPAS3A_chd.nc                                    \
     75                                                                        \
     SPAS3A                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPA3AB"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPA3AB_chd.nc                                    \
     75                                                                        \
     SPA3AB                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPAEVS"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPAEVS_chd.nc                                    \
     75                                                                        \
     SPAEVS                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPASWN"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPASWN_chd.nc                                    \
     75                                                                        \
     SPASWN                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SPASWS"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPASWS_chd.nc                                    \
     75                                                                        \
     SPASWS                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for TOPJAS"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TOPJAS_chd.nc                                    \
     75                                                                        \
     TOPJAS                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SENT3A"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SENT3A_chd.nc                                    \
     75                                                                        \
     SENT3A                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for S3AS3B"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_S3AS3B_chd.nc                                    \
     75                                                                        \
     S3AS3B                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for ENVSRL"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_ENVSRL_chd.nc                                    \
     75                                                                        \
     ENVSRL                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SWOT_N"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SWOT_N_chd.nc                                    \
     75                                                                        \
     SWOT_N                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
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
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing magnitude metrics for SWOT_S"
../src/rrr_anl_map_mag_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SWOT_S_chd.nc                                    \
     75                                                                        \
     SWOT_S                                                                    \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing magnitude metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_tst.csv                   \
     1e-3                                                                      \
     2e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing event metrics for reference
#*******************************************************************************
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for GRADES"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing event metrics for multiple temporal sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Analyzing event metrics for TIM03D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TIM03D"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM03D_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM03D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TIM03D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM03D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for TIM05D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TIM05D"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM05D_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM05D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TIM05D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM05D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for TIM10D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TIM10D"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM10D_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM10D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TIM10D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM10D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for TIM21D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TIM21D"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM21D_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM21D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TIM21D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM21D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for TIM27D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TIM27D"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM27D_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM27D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TIM27D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM27D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for TIM35D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TIM35D"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TIM35D_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM35D_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TIM35D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM35D_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing event metrics for multiple spatial sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Analyzing event metrics for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SPATPJ"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPATPJ_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPATPJ_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SPATPJ_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPATPJ_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SPAS3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SPAS3A"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPAS3A_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPAS3A_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SPAS3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPAS3A_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SPA3AB
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SPA3AB"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPA3AB_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPA3AB_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SPA3AB_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPA3AB_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SPAEVS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SPAEVS"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPAEVS_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPAEVS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SPAEVS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPAEVS_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SPASWN
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SPASWN"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPASWN_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPASWN_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SPASWN_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPASWN_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SPASWS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SPASWS"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SPASWS_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPASWS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SPASWS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SPASWS_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Analyzing event metrics for multiple satellite sampling sequences
#*******************************************************************************

#-------------------------------------------------------------------------------
#Analyzing event metrics for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for TOPJAS"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_TOPJAS_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TOPJAS_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_TOPJAS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TOPJAS_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SENT3A"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SENT3A_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SENT3A_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SENT3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SENT3A_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for S3AS3B"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_S3AS3B_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_S3AS3B_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_S3AS3B_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_S3AS3B_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for ENVSRL"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_ENVSRL_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_ENVSRL_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_ENVSRL_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_ENVSRL_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SWOT_N"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SWOT_N_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_N_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_N_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_N_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Analyzing event metrics for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Analyzing event metrics for SWOT_S"
../src/rrr_anl_map_evt_mod.py                                                  \
     ../output/MERIT_WRR/Qout_SWOT_S_chd.nc                                    \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_S_75p_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing event metrics"
./tst_cmp_csv.py                                                               \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_S_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_S_75p_tst.csv                   \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Figures
#*******************************************************************************

#-------------------------------------------------------------------------------
#Figures 2ac
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 2ac"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_TIM03D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM05D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM10D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM21D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM27D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TIM35D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig2ac_tst/                                  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig2ac_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 2dg
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 2dg"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_TIM03D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM05D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM10D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM21D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM27D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TIM35D_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig2dg_tst/                                  \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig2dg_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 3a
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 3a"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPATPJ_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_TOPJAS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig3a_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig3a_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 3b
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 3b"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPAEVS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_ENVSRL_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig3b_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig3b_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 3c
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 3c"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPAS3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SENT3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig3c_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig3c_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 3d
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 3d"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPA3AB_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_S3AS3B_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig3d_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig3d_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 3e
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 3e"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPASWN_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_N_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig3e_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig3e_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 3f
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 3f"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_mag_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_mag_SPASWS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_mag_SWOT_S_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig3f_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig3f_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 4a
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 4a"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_SPATPJ_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_TOPJAS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig4a_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig4a_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 4b
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 4b"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_SPAEVS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_ENVSRL_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig4b_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig4b_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 4c
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 4c"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_SPAS3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SENT3A_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig4c_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig4c_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 4d
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 4d"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_SPA3AB_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_S3AS3B_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig4d_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig4d_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 4e
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 4e"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_SPASWN_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_N_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig4e_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig4e_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Figures 4f
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Figures 4f"
../src/rrr_anl_map_cdf.py                                                      \
     ../output/MERIT_WRR/analysis/map_evt_GRADES_75p.csv                       \
     ../output/MERIT_WRR/analysis/map_evt_SPASWS_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/map_evt_SWOT_S_75p_chd.csv                   \
     ../output/MERIT_WRR/analysis/fig4f_tst/                                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -rf ../output/MERIT_WRR/analysis/fig4f_tst/
rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Animations
#*******************************************************************************

#-------------------------------------------------------------------------------
#Animation for GRADES
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for GRADES"
../src/rrr_anl_anm_riv.py                                                      \
     ../input/MERIT_WRR/Qout_GRADES_Qmean_125cms_20000101_20091231.nc          \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_GRADES_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TIM03D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TIM03D"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TIM03D_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TIM03D_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TIM05D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TIM05D"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TIM05D_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TIM05D_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TIM10D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TIM10D"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TIM10D_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TIM10D_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TIM21D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TIM21D"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TIM21D_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TIM21D_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TIM27D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TIM27D"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TIM27D_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TIM27D_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TIM35D
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TIM35D"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TIM35D_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TIM35D_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SPATPJ
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SPATPJ"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SPATPJ_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SPATPJ_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SPAS3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SPAS3A"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SPAS3A_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SPAS3A_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SPA3AB
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SPA3AB"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SPA3AB_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SPA3AB_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SPAEVS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SPAEVS"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SPAEVS_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SPAEVS_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SPASWN
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SPASWN"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SPASWN_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SPASWN_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SPASWS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SPASWS"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SPASWS_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SPASWS_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for TOPJAS
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for TOPJAS"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_TOPJAS_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_TOPJAS_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SENT3A
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SENT3A"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SENT3A_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SENT3A_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for S3AS3B
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for S3AS3B"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_S3AS3B_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_S3AS3B_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for ENVSRL
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for ENVSRL"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_ENVSRL_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_ENVSRL_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SWOT_N
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SWOT_N"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SWOT_N_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SWOT_N_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Animation for SWOT_S
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/$tot"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Animation for SWOT_S"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/MERIT_WRR/Qout_SWOT_S_chd.nc                                    \
     ../input/MERIT_WRR/MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.shp  \
     ../output/MERIT_WRR/anim_SWOT_S_Global_abs_chd_tst.mp4                    \
     0                                                                         \
     366                                                                       \
     ../input/MERIT_WRR/Imagery_WGS84_Global.tif                               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

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
