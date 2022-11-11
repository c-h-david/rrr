#!/usr/bin/env python3
#*******************************************************************************
#rrr_cpl_riv_lsm_rte.py
#*******************************************************************************

#Purpose:
#Given a RAPID water inflow file (.nc4), a RAPID connectivity file (.csv), a
#RAPID basin ID file (.csv), and a RAPID discharge outflow file (.nc4); this
#program computes a matrix-based lumped routing and saves the results in the
#outflow file. Note that a lumped routing on a sub-basin (defined in the basin
#ID file) is possible.
#Optional arguments consisting of a Muskingum k file (.csv) and a water storage
#file (.nc4) can allow for estimates of water storage.
#Author:
#Cedric H. David, 2022-2022


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
from scipy.sparse import csc_matrix
from scipy.sparse.linalg import spsolve
import netCDF4
import datetime
import subprocess
import os.path


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_m3r_ncf
# 2 - rrr_con_csv
# 3 - rrr_bas_csv
# 4 - rrr_Qou_ncf
#(5)- rrr_kmu_csv
#(6)- rrr_Vmu_ncf


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 5 or IS_arg > 7:
     print('ERROR - A minimum of 4 and a maximum of 6 arguments can be used')
     raise SystemExit(22)

rrr_m3r_ncf=sys.argv[1]
rrr_con_csv=sys.argv[2]
rrr_bas_csv=sys.argv[3]
rrr_Qou_ncf=sys.argv[4]

if IS_arg > 5:
     rrr_kmu_csv = sys.argv[5]
     rrr_Vmu_ncf = sys.argv[6]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_m3r_ncf)
print('- '+rrr_con_csv)
print('- '+rrr_bas_csv)
print('- '+rrr_Qou_ncf)
if IS_arg > 5: print('- ' + rrr_kmu_csv)
if IS_arg > 5: print('- ' + rrr_Vmu_ncf)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_m3r_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_m3r_ncf)
     raise SystemExit(22) 

try:
     with open(rrr_con_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_csv)
     raise SystemExit(22) 

try:
     with open(rrr_bas_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_bas_csv)
     raise SystemExit(22) 

if IS_arg > 5:
     try:
          with open(rrr_kmu_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_kmu_csv)
          raise SystemExit(22)


#*******************************************************************************
#Reading connectivity file
#*******************************************************************************
print('Reading connectivity file')

IV_riv_tot_id=[]
IV_riv_tot_dn=[]
with open(rrr_con_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id.append(int(row[0]))
          IV_riv_tot_dn.append(int(row[1]))

IS_riv_tot=len(IV_riv_tot_id)
print('- Number of river reaches in rrr_con_csv: '+str(IS_riv_tot))


#*******************************************************************************
#Reading basin file
#*******************************************************************************
print('Reading basin file')

IV_riv_bas_id=[]
with open(rrr_bas_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_bas_id.append(int(row[0]))

IS_riv_bas=len(IV_riv_bas_id)
print('- Number of river reaches in rrr_bas_csv: '+str(IS_riv_bas))


#*******************************************************************************
#Creating hash tables
#*******************************************************************************
print('Creating hash tables')

IM_hsh_tot={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh_tot[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

IM_hsh_bas={}
for JS_riv_bas in range(IS_riv_bas):
     IM_hsh_bas[IV_riv_bas_id[JS_riv_bas]]=JS_riv_bas

IV_riv_ix1=[IM_hsh_bas[IS_riv_id] for IS_riv_id in IV_riv_tot_id]
IV_riv_ix2=[IM_hsh_tot[IS_riv_id] for IS_riv_id in IV_riv_bas_id]
#These arrays allow for index mapping such that IV_riv_tot_id[JS_riv_tot]
#                                              =IV_riv_bas_id[JS_riv_bas]
#IV_riv_ix1[JS_riv_tot]=JS_riv_bas
#IV_riv_ix2[JS_riv_bas]=JS_riv_tot

print('- Hash tables created')


#*******************************************************************************
#Creating network matrix
#*******************************************************************************
print('Creating network matrix')

IV_row=[]
IV_col=[]
IV_val=[]
for JS_riv_bas in range(IS_riv_bas):
     JS_riv_tot=IM_hsh_tot[IV_riv_bas_id[JS_riv_bas]]
     if IV_riv_tot_dn[JS_riv_tot]!=0:
          JS_riv_ba2=IM_hsh_bas[IV_riv_tot_dn[JS_riv_tot]]
          IV_row.append(JS_riv_ba2)
          IV_col.append(JS_riv_bas)
          IV_val.append(1)

ZM_Net=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_riv_bas,IS_riv_bas))

print('- Network matrix created')
print('  . Total number of connections: '+str(len(IV_val)))


#*******************************************************************************
#Creating identity matrix
#*******************************************************************************
print('Creating identity matrix')

IV_row=range(IS_riv_bas)
IV_col=range(IS_riv_bas)
IV_val=[1]*IS_riv_bas
ZM_I=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_riv_bas,IS_riv_bas))

print('- Done')


#*******************************************************************************
#Creating Qout netCDF file
#*******************************************************************************
print('Creating Qout netCDF file')

#-------------------------------------------------------------------------------
#Creating structure
#-------------------------------------------------------------------------------
print('- Creating structure')
g = netCDF4.Dataset(rrr_Qou_ncf, "w", format="NETCDF4")

time = g.createDimension("time", None)
rivid = g.createDimension("rivid", IS_riv_tot)
nv = g.createDimension("nv", 2)

Qout = g.createVariable("Qout","f4",("time","rivid",),                         \
                        fill_value=float(1e20))
rivid = g.createVariable("rivid","i4",("rivid",))
time = g.createVariable("time","i4",("time",))
time_bnds = g.createVariable("time_bnds","i4",("time","nv",))
lon = g.createVariable("lon","f8",("rivid",))
lat = g.createVariable("lat","f8",("rivid",))
crs = g.createVariable("crs","i4")

#-------------------------------------------------------------------------------
#Populating global attributes
#-------------------------------------------------------------------------------
print('- Populating global attributes')
dt=datetime.datetime.utcnow()
dt=dt.replace(microsecond=0)
#Current UTC time without the microseconds 
vsn=subprocess.Popen('../version.sh',stdout=subprocess.PIPE).communicate()
vsn=vsn[0]
vsn=vsn.rstrip()
vsn=vsn.decode()
#Version of RRR

g.Conventions='CF-1.6'
g.title=''
g.institution=''
g.source='RRR: '+vsn+', water inflow: '+os.path.basename(rrr_m3r_ncf)
g.history='date created: '+dt.isoformat()+'+00:00'
g.references='https://github.com/c-h-david/rrr/'
g.comment=''
g.featureType='timeSeries'

#-------------------------------------------------------------------------------
#Populating variable attributes
#-------------------------------------------------------------------------------
print('- Populating variable attributes')

Qout.long_name='average river water discharge downstream of each river reach'
Qout.units='m3 s-1'
Qout.coordinates='lon lat'
Qout.grid_mapping='crs'
Qout.cell_methods='time: sum'

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


#*******************************************************************************
#Reading rrr_m3r_ncf and computing lumped discharge
#*******************************************************************************
print('Reading rrr_m3r_ncf and computing lumped discharge')

f=netCDF4.Dataset(rrr_m3r_ncf, 'r')

#-------------------------------------------------------------------------------
#Dimensions
#-------------------------------------------------------------------------------
if 'COMID' in f.dimensions:
     YS_rivid='COMID'
elif 'rivid' in f.dimensions:
     YS_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_m3r_ncf)
     raise SystemExit(22) 

IS_m3r_tot=len(f.dimensions[YS_rivid])
print('- The number of river reaches is: '+str(IS_m3r_tot))

if 'Time' in f.dimensions:
     YS_time='Time'
elif 'time' in f.dimensions:
     YS_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_m3r_ncf)
     raise SystemExit(22) 

IS_m3r_tim=len(f.dimensions[YS_time])
print('- The number of time steps is: '+str(IS_m3r_tim))

#-------------------------------------------------------------------------------
#Variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f.variables:
     YS_var='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_m3r_ncf)
     raise SystemExit(22) 

if YS_rivid in f.variables:
     IV_m3r_tot_id=list(f.variables[YS_rivid])
     if IV_m3r_tot_id==IV_riv_tot_id:
          print('- The river IDs in rrr_m3r_ncf and rrr_con_csv are the same')
     else:
          print('ERROR - The river IDs in rrr_m3r_ncf and rrr_con_csv differ')
          raise SystemExit(22) 

if YS_time in f.variables:
     ZS_TaR=f.variables[YS_time][1]-f.variables[YS_time][0]
     print('- The time step in rrr_m3r_ncf was determined as: '+str(ZS_TaR)+   \
           ' seconds')
else:
     ZS_TaR=10800
     print('- No time variables in rrr_m3r_ncf, using default of : '           \
            +str(ZS_TaR)+' seconds')

#-------------------------------------------------------------------------------
#Computing matrix-based lumped routing
#-------------------------------------------------------------------------------
print('- Computing matrix-based lumped routing')

for JS_m3r_tim in range(IS_m3r_tim):
     ZV_m3r_ttt=f.variables[YS_var][JS_m3r_tim,:]
     ZV_m3r_tmp=ZV_m3r_ttt[IV_riv_ix2]
     ZV_Qex_tmp=ZV_m3r_tmp/ZS_TaR
     ZV_Qou_lum=spsolve(ZM_I-ZM_Net,ZV_Qex_tmp)
     Qout[JS_m3r_tim,:]=ZV_Qou_lum

print(' . Done')

#-------------------------------------------------------------------------------
#Populating static data
#-------------------------------------------------------------------------------
print('- Populating static data')

rivid[:]=f.variables[YS_rivid][IV_riv_ix2]
lon[:]=f.variables['lon'][IV_riv_ix2]
lat[:]=f.variables['lat'][IV_riv_ix2]
time[:]=f.variables['time'][:]
time_bnds[:]=f.variables['time_bnds'][:]

#-------------------------------------------------------------------------------
#Closing all netCDF files
#-------------------------------------------------------------------------------
f.close()
g.close()


#*******************************************************************************
#Creating V netCDF file
#*******************************************************************************
if IS_arg >5:
     print('Creating V netCDF file')

     #--------------------------------------------------------------------------
     #Creating structure
     #--------------------------------------------------------------------------
     print('- Creating structure')
     h = netCDF4.Dataset(rrr_Vmu_ncf, "w", format="NETCDF4")

     time = h.createDimension("time", None)
     rivid = h.createDimension("rivid", IS_riv_tot)
     nv = h.createDimension("nv", 2)

     V = h.createVariable("V","f4",("time","rivid",),                          \
                             fill_value=float(1e20))
     rivid = h.createVariable("rivid","i4",("rivid",))
     time = h.createVariable("time","i4",("time",))
     time_bnds = h.createVariable("time_bnds","i4",("time","nv",))
     lon = h.createVariable("lon","f8",("rivid",))
     lat = h.createVariable("lat","f8",("rivid",))
     crs = h.createVariable("crs","i4")

     #--------------------------------------------------------------------------
     #Populating global attributes
     #--------------------------------------------------------------------------
     print('- Populating global attributes')
     dt=datetime.datetime.utcnow()
     dt=dt.replace(microsecond=0)
     #Current UTC time without the microseconds
     vsn=subprocess.Popen('../version.sh',stdout=subprocess.PIPE).communicate()
     vsn=vsn[0]
     vsn=vsn.rstrip()
     vsn=vsn.decode()
     #Version of RRR

     h.Conventions='CF-1.6'
     h.title=''
     h.institution=''
     h.source='RRR: '+vsn+', water inflow: '+os.path.basename(rrr_m3r_ncf)
     h.history='date created: '+dt.isoformat()+'+00:00'
     h.references='https://github.com/c-h-david/rrr/'
     h.comment=''
     h.featureType='timeSeries'

     #--------------------------------------------------------------------------
     #Populating variable attributes
     #--------------------------------------------------------------------------
     print('- Populating variable attributes')

     V.long_name='average river water volume inside of each river reach'

     V.units='m3'
     V.coordinates='lon lat'
     V.grid_mapping='crs'
     V.cell_methods='time: sum'

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

     #--------------------------------------------------------------------------
     #Closing all netCDF files
     #--------------------------------------------------------------------------
     h.close()


#*******************************************************************************
#End
#*******************************************************************************
