#!/usr/bin/env python3
#*******************************************************************************
#rrr_lsm_tot_ens.py
#*******************************************************************************

#Purpose:
#Given three files with time-varying surface and subsurface runoff (in kg/m2) 
#and the name of a new netCDF file, this program computes the ensemble average
#of surface runoff and subsurface runoff for the new file.
#Author:
#Cedric H. David, 2022-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import shutil
import netCDF4
import numpy
import datetime
import os.path
import subprocess


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_in1
# 2 - rrr_lsm_in2
# 3 - rrr_lsm_in3
# 4 - rrr_lsm_out


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments must be used')
     raise SystemExit(22) 

rrr_lsm_in1=sys.argv[1]
rrr_lsm_in2=sys.argv[2]
rrr_lsm_in3=sys.argv[3]
rrr_lsm_out=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_in1)
print('- '+rrr_lsm_in2)
print('- '+rrr_lsm_in3)
print('- '+rrr_lsm_out)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_lsm_in1) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_in1)
     raise SystemExit(22) 

try:
     with open(rrr_lsm_in2) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_in2)
     raise SystemExit(22) 

try:
     with open(rrr_lsm_in3) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_in3)
     raise SystemExit(22) 


#*******************************************************************************
#Reading netCDF file 1
#*******************************************************************************
print('Reading netCDF file 1')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f1 = netCDF4.Dataset(rrr_lsm_in1, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'lon' in f1.dimensions:
     YS_lon1='lon'
else:
     print('ERROR - lon dimension does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

IS_lon1=len(f1.dimensions[YS_lon1])
print('- The number of longitudes is: '+str(IS_lon1))

if 'lat' in f1.dimensions:
     YS_lat1='lat'
else:
     print('ERROR - lat dimension does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

IS_lat1=len(f1.dimensions[YS_lat1])
print('- The number of latitudes  is: '+str(IS_lat1))

if 'time' in f1.dimensions:
     YS_time1='time'
else:
     print('ERROR - time dimension does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

IS_time1=len(f1.dimensions[YS_time1])
print('- The number of time steps is: '+str(IS_time1))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'RUNSF' in f1.variables:
     YS_RUNSF1='RUNSF'
     if '_FillValue' in  f1.variables[YS_RUNSF1].ncattrs(): 
          ZS_RUNSF_fill1=f1.variables[YS_RUNSF1]._FillValue
          print('- The fill value for RUNSF is: '+str(ZS_RUNSF_fill1))
     else:
          ZS_RUNSF_fill1=None
else:
     print('ERROR - RUNSF variable does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

if 'RUNSB' in f1.variables:
     YS_RUNSB1='RUNSB'
     if '_FillValue' in  f1.variables[YS_RUNSB1].ncattrs(): 
          ZS_RUNSB_fill1=f1.variables[YS_RUNSB1]._FillValue
          print('- The fill value for RUNSB is: '+str(ZS_RUNSB_fill1))
     else:
          ZS_RUNSB_fill1=None
else:
     print('ERROR - RUNSB variable does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

if 'lon' in f1.variables:
     YS_lon1='lon'
     ZV_lon1=f1.variables[YS_lon1][:]
else:
     print('ERROR - lon variable does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

if 'lat' in f1.variables:
     YS_lat='lat'
     ZV_lat1=f1.variables[YS_lat1][:]
else:
     print('ERROR - lat does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

if 'time' in f1.variables:
     YS_time1='time'
     ZV_time1=f1.variables[YS_time1][:]
else:
     print('ERROR - time does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 


#*******************************************************************************
#Reading netCDF file 2
#*******************************************************************************
print('Reading netCDF file 2')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f2 = netCDF4.Dataset(rrr_lsm_in2, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'lon' in f2.dimensions:
     YS_lon2='lon'
else:
     print('ERROR - lon dimension does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

IS_lon2=len(f2.dimensions[YS_lon2])
print('- The number of longitudes is: '+str(IS_lon2))

if 'lat' in f2.dimensions:
     YS_lat2='lat'
else:
     print('ERROR - lat dimension does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

IS_lat2=len(f2.dimensions[YS_lat2])
print('- The number of latitudes  is: '+str(IS_lat2))

if 'time' in f2.dimensions:
     YS_time2='time'
else:
     print('ERROR - time dimension does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

IS_time2=len(f2.dimensions[YS_time2])
print('- The number of time steps is: '+str(IS_time2))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'RUNSF' in f2.variables:
     YS_RUNSF2='RUNSF'
     if '_FillValue' in  f2.variables[YS_RUNSF2].ncattrs(): 
          ZS_RUNSF_fill2=f2.variables[YS_RUNSF2]._FillValue
          print('- The fill value for RUNSF is: '+str(ZS_RUNSF_fill2))
     else:
          ZS_RUNSF_fill2=None
else:
     print('ERROR - RUNSF variable does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

if 'RUNSB' in f2.variables:
     YS_RUNSB2='RUNSB'
     if '_FillValue' in  f2.variables[YS_RUNSB2].ncattrs(): 
          ZS_RUNSB_fill2=f2.variables[YS_RUNSB2]._FillValue
          print('- The fill value for RUNSB is: '+str(ZS_RUNSB_fill2))
     else:
          ZS_RUNSB_fill2=None
else:
     print('ERROR - RUNSB variable does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

if 'lon' in f2.variables:
     YS_lon2='lon'
     ZV_lon2=f2.variables[YS_lon2][:]
else:
     print('ERROR - lon variable does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

if 'lat' in f2.variables:
     YS_lat='lat'
     ZV_lat2=f2.variables[YS_lat2][:]
else:
     print('ERROR - lat does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

if 'time' in f2.variables:
     YS_time2='time'
     ZV_time2=f2.variables[YS_time2][:]
else:
     print('ERROR - time does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 


#*******************************************************************************
#Reading netCDF file 3
#*******************************************************************************
print('Reading netCDF file 3')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f3 = netCDF4.Dataset(rrr_lsm_in3, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'lon' in f3.dimensions:
     YS_lon3='lon'
else:
     print('ERROR - lon dimension does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

IS_lon3=len(f3.dimensions[YS_lon3])
print('- The number of longitudes is: '+str(IS_lon3))

if 'lat' in f3.dimensions:
     YS_lat3='lat'
else:
     print('ERROR - lat dimension does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

IS_lat3=len(f3.dimensions[YS_lat3])
print('- The number of latitudes  is: '+str(IS_lat3))

if 'time' in f3.dimensions:
     YS_time3='time'
else:
     print('ERROR - time dimension does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

IS_time3=len(f3.dimensions[YS_time3])
print('- The number of time steps is: '+str(IS_time3))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'RUNSF' in f3.variables:
     YS_RUNSF3='RUNSF'
     if '_FillValue' in  f3.variables[YS_RUNSF3].ncattrs(): 
          ZS_RUNSF_fill3=f3.variables[YS_RUNSF3]._FillValue
          print('- The fill value for RUNSF is: '+str(ZS_RUNSF_fill3))
     else:
          ZS_RUNSF_fill3=None
else:
     print('ERROR - RUNSF variable does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

if 'RUNSB' in f3.variables:
     YS_RUNSB3='RUNSB'
     if '_FillValue' in  f3.variables[YS_RUNSB3].ncattrs(): 
          ZS_RUNSB_fill3=f3.variables[YS_RUNSB3]._FillValue
          print('- The fill value for RUNSB is: '+str(ZS_RUNSB_fill3))
     else:
          ZS_RUNSB_fill3=None
else:
     print('ERROR - RUNSB variable does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

if 'lon' in f3.variables:
     YS_lon3='lon'
     ZV_lon3=f3.variables[YS_lon3][:]
else:
     print('ERROR - lon variable does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

if 'lat' in f3.variables:
     YS_lat='lat'
     ZV_lat3=f3.variables[YS_lat3][:]
else:
     print('ERROR - lat does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

if 'time' in f3.variables:
     YS_time3='time'
     ZV_time3=f3.variables[YS_time3][:]
else:
     print('ERROR - time does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 


#*******************************************************************************
#Check consistency
#*******************************************************************************
print('Check consistency')

if IS_lon1==IS_lon2 and IS_lon1==IS_lon3: 
     IS_lon=IS_lon1
     print('- Common number of longitudes: '+str(IS_lon))
else: 
     print('ERROR - The number of longitudes differ')
     raise SystemExit(22) 

if IS_lat1==IS_lat2 and IS_lat1==IS_lat3: 
     IS_lat=IS_lat1
     print('- Common number of latitudes: '+str(IS_lat))
else: 
     print('ERROR - The number of latitudes differ')
     raise SystemExit(22) 

if IS_time1==IS_time2 and IS_time1==IS_time3: 
     IS_time=IS_time1
     print('- Common number of time steps: '+str(IS_time))
else: 
     print('ERROR - The number of time steps differ')
     raise SystemExit(22) 

if (ZV_lon1==ZV_lon2).all() and (ZV_lon1==ZV_lon3).all():
     ZV_lon=ZV_lon1
     print('- The longitudes are the same')
else:
     print('ERROR - The longitudes differ')
     raise SystemExit(22)

if (ZV_lat1==ZV_lat2).all() and (ZV_lat1==ZV_lat3).all():
     ZV_lat=ZV_lat1
     print('- The latitudes are the same')
else:
     print('ERROR - The latitudes differ')
     raise SystemExit(22)

if (ZV_time1==ZV_time2).all() and (ZV_time1==ZV_time3).all():
     ZV_time=ZV_time1
     print('- The times are the same')
else:
     print('ERROR - The times differ')
     raise SystemExit(22)


#*******************************************************************************
#Copying netCDF file
#*******************************************************************************
print('Copying netCDF file')

shutil.copyfile(rrr_lsm_in1,rrr_lsm_out)

print('- Done')


#*******************************************************************************
#Populating netCDF file with ensemble averages
#*******************************************************************************
print('Populating netCDF file with ensemble averages')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f4 = netCDF4.Dataset(rrr_lsm_out, 'a')

ZV_RUNSF4=f4.variables[YS_RUNSF1]
ZV_RUNSB4=f4.variables[YS_RUNSB1]

#-------------------------------------------------------------------------------
#Computing ensemble average
#-------------------------------------------------------------------------------
print('- Computing ensemble average')

ZV_RUNSF_av1=numpy.empty([IS_lat,IS_lon])
ZV_RUNSF_av2=numpy.empty([IS_lat,IS_lon])
ZV_RUNSF_av3=numpy.empty([IS_lat,IS_lon])
ZV_RUNSF_avt=numpy.empty([IS_lat,IS_lon])

ZV_RUNSB_av1=numpy.empty([IS_lat,IS_lon])
ZV_RUNSB_av2=numpy.empty([IS_lat,IS_lon])
ZV_RUNSB_av3=numpy.empty([IS_lat,IS_lon])
ZV_RUNSB_avt=numpy.empty([IS_lat,IS_lon])

for JS_time in range(IS_time):
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #RUNSF
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ZV_RUNSF1=f1.variables[YS_RUNSF1][JS_time,:]
     ZV_RUNSF2=f2.variables[YS_RUNSF2][JS_time,:]
     ZV_RUNSF3=f3.variables[YS_RUNSF3][JS_time,:]
     ZV_RUNSFt=(ZV_RUNSF1+ZV_RUNSF2+ZV_RUNSF3)/3

     ZV_RUNSF_av1=ZV_RUNSF_av1+ZV_RUNSF1
     ZV_RUNSF_av2=ZV_RUNSF_av2+ZV_RUNSF2
     ZV_RUNSF_av3=ZV_RUNSF_av3+ZV_RUNSF3
     ZV_RUNSF_avt=ZV_RUNSF_avt+ZV_RUNSFt

     ZV_RUNSF4[JS_time,:]=ZV_RUNSFt

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #RUNSB
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ZV_RUNSB1=f1.variables[YS_RUNSB1][JS_time,:]
     ZV_RUNSB2=f2.variables[YS_RUNSB2][JS_time,:]
     ZV_RUNSB3=f3.variables[YS_RUNSB3][JS_time,:]
     ZV_RUNSBt=(ZV_RUNSB1+ZV_RUNSB2+ZV_RUNSB3)/3

     ZV_RUNSB_av1=ZV_RUNSB_av1+ZV_RUNSB1
     ZV_RUNSB_av2=ZV_RUNSB_av2+ZV_RUNSB2
     ZV_RUNSB_av3=ZV_RUNSB_av3+ZV_RUNSB3
     ZV_RUNSB_avt=ZV_RUNSB_avt+ZV_RUNSBt

     ZV_RUNSB4[JS_time,:]=ZV_RUNSBt

ZV_RUNSF_av1=ZV_RUNSF_av1/IS_time
ZV_RUNSF_av2=ZV_RUNSF_av2/IS_time
ZV_RUNSF_av3=ZV_RUNSF_av3/IS_time
ZV_RUNSF_avt=ZV_RUNSF_avt/IS_time

ZV_RUNSB_av1=ZV_RUNSB_av1/IS_time
ZV_RUNSB_av2=ZV_RUNSB_av2/IS_time
ZV_RUNSB_av3=ZV_RUNSB_av3/IS_time
ZV_RUNSB_avt=ZV_RUNSB_avt/IS_time

#-------------------------------------------------------------------------------
#Metadata in netCDF global attributes
#-------------------------------------------------------------------------------
print('- Populate global attributes')

dt=datetime.datetime.utcnow()
dt=dt.replace(microsecond=0)
#Current UTC time without the microseconds
vsn=subprocess.Popen('../version.sh',stdout=subprocess.PIPE).communicate()
vsn=vsn[0]
vsn=vsn.rstrip()
vsn=vsn.decode()
#Version of RRR

f4.Conventions='CF-1.6'
f4.title=''
f4.institution=''
f4.source='RRR: '+vsn+', runoff: '+os.path.basename(rrr_lsm_in1)+', '          \
                                  +os.path.basename(rrr_lsm_in2)+', '          \
                                  +os.path.basename(rrr_lsm_in3)
f4.history='date created: '+dt.isoformat()+'+00:00'
f4.references='https://github.com/c-h-david/rrr/'
f4.comment=''

#-------------------------------------------------------------------------------
#Close netCDF files
#-------------------------------------------------------------------------------
f1.close()
f2.close()
f3.close()
f4.close()


#*******************************************************************************
#Printing some diagnostic quantities
#*******************************************************************************
print('Printing some diagnostic quantities')

print('- Average of RUNSF for rrr_lsm_in1 '+str(ZV_RUNSF_av1.mean()))
print('- Average of RUNSF for rrr_lsm_in2 '+str(ZV_RUNSF_av2.mean()))
print('- Average of RUNSF for rrr_lsm_in3 '+str(ZV_RUNSF_av3.mean()))
print('- Average of RUNSF for rrr_lsm_out '+str(ZV_RUNSF_avt.mean()))

print('- Average of RUNSB for rrr_lsm_in1 '+str(ZV_RUNSB_av1.mean()))
print('- Average of RUNSB for rrr_lsm_in2 '+str(ZV_RUNSB_av2.mean()))
print('- Average of RUNSB for rrr_lsm_in3 '+str(ZV_RUNSB_av3.mean()))
print('- Average of RUNSB for rrr_lsm_out '+str(ZV_RUNSB_avt.mean()))


#*******************************************************************************
#End
#*******************************************************************************
