#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_shp_avg_riv.py
#*******************************************************************************

#Purpose:
#Given a shapefile of a river network, a netCDF file with corresponding RAPID
#outputs, and the name of a new shapefile; this program computes the average of
#simulations and appends it as a new attribute to a copy of the input shapefile.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import netCDF4
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_out_ncf
# 2 - rrr_riv_shp
# 3 - rrr_new_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22) 

rrr_riv_shp=sys.argv[1]
rrr_out_ncf=sys.argv[2]
rrr_new_shp=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_riv_shp)
print('- '+rrr_out_ncf)
print('- '+rrr_new_shp)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22) 

try:
     with open(rrr_out_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_out_ncf)
     raise SystemExit(22) 


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')
IS_riv_shp=len(rrr_riv_lay)
print('- The number of river features is: '+str(IS_riv_shp))

if 'COMID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='COMID'
elif 'ComID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='ComID'
elif 'ARCID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='ARCID'
else:
     print('ERROR - Neither COMID, ComID, nor ARCID exist in '+rrr_riv_shp)
     raise SystemExit(22) 

IV_riv_shp=[0]*IS_riv_shp
for JS_riv_shp in range(IS_riv_shp):
     riv_fea=rrr_riv_lay[JS_riv_shp]
     riv_prp=riv_fea['properties']
     IV_riv_shp[JS_riv_shp]=int(riv_prp[YV_riv_id])


#*******************************************************************************
#Open netCDF file
#*******************************************************************************
print('Opening netCDF file')

f = netCDF4.Dataset(rrr_out_ncf, 'r')


#*******************************************************************************
#Read netCDF file static data
#*******************************************************************************
print('Reading netCDF file static data')

#-------------------------------------------------------------------------------
#Get dimensions/variables names
#-------------------------------------------------------------------------------
if 'COMID' in f.dimensions:
     YS_id_name='COMID'
elif 'rivid' in f.dimensions:
     YS_id_name='rivid'
else:
     print('ERROR - neither COMID nor rivid exist in'+rrr_out_ncf)
     raise SystemExit(22) 

if 'Time' in f.dimensions:
     YS_time_name='Time'
elif 'time' in f.dimensions:
     YS_time_name='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_out_ncf)
     raise SystemExit(22) 

if 'Qout' in f.variables:
     YS_out_name='Qout'
elif 'V' in f.variables:
     YS_out_name='V'
else:
     print('ERROR - neither Qout nor V exist in'+rrr_out_ncf)
     raise SystemExit(22) 

#-------------------------------------------------------------------------------
#Get variable sizes 
#-------------------------------------------------------------------------------
IS_riv_ncf=len(f.variables[YS_id_name])
print('- Number of river reaches: '+str(IS_riv_ncf))

IS_time=len(f.variables[YS_out_name])
print('- Number of time steps: '+str(IS_time))

#-------------------------------------------------------------------------------
#Get river IDs
#-------------------------------------------------------------------------------
print('- Getting river IDs')
IV_riv_ncf=f.variables[YS_id_name][:]


#*******************************************************************************
#Read netCDF file dynamic data
#*******************************************************************************
print('Reading netCDF file dynamic data')

#-------------------------------------------------------------------------------
#Computing average
#-------------------------------------------------------------------------------
print('Computing average')

ZV_avg_ncf=numpy.zeros(IS_riv_ncf)

for JS_time in range(IS_time):
     ZV_out=f.variables[YS_out_name][JS_time,:]
     ZV_avg_ncf=ZV_avg_ncf+ZV_out

ZV_avg_ncf=ZV_avg_ncf/IS_time


#*******************************************************************************
#Creating hash table
#*******************************************************************************
print('Creating hash table')

IM_hsh={}
for JS_riv_shp in range(IS_riv_shp):
     IM_hsh[IV_riv_shp[JS_riv_shp]]=JS_riv_shp

print('- Done')


#*******************************************************************************
#Copying shapefile and appending with average
#*******************************************************************************
print('Copying shapefile and appending with average')

ZV_avg_shp=numpy.zeros(IS_riv_shp)
for JS_riv_ncf in range(IS_riv_ncf):
     JS_riv_shp=IM_hsh[IV_riv_ncf[JS_riv_ncf]]
     ZV_avg_shp[JS_riv_shp]=ZV_avg_ncf[JS_riv_ncf]
print('- Average resorted for shapefile ')

rrr_riv_crs=rrr_riv_lay.crs
rrr_new_crs=rrr_riv_crs.copy()
#print(rrr_new_crs)
print('- Coordinate Reference System copied')

rrr_riv_sch=rrr_riv_lay.schema
rrr_new_sch=rrr_riv_sch.copy()
rrr_new_sch['properties']['meanQ']='float:24.5'
#print(rrr_new_sch)
print('- Schema copied')

rrr_new_lay=fiona.open(rrr_new_shp, 'w',                                       \
                       crs=rrr_new_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_new_sch                                      \
                       )
print('- New shapefile created')

for JS_riv_shp in range(IS_riv_shp):
     rrr_riv_fea=rrr_riv_lay[JS_riv_shp]
     rrr_riv_prp=rrr_riv_fea['properties']
     rrr_riv_geo=rrr_riv_fea['geometry']

     rrr_new_prp=rrr_riv_prp.copy()
     rrr_new_geo=rrr_riv_geo.copy()

     rrr_new_prp['meanQ']=ZV_avg_shp[JS_riv_shp]

     rrr_new_lay.write({                                                       \
                        'properties': rrr_new_prp,                             \
                        'geometry': rrr_new_geo,                               \
                        })
print('- New shapefile populated')

rrr_new_lay.close()
print('- Closing shapefile so that values are saved')


#*******************************************************************************
#End
#*******************************************************************************
