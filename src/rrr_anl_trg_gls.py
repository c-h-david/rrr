#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_trg_gls.py
#*******************************************************************************

#Purpose:
#This program uses near real time river discharge forecasts produced by ECMWF
#under the GEOGloWS program to generate a list of triggers for near-term
#(future) Earth observations. The triggers are saved in two similar files in
#.csv and .shp formats that are provided as runtime options.
#Author:
#Cedric H. David, 2020-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import requests
import pandas
import math
from datetime import datetime
import fiona
import fiona.crs
import shapely
import shapely.geometry


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_trg_csv
# 2 - rrr_trg_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

rrr_trg_csv=sys.argv[1]
rrr_trg_shp=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_trg_csv)
print('- '+rrr_trg_shp)


#*******************************************************************************
#Gathering and analyzing forecasts
#*******************************************************************************
print('Gathering and analyzing forecasts')

#-------------------------------------------------------------------------------
#Accessing data from online csv file
#-------------------------------------------------------------------------------
url='https://geoglows.ecmwf.int/api/ForecastWarnings/'
print('- Accessing '+url)
data=requests.get(url)
if not data.ok:
     print('ERROR - status code '+str(data.status_code)+                       \
           ' returned when downloading '+url)
     raise SystemExit(22)
name='ForecastWarnings-all.csv'

#-------------------------------------------------------------------------------
#Saving data into csv file locally
#-------------------------------------------------------------------------------
print('- Saving '+name)
with open(name, 'w') as f:
     f.write(data.content)

#-------------------------------------------------------------------------------
#Reading local csv file
#-------------------------------------------------------------------------------
print('- Reading '+name)
df_all=pandas.read_csv(name)
IS_all=len(df_all)
print(' . Total number of rows in file: '+str(IS_all))
print(' . Maximum forecasted flow: '+str(df_all['max_forecasted_flow'].max()))
print(' . Minimum forecasted flow: '+str(df_all['max_forecasted_flow'].min()))
print(' . Average forecasted flow: '+str(df_all['max_forecasted_flow'].mean()))

#-------------------------------------------------------------------------------
#Analyzing local csv file
#-------------------------------------------------------------------------------
print('- Analyzing '+name)
ZV_lon=[]
ZV_lat=[]
YV_dti=[]
ZV_svr=[]
ZV_imp=[]
ZV_crt=[]

for JS_all in range(IS_all):
     ZS_flw=df_all['max_forecasted_flow'][JS_all]
     for YS_ret in ['2','5','10','25','50','100']:
          ZS_ret=float(YS_ret)
          YS_dat=df_all['date_exceeds_return_period_'+YS_ret][JS_all]
          if pandas.notnull(YS_dat):
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               #Compute trigger indexes
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               ZS_lon=df_all['stream_lon'][JS_all]
               ZS_lat=df_all['stream_lat'][JS_all]
               YS_dti=str(datetime.strptime(YS_dat,'%Y-%m-%d %H:%M:%S')        \
                                           .isoformat())
               ZS_svr=math.log10(ZS_ret)/2.
               if ZS_flw < 10**2.5: ZS_imp=0.
               if ZS_flw > 10**5  : ZS_imp=1.
               if ZS_flw >=10**2.5 and ZS_flw <=10**5:
                    ZS_imp=(math.log10(ZS_flw)-math.log10(10**2.5))            \
                          /(math.log10(10**5 )-math.log10(10**2.5))
               ZS_crt=1.

               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               #Append arrays
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               ZV_lon.append(ZS_lon)
               ZV_lat.append(ZS_lat)
               YV_dti.append(YS_dti)
               ZV_svr.append(ZS_svr)
               ZV_imp.append(ZS_imp)
               ZV_crt.append(ZS_crt)

IS_trg=len(ZV_lon)
print(' . Total number of triggers generated: '+str(IS_trg))

ZV_trg=[0]*IS_trg
for JS_trg in range(IS_trg):
     ZV_trg[JS_trg]=ZV_svr[JS_trg]*ZV_imp[JS_trg]*ZV_crt[JS_trg]


#*******************************************************************************
#Creating trigger csv file
#*******************************************************************************
print('Creating trigger csv file: '+rrr_trg_csv)

#-------------------------------------------------------------------------------
#Creating empty trigger dataframe
#-------------------------------------------------------------------------------
df_trg=pandas.DataFrame(columns=['longitude',                                  \
                                 'latitude',                                   \
                                 'datetime',                                   \
                                 'severity',                                   \
                                 'importance',                                 \
                                 'certainty'])

#-------------------------------------------------------------------------------
#Populating trigger dataframe
#-------------------------------------------------------------------------------
df_trg['longitude'] =ZV_lon
df_trg['latitude']  =ZV_lat
df_trg['datetime']  =YV_dti
df_trg['severity']  =ZV_svr
df_trg['importance']=ZV_imp
df_trg['certainty'] =ZV_crt

#-------------------------------------------------------------------------------
#Saving trigger dataframe in csv file
#-------------------------------------------------------------------------------
df_trg.to_csv(rrr_trg_csv,index=False)
print('- Done')


#*******************************************************************************
#Creating trigger shp file
#*******************************************************************************
print('Creating trigger shp file: '+rrr_trg_shp)

#-------------------------------------------------------------------------------
#Schema
#-------------------------------------------------------------------------------
rrr_trg_sch={                                                                  \
             'geometry': 'Point',                                              \
             'properties': {                                                   \
                            'isotime':    'str:19',                            \
                            'severity':   'float:4.2',                         \
                            'importance': 'float:4.2',                         \
                            'certainty':  'float:4.2',                         \
                            'trigger':    'float:4.2'                          \
                           }                                                   \
            }

#-------------------------------------------------------------------------------
#Coordinate system
#-------------------------------------------------------------------------------
rrr_trg_crs=fiona.crs.from_epsg(4326)
#4326 is for WGS84 (https://epsg.io/4326)

#-------------------------------------------------------------------------------
#Create shapefile with geometry and properties
#-------------------------------------------------------------------------------
with fiona.open(rrr_trg_shp,'w',driver='ESRI Shapefile',                       \
                                crs=rrr_trg_crs,                               \
                                schema=rrr_trg_sch) as rrr_trg_lay:
     for JS_trg in range(IS_trg):
          rrr_trg_prp={'isotime':    YV_dti[JS_trg],                           \
                       'severity':   ZV_svr[JS_trg],                           \
                       'importance': ZV_imp[JS_trg],                           \
                       'certainty':  ZV_crt[JS_trg],                           \
                       'trigger':    ZV_trg[JS_trg]                            \
                      }
          rrr_trg_geo=shapely.geometry.mapping(                                \
                        shapely.geometry.Point((ZV_lon[JS_trg],ZV_lat[JS_trg])))
          rrr_trg_lay.write({                                             \
                             'properties': rrr_trg_prp,                   \
                             'geometry': rrr_trg_geo,                     \
                             })

print('- Done')


#*******************************************************************************
#End
#*******************************************************************************
