#/bin/bash
#*******************************************************************************
#rrr_cpl_riv_lsm_att.sh
#*******************************************************************************

#Purpose:
#This program modifies some global attributes from a given netCDF file based on
#command line inputs. 
#Author:
#Cedric H. David, 2016-2018


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - nc_file
# 2 - title
# 3 - institution
# 4 - comment
# 5 - semi_major_axis
# 6 - inverse_flattening


#*******************************************************************************
#Check command line inputs
#*******************************************************************************
if [ "$#" -ne "6" ]; then
     echo "A total of 6 arguments must be provided" 1>&2
     exit 22
fi 
#Check that 6 arguments were provided 

if [ ! -e "$1" ]; then
     echo "Input file $1 doesn't exist" 1>&2
     exit 22
fi
#Check that the input file exists


#*******************************************************************************
#Assign command line arguments to local variables
#*******************************************************************************
nc_file=$1
title=$2
institution=$3
comment=$4
semi_major_axis=$5
inverse_flattening=$6
#Command line arguments


#*******************************************************************************
#Print input information
#*******************************************************************************
echo 'Command line inputs'
echo '- nc_file           :' $nc_file
echo '- title             :' $title
echo '- institution       :' $institution
echo '- comment           :' $comment
echo '- semi_major_axis   :' $semi_major_axis
echo '- inverse_flattening:' $inverse_flattening


#*******************************************************************************
#Edit global attributes
#*******************************************************************************
ncatted -h -a title,global,m,c,"$title" $nc_file
ncatted -h -a institution,global,m,c,"$institution" $nc_file
ncatted -h -a comment,global,m,c,"$comment" $nc_file
ncatted -h -a semi_major_axis,crs,m,c,"$semi_major_axis" $nc_file
ncatted -h -a inverse_flattening,crs,m,c,"$inverse_flattening" $nc_file
#-h for not updating "history", -a for "attribute", m is modify, c is character


#*******************************************************************************
#End
#*******************************************************************************
