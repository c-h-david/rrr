#!/usr/bin/env python3
#*******************************************************************************
#tst_cmp_n1d.py
#*******************************************************************************

#Purpose:
#Compare one unique 1-D variable within two netCDF files.
#Author:
#Cedric H. David, 2016-2022


#*******************************************************************************
#Prerequisites
#*******************************************************************************
import sys
import netCDF4
import math
import numpy


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_ncf_file1
# 2 - rrr_ncf_file2
# 3 - rrr_ncf_var
#(3)- relative tolerance 
#(4)- absolute tolerance 


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 4 or IS_arg > 6:
     print('ERROR - A minimum of 3 and a maximum of 5 arguments can be used')
     raise SystemExit(22) 

rrr_ncf_file1=sys.argv[1]
rrr_ncf_file2=sys.argv[2]
rrr_ncf_var=sys.argv[3]
if IS_arg > 4:
     ZS_rtol=float(sys.argv[4])
else:
     ZS_rtol=float(0)
if IS_arg > 5:
     ZS_atol=float(sys.argv[5])
else:
     ZS_atol=float(0)
     

#*******************************************************************************
#Print current variables
#*******************************************************************************
print('Comparing netCDF files')
print('1st netCDF file               :'+rrr_ncf_file1)
print('2nd netCDF file               :'+rrr_ncf_file2)
print('Name of variable              :'+rrr_ncf_var)
print('Relative tolerance            :'+str(ZS_rtol))
print('Absolute tolerance            :'+str(ZS_atol))
print('-------------------------------')


#*******************************************************************************
#Test if input files exist
#*******************************************************************************
try:
     with open(rrr_ncf_file1) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_ncf_file1)
     raise SystemExit(22) 

try:
     with open(rrr_ncf_file2) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_ncf_file2)
     raise SystemExit(22) 


#*******************************************************************************
#Read and compare netCDF files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Open files and get dimensions
#-------------------------------------------------------------------------------
f1 = netCDF4.Dataset(rrr_ncf_file1, "r")

if 'COMID' in f1.dimensions:
     IS_riv_tot1=len(f1.dimensions['COMID'])
elif 'rivid' in f1.dimensions:
     IS_riv_tot1=len(f1.dimensions['rivid'])
else:
     print('ERROR - Neither COMID nor rivid are dimensions in: '+rrr_ncf_file1) 
     raise SystemExit(99) 
     
if rrr_ncf_var not in f1.variables:
     print('ERROR - '+rrr_ncf_var+' is not a variables in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

f2 = netCDF4.Dataset(rrr_ncf_file2, "r")

if 'COMID' in f2.dimensions:
     IS_riv_tot2=len(f2.dimensions['COMID'])
elif 'rivid' in f2.dimensions:
     IS_riv_tot2=len(f2.dimensions['rivid'])
else:
     print('ERROR - Neither COMID nor rivid are dimensions in: '+rrr_ncf_file2) 
     raise SystemExit(99) 
     
if rrr_ncf_var not in f2.variables:
     print('ERROR - '+rrr_ncf_var+' is not a variables in: '+rrr_ncf_file2) 
     raise SystemExit(99) 

#-------------------------------------------------------------------------------
#Compare file sizes and variable names
#-------------------------------------------------------------------------------
if IS_riv_tot1==IS_riv_tot2:
     IS_riv_tot=IS_riv_tot1
     print('Common number of river reaches:'+str(IS_riv_tot))
else:
     print('ERROR - The number of river reaches differs: '                     \
           +str(IS_riv_tot1)+' <> '+str(IS_riv_tot2))
     raise SystemExit(99) 

print('-------------------------------')

#-------------------------------------------------------------------------------
#Compare rivid values if they exist in both files
#-------------------------------------------------------------------------------
if 'COMID' in f1.variables:
     IV_riv_tot1=f1.variables['COMID']
elif 'rivid' in f1.variables:
     IV_riv_tot1=f1.variables['rivid']

if 'COMID' in f2.variables:
     IV_riv_tot2=f2.variables['COMID']
elif 'rivid' in f2.variables:
     IV_riv_tot2=f2.variables['rivid']

if 'IV_riv_tot1' in locals() and 'IV_riv_tot2' in locals():
     #This makes sure that both variables actually exist before comparing them
     if numpy.array_equal(IV_riv_tot1[:],IV_riv_tot2[:]):
          print('The rivids are the same')
     else:
          print('ERROR: The rivids differ')
          raise SystemExit(99) 
     print('-------------------------------')

#-------------------------------------------------------------------------------
#Compute differences 
#-------------------------------------------------------------------------------

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#initializing
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
ZS_rdif=0
ZS_adif=0

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Reading values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
ZV_var_1=f1.variables[rrr_ncf_var][:]
ZV_var_2=f2.variables[rrr_ncf_var][:]

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Comparing difference values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Tried computations with regular Python lists but this makes is very slow.
#Also tried using map(operator.sub,V,W) or [x-y for x,y in zip(V,W)]
#But this still results in slow computations.
#The best performance seems to be with Numpy.
ZV_dvar_abs=numpy.absolute(ZV_var_1-ZV_var_2)

ZS_adif=numpy.max(ZV_dvar_abs)

ZS_rdif= math.sqrt( numpy.sum(ZV_dvar_abs*ZV_dvar_abs)                         \
                   /numpy.sum(ZV_var_1*ZV_var_1))


#*******************************************************************************
#Print difference values and comparing values to tolerance
#*******************************************************************************
print('Max relative difference       :'+'{0:.2e}'.format(ZS_rdif))
print('Max absolute difference       :'+'{0:.2e}'.format(ZS_adif))
print('-------------------------------')

if ZS_rdif > ZS_rtol:
     print('Unacceptable rel. difference!!!')
     print('-------------------------------')
     raise SystemExit(99) 

if ZS_adif > ZS_atol:
     print('Unacceptable abs. difference!!!')
     print('-------------------------------')
     raise SystemExit(99) 

print('netCDF files similar!!!')
print('-------------------------------')


#*******************************************************************************
#End
#*******************************************************************************
