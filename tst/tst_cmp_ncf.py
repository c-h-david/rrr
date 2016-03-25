#!/usr/bin/python
#*******************************************************************************
#tst_cmp_ncf.py
#*******************************************************************************

#Purpose:
#Compare netCDF files.
#Author:
#Cedric H. David, 2016-2016


#*******************************************************************************
#Prerequisites
#*******************************************************************************
import sys
import netCDF4
import math


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_ncf_file1
# 2 - rrr_ncf_file2
#(3)- relative tolerance 
#(4)- absolute tolerance 


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 3 or IS_arg > 5:
     print('ERROR - A minimum of 2 and a maximum of 4 arguments can be used')
     raise SystemExit(22) 

rrr_ncf_file1=sys.argv[1]
rrr_ncf_file2=sys.argv[2]
if IS_arg > 3:
     ZS_rtol=float(sys.argv[3])
else:
     ZS_rtol=float(0)
if IS_arg > 4:
     ZS_atol=float(sys.argv[4])
else:
     ZS_atol=float(0)
     

#*******************************************************************************
#Print current variables
#*******************************************************************************
print('Comparing netCDF files')
print('1st netCDF file               :'+rrr_ncf_file1)
print('2nd netCDF file               :'+rrr_ncf_file2)
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
     
if 'Time' in f1.dimensions:
     IS_time1=len(f1.dimensions['Time'])
elif 'time' in f1.dimensions:
     IS_time1=len(f1.dimensions['time'])
else:
     print('ERROR - Neither Time nor time are dimensions in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

if 'm3_riv' in f1.variables:
     rrr_ncf_var1='m3_riv'
elif 'Qout' in f1.variables:
     rrr_ncf_var1='Qout'
elif 'V' in f1.variables:
     rrr_ncf_var1='V'
else:
     print('ERROR - m3_riv, Qout, or V are not variables in: '+rrr_ncf_file1) 
     raise SystemExit(99) 

f2 = netCDF4.Dataset(rrr_ncf_file2, "r")

if 'COMID' in f2.dimensions:
     IS_riv_tot2=len(f2.dimensions['COMID'])
elif 'rivid' in f2.dimensions:
     IS_riv_tot2=len(f2.dimensions['rivid'])
else:
     print('ERROR - Neither COMID nor rivid are dimensions in: '+rrr_ncf_file2) 
     raise SystemExit(99) 
     
if 'Time' in f2.dimensions:
     IS_time2=len(f2.dimensions['Time'])
elif 'time' in f2.dimensions:
     IS_time2=len(f2.dimensions['time'])
else:
     print('ERROR - Neither Time nor time are dimensions in: '+rrr_ncf_file2) 
     raise SystemExit(99) 
     
if 'm3_riv' in f2.variables:
     rrr_ncf_var2='m3_riv'
elif 'Qout' in f2.variables:
     rrr_ncf_var2='Qout'
elif 'V' in f2.variables:
     rrr_ncf_var2='V'
else:
     print('ERROR - m3_riv, Qout, or V are not variables in: '+rrr_ncf_file2) 
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

if IS_time1==IS_time2:
     IS_time=IS_time1
     print('Common number of time steps   :'+str(IS_time))
else:
     print('ERROR - The number of time steps differs: '                        \
           +str(IS_time1)+' <> '+str(IS_time2))
     raise SystemExit(99) 

if rrr_ncf_var1==rrr_ncf_var2:
     rrr_ncf_var=rrr_ncf_var1
     print('Common variable name          :'+rrr_ncf_var)
else:
     print('ERROR - The variables differ: '                                    \
           +rrr_ncf_var1+' <> '+rrr_ncf_var1)
     raise SystemExit(99) 

print('-------------------------------')

#-------------------------------------------------------------------------------
#Compute differences 
#-------------------------------------------------------------------------------
ZS_rdif_max=0
ZS_adif_max=0

for JS_time in range(IS_time):
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#initializing
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZV_Vol_1=[0]*IS_riv_tot
     ZV_Vol_2=[0]*IS_riv_tot
     ZV_dVol_abs=[0]*IS_riv_tot
     ZS_rdif=0
     ZS_adif=0

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#initializing
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZV_Vol_1=f1.variables[rrr_ncf_var][JS_time,:]
     ZV_Vol_2=f2.variables[rrr_ncf_var][JS_time,:]

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Comparing difference values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Also tried using map(operator.sub,V,W) or [x-y for x,y in zip(V,W)]
     #But this still results in slow computations
     for JS_riv_tot in range(IS_riv_tot):
          ZV_dVol_abs[JS_riv_tot]=abs(ZV_Vol_1[JS_riv_tot]-ZV_Vol_2[JS_riv_tot])
          ZS_adif=ZV_dVol_abs[JS_riv_tot]
          ZS_adif_max=max(ZS_adif,ZS_adif_max)

     ZS_rdif=math.sqrt(                                                        \
                     sum([dVol*dVol for dVol in ZV_dVol_abs])                  \
                    /sum(vol*vol for vol in ZV_Vol_1)                          \
                    )
     ZS_rdif_max=max(ZS_rdif,ZS_rdif_max)


#*******************************************************************************
#Print difference values and comparing values to tolerance
#*******************************************************************************
print('Max relative difference       :'+str(ZS_rdif_max))
print('Max absolute difference       :'+str(ZS_adif_max))
print('-------------------------------')

if ZS_rdif_max > ZS_rtol:
     print('Unacceptable rel. difference!!!')
     print('-------------------------------')
     raise SystemExit(99) 

if ZS_adif_max > ZS_atol:
     print('Unacceptable abs. difference!!!')
     print('-------------------------------')
     raise SystemExit(99) 

print('netCDF files similar!!!')
print('-------------------------------')


#*******************************************************************************
#End
#*******************************************************************************
