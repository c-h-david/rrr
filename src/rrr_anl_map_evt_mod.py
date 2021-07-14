#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_map_evt_mod.py
#*******************************************************************************

#Purpose:
#Given a netCDF file from RAPID outputs and a CSV file with magnitude metrics,
#this program computes a series of metrics concerning the duration of events
#above a given threshold. If optional ISO 8601 character strings for the
#beginning and the end of the analysis are provided, the metrics are only
#computed over the desired time range.
#Author:
#Cedric H. David, 2021-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import numpy
import datetime
import calendar
import pandas
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_out_ncf
# 2 - rrr_mag_csv
# 3 - rrr_evt_csv
#(4)- rrr_beg_iso
#(5)- rrr_end_iso


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 4 or IS_arg > 6:
     print('ERROR - A minimum of 3 and a maximum of 5 arguments can be used')
     raise SystemExit(22) 

rrr_out_ncf=sys.argv[1]
rrr_mag_csv=sys.argv[2]
rrr_evt_csv=sys.argv[3]
if IS_arg>=5:
     rrr_beg_iso=sys.argv[4]
if IS_arg>=6:
     rrr_end_iso=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_out_ncf)
print('- '+rrr_mag_csv)
print('- '+rrr_evt_csv)
if IS_arg>=5:
     print('- '+rrr_beg_iso)
if IS_arg>=6:
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

try:
     with open(rrr_mag_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_out_csv)
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
IV_riv_bas_id=list(f.variables[YS_id_name])

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
#Read rrr_mag_csv
#*******************************************************************************
print('Reading rrr_mag_csv')

df=pandas.read_csv(rrr_mag_csv)

YS_title=df.columns[0]
IV_riv_bas_id2=df[YS_title].tolist()

if IV_riv_bas_id==IV_riv_bas_id2:
     print('- The river IDs in rrr_out_ncf and rrr_mag_csv are the same')
else:
     print('ERROR - The river IDs in rrr_out_ncf and rrr_mag_csv differ')
     raise SystemExit(22) 

YS_thr=df.columns[-1]
ZV_thr=numpy.array(df[YS_thr].tolist())


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
#Computing number of events, and average, maximum, and minimum duration
#-------------------------------------------------------------------------------
print('Computing number of events, and average, maximum, and minimum duration')

IV_one=numpy.ones(IS_riv_bas)
BV_tru=numpy.ones(IS_riv_bas).astype(bool)
BV_fal=numpy.zeros(IS_riv_bas).astype(bool)

IV_evt=numpy.zeros(IS_riv_bas)
#Array with count for number of events
BV_bef=numpy.zeros(IS_riv_bas).astype(bool)
#Array with booleans for if there was an event before
ZV_taR=numpy.ones(IS_riv_bas)*ZS_TauR
#Array with the duration of each time step

ZV_cur=numpy.zeros(IS_riv_bas)
#Duration of current event up to now at each reach
ZV_min=numpy.ones(IS_riv_bas)*1e20
#Minimum duration of past events at each reach
ZV_max=numpy.zeros(IS_riv_bas)
#Maximum duration of past events at each reach
ZV_avg=numpy.zeros(IS_riv_bas)
#Average duration of past events at each reach
ZV_lst=numpy.zeros(IS_riv_bas)
#Last available value
IV_nls=numpy.ones(IS_riv_bas)
#Number of time steps since last available value
IV_add=numpy.zeros(IS_riv_bas)
#Number of time steps to add if using linear interpolation between NoData
IV_sub=numpy.zeros(IS_riv_bas)
#Number of time steps to substract if using linear interpolation between NoData

for JS_time in range(IS_beg,IS_end+1):
     ZV_out=f.variables[YS_out_name][JS_time,:]
     #values read from the netCDF file

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Determining where actual values exist (i.e. avoiding NoData)
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if numpy.ma.is_masked(ZV_out):
          BV_out=~ZV_out.mask
     else:
          BV_out=numpy.ones(IS_riv_bas).astype(bool)
     #locations where the netCDF values are not masked (~ inverts all booleans)

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Testing if existing values are above threshold, otherwise same as before
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     BV_thr=numpy.greater_equal(ZV_out,ZV_thr,where=BV_out)
     #Locations where a current value exists and is greater/equal to threshold
     BV_now=BV_bef
     #Assume BV_now is the same as BV_bef
     BV_now=numpy.where(BV_out & BV_thr,BV_tru,BV_now)
     #Set BV_now to True in locations where a value exists & exceeds threshold,
     #otherwise retain the previous value of BV_now
     BV_now=numpy.where(BV_out & (~BV_thr),BV_fal,BV_now)
     #Set BV_now to False in locations where a value exists & does NOT exceed
     #threshold, otherwise retain the previous value of BV_now

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Updating current events
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     IV_evt=numpy.where((~BV_bef) & BV_now,IV_evt+IV_one,IV_evt)
     #Increase number of events where there is one now and there wasn't before
     ZV_cur=numpy.where(BV_now,ZV_cur+ZV_taR,ZV_cur)
     #Increase the duration of events where events are ongoing

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Correcting for linear interpolation at beginning of events
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ZV_den=numpy.where((BV_now)&(~BV_bef)&(~(ZV_out-ZV_lst==0)),ZV_out-ZV_lst,\
                         IV_one)
     IV_add=numpy.where((BV_now)&(~BV_bef),                                    \
                        (IV_nls*(ZV_out-ZV_thr)/(ZV_den)).astype(int),         \
                        0*IV_one)
     ZV_cur=numpy.where((BV_now)&(~BV_bef),ZV_cur+IV_add*ZV_taR,ZV_cur)

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Correcting for linear interpolation at end of events
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ZV_den=numpy.where((~BV_now)&(BV_bef)&(~(ZV_lst-ZV_out==0)),ZV_lst-ZV_out,\
                         IV_one)
     IV_sub=numpy.where((~BV_now)&(BV_bef),                                    \
                        IV_nls-IV_one-                                         \
                        (IV_nls*(ZV_lst-ZV_thr)/ZV_den).astype(int),           \
                        0*IV_one)
     ZV_cur=numpy.where((~BV_now)&(BV_bef),ZV_cur-IV_sub*ZV_taR,ZV_cur)

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Updating metrics at event completion
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ZV_avg=numpy.where((~BV_now)&(BV_bef),ZV_avg+ZV_cur,ZV_avg)
     #Increase average time by event duration where events ended, or retain
     ZV_max=numpy.where((~BV_now)&(BV_bef)&(ZV_cur>ZV_max),ZV_cur,ZV_max)
     #Update value of maximum if an event ended (before zeroing current event)
     ZV_min=numpy.where((~BV_now)&(BV_bef)&(ZV_cur<ZV_min),ZV_cur,ZV_min)
     #Update value of minimum if an event ended (before zeroing current event)

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Updating metrics for last time step at locations where event still ongoing
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     if JS_time==IS_end:
          ZV_avg=numpy.where(BV_now,ZV_avg+ZV_cur,ZV_avg)
          ZV_max=numpy.where(BV_now&(ZV_cur>ZV_max),ZV_cur,ZV_max)
          ZV_min=numpy.where(BV_now&(ZV_cur<ZV_min),ZV_cur,ZV_min)
          
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Resetting values
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     ZV_lst=numpy.where(BV_out,ZV_out,ZV_lst)
     #Replace last known value by current value where a current value exists
     IV_nls=numpy.where(~BV_out,IV_nls+IV_one,IV_one)
     #Incrementally grow the number of time steps since last known value
     ZV_cur=numpy.where(BV_now,ZV_cur,0*IV_one)
     #Retain values of current even duration unless the events have ended
     BV_bef=BV_now
     #Reset now/before status

IV_evt=numpy.where(IV_evt==0,-9999,IV_evt)
#Replacing number of values by -9999 only where there was 0 values to avoid
#runtime warning during division below
ZV_avg=numpy.where(IV_evt>0,ZV_avg/IV_evt,numpy.NaN)
#Dividing sum of values by number of values. Otherwise: NaN
ZV_max=numpy.where(IV_evt>0,ZV_max,numpy.NaN)
#Replacing max value by NaN where there was only masked data
ZV_min=numpy.where(IV_evt>0,ZV_min,numpy.NaN)
#Replacing max value by NaN where there was only masked data
IV_evt=numpy.where(IV_evt>0,IV_evt,numpy.NaN)
#Replacing number of values by NaN where there was only masked data


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Writing CSV file')

with open(rrr_evt_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     IV_line=[YS_title,                                                        \
              'T'+YS_thr[-3:]+'_avg',                                          \
              'T'+YS_thr[-3:]+'_max',                                          \
              'T'+YS_thr[-3:]+'_min',                                          \
              'N'+YS_thr[-3:]]
     csvwriter.writerow(IV_line) 

     for JS_riv_bas in range(IS_riv_bas):
          IV_line=[IV_riv_bas_id[JS_riv_bas],                                  \
                   round(ZV_avg[JS_riv_bas],2),                                \
                   round(ZV_max[JS_riv_bas],2),                                \
                   round(ZV_min[JS_riv_bas],2),                                \
                   IV_evt[JS_riv_bas]]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
