#!/usr/bin/env python3
#*******************************************************************************
#rrr_cpl_riv_lsm_err.py
#*******************************************************************************

#Purpose:
#Given a netCDF file with estimates of time-varying external inflow (in m^3)
#into the river network, a CSV file with estimates of errors in the inflow (i.e.
#bias, standard error, and covariances), along with two multiplying factors (one
#for bias and one for square root of variance/covariance, this program creates a
#netCDF file that is a copy of the initial netCDF that also includes estimates
#of errors, which is to be used for uncertainty quantification and/or data
#assimilation.
#Author:
#Cedric H. David, 2018-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import numpy
import csv
import shutil


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_mod_ncf
# 2 - rrr_bvc_csv
# 3 - ZS_scl_bia
# 4 - ZS_scl_sde
# 5 - rrr_err_ncf


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments must be used')
     raise SystemExit(22) 

rrr_mod_ncf=sys.argv[1]
rrr_bvc_csv=sys.argv[2]
ZS_scl_bia=float(sys.argv[3])
ZS_scl_sde=float(sys.argv[4])
rrr_err_ncf=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_mod_ncf)
print('- '+rrr_bvc_csv)
print('- '+str(ZS_scl_bia))
print('- '+str(ZS_scl_sde))
print('- '+rrr_err_ncf)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_mod_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_mod_ncf)
     raise SystemExit(22)

try:
     with open(rrr_bvc_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_bvc_csv)
     raise SystemExit(22)


#*******************************************************************************
#Reading netCDF file
#*******************************************************************************
print('Reading netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Opening netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f1 = netCDF4.Dataset(rrr_mod_ncf, 'r')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Getting dimension sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if 'COMID' in f1.dimensions:
     YS_rivid='COMID'
elif 'rivid' in f1.dimensions:
     YS_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

IS_riv_tot1=len(f1.dimensions[YS_rivid])
print('- The number of river reaches is: '+str(IS_riv_tot1))

if 'Time' in f1.dimensions:
     YS_time='Time'
elif 'time' in f1.dimensions:
     YS_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

IS_lsm_time=len(f1.dimensions[YS_time])
print('- The number of time steps is: '+str(IS_lsm_time))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Getting variables
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if YS_rivid in f1.variables:
     IV_riv_tot_id1=list(f1.variables[YS_rivid][:])
else:
     print('ERROR - '+YS_rivid+' does not exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

if 'm3_riv' in f1.variables:
     YS_var='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

if '_FillValue' in  f1.variables[YS_var].ncattrs(): 
     ZS_fill=f1.variables[YS_var]._FillValue
     print('- The fill value is: '+str(ZS_fill))
else:
     ZS_fill=None

if 'long_name' in  f1.variables[YS_var].ncattrs(): 
     YS_long_name=f1.variables[YS_var].long_name
else:
     YS_long_name=None

if 'units' in  f1.variables[YS_var].ncattrs(): 
     YS_units=f1.variables[YS_var].units
else:
     YS_units=None

if 'coordinates' in  f1.variables[YS_var].ncattrs(): 
     YS_coordinates=f1.variables[YS_var].coordinates
else:
     YS_coordinates=None

if 'grid_mapping' in  f1.variables[YS_var].ncattrs(): 
     YS_grid_mapping=f1.variables[YS_var].grid_mapping
else:
     YS_grid_mapping=None

if 'cell_methods' in  f1.variables[YS_var].ncattrs(): 
     YS_cell_methods=f1.variables[YS_var].cell_methods
else:
     YS_cell_methods=None

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Closing file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f1.close()


#*******************************************************************************
#Reading CSV file
#*******************************************************************************
print('Reading CSV file')

with open(rrr_bvc_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     YV_headers=next(csvreader)
     IS_riv_tot2=sum([1 for row in csvreader])
     #Counting the number of lines here allows for memory allocation below
     IS_riv_rad=len(YV_headers)-4
     #Same for the number of downstream covariances

print('- Number of river reaches in rrr_bvc_csv: '+str(IS_riv_tot2))
print('- Number of downstream covariances: '+str(IS_riv_rad))

IV_riv_tot_id2=numpy.zeros(IS_riv_tot2)
ZV_riv_tot_bia=numpy.zeros(IS_riv_tot2)
ZV_riv_tot_sde=numpy.zeros(IS_riv_tot2)
ZV_riv_tot_cva=numpy.zeros(IS_riv_tot2)
ZM_riv_tot_cvd=numpy.zeros((IS_riv_tot2,IS_riv_rad))

with open(rrr_bvc_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     YV_headers=next(csvreader)
     JS_riv_tot=0
     for row in csvreader:
          IV_riv_tot_id2[JS_riv_tot]=row[0]
          ZV_riv_tot_bia[JS_riv_tot]=row[1]
          ZV_riv_tot_sde[JS_riv_tot]=row[2]
          ZV_riv_tot_cva[JS_riv_tot]=row[3]
          ZM_riv_tot_cvd[JS_riv_tot]=row[4:]
          JS_riv_tot=JS_riv_tot+1


#*******************************************************************************
#Scaling biases and variances/covariances
#*******************************************************************************
print('Scaling biases and variances/covariances')

ZV_riv_tot_bia=ZV_riv_tot_bia*ZS_scl_bia
ZV_riv_tot_sde=ZV_riv_tot_sde*ZS_scl_sde
ZV_riv_tot_cva=ZV_riv_tot_cva*ZS_scl_sde**2
ZM_riv_tot_cvd=ZM_riv_tot_cvd*ZS_scl_sde**2

print('- Done')


#*******************************************************************************
#Ensuring consistency in units
#*******************************************************************************
print('Ensuring consistency in units')

ZV_riv_tot_bia=numpy.sign(ZV_riv_tot_bia)*numpy.square(ZV_riv_tot_bia)
ZV_riv_tot_sde=numpy.square(ZV_riv_tot_sde)

print('- Done')


#*******************************************************************************
#Checking consistency
#*******************************************************************************
print('Checking consistency')

if IS_riv_tot1==IS_riv_tot2: 
     print('- Common number of river reaches: '+str(IS_riv_tot1))
else: 
     print('ERROR - The number of river reaches differ')
     raise SystemExit(22) 

if (IV_riv_tot_id1==IV_riv_tot_id2).all(): 
     print('- The river reach IDs are the same')
else: 
     print('ERROR - The river reach IDs differ')
     raise SystemExit(22) 
     

#*******************************************************************************
#Copying netCDF file
#*******************************************************************************
print('Copying netCDF file')

shutil.copyfile(rrr_mod_ncf,rrr_err_ncf)

print('- Done')


#*******************************************************************************
#Appending new netCDF file
#*******************************************************************************
print('Appending netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Opening netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f2 = netCDF4.Dataset(rrr_err_ncf, 'a')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Creating new dimension
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Creating new dimension')
nerr=f2.createDimension('nerr', size=IS_riv_rad+3)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Creating new variable
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Creating new variable')
m3_riv_err = f2.createVariable('m3_riv_err',"f4",('nerr',YS_rivid,))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Add variable attributes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Adding variable attributes')
attdict={}

if YS_long_name != None: attdict['long_name']='estimate of error for '         \
                                             +YS_long_name
if YS_units != None: attdict['units']='m6'
if YS_coordinates != None: attdict['coordinates']=YS_coordinates
if YS_grid_mapping != None: attdict['grid_mapping']=YS_grid_mapping

m3_riv_err.setncatts(attdict)
#Setting multiple attributes at once helps decrease the writing time a lot.
#It looks like otherwise the file is copied over and over each time otherwise.
#This limitation may not exist if netCDF4 is used instead of netCDF3.

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Populate new variable
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
print('- Populating new variable')
m3_riv_err[0,:]=ZV_riv_tot_bia
m3_riv_err[1,:]=ZV_riv_tot_sde
m3_riv_err[2,:]=ZV_riv_tot_cva
for JS_riv_rad in range(IS_riv_rad):
     m3_riv_err[3+JS_riv_rad,:]=ZM_riv_tot_cvd[:,JS_riv_rad]

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Close file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f2.close()


#*******************************************************************************
#End
#*******************************************************************************
