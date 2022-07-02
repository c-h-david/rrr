#!/usr/bin/env python
#*******************************************************************************
#tst_prf_ncf.py
#*******************************************************************************

#Purpose:
#Given a netCDF file with a variable referenced to a time dimension and a rivid
#dimension, along with a number of 'read' operations that should be performed,
#this script provides some performance evaluation on how fast the netCDF
#variable can be read along its two dimensions. Some details are also given
#related to the netCDF format used, and potential chunking options applied. This
#script is useful to diagnose lengthy read operations that can be addressed by
#setting alternate chunking options in netCDF4 files.
#Author:
#Cedric H. David, 2018-2022


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import time


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_vol_ncf
# 2 - IS_read


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments must be used')
     raise SystemExit(22) 

rrr_vol_ncf=sys.argv[1]
IS_read=int(sys.argv[2])


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_vol_ncf)
print('- '+str(IS_read))


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_vol_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_vol_ncf)
     raise SystemExit(22)


#*******************************************************************************
#Open netCDF file
#*******************************************************************************
print('Open netCDF file')

f = netCDF4.Dataset(rrr_vol_ncf, 'r')


#*******************************************************************************
#Determine netCDF format and dimensions
#*******************************************************************************
print('Determine netCDF format and dimensions')

#-------------------------------------------------------------------------------
#Get netCDF format
#-------------------------------------------------------------------------------
YS_fmt=f.file_format
print('- The file format is: '+str(YS_fmt))

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'COMID' in f.dimensions:
     YS_rivid1='COMID'
elif 'rivid' in f.dimensions:
     YS_rivid1='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_vol_ncf)
     raise SystemExit(22) 

IS_riv_tot=len(f.dimensions[YS_rivid1])
print('- The number of river reaches is: '+str(IS_riv_tot))

if 'Time' in f.dimensions:
     YS_time='Time'
elif 'time' in f.dimensions:
     YS_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_vol_ncf)
     raise SystemExit(22) 

IS_time=len(f.dimensions[YS_time])
print('- The number of time steps is: '+str(IS_time))


#*******************************************************************************
#Determine netCDF variable name and potential chunk sizes
#*******************************************************************************
print('Determine netCDF variable name and potential chunk sizes')

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f.variables:
     YS_var='m3_riv'
     print('- The variable that will be accessed is: '+YS_var)
else:
     print('ERROR - m3_riv does not exist in '+rrr_vol_ncf)
     raise SystemExit(22) 

#-------------------------------------------------------------------------------
#Get Chunk sizes
#-------------------------------------------------------------------------------
if (f.variables[YS_var].chunking() == None):
     print('- No chunking is used for: '+YS_var)
else:
     IV_chunks=f.variables[YS_var].chunking()
     print('- The chunk sizes used for '+YS_var+' are: '+str(IV_chunks))


#*******************************************************************************
#Evaluate read performance over the given number of read operations
#*******************************************************************************
print('Evaluate read performance over the given number of read operations')

#-------------------------------------------------------------------------------
#Read all river reaches for a given time
#-------------------------------------------------------------------------------
print('- Read all river reaches for a given time')

YS_len=str(len(f.variables[YS_var][0,:]))
print(' . Read operations will be performed: '+str(IS_read)+' times')
print(' . Each read operation will access: '+YS_len+' values')

ZS_beg=time.time()
for JS_read in range(IS_read):
    ZV_read=f.variables[YS_var][0,:]
ZS_end=time.time()
ZS_dif=round(ZS_end-ZS_beg,3)
print(' . Duration for this task: '+str(ZS_dif)+' seconds')

#-------------------------------------------------------------------------------
#Read all times for a given river reach
#-------------------------------------------------------------------------------
print('- Read all times for a given river reach')

YS_len=str(len(f.variables[YS_var][:,0]))
print(' . Read operations will be performed: '+str(IS_read)+' times')
print(' . Each read operation will access: '+YS_len+' values')

ZS_beg=time.time()
for JS_read in range(IS_read):
    ZV_read=f.variables[YS_var][:,0]
ZS_end=time.time()
ZS_dif=round(ZS_end-ZS_beg,3)
print(' . Duration for this task: '+str(ZS_dif)+' seconds')


#*******************************************************************************
#Evaluate read performance over the entire record
#*******************************************************************************
print('Evaluate read performance over the entire record')

#-------------------------------------------------------------------------------
#Read all river reaches for a given time
#-------------------------------------------------------------------------------
print('- Read all river reaches for a given time')

YS_len=str(len(f.variables[YS_var][0,:]))
print(' . Read operations will be performed: '+str(IS_time)+' times')
print(' . Each read operation will access: '+YS_len+' values')

ZS_beg=time.time()
for JS_time in range(IS_time):
    ZV_read=f.variables[YS_var][JS_time,:]
ZS_end=time.time()
ZS_dif=round(ZS_end-ZS_beg,3)
print(' . Duration for this task: '+str(ZS_dif)+' seconds')

#-------------------------------------------------------------------------------
#Read all times for a given river reach
#-------------------------------------------------------------------------------
print('- Read all times for a given river reach')

YS_len=str(len(f.variables[YS_var][:,0]))
print(' . Read operations will be performed: '+str(IS_riv_tot)+' times')
print(' . Each read operation will access: '+YS_len+' values')

ZS_beg=time.time()
for JS_riv_tot in range(IS_riv_tot):
    ZV_read=f.variables[YS_var][:,JS_riv_tot]
ZS_end=time.time()
ZS_dif=round(ZS_end-ZS_beg,3)
print(' . Duration for this task: '+str(ZS_dif)+' seconds')


#*******************************************************************************
#End
#*******************************************************************************
