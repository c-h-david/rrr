#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_obs.py
#*******************************************************************************

#Purpose:
#Given a shapefile with unique integer identifiers for observing stations and 
#unique station codes, a csv file containing observations previously downloaded
#using rrr_obs_tot_nwisdv.py, a start date (%Y-%m-%d), an interval (in number of 
#days), and a name; this program creates one csv file that contains a summary 
#table of hydrographs indexed by station rivid. An optional percentage integer
#can also be given to compute a similar uncertainty table.
#Author:
#Cedric H. David, 2016-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import fiona
import numpy
import csv
import datetime


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_obs_csv
# 3 - rrr_flw_csv
# 4 - iso_dat_str
# 5 - ZS_interval
# 6 - rrr_obs_str
# 7 - rrr_hyd_csv
#(8)- ZS_pct_uq


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 8 or IS_arg > 9:
     print('ERROR - A minimum of 7 and a maximum of 8 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_obs_csv=sys.argv[2]
rrr_flw_csv=sys.argv[3]
iso_dat_str=sys.argv[4]
ZS_interval=float(sys.argv[5])
rrr_obs_str=sys.argv[6]
rrr_hyd_csv=sys.argv[7]
if IS_arg==9:
     ZS_pct_uq=float(sys.argv[8])
else:
     ZS_pct_uq=0


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_obs_csv)
print('- '+rrr_flw_csv)
print('- '+iso_dat_str)
print('- '+str(ZS_interval))
print('- '+rrr_obs_str)
print('- '+rrr_hyd_csv)
print('- '+str(ZS_pct_uq))


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
     with open(rrr_obs_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_csv)
     raise SystemExit(22)

try:
     with open(rrr_flw_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_flw_csv)
     raise SystemExit(22) 

if (ZS_pct_uq < 0 or ZS_pct_uq >100):
     print('ERROR - The percentage '+str(ZS_pct_uq)+' must be in range [0,100]')
     raise SystemExit(22) 


#*******************************************************************************
#Read rrr_obs_shp
#*******************************************************************************
print('Read rrr_obs_shp')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')
IS_obs_bas=len(rrr_obs_lay)
print('- The number of gauge features is: '+str(IS_obs_bas))

if 'COMID_1' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID_1'
elif 'FLComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='FLComID'
elif 'ARCID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ARCID'
else:
     print('ERROR - COMID_1, FLComID, or ARCID do not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'SOURCE_FEA' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='SOURCE_FEA'
elif 'Code' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='Code'
else:
     print('ERROR - Neither SOURCE_FEA nor Code exist in '+rrr_obs_shp)
     raise SystemExit(22) 

IV_obs_bas_id=[]
YV_obs_bas_cd=[]
for JS_obs_bas in range(IS_obs_bas):
     IV_obs_bas_id.append(int(rrr_obs_lay[JS_obs_bas]['properties'][YV_obs_id]))
     YV_obs_bas_cd.append(str(rrr_obs_lay[JS_obs_bas]['properties'][YV_obs_cd]))

z = sorted(zip(IV_obs_bas_id,YV_obs_bas_cd))
IV_obs_bas_id_srt,YV_obs_bas_cd_srt=zip(*z)
#Sorting the lists together based on increasing value of the river ID.
IV_obs_bas_id_srt=list(IV_obs_bas_id_srt)
YV_obs_bas_cd_srt=list(YV_obs_bas_cd_srt)
#Because zip creates tuples and not lists


#*******************************************************************************
#Read rrr_obs_csv
#*******************************************************************************
print('Read rrr_obs_csv')

IV_obs_tot_id=[]

with open(rrr_obs_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_obs_tot_id.append(int(row[0]))

IS_obs_tot=len(IV_obs_tot_id)
print('- The number of observed locations is: '+str(IS_obs_tot))


#*******************************************************************************
#Read rrr_flw_csv
#*******************************************************************************
print('Read rrr_flw_csv')

ZM_obs=numpy.array([]).reshape(0,IS_obs_tot)
#Initialize an empty array of size IS_obs_tot to store all hydrographs

with open(rrr_flw_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_obs=[float(obs) for obs in row]
          ZM_obs=numpy.vstack((ZM_obs,ZV_obs))

IS_time=ZM_obs.shape[0]
print('- The number of time steps is: '+str(IS_time))


#*******************************************************************************
#Get temporal information from command line options
#*******************************************************************************
print('Get temporal information from command line options')

dt_str=datetime.datetime.strptime(iso_dat_str,'%Y-%m-%d')
print('- Start date selected is: '+str(dt_str))

dt_int=datetime.timedelta(ZS_interval)
print('- Interval selected is: '+str(dt_int))

ZV_time=[]
YV_time=[]
for JS_time in range(IS_time):
     ZV_time.append(dt_str+JS_time*dt_int)
     YV_time.append(ZV_time[JS_time].strftime('%Y-%m-%d'))


#*******************************************************************************
#Create hash table
#*******************************************************************************
print('Create hash table')

IM_hsh={}

for JS_obs_tot in range(IS_obs_tot):
     IM_hsh[IV_obs_tot_id[JS_obs_tot]]=JS_obs_tot

IV_obs_loc=[IM_hsh[IV_obs_bas_id_srt[JS_obs_bas]]                              \
            for JS_obs_bas in range(IS_obs_bas)]


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Write CSV file')

with open(rrr_hyd_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     #csvwriter.writerow([rrr_obs_str]+YV_obs_bas_cd_srt)
     csvwriter.writerow([rrr_obs_str]+IV_obs_bas_id_srt)
     for JS_time in range(IS_time):
          IV_line=[YV_time[JS_time]]+list(ZM_obs[JS_time,IV_obs_loc])
          csvwriter.writerow(IV_line) 

if ZS_pct_uq > 0:
     rrr_hyd_csv=rrr_hyd_csv[:-4]+'_uq.csv'
     with open(rrr_hyd_csv, 'wb') as csvfile:
          csvwriter = csv.writer(csvfile, dialect='excel')
          #csvwriter.writerow([rrr_obs_str]+YV_obs_bas_cd_srt)
          csvwriter.writerow([rrr_obs_str]+IV_obs_bas_id_srt)
          for JS_time in range(IS_time):
               IV_line=[YV_time[JS_time]]+list(ZM_obs[JS_time,IV_obs_loc]      \
                                               *ZS_pct_uq/100)
               csvwriter.writerow(IV_line) 
#Write hydrographs for uncertainty 


#*******************************************************************************
#End
#*******************************************************************************
