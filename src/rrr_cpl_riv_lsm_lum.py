#!/usr/bin/env python3
#*******************************************************************************
#rrr_cpl_riv_lsm_lum.py
#*******************************************************************************

#Purpose:
#Given a netCDF file with time-varying external inflow (in m^3) into the river
#network, a list of river IDs that are upstream of a given river ID, and the
#river ID itself; this program computes the lumped discharge and stores it in a
#new CSV file.
#Author:
#Cedric H. David, 2018-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import csv
import numpy
import datetime


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_vol_ncf
# 2 - rrr_ups_csv
# 3 - YS_riv_id
# 4 - rrr_hyd_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments must be used')
     raise SystemExit(22) 

rrr_vol_ncf=sys.argv[1]
rrr_ups_csv=sys.argv[2]
YS_riv_id=sys.argv[3]
rrr_hyd_csv=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_vol_ncf)
print('- '+rrr_ups_csv)
print('- '+YS_riv_id)
print('- '+rrr_hyd_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_vol_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_vol_ncf)
     raise SystemExit(22) 

try:
     with open(rrr_ups_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_ups_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Reading netCDF file
#*******************************************************************************
print('Reading netCDF file')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f1 = netCDF4.Dataset(rrr_vol_ncf, 'r')

#-------------------------------------------------------------------------------
#Get dimension names and sizes
#-------------------------------------------------------------------------------
if 'COMID' in f1.dimensions:
     YS_rivid='COMID'
elif 'rivid' in f1.dimensions:
     YS_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_vol_ncf)
     raise SystemExit(22) 

IS_riv_tot=len(f1.dimensions[YS_rivid])
print('- The number of river reaches is: '+str(IS_riv_tot))

if 'Time' in f1.dimensions:
     YS_time='Time'
elif 'time' in f1.dimensions:
     YS_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_vol_ncf)
     raise SystemExit(22) 

IS_time=len(f1.dimensions[YS_time])
print('- The number of time steps is: '+str(IS_time))

#-------------------------------------------------------------------------------
#Get variable names
#-------------------------------------------------------------------------------
if 'm3_riv' in f1.variables:
     YS_var='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_vol_ncf)
     raise SystemExit(22) 


#*******************************************************************************
#Reading CSV file
#*******************************************************************************
print('Reading CSV file')

IV_riv_ups_id=[]
with open(rrr_ups_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     #IS_riv_ups=sum(1 for row in csvreader)-1
     YV_header=next(iter(csvreader))
     for row in csvreader:
          IV_riv_ups_id.append(int(row[0]))

IS_riv_ups=len(IV_riv_ups_id)
print('- Number of river reaches in rrr_ups_csv: '+str(IS_riv_ups))


#*******************************************************************************
#Creating hash table
#*******************************************************************************
print('Creating hash table')

IV_riv_tot_id=f1.variables[YS_rivid][:]

ZM_hsh={}
for JS_riv_tot in range(IS_riv_tot):
     ZM_hsh[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

print('- Done')


#*******************************************************************************
#Computing lumped runoff for given list of river IDs
#*******************************************************************************
print('Computing lumped runoff for given list of river IDs')

ZV_time=[]
for JS_time in range(IS_time):
     ZV_time.append(f1.variables[YS_time][JS_time])

YV_time=[datetime.datetime.utcfromtimestamp(t).strftime('%Y-%m-%d')            \
         for t in ZV_time]

IV_riv_ups_index=[]
for JS_riv_ups in range(IS_riv_ups):
     IV_riv_ups_index.append(ZM_hsh[IV_riv_ups_id[JS_riv_ups]])


ZV_var_lum=[]
for JS_time in range(IS_time):
     ZV_var_tmp=f1.variables[YS_var][JS_time,:]
     ZV_var_lum.append(sum(ZV_var_tmp[IV_riv_ups_index]))
#Lumping all water volume

ZV_var_lum=ZV_var_lum/(ZV_time[1]-ZV_time[0])
#Converting to discharge


#*******************************************************************************
#Write rrr_hyd_csv file
#*******************************************************************************
print('Write rrr_hyd_csv file')

with open(rrr_hyd_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow(['Lumped',YS_riv_id])
     for JS_time in range(IS_time):
          IV_line=[YV_time[JS_time],ZV_var_lum[JS_time]]
          csvwriter.writerow(IV_line)
#Write hydrographs


#*******************************************************************************
#End
#*******************************************************************************
