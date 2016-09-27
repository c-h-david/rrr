#!/usr/bin/python
#*******************************************************************************
#rrr_lsm_tot_add_avg.py
#*******************************************************************************

#Purpose:
#Given a file with time-varying external inflow (in m^3) into the river network,
#a percent value, and the name of a new netCDF file, this program computes the 
#average value of external inflow for each river reach, multiplies by the 
#desired percentage, and creates a copy of the previous file with the addition 
#of the new partial values. If CF metadata are present, they are all copied, 
#except for the long_name to which "estimate of error for " is appended.
#Author:
#Cedric H. David, 2016-2016


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import shutil
import netCDF4


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_file1
# 2 - ZS_avg_perc
# 3 - rrr_lsm_file2


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments must be used')
     raise SystemExit(22) 

rrr_lsm_file1=sys.argv[1]
ZS_avg_perc=float(sys.argv[2])
rrr_lsm_file2=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_file1)
print('- '+str(ZS_avg_perc))
print('- '+rrr_lsm_file2)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_lsm_file1) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_file1)
     raise SystemExit(22) 


#*******************************************************************************
#Reading netCDF file
#*******************************************************************************
print('Reading netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Open netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f1 = netCDF4.Dataset(rrr_lsm_file1, 'r')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get dimension sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if 'COMID' in f1.dimensions:
     YV_rivid='COMID'
elif 'rivid' in f1.dimensions:
     YV_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_lsm_file1)
     raise SystemExit(22) 

IS_riv_tot=len(f1.dimensions[YV_rivid])
print('- The number of river reaches is: '+str(IS_riv_tot))

if 'Time' in f1.dimensions:
     YV_time='Time'
elif 'time' in f1.dimensions:
     YV_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_lsm_file1)
     raise SystemExit(22) 

IS_lsm_time=len(f1.dimensions[YV_time])
print('- The number of time steps is: '+str(IS_lsm_time))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get variables
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if 'm3_riv' in f1.variables:
     YV_var='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_lsm_file1)
     raise SystemExit(22) 

if '_FillValue' in  f1.variables[YV_var].ncattrs(): 
     ZS_fill=f1.variables[YV_var]._FillValue
     print('- The fill value is: '+str(ZS_fill))
else:
     ZS_fill=None

if 'long_name' in  f1.variables[YV_var].ncattrs(): 
     YV_long_name=f1.variables[YV_var].long_name
else:
     YV_long_name=None

if 'units' in  f1.variables[YV_var].ncattrs(): 
     YV_units=f1.variables[YV_var].units
else:
     YV_units=None

if 'coordinates' in  f1.variables[YV_var].ncattrs(): 
     YV_coordinates=f1.variables[YV_var].coordinates
else:
     YV_coordinates=None

if 'grid_mapping' in  f1.variables[YV_var].ncattrs(): 
     YV_grid_mapping=f1.variables[YV_var].grid_mapping
else:
     YV_grid_mapping=None

if 'cell_methods' in  f1.variables[YV_var].ncattrs(): 
     YV_cell_methods=f1.variables[YV_var].cell_methods
else:
     YV_cell_methods=None

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Computing average
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Computing average')

ZV_vol_tmp=[0]*IS_riv_tot
ZV_vol_avg=[0]*IS_riv_tot
for JS_lsm_time in range(IS_lsm_time):
     ZV_vol_tmp=f1.variables[YV_var][JS_lsm_time,:]
     ZV_vol_avg=ZV_vol_avg+ZV_vol_tmp

ZV_vol_avg=ZV_vol_avg/IS_lsm_time
ZV_vol_avg=ZV_vol_avg*ZS_avg_perc/100

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Close file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f1.close()


#*******************************************************************************
#Copying netCDF file
#*******************************************************************************
print('Copying netCDF file')

shutil.copyfile(rrr_lsm_file1,rrr_lsm_file2)

print('- Done')


#*******************************************************************************
#Appending new netCDF file
#*******************************************************************************
print('Appending netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Open netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f2 = netCDF4.Dataset(rrr_lsm_file2, 'a')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Create new variable
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Creating new variable')
dm3_riv = f2.createVariable('dm3_riv',"f4",(YV_rivid,),fill_value=ZS_fill)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Add variable attributes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Adding variable attributes')
attdict={}

if YV_long_name != None: attdict['long_name']='estimate of error for '         \
                                             +YV_long_name
if YV_units != None: attdict['units']=YV_units
if YV_coordinates != None: attdict['coordinates']=YV_coordinates
if YV_grid_mapping != None: attdict['grid_mapping']=YV_grid_mapping
if YV_cell_methods != None: attdict['cell_methods']=YV_cell_methods

dm3_riv.setncatts(attdict)
#Setting multiple attributes at once helps decrease the writing time a lot.
#It looks like otherwise the file is copied over and over each time otherwise.
#This limitation may not exist if netCDF4 is used instead of netCDF3.

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Populate new variable
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Populating new variable')
dm3_riv[:]=ZV_vol_avg

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Close file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f2.close()


#*******************************************************************************
#End
#*******************************************************************************
