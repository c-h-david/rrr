#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_shp_avg_obs.py
#*******************************************************************************

#Purpose:
#Given a shapefile of river gauges, a CSV file with corresponding observations,
#and the name of a new shapefile; this program computes the average of
#observations and appends it as a new attribute to a copy of the input
#shapefile.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import pandas
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_Qob_csv
# 3 - rrr_new_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22)

rrr_obs_shp=sys.argv[1]
rrr_Qob_csv=sys.argv[2]
rrr_new_shp=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_Qob_csv)
print('- '+rrr_new_shp)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22)

try:
     with open(rrr_Qob_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_Qob_csv)
     raise SystemExit(22)


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')
IS_obs_shp=len(rrr_obs_lay)
print('- The number of gauges in shapefile is: '+str(IS_obs_shp))

if 'Sttn_Nm' in rrr_obs_lay[0]['properties']:
     YS_obs_nam='Sttn_Nm'
else:
     print('ERROR - Sttn_Nm does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

YV_obs_nam=[]
for rrr_obs_fea in rrr_obs_lay:
     YV_obs_nam.append(rrr_obs_fea['properties'][YS_obs_nam])


#*******************************************************************************
#Read CSV file
#*******************************************************************************
print('Read CSV file')

df1=pandas.read_csv(rrr_Qob_csv)
#Read the csv file using Pandas

YS_name=df1.columns.values[0]
#The header of the first column which contains dates

df1[YS_name]=pandas.to_datetime(df1[YS_name])
#Convert the first column to DateTime

df1.set_index(YS_name,inplace=True)
#Sets the index of the dataframe as the first column

IS_time=df1.shape[0]
IS_Qob_csv=df1.shape[1]
YV_Qob_nam=df1.columns.tolist()
ZV_Qav=df1.mean().tolist()

print('- The number of gauges in CSV file is: '+str(IS_Qob_csv))
print('- The number of time steps in CSV file is: '+str(IS_time))


#*******************************************************************************
#Check consistency
#*******************************************************************************
print('Check consistency')

if IS_obs_shp!=IS_Qob_csv:
     print('ERROR - Inconsistent number of gauges')
     raise SystemExit(22)

if not YV_Qob_nam==YV_obs_nam:
     print('ERROR - Inconsistent names of gauges')
     raise SystemExit(22)

print('- Done')


#*******************************************************************************
#Copying shapefile and appending with average
#*******************************************************************************
print('Copying shapefile and appending with average')

rrr_obs_crs=rrr_obs_lay.crs
rrr_new_crs=rrr_obs_crs.copy()
#print(rrr_new_crs)
print('- Coordinate Reference System copied')

rrr_obs_sch=rrr_obs_lay.schema
rrr_new_sch=rrr_obs_sch.copy()
rrr_new_sch['properties']['meanQ']='float:10.3'
#print(rrr_new_sch)
print('- Schema copied')

rrr_new_lay=fiona.open(rrr_new_shp, 'w',                                       \
                       crs=rrr_new_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_new_sch                                      \
                       )
print('- New shapefile created')

for JS_obs_shp in range(IS_obs_shp):
     rrr_obs_fea=rrr_obs_lay[JS_obs_shp]
     rrr_obs_prp=rrr_obs_fea['properties']
     rrr_obs_geo=rrr_obs_fea['geometry']

     rrr_new_prp=rrr_obs_prp.copy()
     rrr_new_geo=rrr_obs_geo.copy()

     rrr_new_prp['meanQ']=round(ZV_Qav[JS_obs_shp],3)

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
