#!/usr/bin/env python2
#*******************************************************************************
#tst_chk_ncf.py
#*******************************************************************************

#Purpose:
#Check netCDF files for fill values, returns error if found, otherwise exit 22.
#Author:
#Cedric H. David, 2017-2018


#*******************************************************************************
#Prerequisites
#*******************************************************************************
import sys
import netCDF4
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_ncf_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 2:
     print('ERROR - 1 and ony 1 argument must be used')
     raise SystemExit(22) 

rrr_ncf_file=sys.argv[1]
     

#*******************************************************************************
#Print current variables
#*******************************************************************************
print('Checking netCDF file')
print('netCDF file                   :'+rrr_ncf_file)
print('-------------------------------')


#*******************************************************************************
#Test if input files exist
#*******************************************************************************
try:
     with open(rrr_ncf_file) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_ncf_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read and check netCDF file
#*******************************************************************************

#-------------------------------------------------------------------------------
#Open file and get dimensions
#-------------------------------------------------------------------------------
f = netCDF4.Dataset(rrr_ncf_file, "r")

if 'COMID' in f.dimensions:
     IS_riv_tot=len(f.dimensions['COMID'])
elif 'rivid' in f.dimensions:
     IS_riv_tot=len(f.dimensions['rivid'])
else:
     print('ERROR - Neither COMID nor rivid are dimensions in: '+rrr_ncf_file) 
     raise SystemExit(99) 
     
if 'Time' in f.dimensions:
     IS_time=len(f.dimensions['Time'])
elif 'time' in f.dimensions:
     IS_time=len(f.dimensions['time'])
else:
     print('ERROR - Neither Time nor time are dimensions in: '+rrr_ncf_file) 
     raise SystemExit(99) 

if 'm3_riv' in f.variables:
     rrr_ncf_var='m3_riv'
elif 'Qout' in f.variables:
     rrr_ncf_var='Qout'
elif 'V' in f.variables:
     rrr_ncf_var='V'
else:
     print('ERROR - m3_riv, Qout, or V are not variables in: '+rrr_ncf_file) 
     raise SystemExit(99) 

#-------------------------------------------------------------------------------
#Print file sizes and variable name
#-------------------------------------------------------------------------------
print('Number of river reaches       :'+str(IS_riv_tot))
print('Number of time steps          :'+str(IS_time))
print('Variable name                 :'+rrr_ncf_var)
print('-------------------------------')

#-------------------------------------------------------------------------------
#Check for fillvalues
#-------------------------------------------------------------------------------
BS_error=False

for JS_time in range(IS_time):

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Read values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZV_var=f.variables[rrr_ncf_var][JS_time,:]

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Check for masked array
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     if(isinstance(ZV_var,numpy.ma.MaskedArray)):
          BS_error=BS_error or True
          print('ERROR at time step: '+str(JS_time)+', MaskedArray detected, ' \
                +'number of masked values: '+str(numpy.ma.count_masked(ZV_var)))


#*******************************************************************************
#Exit if there a MaskedArray was detected
#*******************************************************************************
if (BS_error):
     raise SystemExit(22) 

print('No MaskedArray found!!!')
print('-------------------------------')
     

#*******************************************************************************
#End
#*******************************************************************************
