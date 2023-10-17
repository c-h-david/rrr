#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_hyd_spa.py
#*******************************************************************************

#Purpose:
#Given a netCDF file with modeled values for river discharge (Qout) or storage
#(V) and a shapefile with a subset of the available river reaches; this program
#produces a CSV file containing a time series of spatially aggregated values for
#the subset.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import netCDF4
import datetime
import csv
import os.path


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_mod_ncf
# 2 - rrr_riv_shp
# 3 - rrr_spa_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22)

rrr_mod_ncf=sys.argv[1]
rrr_riv_shp=sys.argv[2]
rrr_spa_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_mod_ncf)
print('- '+rrr_riv_shp)
print('- '+rrr_spa_csv)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_mod_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_mod_ncf)
     raise SystemExit(22)

try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22)


#*******************************************************************************
#Read netCDF file static data
#*******************************************************************************
print('Reading netCDF file static data')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f = netCDF4.Dataset(rrr_mod_ncf, 'r')

#-------------------------------------------------------------------------------
#Get dimensions/variables names
#-------------------------------------------------------------------------------
if 'COMID' in f.dimensions:
     YS_mod_rid='COMID'
elif 'rivid' in f.dimensions:
     YS_mod_rid='rivid'
else:
     print('ERROR - neither COMID nor rivid exist in'+rrr_mod_ncf)
     raise SystemExit(22)

if 'Time' in f.dimensions:
     YS_mod_tim='Time'
elif 'time' in f.dimensions:
     YS_mod_tim='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_mod_ncf)
     raise SystemExit(22)

if 'Qout' in f.variables:
     YS_mod_var='Qout'
elif 'V' in f.variables:
     YS_mod_var='V'
else:
     print('ERROR - neither Qout nor V exist in'+rrr_mod_ncf)
     raise SystemExit(22)

#-------------------------------------------------------------------------------
#Get variable sizes
#-------------------------------------------------------------------------------
IS_mod_rid=len(f.variables[YS_mod_rid])
print('- Number of river reaches: '+str(IS_mod_rid))

IS_mod_tim=len(f.variables[YS_mod_tim])
print('- Number of time steps: '+str(IS_mod_tim))

#-------------------------------------------------------------------------------
#Get river IDs
#-------------------------------------------------------------------------------
print('- Get river IDs')

IV_mod_rid=f.variables[YS_mod_rid]

#-------------------------------------------------------------------------------
#Get time variable values
#-------------------------------------------------------------------------------
print('- Get time variable values')

ZV_time=[0]*IS_mod_tim
YV_time=['']*IS_mod_tim
if YS_mod_tim in f.variables and                                               \
   f.variables[YS_mod_tim][0]!=netCDF4.default_fillvals['i4']:
   #If the time variable exists but was not populated it holds the default
   #netCDF _fillValue and should be ignored here
     print(' . Values of time variable obtained from metadata')
     ZV_time=f.variables[YS_mod_tim][:]
     for JS_mod_tim in range(IS_mod_tim):
          YS_time=datetime.datetime.fromtimestamp(ZV_time[JS_mod_tim],         \
                                                          datetime.timezone.utc)
          YS_time=YS_time.strftime('%Y-%m-%d')
          YV_time[JS_mod_tim]=YS_time


#*******************************************************************************
#Read rrr_riv_shp
#*******************************************************************************
print('Read rrr_riv_shp')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')

if 'COMID' in rrr_riv_lay.schema['properties']:
     YS_riv_rid='COMID'
elif 'rivid' in rrr_riv_lay.schema['properties']:
     YS_riv_rid='rivid'
else:
     print('ERROR - COMID, rivid do not exist in '+rrr_riv_shp)
     raise SystemExit(22)

IV_riv_rid=[]
for rrr_riv_fea in rrr_riv_lay:
     IV_riv_rid.append(rrr_riv_fea['properties'][YS_riv_rid])

IS_riv_rid=len(IV_riv_rid)
print('- Number of river reaches in rrr_riv_shp: '+str(IS_riv_rid))


#*******************************************************************************
#Make hash table
#*******************************************************************************
print('- Make hash table')
IM_hsh={}
for JS_mod_rid in range(IS_mod_rid):
     IM_hsh[int(IV_mod_rid[JS_mod_rid])]=JS_mod_rid

IV_mod_idx=[IM_hsh[rid] for rid in IV_riv_rid]


#*******************************************************************************
#Read netCDF file dynamic data
#*******************************************************************************
print('Reading netCDF file dynamic data')

ZV_spa=[]
for JS_mod_tim in range(IS_mod_tim):
     ZV_tmp=f.variables[YS_mod_var][JS_mod_tim,:]
     ZV_spa.append(sum(ZV_tmp[IV_mod_idx]))


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Write CSV file')

with open(rrr_spa_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow([os.path.basename(rrr_mod_ncf),YS_mod_var])
     for JS_mod_tim in range(IS_mod_tim):
          csvwriter.writerow([YV_time[JS_mod_tim],ZV_spa[JS_mod_tim]])
#Write hydrographs


#*******************************************************************************
#End
#*******************************************************************************
