#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_map_mag_mod.py
#*******************************************************************************

#Purpose:
#Given a netCDF file from RAPID outputs, the name of a CSV file, and a
#percentile value, this program computes a series of metrics concerning the
#magnitude of the output variable (e.g. river discharge) for each individual
#river reach and saves the output in the CSV file. If optional ISO 8601
#character strings for the beginning and the end of the analysis are provided,
#the metrics are only computed over the desired time range.
#Author:
#Cedric H. David, 2021-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import numpy
import datetime
import calendar
import heapq
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_out_ncf
# 2 - ZS_prc
# 3 - YS_title
# 4 - rrr_map_csv
#(5)- rrr_beg_iso
#(6)- rrr_end_iso


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 5 or IS_arg > 7:
     print('ERROR - A minimum of 4 and a maximum of 6 arguments can be used')
     raise SystemExit(22) 

rrr_out_ncf=sys.argv[1]
ZS_prc=float(sys.argv[2])
YS_title=sys.argv[3]
rrr_map_csv=sys.argv[4]
if IS_arg>=6:
     rrr_beg_iso=sys.argv[5]
if IS_arg>=7:
     rrr_end_iso=sys.argv[6]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_out_ncf)
print('- '+str(ZS_prc))
print('- '+YS_title)
print('- '+rrr_map_csv)
if IS_arg>=6:
     print('- '+rrr_beg_iso)
if IS_arg>=7:
     print('- '+rrr_end_iso)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_out_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_out_ncf)
     raise SystemExit(22) 

if ZS_prc<0 or ZS_prc>100:
     print('ERROR - Percentile value: '+str(ZS_prc)+', must be within [0,100]')
     raise SystemExit(22)


#*******************************************************************************
#Open netCDF file
#*******************************************************************************
print('Opening netCDF file')

f = netCDF4.Dataset(rrr_out_ncf, 'r')


#*******************************************************************************
#Read netCDF file static data
#*******************************************************************************
print('Reading netCDF file static data')

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

#-------------------------------------------------------------------------------
#Get variable sizes 
#-------------------------------------------------------------------------------
IS_riv_bas=len(f.variables[YS_id_name])
print('- Number of river reaches: '+str(IS_riv_bas))

IS_time=len(f.variables[YS_out_name])
print('- Number of time steps: '+str(IS_time))

#-------------------------------------------------------------------------------
#Get river IDs
#-------------------------------------------------------------------------------
print('- Getting river IDs')
IV_riv_bas_id=f.variables[YS_id_name]

#-------------------------------------------------------------------------------
#Getting or making time variable values
#-------------------------------------------------------------------------------
print('- Getting or making time variable values')
ZV_time=numpy.zeros(IS_time)
if YS_time_name in f.variables and                                             \
     f.variables[YS_time_name][0]!=netCDF4.default_fillvals['i4']:
     #If the time variable exists but was not populated it holds the default
     #netCDF _fillValue and should be ignored here
     print(' . Values of time variable obtained from netCDF metadata')
     ZV_time=f.variables[YS_time_name][:]
     ZS_TauR=f.variables[YS_time_name][1]-f.variables[YS_time_name][0]
else:
     rrr_str_iso='2004-01-01T06:00:00'
     #The start time for the first time step in the input netCDF file.
     #ISO 8601 format: '1970-01-01T00:00:00', make sure UTC is used 
     ZS_TauR=10800
     #The duration (s) of the time steps in the input netCDF, 3h is most common
     print(' . WARNING: netCDF file does not have values of time variable')
     print('            Assuming file starts at '+rrr_str_iso)
     print('            Assuming time step is '+str(ZS_TauR)+' s')

     rrr_str_obj=datetime.datetime.strptime(rrr_str_iso,'%Y-%m-%dT%H:%M:%S')
     ZV_time[0]=calendar.timegm(rrr_str_obj.timetuple())
     for JS_time in range(1,IS_time):
          ZV_time[JS_time]=ZV_time[JS_time-1]+ZS_TauR


#*******************************************************************************
#Read netCDF file dynamic data
#*******************************************************************************
print('Reading netCDF file dynamic data')

#-------------------------------------------------------------------------------
#Determine time steps to include in analysis
#-------------------------------------------------------------------------------
print('Determining time steps to include in analysis')

if 'rrr_beg_iso' in locals():
     rrr_beg_obj=datetime.datetime.strptime(rrr_beg_iso,'%Y-%m-%dT%H:%M:%S')
     ZS_beg=calendar.timegm(rrr_beg_obj.timetuple())
else:
     ZS_beg=ZV_time[0]

if 'rrr_end_iso' in locals():
     rrr_end_obj=datetime.datetime.strptime(rrr_end_iso,'%Y-%m-%dT%H:%M:%S')
     ZS_end=calendar.timegm(rrr_end_obj.timetuple())
else:
     ZS_end=ZV_time[IS_time-1]

print('- Performing the analysis for times steps between those starting at:')
print('  '+datetime.datetime.utcfromtimestamp(ZS_beg).isoformat())
print('  '+datetime.datetime.utcfromtimestamp(ZS_end).isoformat())
print('  (both included)')

IS_beg=numpy.where(ZV_time==ZS_beg)[0]
if len(IS_beg)==1:
     IS_beg=IS_beg[0]
else:
     print('ERROR - Could not locate requested begin time in'+rrr_out_ncf)
     raise SystemExit(22) 

IS_end=numpy.where(ZV_time==ZS_end)[0]
if len(IS_end)==1:
     IS_end=IS_end[0]
else:
     print('ERROR - Could not locate requested end time in'+rrr_out_ncf)
     raise SystemExit(22) 

#-------------------------------------------------------------------------------
#Computing average, maximum, and minimum
#-------------------------------------------------------------------------------
print('Computing average, maximum, and minimum')

IV_one=numpy.ones(IS_riv_bas).astype(int)
IV_npt=numpy.zeros(IS_riv_bas).astype(int)
ZV_avg=numpy.zeros(IS_riv_bas)
ZV_max=numpy.zeros(IS_riv_bas)
ZV_min=numpy.zeros(IS_riv_bas)
ZV_min[:]=1000000000

for JS_time in range(IS_beg,IS_end+1):
     ZV_out=f.variables[YS_out_name][JS_time,:]
     #values read from the netCDF file
     if numpy.ma.is_masked(ZV_out):
          BV_yes=~ZV_out.mask
     else:
          BV_yes=[True]*IS_riv_bas
     #locations where the netCDF values are not masked (~ inverts all booleans)
     IV_npt=numpy.where(BV_yes,IV_npt+IV_one,IV_npt)
     #updating the number of actual values (i.e. not NaN) for each reach
     ZV_avg=numpy.where(BV_yes,ZV_avg+ZV_out,ZV_avg)
     #updating the average
     ZV_max=numpy.where((BV_yes)&(ZV_out>ZV_max),ZV_out,ZV_max)
     #updating the maximum
     ZV_min=numpy.where((BV_yes)&(ZV_out<ZV_min),ZV_out,ZV_min)
     #updating the minimum

IV_npt=numpy.where(IV_npt==0,-9999,IV_npt)
#Replacing number of values by -9999 only where there was 0 values to avoid
#runtime warning during division below
ZV_avg=numpy.where(IV_npt>0,ZV_avg/IV_npt,numpy.NaN)
#Dividing sum of values by number of values. Otherwise: NaN
ZV_max=numpy.where(IV_npt>0,ZV_max,numpy.NaN)
#Replacing max value by NaN where there only masked data
ZV_min=numpy.where(IV_npt>0,ZV_min,numpy.NaN)
#Replacing max value by NaN where there only masked data

#-------------------------------------------------------------------------------
#Computing percentile
#-------------------------------------------------------------------------------
print('Computing percentile')

ZS_kth=ZS_prc/100.
#The kth statistic corresponding to the desired percentile
ZV_rat=numpy.zeros(IS_riv_bas)
#List of ratios, one ratio per reach, used as weight between two percentiles
ZH_hea=[[] for JS_riv_bas in range(IS_riv_bas)]
#List of heaps, one heap per reach, each will be built with appropriate size
ZV_til=numpy.empty(IS_riv_bas)
ZV_til[:]=numpy.nan
#Initialized numpy array for percentile values

for JS_riv_bas in range(IS_riv_bas):
     IS_npt=IV_npt[JS_riv_bas]
     #The number of points in the timeseries for this river reach
     if IS_npt>0: ZV_rat[JS_riv_bas]=ZS_kth*(IS_npt-1)-int(ZS_kth*(IS_npt-1))
     if ZS_kth>=0.5:
          IS_nhp=IS_npt-int(ZS_kth*(IS_npt-1))
          #The number of elements to retain for percentile computation
          ZH_hea[JS_riv_bas]=[-999999999]*IS_nhp
          heapq.heapify(ZH_hea[JS_riv_bas])
     if ZS_kth<0.5:
          IS_nhp=int(ZS_kth*(IS_npt-1))+2
          #The number of elements to retain for percentile computation
          ZH_hea[JS_riv_bas]=[999999999]*IS_nhp
          heapq.heapify(ZH_hea[JS_riv_bas])

for JS_time in range(IS_beg,IS_end+1):
     ZV_out=f.variables[YS_out_name][JS_time,:]
     #values read from the netCDF file
     if numpy.ma.is_masked(ZV_out):
          BV_yes=~ZV_out.mask
     else:
          BV_yes=[True]*IS_riv_bas
     #locations where the netCDF values are not masked (~ inverts all booleans)
     for JS_riv_bas in range(IS_riv_bas):
          if (BV_yes[JS_riv_bas] and ZS_kth>=0.5):
               heapq.heappushpop(ZH_hea[JS_riv_bas],ZV_out[JS_riv_bas])
          if (BV_yes[JS_riv_bas] and ZS_kth<0.5):
               heapq._heappushpop_max(ZH_hea[JS_riv_bas],ZV_out[JS_riv_bas])

for JS_riv_bas in range(IS_riv_bas):
     if IV_npt[JS_riv_bas]>0:
          ZS_rat=ZV_rat[JS_riv_bas]
          if ZS_kth>=0.5:
               ZV_two=heapq.nsmallest(2,ZH_hea[JS_riv_bas])
          if ZS_kth<0.5:
               ZV_two=heapq.nlargest(2,ZH_hea[JS_riv_bas])
          ZV_two.sort()
          ZV_til[JS_riv_bas]=ZV_two[0]+ZS_rat*(ZV_two[1]-ZV_two[0])


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Writing CSV file')

with open(rrr_map_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     IV_line=[YS_title,                                                        \
              YS_out_name+'_avg',                                              \
              YS_out_name+'_max',                                              \
              YS_out_name+'_min',                                              \
              YS_out_name+'_'+str(int(ZS_prc))+'p']
     csvwriter.writerow(IV_line) 

     for JS_riv_bas in range(IS_riv_bas):
          IV_line=[IV_riv_bas_id[JS_riv_bas],                                  \
                   round(ZV_avg[JS_riv_bas],2),                                \
                   round(ZV_max[JS_riv_bas],2),                                \
                   round(ZV_min[JS_riv_bas],2),                                \
                   round(ZV_til[JS_riv_bas],2)]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
