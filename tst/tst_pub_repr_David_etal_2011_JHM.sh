#!/bin/bash
#*******************************************************************************
#tst_pub_repr_David_etal_2011_JHM.sh
#*******************************************************************************

#Purpose:
#
#Author:
#Cedric H. David, 2015-2020


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Reproducing files for: http://dx.doi.org/10.1175/2011JHM1345.1"
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
     ../input/San_Guad_JHM/NHDFlowline_San_Guad.dbf                            \
     ../input/San_Guad_JHM/NHDFlowlineVAA.dbf                                  \
     4                                                                         \
     ../output/San_Guad_JHM/rapid_connect_San_Guad_tst.csv                     \
     ../output/San_Guad_JHM/kfac_San_Guad_1km_hour_tst.csv                     \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1_tst.csv                          \
     ../output/San_Guad_JHM/sort_San_Guad_hydroseq_tst.csv                     \
     ../output/San_Guad_JHM/coords_San_Guad_tst.csv                            \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing connectivity"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/rapid_connect_San_Guad.csv                         \
     ../output/San_Guad_JHM/rapid_connect_San_Guad_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing kfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/kfac_San_Guad_1km_hour.csv                         \
     ../output/San_Guad_JHM/kfac_San_Guad_1km_hour_tst.csv                     \
     1e-15                                                                     \
     1e-10                                                                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing xfac"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1.csv                              \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1_tst.csv                          \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing sorted IDs"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/sort_San_Guad_hydroseq.csv                         \
     ../output/San_Guad_JHM/sort_San_Guad_hydroseq_tst.csv                     \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing coordinates"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/coords_San_Guad.csv                                \
     ../output/San_Guad_JHM/coords_San_Guad_tst.csv                            \
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
#Parameters 1
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_1 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_JHM/kfac_San_Guad_1km_hour_tst.csv                     \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1_tst.csv                          \
     0.131042                                                                  \
     2.58128                                                                   \
     ../output/San_Guad_JHM/k_San_Guad_2004_1_tst.csv                          \
     ../output/San_Guad_JHM/x_San_Guad_2004_1_tst.csv                          \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_1 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/k_San_Guad_2004_1.csv                              \
     ../output/San_Guad_JHM/k_San_Guad_2004_1_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_1 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/x_San_Guad_2004_1.csv                              \
     ../output/San_Guad_JHM/x_San_Guad_2004_1_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
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

echo "- Creating p_2 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_JHM/kfac_San_Guad_celerity.csv                         \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1_tst.csv                          \
     1                                                                         \
     1                                                                         \
     ../output/San_Guad_JHM/k_San_Guad_2004_2_tst.csv                          \
     ../output/San_Guad_JHM/x_San_Guad_2004_2_tst.csv                          \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_2 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/k_San_Guad_2004_2.csv                              \
     ../output/San_Guad_JHM/k_San_Guad_2004_2_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_2 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/x_San_Guad_2004_2.csv                              \
     ../output/San_Guad_JHM/x_San_Guad_2004_2_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters 3
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_3 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_JHM/kfac_San_Guad_celerity.csv                         \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1_tst.csv                          \
     0.617188                                                                  \
     1.95898                                                                   \
     ../output/San_Guad_JHM/k_San_Guad_2004_3_tst.csv                          \
     ../output/San_Guad_JHM/x_San_Guad_2004_3_tst.csv                          \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_3 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/k_San_Guad_2004_3.csv                              \
     ../output/San_Guad_JHM/k_San_Guad_2004_3_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_3 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/x_San_Guad_2004_3.csv                              \
     ../output/San_Guad_JHM/x_San_Guad_2004_3_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Parameters 4
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Creating p_4 files"
../src/rrr_riv_tot_scl_prm.py                                                  \
     ../output/San_Guad_JHM/kfac_San_Guad_celerity.csv                         \
     ../output/San_Guad_JHM/xfac_San_Guad_0.1_tst.csv                          \
     1.54                                                                      \
     1                                                                         \
     ../output/San_Guad_JHM/k_San_Guad_2004_4_tst.csv                          \
     ../output/San_Guad_JHM/x_San_Guad_2004_4_tst.csv                          \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing k_4 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/k_San_Guad_2004_4.csv                              \
     ../output/San_Guad_JHM/k_San_Guad_2004_4_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing x_4 files"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/x_San_Guad_2004_4.csv                              \
     ../output/San_Guad_JHM/x_San_Guad_2004_4_tst.csv                          \
     1e-6                                                                      \
     1e-2                                                                      \
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
     ../input/San_Guad_JHM/NHDFlowline_San_Guad.dbf                            \
     ../output/San_Guad_JHM/rapid_connect_San_Guad_tst.csv                     \
     ../output/San_Guad_JHM/sort_San_Guad_hydroseq_tst.csv                     \
     ../output/San_Guad_JHM/riv_bas_id_San_Guad_hydroseq_tst.csv               \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing sorted basin file"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/basin_id_San_Guad_hydroseq.csv                     \
     ../output/San_Guad_JHM/riv_bas_id_San_Guad_hydroseq_tst.csv               \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Add coupling procedure???
#*******************************************************************************


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
     ../input/San_Guad_JHM/StreamGageEvent_San_Guad_comid_withdir.shp          \
     2004-01-01                                                                \
     2007-12-31                                                                \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full_tst.csv            \
     ../output/San_Guad_JHM/Qobs_San_Guad_2004_2007_full_tst.csv               \
     ../output/San_Guad_JHM/StreamGageEvent_San_Guad_comid_withdir_2004_2007_full.shp \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing gauges"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full_tst.csv            \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

echo "- Comparing observed flows"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/Qobs_San_Guad_2004_2007_full.csv                   \
     ../output/San_Guad_JHM/Qobs_San_Guad_2004_2007_full_tst.csv               \
     5e-2                                                                      \
     2e-2                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi


#*******************************************************************************
#Timeseries, hydrographs and statistics
#*******************************************************************************

#-------------------------------------------------------------------------------
#Timeseries for observations
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for observations"
../src/rrr_anl_hyd_obs.py                                                      \
     ../output/San_Guad_JHM/Qobs_San_Guad_2004_2007_full.csv                   \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs_tst/                   \
     1                                                                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for observations"
for file in `ls ../output/San_Guad_JHM/hydrographs/hydrographs_obs/`
do
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/$file                  \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs_tst/$file              \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
done

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations with parameters p1
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations with parameters p1"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p1_dtR900s.nc               \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p1_tst/                \
     8                                                                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations with parameters p1"
for file in `ls ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p1/`
do
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p1/$file               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p1_tst/$file           \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
done

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations with parameters p2
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations with parameters p2"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p2_dtR900s.nc               \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p2_tst/                \
     8                                                                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations with parameters p2"
for file in `ls ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p2/`
do
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p2/$file               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p2_tst/$file           \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
done

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations with parameters p3
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations with parameters p3"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p3_dtR900s.nc               \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p3_tst/                \
     8                                                                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations with parameters p3"
for file in `ls ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p3/`
do
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p3/$file               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p3_tst/$file           \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
done

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Timeseries for model simulations with parameters p4
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Timeseries for model simulations with parameters p4"
../src/rrr_anl_hyd_mod.py                                                      \
     ../output/San_Guad_JHM/Qout_San_Guad_1460days_p4_dtR900s.nc               \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p4_tst/                \
     8                                                                         \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing timeseries for model simulations with parameters p4"
for file in `ls ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p4/`
do
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p4/$file               \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p4_tst/$file           \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi
done

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations with parameters p1
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations with parameters p1"
../src/rrr_anl_hyd_plt.py                                                      \
     ../input/San_Guad_JHM/StreamGageEvent_San_Guad_comid_withdir_full_2004_2007_plot.shp \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p1/                    \
     ../output/San_Guad_JHM/hydrographs/hydrographs_plt_rap_p1_tst/            \
     2004-01-01                                                                \
     1                                                                         \
     3000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations with parameters p2
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations with parameters p2"
../src/rrr_anl_hyd_plt.py                                                      \
     ../input/San_Guad_JHM/StreamGageEvent_San_Guad_comid_withdir_full_2004_2007_plot.shp \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p2/                    \
     ../output/San_Guad_JHM/hydrographs/hydrographs_plt_rap_p2_tst/            \
     2004-01-01                                                                \
     1                                                                         \
     3000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations with parameters p3
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations with parameters p3"
../src/rrr_anl_hyd_plt.py                                                      \
     ../input/San_Guad_JHM/StreamGageEvent_San_Guad_comid_withdir_full_2004_2007_plot.shp \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p3/                    \
     ../output/San_Guad_JHM/hydrographs/hydrographs_plt_rap_p3_tst/            \
     2004-01-01                                                                \
     1                                                                         \
     3000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Hydrographs for model simulations with parameters p4
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Hydrographs for model simulations with parameters p4"
../src/rrr_anl_hyd_plt.py                                                      \
     ../input/San_Guad_JHM/StreamGageEvent_San_Guad_comid_withdir_full_2004_2007_plot.shp \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p4/                    \
     ../output/San_Guad_JHM/hydrographs/hydrographs_plt_rap_p4_tst/            \
     2004-01-01                                                                \
     1                                                                         \
     3000                                                                      \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing to NOTHING"

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations with parameters p1
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations with parameters p1"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p1/                    \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p1_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations with parameters p1"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p1.csv                       \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p1_tst.csv                   \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations with parameters p2
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations with parameters p2"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p2/                    \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p2_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations with parameters p2"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p2.csv                       \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p2_tst.csv                   \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations with parameters p3
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations with parameters p3"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p3/                    \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p3_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations with parameters p3"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p3.csv                       \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p3_tst.csv                   \
     1e-5                                                                      \
     1e-6                                                                      \
     > $cmp_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed comparison: $cmp_file" >&2 ; exit $x ; fi

rm -f $run_file
rm -f $cmp_file
echo "Success"
echo "********************"
fi

#-------------------------------------------------------------------------------
#Statistics for model simulations with parameters p4
#-------------------------------------------------------------------------------
unt=$((unt+1))
if (("$unt" >= "$fst")) && (("$unt" <= "$lst")) ; then
echo "Running unit test $unt/x"
run_file=tmp_run_$unt.txt
cmp_file=tmp_cmp_$unt.txt

echo "- Statistics for model simulations with parameters p4"
../src/rrr_anl_hyd_sts.py                                                      \
     ../output/San_Guad_JHM/gage_id_San_Guad_2004_2007_full.csv                \
     ../output/San_Guad_JHM/hydrographs/hydrographs_obs/                       \
     ../output/San_Guad_JHM/hydrographs/hydrographs_rap_p4/                    \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p4_tst.csv                   \
     > $run_file
x=$? && if [ $x -gt 0 ] ; then echo "Failed run: $run_file" >&2 ; exit $x ; fi

echo "- Comparing statistics for model simulations with parameters p4"
./tst_cmp_csv.py                                                               \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p4.csv                       \
     ../output/San_Guad_JHM/hydrographs/stats_rap_p4_tst.csv                   \
     1e-5                                                                      \
     1e-6                                                                      \
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
rm -f ../output/San_Guad_JHM/*_tst.csv
rm -rf ../output/San_Guad_JHM/hydrographs/hydrographs_*tst/
rm -rf ../output/San_Guad_JHM/hydrographs/stats_*tst.csv/


#*******************************************************************************
#End
#*******************************************************************************
echo "Passed all tests!!!"
echo "********************"
