#!/usr/bin/env python2
#*******************************************************************************
#rrr_lsm_tot_utc_shf.py
#*******************************************************************************

#Purpose:
#Given a run file with lon, lat, and time dimensions, and with lon, lat, RUNSF, 
#and RUNSB variables(both in kg m-2); along with a number of time steps to shift
#this program creates creates a new netCDF file that is shifted in time.
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
import os.path


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_file1
# 2 - IS_shift
# 3 - rrr_lsm_file2


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22) 

rrr_lsm_file1=sys.argv[1]
IS_shift=int(sys.argv[2])
rrr_lsm_file2=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_file1)
print('- '+str(IS_shift))
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
#Copy data with time shift
#*******************************************************************************
print('Copy data with time shift')

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
print('- Copy existing global attributes')

if 'Conventions' in f.ncattrs(): g.Conventions=f.Conventions
if 'title'       in f.ncattrs(): g.title=f.title
if 'institution' in f.ncattrs(): g.institution=f.institution
if 'source'      in f.ncattrs(): g.source=f.source
if 'history'     in f.ncattrs(): g.history=f.history
if 'references'  in f.ncattrs(): g.references=f.references
if 'comment'     in f.ncattrs(): g.comment=f.comment

#-------------------------------------------------------------------------------
#Metadata in netCDF variable attributes
#-------------------------------------------------------------------------------
print('- Copy existing variable attributes')

if 'time' in f.variables:
     var=f.variables['time']
     if 'standard_name' in  var.ncattrs(): time.standard_name=var.standard_name
     if 'long_name' in var.ncattrs(): time.long_name=var.long_name
     if 'units' in var.ncattrs(): time.units=var.units
     if 'axis' in var.ncattrs(): time.axis=var.axis
     if 'calendar' in var.ncattrs(): time.calendar=var.calendar
     if 'bounds' in var.ncattrs(): time.bounds=var.bounds

if 'lat' in f.variables:
     var=f.variables['lat']
     if 'standard_name' in  var.ncattrs(): lat.standard_name=var.standard_name
     if 'long_name' in  var.ncattrs(): lat.long_name=var.long_name
     if 'units' in  var.ncattrs(): lat.units=var.units
     if 'axis' in  var.ncattrs(): lat.axis=var.axis

if 'lon' in f.variables:
     var=f.variables['lon']
     if 'standard_name' in  var.ncattrs(): lon.standard_name=var.standard_name
     if 'long_name' in  var.ncattrs(): lon.long_name=var.long_name
     if 'units' in  var.ncattrs(): lon.units=var.units
     if 'axis' in  var.ncattrs(): lon.axis=var.axis

if 'RUNSF' in f.variables: 
     var=f.variables['RUNSF']
     if 'standard_name' in var.ncattrs(): RUNSF.standard_name=var.standard_name
     if 'long_name' in var.ncattrs(): RUNSF.long_name=var.long_name
     if 'units' in var.ncattrs(): RUNSF.units=var.units
     if 'units' in var.ncattrs(): RUNSF.coordinates=var.coordinates
     if 'grid_mapping' in var.ncattrs(): RUNSF.grid_mapping=var.grid_mapping
     if 'cell_methods' in var.ncattrs(): RUNSF.cell_methods=var.cell_methods

if 'RUNSB' in f.variables: 
     var=f.variables['RUNSB']
     if 'standard_name' in var.ncattrs(): RUNSB.standard_name=var.standard_name
     if 'long_name' in var.ncattrs(): RUNSB.long_name=var.long_name
     if 'units' in var.ncattrs(): RUNSB.units=var.units
     if 'units' in var.ncattrs(): RUNSB.coordinates=var.coordinates
     if 'grid_mapping' in var.ncattrs(): RUNSB.grid_mapping=var.grid_mapping
     if 'cell_methods' in var.ncattrs(): RUNSB.cell_methods=var.cell_methods

if 'crs' in f.variables: 
     var=f.variables['crs']
     if 'grid_mapping_name' in var.ncattrs(): crs.grid_mapping_name=var.grid_mapping_name
     if 'semi_major_axis' in var.ncattrs(): crs.semi_major_axis=var.semi_major_axis
     if 'inverse_flattening' in var.ncattrs(): crs.inverse_flattening=var.inverse_flattening

#-------------------------------------------------------------------------------
#Copy data from existing netCDF file
#-------------------------------------------------------------------------------
print('- Copy data from existing netCDF file')

lon[:]=f.variables['lon'][:]
lat[:]=f.variables['lat'][:]
for JS_lsm_time in range(IS_lsm_time-IS_shift):
     RUNSF[JS_lsm_time]=f.variables['RUNSF'][JS_lsm_time+IS_shift]
     RUNSB[JS_lsm_time]=f.variables['RUNSB'][JS_lsm_time+IS_shift]
     time[JS_lsm_time]=f.variables['time'][JS_lsm_time+IS_shift]
     time_bnds[JS_lsm_time]=f.variables['time_bnds'][JS_lsm_time+IS_shift]
#Copy all existing data shifted by IS_shift values


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
