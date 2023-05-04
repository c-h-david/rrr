#!/usr/bin/env python3
#*******************************************************************************
#rrr_cpl_riv_lsm_ens.py
#*******************************************************************************

#Purpose:
#Given three files with time-varying external inflow (in m^3) into the river 
#network and the name of a new netCDF file, this program computes the ensemble
#average value of external inflow for each river reach into the new file.
#Author:
#Cedric H. David, 2018-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import shutil
import netCDF4
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_in1
# 2 - rrr_lsm_in2
# 3 - rrr_lsm_in3
# 4 - rrr_lsm_out


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments must be used')
     raise SystemExit(22) 

rrr_lsm_in1=sys.argv[1]
rrr_lsm_in2=sys.argv[2]
rrr_lsm_in3=sys.argv[3]
rrr_lsm_out=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_in1)
print('- '+rrr_lsm_in2)
print('- '+rrr_lsm_in3)
print('- '+rrr_lsm_out)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_lsm_in1) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_in1)
     raise SystemExit(22) 

try:
     with open(rrr_lsm_in2) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_in2)
     raise SystemExit(22) 

try:
     with open(rrr_lsm_in3) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_in3)
     raise SystemExit(22) 


#*******************************************************************************
#Reading netCDF file 1
#*******************************************************************************
print('Reading netCDF file 1')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f1 = netCDF4.Dataset(rrr_lsm_in1, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'COMID' in f1.dimensions:
     YS_rivid1='COMID'
elif 'rivid' in f1.dimensions:
     YS_rivid1='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

IS_riv_tot1=len(f1.dimensions[YS_rivid1])
print('- The number of river reaches is: '+str(IS_riv_tot1))

if 'Time' in f1.dimensions:
     YS_time1='Time'
elif 'time' in f1.dimensions:
     YS_time1='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

IS_time1=len(f1.dimensions[YS_time1])
print('- The number of time steps is: '+str(IS_time1))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f1.variables:
     YS_var1='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_lsm_in1)
     raise SystemExit(22) 

IV_riv_tot_id1=f1.variables[YS_rivid1][:]
ZV_time1=f1.variables[YS_time1][:]

if '_FillValue' in  f1.variables[YS_var1].ncattrs(): 
     ZS_fill1=f1.variables[YS_var1]._FillValue
     print('- The fill value is: '+str(ZS_fill1))
else:
     ZS_fill1=None

if 'long_name' in  f1.variables[YS_var1].ncattrs(): 
     YS_long_name1=f1.variables[YS_var1].long_name
else:
     YS_long_name1=None

if 'units' in  f1.variables[YS_var1].ncattrs(): 
     YS_units1=f1.variables[YS_var1].units
else:
     YS_units1=None

if 'coordinates' in  f1.variables[YS_var1].ncattrs(): 
     YS_coordinates1=f1.variables[YS_var1].coordinates
else:
     YS_coordinates1=None

if 'grid_mapping' in  f1.variables[YS_var1].ncattrs(): 
     YS_grid_mapping1=f1.variables[YS_var1].grid_mapping
else:
     YS_grid_mapping1=None

if 'cell_methods' in  f1.variables[YS_var1].ncattrs(): 
     YS_cell_methods1=f1.variables[YS_var1].cell_methods
else:
     YS_cell_methods1=None


#*******************************************************************************
#Reading netCDF file 2
#*******************************************************************************
print('Reading netCDF file 2')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f2 = netCDF4.Dataset(rrr_lsm_in2, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'COMID' in f2.dimensions:
     YS_rivid2='COMID'
elif 'rivid' in f2.dimensions:
     YS_rivid2='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

IS_riv_tot2=len(f2.dimensions[YS_rivid2])
print('- The number of river reaches is: '+str(IS_riv_tot2))

if 'Time' in f2.dimensions:
     YS_time2='Time'
elif 'time' in f2.dimensions:
     YS_time2='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

IS_time2=len(f2.dimensions[YS_time2])
print('- The number of time steps is: '+str(IS_time2))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f2.variables:
     YS_var2='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_lsm_in2)
     raise SystemExit(22) 

IV_riv_tot_id2=f2.variables[YS_rivid2][:]
ZV_time2=f2.variables[YS_time2][:]

if '_FillValue' in  f2.variables[YS_var2].ncattrs(): 
     ZS_fill2=f2.variables[YS_var2]._FillValue
     print('- The fill value is: '+str(ZS_fill2))
else:
     ZS_fill2=None

if 'long_name' in  f2.variables[YS_var2].ncattrs(): 
     YS_long_name2=f2.variables[YS_var2].long_name
else:
     YS_long_name2=None

if 'units' in  f2.variables[YS_var2].ncattrs(): 
     YS_units2=f2.variables[YS_var2].units
else:
     YS_units2=None

if 'coordinates' in  f2.variables[YS_var2].ncattrs(): 
     YS_coordinates2=f2.variables[YS_var2].coordinates
else:
     YS_coordinates2=None

if 'grid_mapping' in  f2.variables[YS_var2].ncattrs(): 
     YS_grid_mapping2=f2.variables[YS_var2].grid_mapping
else:
     YS_grid_mapping2=None

if 'cell_methods' in  f2.variables[YS_var2].ncattrs(): 
     YS_cell_methods2=f2.variables[YS_var2].cell_methods
else:
     YS_cell_methods2=None


#*******************************************************************************
#Reading netCDF file 3
#*******************************************************************************
print('Reading netCDF file 3')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f3 = netCDF4.Dataset(rrr_lsm_in3, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'COMID' in f3.dimensions:
     YS_rivid3='COMID'
elif 'rivid' in f3.dimensions:
     YS_rivid3='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

IS_riv_tot3=len(f3.dimensions[YS_rivid3])
print('- The number of river reaches is: '+str(IS_riv_tot3))

if 'Time' in f3.dimensions:
     YS_time3='Time'
elif 'time' in f3.dimensions:
     YS_time3='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

IS_time3=len(f3.dimensions[YS_time3])
print('- The number of time steps is: '+str(IS_time3))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f3.variables:
     YS_var3='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_lsm_in3)
     raise SystemExit(22) 

IV_riv_tot_id3=f3.variables[YS_rivid3][:]
ZV_time3=f3.variables[YS_time3][:]

if '_FillValue' in  f3.variables[YS_var3].ncattrs(): 
     ZS_fill3=f3.variables[YS_var3]._FillValue
     print('- The fill value is: '+str(ZS_fill3))
else:
     ZS_fill3=None

if 'long_name' in  f3.variables[YS_var3].ncattrs(): 
     YS_long_name3=f3.variables[YS_var3].long_name
else:
     YS_long_name3=None

if 'units' in  f3.variables[YS_var3].ncattrs(): 
     YS_units3=f3.variables[YS_var3].units
else:
     YS_units3=None

if 'coordinates' in  f3.variables[YS_var3].ncattrs(): 
     YS_coordinates3=f3.variables[YS_var3].coordinates
else:
     YS_coordinates3=None

if 'grid_mapping' in  f3.variables[YS_var3].ncattrs(): 
     YS_grid_mapping3=f3.variables[YS_var3].grid_mapping
else:
     YS_grid_mapping3=None

if 'cell_methods' in  f3.variables[YS_var3].ncattrs(): 
     YS_cell_methods3=f3.variables[YS_var3].cell_methods
else:
     YS_cell_methods3=None


#*******************************************************************************
#Check consistency
#*******************************************************************************
print('Check consistency')

if IS_riv_tot1==IS_riv_tot2 and IS_riv_tot1==IS_riv_tot3: 
     IS_riv_tot=IS_riv_tot1
     print('- Common number of river reaches: '+str(IS_riv_tot))
else: 
     print('ERROR - The number of river reaches differ')
     raise SystemExit(22) 
     
if IS_time1==IS_time2 and IS_time1==IS_time3: 
     IS_time=IS_time1
     print('- Common number of time steps: '+str(IS_time))
else: 
     print('ERROR - The number of time steps differ')
     raise SystemExit(22) 
     
if (IV_riv_tot_id1==IV_riv_tot_id2).all() and                                  \
   (IV_riv_tot_id1==IV_riv_tot_id3).all(): 
     IV_riv_tot_id=IV_riv_tot_id1
     print('- The river reach IDs are the same')
else: 
     print('ERROR - The river reach IDs differ')
     raise SystemExit(22) 
     
if (ZV_time1==ZV_time2).all() and                                  \
   (ZV_time1==ZV_time3).all(): 
     ZV_time=ZV_time1
     print('- The time variables are the same')
else: 
     print('ERROR - The time variables differ')
     raise SystemExit(22) 
     

#*******************************************************************************
#Copying netCDF file
#*******************************************************************************
print('Copying netCDF file')

shutil.copyfile(rrr_lsm_in1,rrr_lsm_out)

print('- Done')


#*******************************************************************************
#Populating netCDF file with ensemble averages
#*******************************************************************************
print('Populating netCDF file with ensemble averages')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f4 = netCDF4.Dataset(rrr_lsm_out, 'a')

ZV_ens=f4.variables[YS_var1]

#-------------------------------------------------------------------------------
#Computing ensemble average
#-------------------------------------------------------------------------------
print('- Computing ensemble average')

ZV_vol_out=numpy.empty(IS_riv_tot)
ZV_vol_av1=numpy.empty(IS_riv_tot)
ZV_vol_av2=numpy.empty(IS_riv_tot)
ZV_vol_av3=numpy.empty(IS_riv_tot)
ZV_vol_avt=numpy.empty(IS_riv_tot)

for JS_time in range(IS_time):
     ZV_vol_in1=f1.variables[YS_var1][JS_time,:]
     ZV_vol_in2=f2.variables[YS_var2][JS_time,:]
     ZV_vol_in3=f3.variables[YS_var3][JS_time,:]
     ZV_vol_out=(ZV_vol_in1+ZV_vol_in2+ZV_vol_in3)/3

     ZV_vol_av1=ZV_vol_av1+ZV_vol_in1
     ZV_vol_av2=ZV_vol_av2+ZV_vol_in2
     ZV_vol_av3=ZV_vol_av3+ZV_vol_in3
     ZV_vol_avt=ZV_vol_avt+ZV_vol_out

     ZV_ens[JS_time,:]=ZV_vol_out

ZV_vol_av1=ZV_vol_av1/IS_time
ZV_vol_av2=ZV_vol_av2/IS_time
ZV_vol_av3=ZV_vol_av3/IS_time
ZV_vol_avt=ZV_vol_avt/IS_time

#-------------------------------------------------------------------------------
#Close netCDF files
#-------------------------------------------------------------------------------
f1.close()
f2.close()
f3.close()
f4.close()


#*******************************************************************************
#Printing some diagnostic quantities
#*******************************************************************************
print('- Printing some diagnostic quantities')

print(ZV_vol_av1.mean())
print(ZV_vol_av2.mean())
print(ZV_vol_av3.mean())
print(ZV_vol_avt.mean())


#*******************************************************************************
#End
#*******************************************************************************
