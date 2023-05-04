#/bin/bash
#*******************************************************************************
#rrr_lsm_tot_cmb_acc.sh
#*******************************************************************************

#Purpose:
#Given a list of netCDF files with one time step each, produces a combined 
#(concatenated) netCDF file with averages computed over a given number of time 
#steps.
#Each netCDF file contains the following information:
# - nc_file(lat,lon,time) 
#   . lon(lon)
#   . lat(lat)
#   . RUNSF(time,lat,lon)
#   . RUNSB(time,lat,lon)
#This program uses the netCDF Common Operators (NCO, i.e. ncra).
#Author:
#Cedric H. David, 2016-2023


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1   - 1st netCDF file
# 2   - 2nd netCDF file
# 3   - 3rd netCDF file
# i   - ith netCDF file
# n-1 - Number of contiguous netCDF files to be averaged together in each step
# n   - output netCDF file


#*******************************************************************************
#Compute the number of netCDF files
#*******************************************************************************
let "IS_file=$#-2"


#*******************************************************************************
#Check command line inputs
#*******************************************************************************
if [ "$#" -lt "3" ]; then
     echo "A minimum of 3 arguments must be provided" 1>&2
     exit 22
fi 
#Check that 3 or more arguments were provided 

for ii in "${@:1:$IS_file}"; do # `seq 1 $IS_file`; do # $#-2; do 
if [ ! -e "${ii}" ]; then
     echo "Input file ${ii} doesn't exist" 1>&2
     exit 22
fi
done
#Check that the input files exist. ${@:1:$IS_file}: the first IS_file arguments


#*******************************************************************************
#Assign command line arguments to local variables
#*******************************************************************************
IS_step=${@:$IS_file+1:1}
#from the list of arguments, starting at IS_file+1, 1 argument (2nd to last)
nc_file=${@:$IS_file+2:1}
#from the list of arguments, starting at IS_file+2, 1 argument (last)
nc_temp=$nc_file'.tmp'


#*******************************************************************************
#If file doesn't already exist: average and concatenate, then scale
#*******************************************************************************
if [ ! -e "$nc_file" ]; then

#-------------------------------------------------------------------------------
#average and concatenate
#-------------------------------------------------------------------------------
if [ ! -e "$nc_temp" ]; then
ncra -O --mro -d time,,,$IS_step,$IS_step                                      \
            ${@:1:$IS_file}                                                    \
           -o $nc_temp
fi
#This uses the NCO 'subcycle' and 'multi record outputs' options.

#-------------------------------------------------------------------------------
#Rename netCDF variables in case it was not done before
#-------------------------------------------------------------------------------
if [ -e "$nc_temp" ]; then
ncrename -v .SSRUN,RUNSF                                                       \
         -v .BGRUN,RUNSB                                                       \
         -v .Qs_acc,RUNSF                                                      \
         -v .Qsb_acc,RUNSB                                                     \
         -v .Qs_tavg,RUNSF                                                     \
         -v .Qsb_tavg,RUNSB                                                    \
         -d .east_west,lon                                                     \
         -d .north_south,lat                                                   \
         $nc_temp
fi
#Adding "." before a variable name informs ncrename that it's optional.
#SSRUN / BGRUN are used in NLDAS for surface runoff / subsurface runoff (resp).
#Q_xx  / Qs_xx are used in GLDAS for surface runoff / subsurface runoff (resp).
#                       xx can be: acc, or tavg.

#-------------------------------------------------------------------------------
#scale so that value is accumulated, not averaged 
#-------------------------------------------------------------------------------
ncap2 -s "RUNSF=RUNSF*$IS_step;RUNSB=RUNSB*$IS_step"                           \
       $nc_temp                                                                \
    -o $nc_file

#-------------------------------------------------------------------------------
#Delete temporary file
#-------------------------------------------------------------------------------
rm -f $nc_temp

#-------------------------------------------------------------------------------
#End file existence
#-------------------------------------------------------------------------------
fi


#*******************************************************************************
#End
#*******************************************************************************
