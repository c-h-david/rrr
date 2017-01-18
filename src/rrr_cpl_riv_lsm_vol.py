#!/usr/bin/python
#*******************************************************************************
#rrr_cpl_riv_lsm_vol.py
#*******************************************************************************

#Purpose:
#Given a river connectivity file, a river coordinate file, a runoff file, and a 
#coupling file, this program creates an inflow file for river modeling with the
#following information:
# - rrr_vol_file(rivid,time,nv)
#   . rivid(rivid)
#   . m3_riv(rivid,time)
#   . time(time)
#   . time_bnds(time,nv)
#   . lon(lon)
#   . lat(lat)
#   . crs
#Author:
#Cedric H. David, 2011-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import netCDF4
import datetime
import calendar
import os.path
import subprocess
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_con_file
# 2 - rrr_crd_file
# 3 - rrr_lsm_file
# 4 - rrr_cpl_file
# 5 - rrr_vol_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22) 

rrr_con_file=sys.argv[1]
rrr_crd_file=sys.argv[2]
rrr_lsm_file=sys.argv[3]
rrr_cpl_file=sys.argv[4]
rrr_vol_file=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_con_file)
print('- '+rrr_crd_file)
print('- '+rrr_lsm_file)
print('- '+rrr_cpl_file)
print('- '+rrr_vol_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_con_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_file)
     raise SystemExit(22) 

try:
     with open(rrr_crd_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_crd_file)
     raise SystemExit(22) 

try:
     with open(rrr_lsm_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_file)
     raise SystemExit(22) 

try:
     with open(rrr_cpl_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_cpl_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read inputs
#*******************************************************************************
print('Read inputs')

#-------------------------------------------------------------------------------
#Read connectivity file
#-------------------------------------------------------------------------------
print('- Read connectivity file')

IV_riv_tot_id1=[]
with open(rrr_con_file) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          IV_riv_tot_id1.append(int(row[0]))
IS_riv_tot1=len(IV_riv_tot_id1)
print('  . The number of river reaches in connectivity file is: '              \
           +str(IS_riv_tot1))

#-------------------------------------------------------------------------------
#Read coordinates file
#-------------------------------------------------------------------------------
print('- Read coordinates file')

IV_riv_tot_id2=[]
ZV_lon=[]
ZV_lat=[]
with open(rrr_crd_file) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          IV_riv_tot_id2.append(int(row[0]))
          ZV_lon.append(row[1])
          ZV_lat.append(row[2])
IS_riv_tot2=len(IV_riv_tot_id2)
print('  . The number of river reaches in coordinates file is: '               \
         +str(IS_riv_tot2))

#-------------------------------------------------------------------------------
#Read netCDF file
#-------------------------------------------------------------------------------
print('- Read netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Open netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f = netCDF4.Dataset(rrr_lsm_file, 'r')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get dimension sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_lsm_lon=len(f.dimensions['lon'])
print('  . The number of longitudes is: '+str(IS_lsm_lon))

IS_lsm_lat=len(f.dimensions['lat'])
print('  . The number of latitudes is: '+str(IS_lsm_lat))

IS_lsm_time=len(f.dimensions['time'])
print('  . The number of time steps is: '+str(IS_lsm_time))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get fill values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Read runoff fill values')
ZS_fill_runsf=netCDF4.default_fillvals['f4']
if 'RUNSF' in f.variables:
     var=f.variables['RUNSF']
     if '_FillValue' in  var.ncattrs(): 
          ZS_fill_runsf=var._FillValue
          print('  . The fill value for RUNSF is: '+str(ZS_fill_runsf))
     

ZS_fill_runsb=netCDF4.default_fillvals['f4']
if 'RUNSB' in f.variables:
     var=f.variables['RUNSB']
     if '_FillValue' in  var.ncattrs(): 
          ZS_fill_runsb=var._FillValue
          print('  . The fill value for RUNSB is: '+str(ZS_fill_runsb))

#-------------------------------------------------------------------------------
#Read coupling file
#-------------------------------------------------------------------------------
print('- Read coupling file')

IV_riv_tot_id3=[]
ZV_riv_sqkm=[]
IV_riv_i_index=[]
IV_riv_j_index=[]
with open(rrr_cpl_file) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          IV_riv_tot_id3.append(int(row[0]))
          ZV_riv_sqkm.append(row[1])
          IV_riv_i_index.append(int(row[2]))
          IV_riv_j_index.append(int(row[3]))
IS_riv_tot3=len(IV_riv_tot_id3)
print('  . The number of river reaches in coupling file is: '+str(IS_riv_tot3))

#-------------------------------------------------------------------------------
#Checking that IDs are the same
#-------------------------------------------------------------------------------
print('- Checking that IDs are the same')

if IS_riv_tot1 != IS_riv_tot2:
     print('ERROR - Number of river reaches differ')
     raise SystemExit(22) 
elif IS_riv_tot1 != IS_riv_tot3:
     print('ERROR - Number of river reaches differ')
     raise SystemExit(22) 
else:
     IS_riv_tot=IS_riv_tot1

for JS_riv_tot in range(IS_riv_tot):
     if IV_riv_tot_id1[JS_riv_tot] != IV_riv_tot_id2[JS_riv_tot]:
          print('ERROR - River reaches differ')
          raise SystemExit(22) 
     if IV_riv_tot_id1[JS_riv_tot] != IV_riv_tot_id3[JS_riv_tot]:
          print('ERROR - River reaches differ')
          raise SystemExit(22) 
IV_riv_tot_id=IV_riv_tot_id1
print(' . IDs are the same')


#*******************************************************************************
#Process data
#*******************************************************************************
print('Process data')

#-------------------------------------------------------------------------------
#Create netCDF file
#-------------------------------------------------------------------------------
print('- Create netCDF file')
g = netCDF4.Dataset(rrr_vol_file, "w", format="NETCDF3_CLASSIC")

ZS_fill_m3_riv=float(1e20)

time = g.createDimension("time", None)
rivid = g.createDimension("rivid", IS_riv_tot)
nv = g.createDimension("nv", 2)

m3_riv = g.createVariable("m3_riv","f4",("time","rivid",),                     \
                         fill_value=ZS_fill_m3_riv)
rivid = g.createVariable("rivid","i4",("rivid",))
time = g.createVariable("time","i4",("time",))
time_bnds = g.createVariable("time_bnds","i4",("time","nv",))
lon = g.createVariable("lon","f8",("rivid",))
lat = g.createVariable("lat","f8",("rivid",))
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
g.source='RRR: '+vsn+', runoff: '+os.path.basename(rrr_lsm_file)
g.history='date created: '+dt.isoformat()+'+00:00'
g.references='https://github.com/c-h-david/rrr/'
g.comment=''
g.featureType='timeSeries'

#-------------------------------------------------------------------------------
#Metadata in netCDF variable attributes
#-------------------------------------------------------------------------------
print('- Populate variable attributes')

#m3_riv.standard_name=''
m3_riv.long_name='accumulated external water volume inflow upstream of each ' \
                 +'river reach'
m3_riv.units='m3'
m3_riv.coordinates='lon lat'
m3_riv.grid_mapping='crs'
m3_riv.cell_methods='time: sum'

time.standard_name='time'
time.long_name='time'
time.units='seconds since 1970-01-01 00:00:00 +00:00'
time.axis='T'
time.calendar='gregorian'
time.bounds='time_bnds'

rivid.long_name='unique identifier for each river each'
rivid.units='1'
rivid.cf_role='timeseries_id'

lon.standard_name='longitude'
lon.long_name='longitude of a point related to each river reach'
lon.units='degrees_east'
lon.axis='X'

lat.standard_name='latitude'
lat.long_name='latitude of a point related to each river reach'
lat.units='degrees_north'
lat.axis='Y'

crs.grid_mapping_name='latitude_longitude'
crs.semi_major_axis=''
crs.inverse_flattening=''

#-------------------------------------------------------------------------------
#Populate static data and read through LSM data to compute/populate dynamic data
#-------------------------------------------------------------------------------
print('- Populate data')

rivid[:]=IV_riv_tot_id[:]
#Common to many of the input files
lon[:]=ZV_lon[:]
lat[:]=ZV_lat[:]
#from the coordinate file

ZV_riv_sqkm[:] = [x*1000 for x in ZV_riv_sqkm]
#scale by 1000 to avoid doing so over and over below 
for JS_lsm_time in range(IS_lsm_time):
     if IS_lsm_time >=100:
          IS_lsm_percent=int(IS_lsm_time/100)+(IS_lsm_time%100>0)
          #rounds UP the value of IS_lsm_time/100
          if JS_lsm_time % IS_lsm_percent == 0:
               print(' . Completed '+str(int(JS_lsm_time/IS_lsm_percent))+'%')
               #show progress in percent
     ZM_lsm_runsf=f.variables['RUNSF'][JS_lsm_time][:][:]
     ZM_lsm_runsb=f.variables['RUNSB'][JS_lsm_time][:][:]
     #The netCDF data are stored following: f.variables[var][time][lat][lon]
     ZM_lsm_run=ZM_lsm_runsf+ZM_lsm_runsb
     #ZM_lsm_run is of type 'numpy.ma.core.MaskedArray' or 'numpy.ndarray'
    
     #if type(ZM_lsm_run)==numpy.ma.core.MaskedArray: 
     #     print(' . This netCDF variable reads as a numpy masked array')
     #     print(' . # of values (not NoData):'                                 \
     #          +str(ZM_lsm_runsf.count(axis=None)))
     #elif type(ZM_lsm_run)==numpy.ndarray: 
     #     print(' . This netCDF variable reads as a numpy N-dimensional')
     ##Helpful to detect if NoData values are included. Python netCDF4 assumes 
     ##that everything is NoData if the _fillValue attribute is not present.

     ZV_riv_vol=[ZS_fill_m3_riv]*IS_riv_tot
     #start with NoData everywhere
     for JS_riv_tot in range(IS_riv_tot):
          ZS_riv_sqkm=ZV_riv_sqkm[JS_riv_tot]
          JS_riv_i_index=IV_riv_i_index[JS_riv_tot]-1
          JS_riv_j_index=IV_riv_j_index[JS_riv_tot]-1
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          if JS_riv_j_index>=0 and JS_riv_j_index>=0:
               ZS_lsm_run=ZM_lsm_run[JS_riv_j_index,JS_riv_i_index]
               #It is much faster to use [j,i] than [j][i] here.
               if type(ZS_lsm_run)==numpy.float32: 
                    ZS_lsm_run_clean=float(ZS_lsm_run)
                    #print('float32')
               elif type(ZS_lsm_run)==numpy.ma.core.MaskedConstant: 
                    ZS_lsm_run_clean=float(0)
                    #print('Masked constant')
               else:
                    print('ERROR - Unrecognized format for runoff value'       \
                          +str(type(ZS_lsm_run)))
                    raise SystemExit(22) 
          else:
               ZS_lsm_run_clean=float(0)
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          ZS_riv_vol=ZS_riv_sqkm*ZS_lsm_run_clean
          ZV_riv_vol[JS_riv_tot]=ZS_riv_vol

     m3_riv[JS_lsm_time,:]=ZV_riv_vol[:]
     #The netCDF data are stored following: g.variables[m3_riv][time][rivid]
print(' . Completed 100%')

time[:]=f.variables['time'][:]
time_bnds[:]=f.variables['time_bnds'][:]
#From the LSM netCDF file


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
