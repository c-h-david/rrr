#!/usr/bin/python
#*******************************************************************************
#rrr_anl_hyd_sts.py
#*******************************************************************************

#Purpose:
#Given a list of unique integer identifiers for observing stations, and two 
#folders where csv timeseries of observed/computed quantities are stored, this 
#program computes simple statistics comparing observed and modeled hydrographs.
#In case timeseries of different lengths are given, the smallest length is used
#unless an optional argument containing the desired length is given.
#Author:
#Cedric H. David, 2011-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import csv
import fiona
from datetime import datetime


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_obs_csv
# 3 - rrr_mod_csv
# 4 - rrr_sts_csv
#(5)- IS_M


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 5 or IS_arg > 7:
     print('ERROR - A minimum of 4 and a maximum of 6 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_obs_csv=sys.argv[2]
rrr_mod_csv=sys.argv[3]
rrr_sts_csv=sys.argv[4]
if IS_arg==7:
     try:
          IS_start_date = datetime.strptime(sys.argv[5], "%Y-%m-%d")
          IS_end_date = datetime.strptime(sys.argv[6], "%Y-%m-%d")
     except ValueError:
          print('ERROR - Dates need to provided in YEAR-MONTH-DAY format')
          raise SystemExit(22)
     IS_M = (IS_end_date-IS_start_date).days+1
else:
     IS_M=1e20
     IS_start_date = None
     IS_end_date = None


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_obs_csv)
print('- '+rrr_mod_csv)
print('- '+rrr_sts_csv)
print('- '+str(IS_M))


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22) 

if not os.path.isfile(rrr_obs_csv):
     print('ERROR - Unable to open'+rrr_obs_csv)
     raise SystemExit(22) 

if not os.path.isfile(rrr_mod_csv):
     print('ERROR - Unable to open'+rrr_mod_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Read rrr_obs_shp
#*******************************************************************************
print('Reading rrr_obs_shp')
IV_obs_tot_id=[]
with fiona.open(rrr_obs_shp, 'r') as shpfile:
     for reach in shpfile:
          IV_obs_tot_id.append(reach['properties']['FLComID'])
IS_obs_tot=len(IV_obs_tot_id)
print('- Number of river reaches in rrr_obs_shp: '+str(IS_obs_tot))

#*******************************************************************************
#Check length of all hydrographs 
#*******************************************************************************
print('- Checking the length of all hydrographs')

with open(rrr_obs_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     next(iter(csvreader), None)  # skip header
     IS_count = len([row for row in csvreader if len(row[0]) > 0])
     #print(IS_count)
     if (IS_count<IS_M):
          IS_M=IS_count
with open(rrr_mod_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     next(iter(csvreader), None)  # skip header
     IS_count = len([row for row in csvreader if len(row[0]) > 0])
     #print(IS_count)
     if (IS_count<IS_M):
          IS_M=IS_count

print('  . Will compute statistics for: '+str(IS_M)+' time steps')


#*******************************************************************************
#Compute flow statistics
#*******************************************************************************
print('- Computing flow statistics')

with open(rrr_sts_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     #csvwriter.writerow(['rivid','Qobsbar','Qmodbar','modRMSE','modNash']) 
     #Difficult to compare CSV files with headers, removed them here
     #However, 'wb' here ensures creation of a new file instead of appending.


#-------------------------------------------------------------------------------
#Read hydrographs
#-------------------------------------------------------------------------------
with open(rrr_obs_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     header = next(iter(csvreader))
     rids = [int(h) for h in header[1:]]
     ZTV_obs = {rid: [0]*IS_M for rid in rids}
     ZTV_obs['date'] = []
     for JS_M in range(IS_M):
          row = next(iter(csvreader))
          if len(row[0]) > 0:
               dt = datetime.strptime(row[0], "%Y-%m-%d")
               ZTV_obs['date'].append(dt)
               for i, rid in enumerate(rids):
                    ZTV_obs[rid][JS_M] = float(row[i+1])

with open(rrr_mod_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     header = next(iter(csvreader))
     rids = [int(h) for h in header[1:]]
     ZTV_mod = {rid: [0]*IS_M for rid in rids}
     ZTV_mod['date'] = []
     for JS_M in range(IS_M):
          row = next(iter(csvreader))
          if len(row[0]) > 0:
               dt = datetime.strptime(row[0], "%Y-%m-%d")
               ZTV_mod['date'].append(dt)
               for i, rid in enumerate(rids):
                    ZTV_mod[rid][JS_M] = float(row[i+1])


for JS_obs_tot in range(IS_obs_tot):
#-------------------------------------------------------------------------------
#initialize all stats to zero
#-------------------------------------------------------------------------------
     ZS_obsbar=0
     ZS_modbar=0
     ZS_modBIA=0
     ZS_modRMS=0
     ZS_modSTD=0
     ZS_modNum=0
     ZS_den=0
     ZS_modNash=0
     ZS_modCor=0
     ZS_den2=0

#-------------------------------------------------------------------------------
#select data and convert to list
#-------------------------------------------------------------------------------
     if IS_start_date is None:
          ZV_obs = [value for value in ZTV_obs[IV_obs_tot_id[JS_obs_tot]]]
          ZV_mod = [value for value in ZTV_mod[IV_obs_tot_id[JS_obs_tot]]]
     else:
          ZV_obs = [value for vi, value in enumerate(ZTV_obs[IV_obs_tot_id[JS_obs_tot]])
                    if ZTV_obs['date'][vi]>=IS_start_date and ZTV_obs['date'][vi]<=IS_end_date]
          ZV_mod= [value for vi, value in enumerate(ZTV_mod[IV_obs_tot_id[JS_obs_tot]])
                   if ZTV_mod['date'][vi]>=IS_start_date and ZTV_mod['date'][vi]<=IS_end_date]

#-------------------------------------------------------------------------------
#calculate stats
#-------------------------------------------------------------------------------
     ZS_obsbar=sum(ZV_obs)/IS_M
     ZS_modbar=sum(ZV_mod)/IS_M
     ZS_modBIA=abs(ZS_obsbar-ZS_modbar)

     for JS_M in range(IS_M):
          ZS_modRMS=ZS_modRMS                                                  \
                   +(ZV_mod[JS_M]-ZV_obs[JS_M])*(ZV_mod[JS_M]-ZV_obs[JS_M])
          ZS_modSTD=ZS_modSTD                                                  \
                   +((ZV_mod[JS_M]-ZS_modbar)-(ZV_obs[JS_M]-ZS_obsbar))**2
          ZS_modCor=ZS_modCor                                                  \
                   +(ZV_mod[JS_M]-ZS_modbar)*(ZV_obs[JS_M]-ZS_obsbar)
          ZS_modNum=ZS_modNum                                                  \
                   +(ZV_mod[JS_M]-ZV_obs[JS_M])*(ZV_mod[JS_M]-ZV_obs[JS_M])
          ZS_den=ZS_den+(ZV_obs[JS_M]-ZS_obsbar)*(ZV_obs[JS_M]-ZS_obsbar)
          ZS_den2=ZS_den2+(ZV_mod[JS_M]-ZS_modbar)*(ZV_mod[JS_M]-ZS_modbar)

     ZS_modRMS=ZS_modRMS/IS_M
     ZS_modRMS=(ZS_modRMS)**0.5
     ZS_modSTD=ZS_modSTD/IS_M
     ZS_modSTD=(ZS_modSTD)**0.5
     if ZS_den!=0:
          ZS_modNash=1-ZS_modNum/ZS_den
     else:
          ZS_modNash=float('nan')
     if ZS_den!=0 and ZS_den2!=0:
          ZS_modCor=ZS_modCor/(ZS_den*ZS_den2)**0.5
     else:
          ZS_modCor=float('nan')

#-------------------------------------------------------------------------------
#Print outputs
#-------------------------------------------------------------------------------
     with open(rrr_sts_csv, 'ab') as csvfile:
          csvwriter = csv.writer(csvfile, dialect='excel')
          csvwriter.writerow([IV_obs_tot_id[JS_obs_tot],                       \
                              round(ZS_obsbar,2),                              \
                              round(ZS_modbar,2),                              \
                              round(ZS_modRMS,2),                              \
                              round(ZS_modBIA,2),                              \
                              round(ZS_modSTD,2),                              \
                              round(ZS_modNash,2),                             \
                              round(ZS_modCor,2),                              \
                             ]) 


#*******************************************************************************
#End
#*******************************************************************************
