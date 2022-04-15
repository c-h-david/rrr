#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_mod.py
#*******************************************************************************

#Purpose:
#Given an observing stations shapefile with unique integer identifiers and 
#unique station codes, a netCDF file containing modeled quantities (for many 
#days/many reaches), a name for the simulation, and a number of consecutive 
#values to be averaged together, this program produces a csv file in which the 
#(averaged) time series of modeled quantities are stored. In case time metadata
#is missing from the netCDF file, this can be provided in the command line.
#If uncertainty information is provided in the netCDF file, another csv file is
#also generated.
#Author:
#Cedric H. David, 2011-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import csv
import fiona
import netCDF4
import numpy
import datetime
import calendar


#*******************************************************************************
#Domain specific hard-coded variables in case metadata is missing for netCDF
#*******************************************************************************
iso_str_dat='1970-01-01T00:00:00'
#The beginning time of the first time step in the input netCDF file.
#ISO 8601 format: '1970-01-01T00:00:00', make sure UTC is used 
ZS_TauR=10800
#The duration (s) of the time steps in the input netCDF files, 3h is most common


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_out_ncf
# 3 - rrr_out_str
# 4 - IS_avg
# 5 - rrr_hyd_csv
#(6)- iso_str_dat
#(7)- ZS_TauR


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 6 or IS_arg > 8:
     print('ERROR - A minimum of 5 and a maximum of 7 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_out_ncf=sys.argv[2]
rrr_out_str=sys.argv[3]
IS_avg=int(sys.argv[4])
rrr_hyd_csv=sys.argv[5]
if IS_arg>=7:
     iso_str_dat=sys.argv[6]
if IS_arg>=8:
     ZS_TauR=int(sys.argv[7])


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_out_ncf)
print('- '+rrr_out_str)
print('- '+str(IS_avg))
print('- '+rrr_hyd_csv)
print('- '+iso_str_dat)
print('- '+str(ZS_TauR))


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_out_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_out_ncf)
     raise SystemExit(22) 

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
print('- Number of river reaches in rrr_obs_shp: '+str(IS_obs_tot))

if 'COMID_1' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID_1'
elif 'FLComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='FLComID'
elif 'ARCID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ARCID'
elif 'COMID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID'
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
IV_obs_tot_id_srt=list(IV_obs_tot_id_srt)
YV_obs_tot_cd_srt=list(YV_obs_tot_cd_srt)
#Because zip creates tuples and not lists


#*******************************************************************************
#Read netCDF file static data
#*******************************************************************************
print('Reading netCDF file static data')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f = netCDF4.Dataset(rrr_out_ncf, 'r')

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

if 'sQout' in f.variables:
     YS_uq_name='sQout'
elif 'sV' in f.variables:
     YS_uq_name='sV'
else:
     YS_uq_name=''

#-------------------------------------------------------------------------------
#Get variable sizes 
#-------------------------------------------------------------------------------
IS_riv_bas=len(f.variables[YS_id_name])
print('- Number of river reaches: '+str(IS_riv_bas))

IS_R=len(f.variables[YS_out_name])
print('- Number of time steps: '+str(IS_R))

#-------------------------------------------------------------------------------
#Get river IDs
#-------------------------------------------------------------------------------
print('- Getting river IDs')
IV_riv_bas_id=f.variables[YS_id_name]

#-------------------------------------------------------------------------------
#Look for UQ estimates
#-------------------------------------------------------------------------------
print('- Look for UQ estimates')
if YS_uq_name!='':
     print(' . UQ estimates available')
else:
     print(' . UQ estimates NOT available')

#-------------------------------------------------------------------------------
#Make hash table
#-------------------------------------------------------------------------------
print('- Making hash table')
IM_hsh={}
for JS_riv_bas in range(IS_riv_bas):
     IM_hsh[IV_riv_bas_id[JS_riv_bas]]=JS_riv_bas

#-------------------------------------------------------------------------------
#Getting or making time variable values
#-------------------------------------------------------------------------------
print('- Getting or making time variable values')
ZV_time=[0]*IS_R
if YS_time_name in f.variables and                                             \
   f.variables[YS_time_name][0]!=netCDF4.default_fillvals['i4']:
   #If the time variable exists but was not populated it holds the default
   #netCDF _fillValue and should be ignored here
     print(' . Values of time variable obtained from metadata')
     ZV_time=f.variables[YS_time_name][:]
     ZS_TauR=f.variables[YS_time_name][1]-f.variables[YS_time_name][0]
else:
     print(' . Values of time variable built from command line data')
     obj_str_date=datetime.datetime.strptime(iso_str_dat,'%Y-%m-%dT%H:%M:%S')
     ZV_time[0]=calendar.timegm(obj_str_date.timetuple())
     for JS_R in range(1,IS_R):
          ZV_time[JS_R]=ZV_time[JS_R-1]+ZS_TauR


#*******************************************************************************
#Read netCDF file dynamic data
#*******************************************************************************
print('Reading netCDF file dynamic data')

#-------------------------------------------------------------------------------
#Computing time variable for running average
#-------------------------------------------------------------------------------
print('- Computing time variable for running average')

ZV_time=numpy.array(ZV_time)
ZV_time_avg=(ZV_time.reshape(-1,IS_avg)).mean(axis=1)
#Compute running average

YV_time_avg=[datetime.datetime.fromtimestamp(t).strftime('%Y-%m-%d')           \
             for t in ZV_time_avg]

#-------------------------------------------------------------------------------
#Generate separate hydrographs into a matrix
#-------------------------------------------------------------------------------
print('- Generating separate hydrographs into a matrix')

IS_out_avg=int(IS_R/IS_avg)
#The number of time steps in the running-averaged timeseries

ZM_out_avg=numpy.array([]).reshape(0,IS_out_avg)
#Initialize an empty array of size IS_out_avg to store all hydrographs

for JS_obs_tot in range(IS_obs_tot):
     print('  . processing river ID: '+str(IV_obs_tot_id_srt[JS_obs_tot]))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Get values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZV_out=f.variables[YS_out_name][:,IM_hsh[IV_obs_tot_id_srt[JS_obs_tot]]]
     #This follows the following format for RAPID outputs: Qout(time,rivid)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Average every so many values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Examples: IS_avg=8 to make daily from 3-hourly
     #          IS_avg=1 to make 3-hourly from 3-hourly
     ZV_out_avg=(ZV_out.reshape(-1,IS_avg)).mean(axis=1)
     #This uses numpy reshape to make a list of lists with IS_avg elements each
     #before using numpy again to average each list.

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Update array containing all hydrographs
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZM_out_avg=numpy.vstack((ZM_out_avg,ZV_out_avg))

#-------------------------------------------------------------------------------
#Transpose the matrix of hydrographs
#-------------------------------------------------------------------------------
print('- Transpose the matrix of hydrographs')

ZM_out_avg=ZM_out_avg.transpose()


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Write CSV file')

with open(rrr_hyd_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     #csvwriter.writerow([rrr_out_str]+YV_obs_tot_cd_srt)
     csvwriter.writerow([rrr_out_str]+IV_obs_tot_id_srt)
     for JS_out_avg in range(IS_out_avg):
          IV_line=[YV_time_avg[JS_out_avg]]+list(ZM_out_avg[JS_out_avg,:]) 
          csvwriter.writerow(IV_line) 
#Write hydrographs
 
if YS_uq_name!='' and                                                          \
   f.variables[YS_uq_name][0]!=netCDF4.default_fillvals['f4']:
   #If the uncertainty variable exists but was not populated it holds the
   #default netCDF _fillValue and should be ignored here
     ZV_out_bar=numpy.mean(ZM_out_avg, axis=0)
     ZV_pct_uq=numpy.zeros(IS_obs_tot)
     for JS_obs_tot in range(IS_obs_tot):
          ZV_pct_uq[JS_obs_tot]=f.variables[YS_uq_name]                        \
                                [IM_hsh[IV_obs_tot_id_srt[JS_obs_tot]]]        \
                               /ZV_out_bar[JS_obs_tot]                         \
                               *100

     rrr_hyd_csv=rrr_hyd_csv[:-4]+'_uq.csv'
     with open(rrr_hyd_csv, 'wb') as csvfile:
          csvwriter = csv.writer(csvfile, dialect='excel')
          #csvwriter.writerow([rrr_out_str]+YV_obs_tot_cd_srt)
          csvwriter.writerow([rrr_out_str]+IV_obs_tot_id_srt)
          for JS_out_avg in range(IS_out_avg):
               IV_line=[YV_time_avg[JS_out_avg]]+list( ZM_out_avg[JS_out_avg,:]\
                                                      *ZV_pct_uq[:]/100) 
               csvwriter.writerow(IV_line) 
#Write hydrographs for uncertainty 


#*******************************************************************************
#End
#*******************************************************************************
