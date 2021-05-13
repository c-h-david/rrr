#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_spl_mod.py
#*******************************************************************************
#Purpose:
#This script sumbsamples river model outputs based on prior subsampling of
#the river network based on polylines/polygons and their mean times and on the
#time (second) required to complete one cycle.
#Author:
#Etienne Fluet Chouinard, Cedric H. David, Md Safat Sikder, 2016-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import netCDF4
import datetime
import calendar
import numpy
import os.path
import subprocess
import progressbar


#*******************************************************************************
#Domain specific hard-coded variables in case metadata is missing for netCDF
#*******************************************************************************
iso_str_date='1970-01-01T00:00:00'
#The beginning time of the first time step in the input netCDF file.
#ISO 8601 format: '1970-01-01T00:00:00', make sure UTC is used 
ZS_TauR=10800
#The duration (s) of the time steps in the input netCDF files, 3h is most common


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_mod_nc1
# 2 - rrr_spl_csv
# 3 - ZS_cyc_tim				#S3:2332800;SaralEvn:3023999.928
						#J3J2J1TP:856706.44;SWOT:1802700
# 4 - rrr_mod_nc3


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

rrr_mod_nc1=sys.argv[1]
rrr_spl_csv=sys.argv[2]
ZS_cyc_tim=float(sys.argv[3])
rrr_mod_nc3=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_mod_nc1)
print('- '+rrr_spl_csv)
print('- '+str(ZS_cyc_tim))
print('- '+rrr_mod_nc3)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_mod_nc1) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_mod_nc1)
     raise SystemExit(22) 

try:
     with open(rrr_spl_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_spl_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Open rrr_mod_nc1
#*******************************************************************************
print('Open rrr_mod_nc1')

f1=netCDF4.Dataset(rrr_mod_nc1,'r')

if 'COMID' in f1.dimensions:
     YV_rivid='COMID'
elif 'rivid' in f1.dimensions:
     YV_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_mod_nc1)
     raise SystemExit(22) 

IS_riv_tot1=len(f1.dimensions[YV_rivid])
print('- The number of river reaches in model outputs is: '+str(IS_riv_tot1))

IV_riv_tot_id1=f1.variables[YV_rivid][:]

if 'Time' in f1.dimensions:
     YV_time='Time'
elif 'time' in f1.dimensions:
     YV_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_mod_nc1)
     raise SystemExit(22) 

IS_time1=len(f1.dimensions[YV_time])
print('- The number of time steps in model outputs is: '+str(IS_time1))

if 'Qout' in f1.variables:
     YV_var='Qout'
elif 'V' in f1.variables:
     YV_var='V'
else:
     print('ERROR - Neither Qout nor V exist in '+rrr_mod_nc1)
     raise SystemExit(22) 

ZV_time1=[0]*IS_time1
if YV_time in f1.variables:
     print('- The values of the time variable are obtained from metadata')
     ZV_time1=f1.variables[YV_time][:]
     ZS_TauR=f1.variables[YV_time][1]-f1.variables[YV_time][0]
else:
     print('- The values of the time variable are built from hardcoded data')
     obj_str_date=datetime.datetime.strptime(iso_str_date,'%Y-%m-%dT%H:%M:%S')
     ZV_time1[0]=calendar.timegm(obj_str_date.timetuple())
     for JS_time1 in range(1,IS_time1):
          ZV_time1[JS_time1]=ZV_time1[JS_time1-1]+ZS_TauR


#*******************************************************************************
#Open rrr_spl_csv
#*******************************************************************************
print('Open rrr_spl_csv')

IV_riv_tot_id2=[]
IV_spl_cnt=[]
IM_mea_tim=[]
with open(rrr_spl_csv) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          if len(row[2:])==int(row[1]):
               IV_riv_tot_id2.append(int(row[0]))
               IV_spl_cnt.append(int(row[1]))
               IM_mea_tim.append(row[2:])
          else:
               print('ERROR - This file is inconsistent: '+rrr_spl_csv)
               raise SystemExit(22) 

IS_riv_tot2=len(IV_riv_tot_id2)
IS_spl_max=max(IV_spl_cnt)
IS_spl_tot=sum(IV_spl_cnt)
print('- The number of river reaches in subsample file is: '+str(IS_riv_tot2))
print('- The maximum number of subsamples per river reach is: '+str(IS_spl_max))
print('- The total number of subsample/river reach pairs is: '+str(IS_spl_tot))


#*******************************************************************************
#Creating hash tables
#*******************************************************************************
print('Creating hash tables')

IH_hsh1={}
for JS_riv_tot1 in range(IS_riv_tot1):
     IH_hsh1[IV_riv_tot_id1[JS_riv_tot1]]=JS_riv_tot1
     #This hash table relates a given rivid with its index in rrr_mod_nc1

IH_hsh2={}
for JS_riv_tot2 in range(IS_riv_tot2):
     IH_hsh2[IV_riv_tot_id2[JS_riv_tot2]]=JS_riv_tot2
     #This hash table relates a given rivid with its index in rrr_spl_csv

print('- Done')


#*******************************************************************************
#Reorganizing subsamples chronologically in a dictionary for faster I/O
#*******************************************************************************
print('Reorganizing subsamples chronologically in a dictionary for faster I/O')

ZH_mea_tim={}
for JS_riv_tot2 in range(IS_riv_tot2):
     for JS_spl_cnt in range(IV_spl_cnt[JS_riv_tot2]):
          ZH_mea_tim[IM_mea_tim[JS_riv_tot2][JS_spl_cnt]]=[]
#Each meantime value now has a key in the Python dictionary

for JS_riv_tot2 in range(IS_riv_tot2):
     for JS_spl_cnt in range(IV_spl_cnt[JS_riv_tot2]):
          ZH_mea_tim[IM_mea_tim[JS_riv_tot2][JS_spl_cnt]]                      \
               .append(IV_riv_tot_id2[JS_riv_tot2])
#Each meantime value now has a list of all associated river IDs

ZV_mea_tim=ZH_mea_tim.keys()
ZV_mea_tim.sort()
#The list of meantime values sorted in chronological order
IS_mea_tim=len(ZV_mea_tim)

print('- The number of meantime values in subsample file is: '+str(IS_mea_tim))


#*******************************************************************************
#Reorganizing subsamples dictionary following river IDs for faster I/O
#*******************************************************************************
print('Reorganizing subsamples dictionary following river IDs for faster I/O')

for JS_mea_tim in range(IS_mea_tim):
     ZS_mea_tim=ZV_mea_tim[JS_mea_tim]
     IV_ids=ZH_mea_tim[ZS_mea_tim]
     IS_ids=len(IV_ids)
     IV_idx=[]
     #--------------------------------------------------------------------------
     #If river IDs are sorted following IV_riv_tot_id1
     #--------------------------------------------------------------------------
     for JS_ids in range(IS_ids):
          IV_idx.append(IH_hsh1[IV_ids[JS_ids]])
     IV_idx.sort()
     ZH_mea_tim[ZS_mea_tim]=[IV_riv_tot_id1[JS_idx] for JS_idx in IV_idx]
     #--------------------------------------------------------------------------
     #If river IDs are sorted following IV_riv_tot_id2
     #--------------------------------------------------------------------------
     #for JS_ids in range(IS_ids):
     #     IV_idx.append(IH_hsh2[IV_ids[JS_ids]])
     #IV_idx.sort()
     #ZH_mea_tim[ZS_mea_tim]=[IV_riv_tot_id2[JS_idx] for JS_idx in IV_idx]

print('- Done')


#*******************************************************************************
#Generating rrr_mod_nc3 based on rrr_mod_nc1 and rrr_spl_csv
#*******************************************************************************
print('Generating rrr_mod_nc3 based on rrr_mod_nc1 and rrr_spl_csv')

#-------------------------------------------------------------------------------
#Create netCDF file
#-------------------------------------------------------------------------------
print('- Create netCDF file')
f3 = netCDF4.Dataset(rrr_mod_nc3, "w", format="NETCDF3_CLASSIC")

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Global attributes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for YV_att in f1.ncattrs():
     f3.setncattr(YV_att,f1.getncattr(YV_att))

vsn=subprocess.Popen('../version.sh',stdout=subprocess.PIPE).communicate()
vsn=vsn[0]
vsn=vsn.rstrip()
#Version of RRR

if 'source' in f1.ncattrs():
     f3.source=f1.source+'; RRR: '+vsn+', file: '+os.path.basename(rrr_mod_nc1)
else:
     f3.source='RRR: '+vsn+', file: '+os.path.basename(rrr_mod_nc1)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Dimensions
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
time = f3.createDimension(YV_time, None)
rivid = f3.createDimension(YV_rivid, IS_riv_tot2)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Variables
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
rivid = f3.createVariable(YV_rivid,"i4",(YV_rivid,))

time = f3.createVariable(YV_time,"i4",(YV_time,))

if '_FillValue' in  f1.variables[YV_var].ncattrs(): 
     ZS_fill=f1.variables[YV_var]._FillValue
else:
     YV_var_type=f1.variables[YV_var].dtype.kind                               \
                +str(f1.variables[YV_var].dtype.itemsize)
     #This produces 'f4' for float32 which is needed to get default_fillvals
     ZS_fill=netCDF4.default_fillvals[YV_var_type]
     print(' . The fill value is: '+str(ZS_fill))
var = f3.createVariable(YV_var,"f4",(YV_time,YV_rivid,),fill_value=ZS_fill)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Variable attributes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for YV_att in f1.variables[YV_rivid].ncattrs():
     f3.variables[YV_rivid].setncattr(                                         \
                                YV_att,f1.variables[YV_rivid].getncattr(YV_att))

if YV_time in f1.variables:
     for YV_att in f1.variables[YV_time].ncattrs():
          f3.variables[YV_time].setncattr(                                     \
                                YV_att,f1.variables[YV_time].getncattr(YV_att))

for YV_att in f1.variables[YV_var].ncattrs():
     f3.variables[YV_var].setncattr(                                           \
                                YV_att,f1.variables[YV_var].getncattr(YV_att))

#-------------------------------------------------------------------------------
#Initialize netCDF variables
#-------------------------------------------------------------------------------
print('- Initialize netCDF variables')
rivid[:]=IV_riv_tot_id1
#If river IDs are sorted following IV_riv_tot_id1
#rivid[:]=IV_riv_tot_id2
##If river IDs are sorted following IV_riv_tot_id2

ZV_time3=ZV_time1
time[:]=ZV_time3
#Populate the times of the original netCDF file in the subsampled netCDF file, 
#or with those built from hardcoded values

IS_time3=IS_time1
for JS_time3 in range(IS_time3):
     var[JS_time3,:]=[ZS_fill]*IS_riv_tot2
#Initialize all variable values (Qout or V) that are being subsampled to NoData

#-------------------------------------------------------------------------------
#Populate netCDF variables
#-------------------------------------------------------------------------------
print('- Populate netCDF variables')

ZS_cyc=(ZV_time3[IS_time3-1]+ZS_TauR-ZV_time3[0])/ZS_cyc_tim
if ZS_cyc.is_integer():
     IS_cyc=ZS_cyc
else:
     IS_cyc=int(ZS_cyc)+1
#Total integer number of complete cycles needed to fully cover simulation
#(note that a value of 1 was added in the integer here to round up)

prg_bar=progressbar.ProgressBar(maxval=IS_cyc-1,                               \
        widgets=[progressbar.Bar('=', '[', ']'), ' ', progressbar.Percentage()])

#prg_bar.start()
for JS_cyc in range(IS_cyc):
     #Here we're looping on all complete cycles sequentially
     #prg_bar.update(JS_cyc)
     for JS_mea_tim in range(IS_mea_tim):
          #Here we're looping on mean times sequentially in increasing order
          ZS_mea_tim=ZV_mea_tim[JS_mea_tim]
          ZS_spl_tim=ZV_time3[0]+JS_cyc*ZS_cyc_tim+ZS_mea_tim
          if (ZS_spl_tim<=ZV_time3[IS_time3-1]+ZS_TauR):
               #Here we're copying the value for each of the sampled river IDs
               JS_time3=numpy.searchsorted(ZV_time1,ZS_spl_tim)-1
               IV_ids=ZH_mea_tim[ZS_mea_tim]
               IV_idx1=[IH_hsh1[IS_ids] for IS_ids in IV_ids]
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               IV_idx3=[IH_hsh1[IS_ids] for IS_ids in IV_ids]
               #If river IDs are sorted following IV_riv_tot_id1
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               #IV_idx3=[IH_hsh2[IS_ids] for IS_ids in IV_ids]
               ##If river IDs are sorted following IV_riv_tot_id2
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               var[JS_time3,IV_idx3]=f1.variables[YV_var][JS_time3,IV_idx1]
#prg_bar.finish()


#*******************************************************************************
#Close all netCDF files
#*******************************************************************************
print('Close all netCDF files')

f1.close()
#Not sure if that does anything
f3.close()
#Closing the new netCDF file allows populating all data 


#*******************************************************************************
#End
#*******************************************************************************
