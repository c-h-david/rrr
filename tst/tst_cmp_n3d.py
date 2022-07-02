#!/usr/bin/env python
#*******************************************************************************
#tst_cmp_n3d.py
#*******************************************************************************

#Purpose:
#Compare netCDF files with 3 dimensions: lon, lat, and time.
#Author:
#Cedric H. David, 2020-2022


#*******************************************************************************
#Prerequisites
#*******************************************************************************
import sys
import netCDF4
import math
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_ncf_file1
# 2 - rrr_ncf_file2
#(3)- relative tolerance 
#(4)- absolute tolerance 


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 3 or IS_arg > 5:
     print('ERROR - A minimum of 2 and a maximum of 4 arguments can be used')
     raise SystemExit(22) 

rrr_ncf_file1=sys.argv[1]
rrr_ncf_file2=sys.argv[2]
if IS_arg > 3:
     ZS_rtol=float(sys.argv[3])
else:
     ZS_rtol=float(0)
if IS_arg > 4:
     ZS_atol=float(sys.argv[4])
else:
     ZS_atol=float(0)
     

#*******************************************************************************
#Print current variables
#*******************************************************************************
print('Comparing netCDF files')
print('1st netCDF file               :'+rrr_ncf_file1)
print('2nd netCDF file               :'+rrr_ncf_file2)
print('Relative tolerance            :'+str(ZS_rtol))
print('Absolute tolerance            :'+str(ZS_atol))
print('-------------------------------')


#*******************************************************************************
#Test if input files exist
#*******************************************************************************
try:
     with open(rrr_ncf_file1) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_ncf_file1)
     raise SystemExit(22) 

try:
     with open(rrr_ncf_file2) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_ncf_file2)
     raise SystemExit(22) 


#*******************************************************************************
#Read and compare netCDF files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Open files and get dimensions
#-------------------------------------------------------------------------------
f1 = netCDF4.Dataset(rrr_ncf_file1, "r")

if 'lon' in f1.dimensions:
     IS_lon_tot1=len(f1.dimensions['lon'])
else:
     print('ERROR - lon is not a dimension in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

if 'lat' in f1.dimensions:
     IS_lat_tot1=len(f1.dimensions['lat'])
else:
     print('ERROR - lat is not a dimension in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

if 'time' in f1.dimensions:
     IS_time1=len(f1.dimensions['time'])
else:
     print('ERROR - time is not a dimension in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

if 'RUNSF' in f1.variables:
     rrr_ncf_rsf1='RUNSF'
else:
     print('ERROR - RUNSF is not a variable in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

if 'RUNSB' in f1.variables:
     rrr_ncf_rsb1='RUNSB'
else:
     print('ERROR - RUNSB is not a variable in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

f2 = netCDF4.Dataset(rrr_ncf_file2, "r")

if 'lon' in f2.dimensions:
     IS_lon_tot2=len(f2.dimensions['lon'])
else:
     print('ERROR - lon is not a dimension in: '+rrr_ncf_file2) 
     raise SystemExit(99) 

if 'lat' in f2.dimensions:
     IS_lat_tot2=len(f2.dimensions['lat'])
else:
     print('ERROR - lat is not a dimension in: '+rrr_ncf_file2) 
     raise SystemExit(99) 

if 'time' in f2.dimensions:
     IS_time2=len(f2.dimensions['time'])
else:
     print('ERROR - time is not a dimension in: '+rrr_ncf_file2) 
     raise SystemExit(99) 

if 'RUNSF' in f2.variables:
     rrr_ncf_rsf2='RUNSF'
else:
     print('ERROR - RUNSF is not a variable in: '+rrr_ncf_file2) 
     raise SystemExit(99) 

if 'RUNSB' in f2.variables:
     rrr_ncf_rsb2='RUNSB'
else:
     print('ERROR - RUNSB is not a variable in: '+rrr_ncf_file2) 
     raise SystemExit(99) 

#-------------------------------------------------------------------------------
#Compare file sizes and variable names
#-------------------------------------------------------------------------------
if IS_lon_tot1==IS_lon_tot2:
     IS_lon_tot=IS_lon_tot1
     print('Common number of longitudes  :'+str(IS_lon_tot))
else:
     print('ERROR - The number of longitudes differs: '                        \
           +str(IS_lon_tot1)+' <> '+str(IS_lon_tot2))
     raise SystemExit(99) 

if IS_lat_tot1==IS_lat_tot2:
     IS_lat_tot=IS_lat_tot1
     print('Common number of latitudes   :'+str(IS_lat_tot))
else:
     print('ERROR - The number of latitudes differs: '                         \
           +str(IS_lat_tot1)+' <> '+str(IS_lat_tot2))
     raise SystemExit(99) 

if IS_time1==IS_time2:
     IS_time=IS_time1
     print('Common number of time steps  :'+str(IS_time))
else:
     print('ERROR - The number of time steps differs: '                        \
           +str(IS_time1)+' <> '+str(IS_time2))
     raise SystemExit(99) 

if rrr_ncf_rsf1==rrr_ncf_rsf2:
     rrr_ncf_rsf=rrr_ncf_rsf1
     print('Common surface runoff name   :'+rrr_ncf_rsf)
else:
     print('ERROR - The surface runoff names differ: '                         \
           +rrr_ncf_rsf1+' <> '+rrr_ncf_rsf1)
     raise SystemExit(99) 

if rrr_ncf_rsb1==rrr_ncf_rsb2:
     rrr_ncf_rsb=rrr_ncf_rsb1
     print('Common subsurface runoff name:'+rrr_ncf_rsb)
else:
     print('ERROR - The subsurface runoff names differ: '                      \
           +rrr_ncf_rsb1+' <> '+rrr_ncf_rsb1)
     raise SystemExit(99) 

print('-------------------------------')

#-------------------------------------------------------------------------------
#Compare coordinate values if they exist in both files
#-------------------------------------------------------------------------------
if 'lon' in f1.variables:
     IV_lon_tot1=f1.variables['lon']

if 'lon' in f2.variables:
     IV_lon_tot2=f2.variables['lon']

if 'IV_lon_tot1' in locals() and 'IV_lon_tot2' in locals():
     #This makes sure that both variables actually exist before comparing them
     if numpy.array_equal(IV_lon_tot1[:],IV_lon_tot2[:]):
          print('The longitudes are the same')
     else:
          print('ERROR: The longitudes differ')
          raise SystemExit(99) 
     print('-------------------------------')

if 'lat' in f1.variables:
     IV_lat_tot1=f1.variables['lat']

if 'lat' in f2.variables:
     IV_lat_tot2=f2.variables['lat']

if 'IV_lat_tot1' in locals() and 'IV_lat_tot2' in locals():
     #This makes sure that both variables actually exist before comparing them
     if numpy.array_equal(IV_lat_tot1[:],IV_lat_tot2[:]):
          print('The latitudes are the same')
     else:
          print('ERROR: The latitudes differ')
          raise SystemExit(99) 
     print('-------------------------------')

if 'time' in f1.variables:
     IV_time_tot1=f1.variables['time']

if 'time' in f2.variables:
     IV_time_tot2=f2.variables['time']

if 'IV_time_tot1' in locals() and 'IV_time_tot2' in locals():
     #This makes sure that both variables actually exist before comparing them
     if numpy.array_equal(IV_time_tot1[:],IV_time_tot2[:]):
          print('The times are the same')
     else:
          print('ERROR: The times differ')
          raise SystemExit(99) 
     print('-------------------------------')

#-------------------------------------------------------------------------------
#Compute differences 
#-------------------------------------------------------------------------------
ZS_rdif_max=0
ZS_adif_max=0

for JS_time in range(IS_time):
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#initializing
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZS_rdif=0
     ZS_adif=0

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#initializing
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZM_rsf_1=f1.variables[rrr_ncf_rsf][JS_time,:,:]
     ZM_rsf_2=f2.variables[rrr_ncf_rsf][JS_time,:,:]

     ZM_rsb_1=f1.variables[rrr_ncf_rsb][JS_time,:,:]
     ZM_rsb_2=f2.variables[rrr_ncf_rsb][JS_time,:,:]

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Comparing difference values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Tried computations with regular Python lists but this makes is very slow.
     #Also tried using map(operator.sub,V,W) or [x-y for x,y in zip(V,W)]
     #But this still results in slow computations.
     #The best performance seems to be with Numpy.
     #Note that the 'where' argument is used because otherwise numpy squares the
     #NoData values (in masked array) before applying the mask again which
     #creates overflows.
     # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     #Surface runoff
     # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     ZM_drsf_abs=numpy.absolute(ZM_rsf_1-ZM_rsf_2)

     ZS_adif_max=max(numpy.max(ZM_drsf_abs),ZS_adif_max)

     if (numpy.ma.is_masked(ZM_drsf_abs)):
          ZM_drsf_squ=numpy.square(ZM_drsf_abs,where=~ZM_drsf_abs.mask)
     else:
          ZM_drsf_squ=numpy.square(ZM_drsf_abs)
     if (numpy.ma.is_masked(ZM_rsf_1)):
          ZM_rsf_1squ=numpy.square(ZM_rsf_1,where=~ZM_rsf_1.mask)
     else:
          ZM_rsf_1squ=numpy.square(ZM_rsf_1)

     ZS_rdif= math.sqrt( numpy.sum(ZM_drsf_squ)                                \
                        /numpy.sum(ZM_rsf_1squ))
     ZS_rdif_max=max(ZS_rdif,ZS_rdif_max)

     # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     #Subsurface runoff
     # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
     ZM_drsb_abs=numpy.absolute(ZM_rsb_1-ZM_rsb_2)

     ZS_adif_max=max(numpy.max(ZM_drsb_abs),ZS_adif_max)

     if (numpy.ma.is_masked(ZM_drsb_abs)):
          ZM_drsb_squ=numpy.square(ZM_drsb_abs,where=~ZM_drsb_abs.mask)
     else:
          ZM_drsb_squ=numpy.square(ZM_drsb_abs)
     if (numpy.ma.is_masked(ZM_rsb_1)):
          ZM_rsb_1squ=numpy.square(ZM_rsb_1,where=~ZM_rsb_1.mask)
     else:
          ZM_rsb_1squ=numpy.square(ZM_rsb_1)

     ZS_rdif= math.sqrt( numpy.sum(ZM_drsb_squ)                                \
                        /numpy.sum(ZM_rsb_1squ))
     ZS_rdif_max=max(ZS_rdif,ZS_rdif_max)


#*******************************************************************************
#Print difference values and comparing values to tolerance
#*******************************************************************************
print('Max relative difference       :'+'{0:.2e}'.format(ZS_rdif_max))
print('Max absolute difference       :'+'{0:.2e}'.format(ZS_adif_max))
print('-------------------------------')

if ZS_rdif_max > ZS_rtol:
     print('Unacceptable rel. difference!!!')
     print('-------------------------------')
     raise SystemExit(99) 

if ZS_adif_max > ZS_atol:
     print('Unacceptable abs. difference!!!')
     print('-------------------------------')
     raise SystemExit(99) 

print('netCDF files similar!!!')
print('-------------------------------')


#*******************************************************************************
#End
#*******************************************************************************
