#!/usr/bin/env python2
#*******************************************************************************
#rrr_anl_hyd_fmt.py
#*******************************************************************************

#Purpose:
#Given a shapefile with unique integer identifiers for observing stations and 
#unique station codes, a folder containing csv files with timeseries of 
#observations or model simulations (files named hydrograph_{id}_obs.csv or 
#hydrograph_{id}_mod.csv), a start date (%Y-%m-%d), an interval (in number of 
#days), and a name; this program creates one csv file that contains a summary 
#table of hydrographs indexed by station rivid. 
#Author:
#Cedric H. David, 2016-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import fiona
import csv
import datetime


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_hyd_dir
# 3 - rrr_str_dat
# 4 - ZS_interval
# 5 - YV_name
# 6 - rrr_fmt_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 7:
     print('ERROR - 6 and only 6 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_hyd_dir=sys.argv[2]
rrr_str_dat=sys.argv[3]
ZS_interval=float(sys.argv[4])
YV_name=sys.argv[5]
rrr_fmt_csv=sys.argv[6]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_hyd_dir)
print('- '+rrr_str_dat)
print('- '+str(ZS_interval))
print('- '+YV_name)
print('- '+rrr_fmt_csv)


#*******************************************************************************
#Check if files and directories exist 
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22) 

if not os.path.isdir(rrr_hyd_dir):
     print('ERROR - Directory does not exist'+rrr_hyd_dir)
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

if 'SOURCE_FEA' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='SOURCE_FEA'
elif 'Code' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='Code'
else:
     print('ERROR - Neither SOURCE_FEA nor Code exist in '+rrr_obs_shp)
     raise SystemExit(22) 

IV_obs_tot_id=[]
YV_obs_tot_cd=[]
for JS_obs_tot in range(IS_obs_tot):
     IV_obs_tot_id.append(int(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_id]))
     YV_obs_tot_cd.append(str(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_cd]))

z = sorted(zip(IV_obs_tot_id,YV_obs_tot_cd))
IV_obs_tot_id_srt,YV_obs_tot_cd_srt=zip(*z)
#Sorting the lists together based on increasing value of the river ID.


#*******************************************************************************
#Get temporal information from command line options
#*******************************************************************************
print('Get temporal information from command line options')

dt_str=datetime.datetime.strptime(rrr_str_dat,'%Y-%m-%d')
print('- Start date selected is: '+str(dt_str))

dt_int=datetime.timedelta(ZS_interval)
print('- Interval selected is: '+str(dt_int))


#*******************************************************************************
#Generate formatted file
#*******************************************************************************
print('Generate formatted table')

rrr_hyd_dir=os.path.join(rrr_hyd_dir, '')
#Add trailing slash to directory name if not present, do nothing otherwise

ZM_all=[]
#Empty list where all data will be added before being transposed and written

for JS_obs_tot in range(IS_obs_tot):
     #--------------------------------------------------------------------------
     #Generate file names from unique IDs
     #--------------------------------------------------------------------------
     rrr_obs_csv=rrr_hyd_dir+'hydrograph_'+str(IV_obs_tot_id_srt[JS_obs_tot])+ \
                  '_obs.csv'
     rrr_mod_csv=rrr_hyd_dir+'hydrograph_'+str(IV_obs_tot_id_srt[JS_obs_tot])+ \
                  '_mod.csv'
     #rrr_obs_csv=rrr_hyd_dir+'hydrograph_'+str(IV_obs_tot_id_srt[JS_obs_tot])+ \
     #             '_obs_uq.csv'
     #rrr_mod_csv=rrr_hyd_dir+'hydrograph_'+str(IV_obs_tot_id_srt[JS_obs_tot])+ \
     #             '_mod_uq.csv'
     if os.path.isfile(rrr_obs_csv):
          rrr_hyd_csv=rrr_obs_csv
     elif os.path.isfile(rrr_mod_csv):
          rrr_hyd_csv=rrr_mod_csv
 
     #--------------------------------------------------------------------------
     #Check that csv files exist
     #--------------------------------------------------------------------------
     try:
          with open(rrr_hyd_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_hyd_csv)
          raise SystemExit(22) 

     #--------------------------------------------------------------------------
     #Read timeseries from csv files
     #--------------------------------------------------------------------------
     ZV_Qhyd=[]
     with open(rrr_hyd_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for row in csvreader:
               ZV_Qhyd.append(float(row[0]))
          IS_time=len(ZV_Qhyd)

     #--------------------------------------------------------------------------
     #Make list of times and add it as the first row
     #--------------------------------------------------------------------------
     if JS_obs_tot==0:
          ZV_time=[]
          YV_time=[]
          for JS_time in range(IS_time):
               ZV_time.append(dt_str+JS_time*dt_int)
               YV_time.append(ZV_time[JS_time].strftime('%Y-%m-%d'))
          ZM_all.append([YV_name]+ YV_time)
          #The + here allows concatenating lists

     #--------------------------------------------------------------------------
     #Add timeseries
     #--------------------------------------------------------------------------
     ZM_all.append([IV_obs_tot_id_srt[JS_obs_tot]]+ZV_Qhyd)
     #ZM_all.append([YV_obs_tot_cd_srt[JS_obs_tot]]+ZV_Qhyd)
     #The + here allows concatenating lists

ZM_all_trp=zip(*ZM_all)
#Transpose the formatted table


#*******************************************************************************
#Write formatted table
#*******************************************************************************
print('Write formatted table')

with open(rrr_fmt_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_time in range(IS_time+1):
          csvwriter.writerow(ZM_all_trp[JS_time]) 


#*******************************************************************************
#End
#*******************************************************************************
