#/bin/bash
#*******************************************************************************
#rrr_lsm_tot_grb_2nc.sh
#*******************************************************************************

#Purpose:
#Given a GRIB file from a common land surface model, and the names associated to 
#four variables it should contain (longitude, latitude, surface runoff, and 
#subsurface runoff, this program creates a netCDF file with the following 
#information:
# - nc_file(lat,lon) 
#   . lon(lon)
#   . lat(lat)
#   . RUNSF(lat,lon)
#   . RUNSB(lat,lon)
#This program uses the NCAR Command Language (NCL, i.e. ncl_convert2nc) and the 
#netCDF Common Operators (NCO, i.e. ncrename).
#Author:
#Cedric H. David, 2011-2017


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - GRIB file
# 2 - Name of longitude variable in GRIB file
# 3 - Name of latitude variable in GRIB file
# 4 - Name of surface runoff variable in GRIB file
# 5 - Name of subsurface runoff variable in GRIB file
# 6 - output directory of netCDF file


#*******************************************************************************
#Check command line inputs
#*******************************************************************************
if [ "$#" -ne "6" ]; then
     echo "A total of 6 arguments must be provided" 1>&2
     exit 22
fi 
#Check that 4 arguments were provided 

if [ ! -e "$1" ]; then
     echo "Input file $1 doesn't exist" 1>&2
     exit 22
fi
#Check that the input file exists

if [ ! -d "$6" ]; then
     echo "Output directory $6 doesn't exist" 1>&2
     exit 22
fi
#Check that the output directory exists


#*******************************************************************************
#Assign command line arguments to local variables
#*******************************************************************************
grb_file=$1
LON=$2
LAT=$3
RUNSF=$4
RUNSB=$5
dir=$6
#Command line arguments

name="${grb_file##*/}"
name="${name%.*}"
name=$name'.nc'
nc_file=$dir/$name
#Generate name and path for netCDF file


#*******************************************************************************
#If file doesn't already exist: Convert .grb to .nc, rename variables, add time
#*******************************************************************************
if [ ! -e "$nc_file" ]; then

#-------------------------------------------------------------------------------
#Convert GRIB to netCDF
#-------------------------------------------------------------------------------
     ncl_convert2nc $grb_file                                                  \
                    -v $LON,$LAT,$RUNSF,$RUNSB                                 \
                    -o $dir                                                    \
                    > tmp_ncl
     rm tmp_ncl

#-------------------------------------------------------------------------------
#Rename netCDF dimension and variables
#-------------------------------------------------------------------------------
     ncrename -d $LON,lon                                                      \
              -d $LAT,lat                                                      \
              -v $LON,lon                                                      \
              -v $LAT,lat                                                      \
              -v $RUNSF,RUNSF                                                  \
              -v $RUNSB,RUNSB                                                  \
              $nc_file 

#-------------------------------------------------------------------------------
#Add degenerate 'time' for later averaging 
#-------------------------------------------------------------------------------
     ncecat -O -u time $nc_file -o $nc_file

#-------------------------------------------------------------------------------
#End conversion
#-------------------------------------------------------------------------------
fi


#*******************************************************************************
#End
#*******************************************************************************
