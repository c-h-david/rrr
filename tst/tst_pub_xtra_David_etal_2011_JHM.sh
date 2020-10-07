#!/bin/bash
#*******************************************************************************
#tst_pub_xtra_David_etal_2011_JHM.sh
#*******************************************************************************

#Purpose:
#
#Author:
#Cedric H. David, 2016-2020


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: http://dx.doi.org/xxx"
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
#San_Guad SWOT
#*******************************************************************************

#-------------------------------------------------------------------------------
#Subsampling polylines based on polygons"
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Subsampling polylines based on polygons"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/San_Guad_JHM/NHDFlowline_San_Guad_with_dir_GNIS_Guadalupe_River.shp \
     ../input/San_Guad_JHM/SWOT_890km_77_onepolypertrack_nadirgap_180_one_cycle.shp \
     ../output/San_Guad_JHM/NHDFlowline_San_Guad_with_dir_GNIS_Guadalupe_River_SWOT.shp \
     ../output/San_Guad_JHM/NHDFlowline_San_Guad_with_dir_GNIS_Guadalupe_River_SWOT.csv \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Subsampling model outputs
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Subsampling model outputs"
../src/rrr_anl_spl_mod.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p3_dtR900s.nc               \
     ../output/San_Guad_JHM/NHDFlowline_San_Guad_with_dir_GNIS_Guadalupe_River_SWOT.csv \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p3_dtR900s_SWOT.nc          \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Producing regular animation
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Producing regular animation"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p3_dtR900s.nc               \
     ../input/San_Guad_JHM/NHDFlowline_San_Guad_with_dir_GNIS_Guadalupe_River.shp \
     ../output/San_Guad_JHM/San_Guad.mp4                                       \
     9976                                                                      \
     10952                                                                     \
     ../input/San_Guad_JHM/San_Guad_imagery.tif                                \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Producing SWOT animation
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Producing SWOT animation"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p3_dtR900s_SWOT.nc          \
     ../input/San_Guad_JHM/NHDFlowline_San_Guad_with_dir_GNIS_Guadalupe_River.shp \
     ../output/San_Guad_JHM/San_Guad_SWOT.mp4                                  \
     9976                                                                      \
     10952                                                                     \
     ../input/San_Guad_JHM/San_Guad_imagery.tif                                \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#HSmsp SWOT
#*******************************************************************************

#-------------------------------------------------------------------------------
#Subsampling polylines based on polygons"
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Subsampling polylines based on polygons"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/HSmsp_WRR/riv_HSmsp_10percent_largest.shp                        \
     ../input/HSmsp_WRR/SWOT_890km_77_onepolypertrack_nadirgap_180_one_cycle.shp \
     ../output/HSmsp_WRR/riv_HSmsp_10percent_largest_SWOT.shp                  \
     ../output/HSmsp_WRR/riv_HSmsp_10percent_largest_SWOT.csv                  \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Subsampling model outputs
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Subsampling model outputs"
../src/rrr_anl_spl_mod.py                                                      \
     ../output/HSmsp_WRR/Qout_HSmsp_2000_2009_VIC_NASA_sgl_pa_phi1_2008_1_n1_preonly_ilu.nc \
     ../output/HSmsp_WRR/riv_HSmsp_10percent_largest_SWOT.csv                  \
     ../output/HSmsp_WRR/Qout_HSmsp_2000_2009_VIC_NASA_sgl_pa_phi1_2008_1_n1_preonly_ilu_SWOT.nc \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Producing regular animation
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Producing regular animation"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/HSmsp_WRR/Qout_HSmsp_2000_2009_VIC_NASA_sgl_pa_phi1_2008_1_n1_preonly_ilu.nc \
     ../output/HSmsp_WRR/riv_HSmsp_10percent_largest.shp                       \
     ../output/HSmsp_WRR/HSmsp.mp4                                       \
     24104                                                                     \
     25080                                                                     \
     ../input/HSmsp_WRR/HSmsp_imagery.tif                                \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Producing SWOT animation
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Producing SWOT animation"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/HSmsp_WRR/Qout_HSmsp_2000_2009_VIC_NASA_sgl_pa_phi1_2008_1_n1_preonly_ilu_SWOT.nc \
     ../output/HSmsp_WRR/riv_HSmsp_10percent_largest.shp                       \
     ../output/HSmsp_WRR/HSmsp_SWOT.mp4                                  \
     24104                                                                     \
     25080                                                                     \
     ../input/HSmsp_WRR/HSmsp_imagery.tif                                \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#WSWM SWOT
#*******************************************************************************

#-------------------------------------------------------------------------------
#Subsampling polylines based on polygons"
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Subsampling polylines based on polygons"
../src/rrr_anl_spl_shp.py                                                      \
     ../input/WSWM_XYZ/NHDFlowline_WSWM_Sort_with_dir_TotDASqKM_gt_10000.shp   \
     ../input/WSWM_XYZ/SWOT_890km_77_onepolypertrack_nadirgap_180_one_cycle.shp \
     ../output/WSWM_XYZ/NHDFlowline_WSWM_Sort_with_dir_TotDASqKM_gt_10000_SWOT.shp \
     ../output/WSWM_XYZ/NHDFlowline_WSWM_Sort_with_dir_TotDASqKM_gt_10000_SWOT.csv \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Subsampling model outputs
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Subsampling model outputs"
../src/rrr_anl_spl_mod.py                                                      \
     ../output/WSWM_XYZ/Qout_WSWM_729days_p0_dtR900s_n1_preonly_20160416.nc    \
     ../output/WSWM_XYZ/NHDFlowline_WSWM_Sort_with_dir_TotDASqKM_gt_10000_SWOT.csv \
     ../output/WSWM_XYZ/Qout_WSWM_729days_p0_dtR900s_n1_preonly_20160416_SWOT.nc \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Producing regular animation
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Producing regular animation"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/WSWM_XYZ/Qout_WSWM_729days_p0_dtR900s_n1_preonly_20160416.nc    \
     ../input/WSWM_XYZ/NHDFlowline_WSWM_Sort_with_dir_TotDASqKM_gt_10000.shp   \
     ../output/WSWM_XYZ/WSWM.mp4                                               \
     2920                                                                      \
     3168                                                                      \
     ../input/WSWM_XYZ/WSWM_Imagery_300dpi.tif                                 \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Producing SWOT animation
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Producing SWOT animation"
../src/rrr_anl_anm_riv.py                                                      \
     ../output/WSWM_XYZ/Qout_WSWM_729days_p0_dtR900s_n1_preonly_20160416_SWOT.nc \
     ../input/WSWM_XYZ/NHDFlowline_WSWM_Sort_with_dir_TotDASqKM_gt_10000.shp   \
     ../output/WSWM_XYZ/WSWM_SWOT.mp4                                          \
     2920                                                                      \
     3168                                                                      \
     ../input/WSWM_XYZ/WSWM_Imagery_300dpi.tif                                 \
     > $run_file
if [ $? -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $? ; fi

echo "- Comparing to NOTHING"

rm $run_file
#rm $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Clean up
#*******************************************************************************
#rm ../output/San_Guad_JHM/*_tst.csv


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
