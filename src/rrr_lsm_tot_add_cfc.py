#!/usr/bin/python
#*******************************************************************************
#rrr_lsm_tot_add_cfc.py
#*******************************************************************************

#Purpose:
#Given a run file with lon, lat, and time dimensions, and with lon, lat, RUNSF, 
#and RUNSB variables(both in kg m-2); along with a start date of the following 
#ISO 8601 format: '2000-01-01T00:00:00' and the duration of the time step, this 
#program creates creates a new netCDF file that is CF-1.6 compliant and that 
#includes time and time_bnds variables.
# - rrr_lsm_file2(lon,lat,time,nv)
#   . RUNSF(lon,lat,time)
#   . RUNSF(lon,lat,time)
#   . time(time)
#   . time_bnds(time,nv)
#   . lon(lon)
#   . lat(lat)
#   . crs
#Author:
#Cedric H. David, 2016-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import datetime
import calendar
import os.path
import subprocess


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_file1
# 2 - rrr_str_date
# 3 - rrr_inc_secs
# 4 - rrr_lsm_file2


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

rrr_lsm_file1=sys.argv[1]
rrr_str_date=sys.argv[2]
rrr_inc_secs=int(sys.argv[3])
rrr_lsm_file2=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_file1)
print('- '+rrr_str_date)
print('- '+str(rrr_inc_secs))
print('- '+rrr_lsm_file2)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_lsm_file1) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_file1)
     raise SystemExit(22) 


#*******************************************************************************
#Read temporal data (should have been provided in UTC)
#*******************************************************************************
print('Read temporal data (should have been provided in UTC)')
obj_str_date=datetime.datetime.strptime(rrr_str_date,'%Y-%m-%dT%H:%M:%S')
IS_inc_secs=int(rrr_inc_secs)
print('- The ISO 8601 time at start is: '+obj_str_date.isoformat())
print('- The increment between time steps is: '+str(IS_inc_secs)+' seconds')


#*******************************************************************************
#Read input netCDF file
#*******************************************************************************
print('Reading input netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Open netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f = netCDF4.Dataset(rrr_lsm_file1, 'r')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get dimension sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_lsm_lon=len(f.dimensions['lon'])
print(' - The number of longitudes is: '+str(IS_lsm_lon))

IS_lsm_lat=len(f.dimensions['lat'])
print(' - The number of latitudes is: '+str(IS_lsm_lat))

IS_lsm_time=len(f.dimensions['time'])
print(' - The number of time steps is: '+str(IS_lsm_time))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get fill values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZS_fill_runsf=netCDF4.default_fillvals['f4']
if 'RUNSF' in f.variables:
     var=f.variables['RUNSF']
     if '_FillValue' in  var.ncattrs(): 
          ZS_fill_runsf=var._FillValue
          print(' - The fill value for RUNSF is: '+str(ZS_fill_runsf))
     else:
          ZS_fill_runsf=None
     

ZS_fill_runsb=netCDF4.default_fillvals['f4']
if 'RUNSB' in f.variables:
     var=f.variables['RUNSB']
     if '_FillValue' in  var.ncattrs(): 
          ZS_fill_runsb=var._FillValue
          print(' - The fill value for RUNSB is: '+str(ZS_fill_runsb))
     else:
          ZS_fill_runsb=None


#*******************************************************************************
#Process data
#*******************************************************************************
print('Process data')

#-------------------------------------------------------------------------------
#Create netCDF file
#-------------------------------------------------------------------------------
print('- Create new netCDF file')
g = netCDF4.Dataset(rrr_lsm_file2, "w", format="NETCDF3_CLASSIC")

time = g.createDimension("time", None)
lat = g.createDimension("lat", IS_lsm_lat)
lon = g.createDimension("lon", IS_lsm_lon)
nv = g.createDimension("nv", 2)

time = g.createVariable("time","i4",("time",))
time_bnds = g.createVariable("time_bnds","i4",("time","nv",))
lat = g.createVariable("lat","f4",("lat",))
lon = g.createVariable("lon","f4",("lon",))
RUNSF = g.createVariable("RUNSF","f4",("time","lat","lon",),                   \
                         fill_value=ZS_fill_runsf)
RUNSB = g.createVariable("RUNSB","f4",("time","lat","lon",),                   \
                         fill_value=ZS_fill_runsb)
crs = g.createVariable("crs","i4")

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
#Version of RRR

g.Conventions='CF-1.6'
g.title=''
g.institution=''
g.source='RRR: '+vsn+', runoff: '+os.path.basename(rrr_lsm_file1)
g.history='date created: '+dt.isoformat()+'+00:00'
g.references='https://github.com/c-h-david/rrr/'
g.comment=''

#-------------------------------------------------------------------------------
#Metadata in netCDF variable attributes
#-------------------------------------------------------------------------------
print('- Populate variable attributes')

time.standard_name='time'
time.long_name='time'
time.units='seconds since 1970-01-01 00:00:00 +00:00'
time.axis='T'
time.calendar='gregorian'
time.bounds='time_bnds'

lon.standard_name='longitude'
lon.long_name='longitude'
lon.units='degrees_east'
lon.axis='X'

lat.standard_name='latitude'
lat.long_name='latitude'
lat.units='degrees_north'
lat.axis='Y'

RUNSF.standard_name='surface_runoff_amount'
RUNSF.long_name='Surface runoff'
RUNSF.units='kg m-2'
RUNSF.coordinates='lon lat'
RUNSF.grid_mapping='crs'
RUNSF.cell_methods='time: sum'

RUNSB.standard_name='subsurface_runoff_amount'
RUNSB.long_name='Subsurface runoff'
RUNSB.units='kg m-2'
RUNSB.coordinates='lon lat'
RUNSB.grid_mapping='crs'
RUNSB.cell_methods='time: sum'

crs.grid_mapping_name='latitude_longitude'
crs.semi_major_axis=''
crs.inverse_flattening=''

#-------------------------------------------------------------------------------
#Populate static data and read through LSM data to compute/populate dynamic data
#-------------------------------------------------------------------------------
print('- Copy data from existing netCDF file')

lon[:]=f.variables['lon'][:]
lat[:]=f.variables['lat'][:]
RUNSF[:]=f.variables['RUNSF'][:]
RUNSB[:]=f.variables['RUNSB'][:]

#-------------------------------------------------------------------------------
#Populate time data 
#-------------------------------------------------------------------------------
print('- Populate time data')

time[0]=calendar.timegm(obj_str_date.timetuple())
#The number of seconds between the start date in the 'epoch' described by the 
#character string: '1970-01-01T00:00:00+00:00'.  The calendar.timegm() function 
#assumes that the time is given in UTC, this is better than time.mktime() which 
#assumes local time is given.
for JS_lsm_time in range(IS_lsm_time-1):
     time[JS_lsm_time+1]=time[JS_lsm_time]+IS_inc_secs
     #increment each time step by the number of seconds provided as input.

#the bounds of the time interval over which the accumulated volume is calculated
for JS_lsm_time in range(IS_lsm_time):
     time_bnds[JS_lsm_time]=[time[JS_lsm_time],time[JS_lsm_time]+IS_inc_secs]


#*******************************************************************************
#Close the netCDF file
#*******************************************************************************
print('Close all netCDF files')

f.close()
#Not sure if that does anything
g.close()
#Closing the new netCDF file allows populating all data 


#*******************************************************************************
#End
#*******************************************************************************
