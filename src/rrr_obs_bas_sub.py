#!/usr/bin/env python3
#*******************************************************************************
#rrr_obs_bas_sub.py
#*******************************************************************************

#Purpose:
#Given a CSV file with observations at many gauges with the first row being
#gauge code (or name) and each subsequent row is flow observations, and given a
#shapefile with a subset of these gauges that includes both gauge code and river
#reach ID; this program creates a subset of observations in a format that is
#suitable for RAPID: i.e. a CSV file with sorted river IDS, and a CSV file with
#corresponding flow observations.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import numpy
import fiona


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_Qob_csv
# 2 - rrr_obs_shp
# 3 - rrr_id2_csv
# 4 - rrr_Qo2_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22)

rrr_Qob_csv=sys.argv[1]
rrr_obs_shp=sys.argv[2]
rrr_id2_csv=sys.argv[3]
rrr_Qo2_csv=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print(' - '+rrr_Qob_csv)
print(' - '+rrr_obs_shp)
print(' - '+rrr_id2_csv)
print(' - '+rrr_Qo2_csv)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_Qob_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_Qob_csv)
     raise SystemExit(22)

try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('WARNING - Unable to open '+rrr_obs_shp+', skipping')
     raise SystemExit(-22)


#*******************************************************************************
#Read CSV file
#*******************************************************************************
print('Read CSV file')

with open(rrr_Qob_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     row=next(iter(csvreader))
     YV_Qob_nam=row
     IS_Qob_csv=len(YV_Qob_nam)

     IS_time=0
     ZV_Qav=numpy.zeros(IS_Qob_csv)
     for row in csvreader:
          IS_time=IS_time+1
          ZV_Qob=numpy.array([float(Qob) for Qob in row])
          ZV_Qav=ZV_Qav+ZV_Qob
     ZV_Qav=ZV_Qav/IS_time

print('- The number of gauges in CSV file is: '+str(IS_Qob_csv))
print('- The number of time steps in CSV file is: '+str(IS_time))


#*******************************************************************************
#Read gauge shapefile
#*******************************************************************************
print('Read gauge shapefile')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')

if 'Sttn_Nm' in rrr_obs_lay[0]['properties']:
     YS_obs_nam='Sttn_Nm'
else:
     print('ERROR - Sttn_Nm does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

if 'rivid' in rrr_obs_lay[0]['properties']:
     YS_obs_ids='rivid'
else:
     print('ERROR - rivid does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

IS_obs_shp=len(rrr_obs_lay)
print(' - The number of gauge features is: '+str(IS_obs_shp))

YV_obs_nam=[]
IV_obs_ids=[]
for rrr_obs_fea in rrr_obs_lay:
     YV_obs_nam.append(rrr_obs_fea['properties'][YS_obs_nam])
     IV_obs_ids.append(rrr_obs_fea['properties'][YS_obs_ids])


#*******************************************************************************
#Create hash table
#*******************************************************************************
print('Create hash table')

YM_hsh={}
for JS_Qob_csv in range(IS_Qob_csv):
     Qob_nam=YV_Qob_nam[JS_Qob_csv]
     YM_hsh[Qob_nam]=JS_Qob_csv

print(' - Done')


#*******************************************************************************
#Check all requested basin stations are in input file
#*******************************************************************************
print('Check all requested basin stations are in input file')

for JS_obs_shp in range(IS_obs_shp):
     obs_nam=YV_obs_nam[JS_obs_shp]
     if obs_nam not in YM_hsh:
          print('ERROR - '+obs_nam+' does not exist in '+rrr_Qob_csv)
          raise SystemExit(22)

print(' - Done')


#*******************************************************************************
#Sort river IDs of subsample
#*******************************************************************************
print('Sort river IDs of subsample')

z=sorted(zip(IV_obs_ids,YV_obs_nam))
IV_obs_ids_srt,YV_obs_nam_srt=zip(*z)
#Sorting the lists together based on increasing value of the river ID.
IV_obs_ids_srt=list(IV_obs_ids_srt)
YV_obs_nam_srt=list(YV_obs_nam_srt)
#Because zip creates tuples and not lists

IV_obs_ids=IV_obs_ids_srt.copy()
YV_obs_nam=YV_obs_nam_srt.copy()
#Reassigning the original names after sorting

print(' - Done')


#*******************************************************************************
#Subsample observations and write CSV files
#*******************************************************************************
print('Subsample observations and write CSV files')

IV_obs_idx=[YM_hsh[Qob_nam] for Qob_nam in YV_obs_nam]

with open(rrr_id2_csv, 'w') as csvfil2:
     csvwriter = csv.writer(csvfil2, dialect='excel')
     for JS_obs_ids in range(len(IV_obs_ids)):
          csvwriter.writerow([IV_obs_ids[JS_obs_ids]])

with open(rrr_Qo2_csv, 'w') as csvfil2:
     csvwriter = csv.writer(csvfil2, dialect='excel')

     with open(rrr_Qob_csv) as csvfile:
          csvreader=csv.reader(csvfile)
          row=next(iter(csvreader))

          for row in csvreader:
               ZV_line=[row[idx] for idx in IV_obs_idx]
               csvwriter.writerow(ZV_line)

print(' - Done')


#*******************************************************************************
#End
#*******************************************************************************
