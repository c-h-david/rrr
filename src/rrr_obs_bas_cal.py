#!/usr/bin/env python3
#*******************************************************************************
#rrr_obs_bas_cal.py
#*******************************************************************************

#Purpose:
#Given a CSV file river IDs where gauges are available and a shapefile with
#gauges where calibration will take place; this program creates a subset CSV
#file corresponding to calibration gauges.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import fiona


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_tot_csv
# 2 - rrr_cal_shp
# 3 - rrr_bas_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22)

rrr_tot_csv=sys.argv[1]
rrr_cal_shp=sys.argv[2]
rrr_bas_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_tot_csv)
print('- '+rrr_cal_shp)
print('- '+rrr_bas_csv)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_tot_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_tot_csv)
     raise SystemExit(22)

try:
     with open(rrr_cal_shp) as file:
          pass
except IOError as e:
     print('WARNING - Unable to open '+rrr_cal_shp+', skipping')
     raise SystemExit(-22)


#*******************************************************************************
#Read CSV file
#*******************************************************************************
print('Read CSV file')

IV_tot_ids=[]
with open(rrr_tot_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_tot_ids.append(int(row[0]))

IS_tot_csv=len(IV_tot_ids)
print('- The number of available gauges in CSV file is: '+str(IS_tot_csv))


#*******************************************************************************
#Read gauge shapefile
#*******************************************************************************
print('Read gauge shapefile')

rrr_cal_lay=fiona.open(rrr_cal_shp, 'r')

if 'Sttn_Nm' in rrr_cal_lay[0]['properties']:
     YS_cal_nam='Sttn_Nm'
else:
     print('ERROR - Sttn_Nm does not exist in '+rrr_cal_shp)
     raise SystemExit(22)

if 'rivid' in rrr_cal_lay[0]['properties']:
     YS_cal_ids='rivid'
else:
     print('ERROR - rivid does not exist in '+rrr_cal_shp)
     raise SystemExit(22)

IS_cal_shp=len(rrr_cal_lay)
print('- The number of gauge features is: '+str(IS_cal_shp))

YV_cal_nam=[]
IV_cal_ids=[]
for rrr_cal_fea in rrr_cal_lay:
     YV_cal_nam.append(rrr_cal_fea['properties'][YS_cal_nam])
     IV_cal_ids.append(rrr_cal_fea['properties'][YS_cal_ids])


#*******************************************************************************
#Extract calibration IDs
#*******************************************************************************
print('Extract calibration IDs')

IV_bas_ids=[]
for JS_tot_csv in range(IS_tot_csv):
     if IV_tot_ids[JS_tot_csv] in IV_cal_ids:
          IV_bas_ids.append(IV_tot_ids[JS_tot_csv])

IS_bas_csv=len(IV_bas_ids)
print('- The number of calibration gauges in CSV file is: '+str(IS_bas_csv))


#*******************************************************************************
#Write calibration CSV file
#*******************************************************************************
print('Write calibration CSV file')

with open(rrr_bas_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_bas_csv in range(IS_bas_csv):
          csvwriter.writerow([IV_bas_ids[JS_bas_csv]])

print('- Done')


#*******************************************************************************
#End
#*******************************************************************************
