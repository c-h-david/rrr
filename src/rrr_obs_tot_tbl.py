#!/usr/bin/env python
#*******************************************************************************
#rrr_obs_tot_tbl.py
#*******************************************************************************

#Purpose:
#Given an observing stations shapefile with unique integer identifiers, unique 
#station codes, names, longitude, and latitude, this program creates one csv 
#file that contains a summary table indexed by station code. 
#Author:
#Cedric H. David, 2016-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import fiona
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_tbl_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_tbl_csv=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_tbl_csv)


#*******************************************************************************
#Check if files and directories exist 
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Read rrr_obs_shp
#*******************************************************************************
print('Read rrr_obs_shp')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')
IS_obs_tot=len(rrr_obs_lay)
print('- The number of gauge features is: '+str(IS_obs_tot))

if 'COMID_1' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID_1'
elif 'FLComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='FLComID'
elif 'ARCID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ARCID'
else:
     print('ERROR - COMID_1, FLComID, or ARCID do not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'STATION_NM' in rrr_obs_lay[0]['properties']:
     YV_obs_nm='STATION_NM'
elif 'Name' in rrr_obs_lay[0]['properties']:
     YV_obs_nm='Name'
else:
     print('ERROR - STATION_NM or Name do not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'SOURCE_FEA' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='SOURCE_FEA'
elif 'Code' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='Code'
else:
     print('ERROR - Neither SOURCE_FEA nor Code exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'Lon' in rrr_obs_lay[0]['properties']:
     YV_obs_ln='Lon'
else:
     print('ERROR - Lon does not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'Lat' in rrr_obs_lay[0]['properties']:
     YV_obs_lt='Lat'
else:
     print('ERROR - Lat does not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

IV_obs_tot_id=[]
YV_obs_tot_nm=[]
YV_obs_tot_cd=[]
ZV_obs_tot_ln=[]
ZV_obs_tot_lt=[]
for JS_obs_tot in range(IS_obs_tot):
     IV_obs_tot_id.append(int(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_id]))
     YV_obs_tot_cd.append(str(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_cd]))
     YV_obs_tot_nm.append(str(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_nm]))
     ZV_obs_tot_ln.append(float(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_ln]))
     ZV_obs_tot_lt.append(float(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_lt]))

z = sorted(zip(IV_obs_tot_id,YV_obs_tot_nm,YV_obs_tot_cd,ZV_obs_tot_ln,        \
               ZV_obs_tot_lt))
IV_obs_tot_id_srt,YV_obs_tot_nm_srt,YV_obs_tot_cd_srt,                         \
ZV_obs_tot_ln_srt,ZV_obs_tot_lt_srt                    =zip(*z)
#Sorting the lists together based on increasing value of the river ID.


#*******************************************************************************
#Write formatted table
#*******************************************************************************
print('Write formatted table')

with open(rrr_tbl_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel', quotechar="'",           \
                            quoting=csv.QUOTE_NONNUMERIC)
     csvwriter.writerow(['RIVID','CODE','NAME','LON','LAT'])
     for JS_obs_tot in range(IS_obs_tot):
          csvwriter.writerow([IV_obs_tot_id_srt[JS_obs_tot],                   \
                              YV_obs_tot_cd_srt[JS_obs_tot],                   \
                              YV_obs_tot_nm_srt[JS_obs_tot],                   \
                              ZV_obs_tot_ln_srt[JS_obs_tot],                   \
                              ZV_obs_tot_lt_srt[JS_obs_tot] ]) 


#*******************************************************************************
#End
#*******************************************************************************
