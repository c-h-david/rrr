#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Sikder_etal_2021_WRR.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
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
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#M. Safat Sikder and Cedric H. David, 2020-2022


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#wget -q -nc           --> Quiet, No-clobber (don't overwrite) 
#wget -r               --> Turn on recursive retrieving. 
#wget -nH              --> Disable generation of host-prefixed directories. 
#wget ---cut-dirs=i    --> Ignore i directory components when saving files. 
#wget -P               --> Directory prefix where everything is downloaded


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Downloading files from:   https://doi.org/10.5281/zenodo.5516592"
echo "which correspond to   :   https://doi.org/10.1029/2020WR029035"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these four DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download RRR input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/5516592/files"
folder="../input/MERIT_WRR"
list="                                                                         \
     MERIT_riv_Qmean_125cms.zip                                                \
     MERIT_riv_Qmean_125cms_simplify_point_remove_1deg.zip                     \
     Qout_GRADES_Qmean_125cms_20000101_20091231.tar.gz                         \
     TOPJAS.zip                                                                \
     SENT3A.zip                                                                \
     S3AS3B.zip                                                                \
     ENVSRL.zip                                                                \
     SWOT_N.zip                                                                \
     SWOT_S.zip                                                                \
     Imagery_WGS84_Global.tif                                                  \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done


#*******************************************************************************
#Download RRR post-processing files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/5516592/files"
folder="../output/MERIT_WRR"
list="                                                                         \
     coverage_TOPJAS.zip                                                       \
     coverage_SENT3A.zip                                                       \
     coverage_S3AS3B.zip                                                       \
     coverage_ENVSRL.zip                                                       \
     coverage_SWOT_N.zip                                                       \
     coverage_SWOT_S.zip                                                       \
     seq_TIM03D_chd.csv                                                        \
     seq_TIM05D_chd.csv                                                        \
     seq_TIM10D_chd.csv                                                        \
     seq_TIM21D_chd.csv                                                        \
     seq_TIM27D_chd.csv                                                        \
     seq_TIM35D_chd.csv                                                        \
     seq_SPATPJ.csv                                                            \
     seq_SPAS3A.csv                                                            \
     seq_SPA3AB.csv                                                            \
     seq_SPAEVS.csv                                                            \
     seq_SPASWN.csv                                                            \
     seq_SPASWS.csv                                                            \
     seq_TOPJAS.csv                                                            \
     seq_SENT3A.csv                                                            \
     seq_S3AS3B.csv                                                            \
     seq_ENVSRL.csv                                                            \
     seq_SWOT_N.csv                                                            \
     seq_SWOT_S.csv                                                            \
     Qout_TIM03D_chd.tar.gz                                                    \
     Qout_TIM05D_chd.tar.gz                                                    \
     Qout_TIM10D_chd.tar.gz                                                    \
     Qout_TIM21D_chd.tar.gz                                                    \
     Qout_TIM27D_chd.tar.gz                                                    \
     Qout_TIM35D_chd.tar.gz                                                    \
     Qout_SPATPJ_chd.tar.gz                                                    \
     Qout_SPAS3A_chd.tar.gz                                                    \
     Qout_SPA3AB_chd.tar.gz                                                    \
     Qout_SPAEVS_chd.tar.gz                                                    \
     Qout_SPASWN_chd.tar.gz                                                    \
     Qout_SPASWS_chd.tar.gz                                                    \
     Qout_TOPJAS_chd.tar.gz                                                    \
     Qout_SENT3A_chd.tar.gz                                                    \
     Qout_S3AS3B_chd.tar.gz                                                    \
     Qout_ENVSRL_chd.tar.gz                                                    \
     Qout_SWOT_N_chd.tar.gz                                                    \
     Qout_SWOT_S_chd.tar.gz                                                    \
     anim_GRADES_Global_abs_chd.mp4                                            \
     anim_TIM03D_Global_abs_chd.mp4                                            \
     anim_TIM05D_Global_abs_chd.mp4                                            \
     anim_TIM10D_Global_abs_chd.mp4                                            \
     anim_TIM21D_Global_abs_chd.mp4                                            \
     anim_TIM27D_Global_abs_chd.mp4                                            \
     anim_TIM35D_Global_abs_chd.mp4                                            \
     anim_SPATPJ_Global_abs_chd.mp4                                            \
     anim_SPAS3A_Global_abs_chd.mp4                                            \
     anim_SPA3AB_Global_abs_chd.mp4                                            \
     anim_SPAEVS_Global_abs_chd.mp4                                            \
     anim_SPASWN_Global_abs_chd.mp4                                            \
     anim_SPASWS_Global_abs_chd.mp4                                            \
     anim_TOPJAS_Global_abs_chd.mp4                                            \
     anim_SENT3A_Global_abs_chd.mp4                                            \
     anim_S3AS3B_Global_abs_chd.mp4                                            \
     anim_ENVSRL_Global_abs_chd.mp4                                            \
     anim_SWOT_N_Global_abs_chd.mp4                                            \
     anim_SWOT_S_Global_abs_chd.mp4                                            \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done


#*******************************************************************************
#Download RRR analysis files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="https://zenodo.org/record/5516592/files"
folder="../output/MERIT_WRR/analysis"
list="                                                                         \
     map_mag_GRADES_75p.csv                                                    \
     map_mag_TIM03D_75p_chd.csv                                                \
     map_mag_TIM05D_75p_chd.csv                                                \
     map_mag_TIM10D_75p_chd.csv                                                \
     map_mag_TIM21D_75p_chd.csv                                                \
     map_mag_TIM27D_75p_chd.csv                                                \
     map_mag_TIM35D_75p_chd.csv                                                \
     map_mag_SPATPJ_75p_chd.csv                                                \
     map_mag_SPAS3A_75p_chd.csv                                                \
     map_mag_SPA3AB_75p_chd.csv                                                \
     map_mag_SPAEVS_75p_chd.csv                                                \
     map_mag_SPASWN_75p_chd.csv                                                \
     map_mag_SPASWS_75p_chd.csv                                                \
     map_mag_TOPJAS_75p_chd.csv                                                \
     map_mag_SENT3A_75p_chd.csv                                                \
     map_mag_S3AS3B_75p_chd.csv                                                \
     map_mag_ENVSRL_75p_chd.csv                                                \
     map_mag_SWOT_N_75p_chd.csv                                                \
     map_mag_SWOT_S_75p_chd.csv                                                \
     map_evt_GRADES_75p.csv                                                    \
     map_evt_TIM03D_75p_chd.csv                                                \
     map_evt_TIM05D_75p_chd.csv                                                \
     map_evt_TIM10D_75p_chd.csv                                                \
     map_evt_TIM21D_75p_chd.csv                                                \
     map_evt_TIM27D_75p_chd.csv                                                \
     map_evt_TIM35D_75p_chd.csv                                                \
     map_evt_SPATPJ_75p_chd.csv                                                \
     map_evt_SPAS3A_75p_chd.csv                                                \
     map_evt_SPA3AB_75p_chd.csv                                                \
     map_evt_SPAEVS_75p_chd.csv                                                \
     map_evt_SPASWN_75p_chd.csv                                                \
     map_evt_SPASWS_75p_chd.csv                                                \
     map_evt_TOPJAS_75p_chd.csv                                                \
     map_evt_SENT3A_75p_chd.csv                                                \
     map_evt_S3AS3B_75p_chd.csv                                                \
     map_evt_ENVSRL_75p_chd.csv                                                \
     map_evt_SWOT_N_75p_chd.csv                                                \
     map_evt_SWOT_S_75p_chd.csv                                                \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done


#*******************************************************************************
#Convert files
#*******************************************************************************
for file in `ls ../input/MERIT_WRR/*.zip`
do
     unzip -nq $file -d ../input/MERIT_WRR/
     if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

for file in `ls ../input/MERIT_WRR/*.tar.gz`
do
     tar -xzf $file --skip-old-files --directory ../input/MERIT_WRR/
     if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

for file in `ls ../output/MERIT_WRR/*.zip`
do
     unzip -nq $file -d ../output/MERIT_WRR/
     if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done

for file in `ls ../output/MERIT_WRR/*.tar.gz`
do
     tar -xzf $file --skip-old-files --directory ../output/MERIT_WRR/
     if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi
done


#*******************************************************************************
#Done
#*******************************************************************************
