#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_uqs.py
#*******************************************************************************

#Purpose:
#Given a shapefile with unique integer identifiers for observing stations and 
#unique station codes, a netCDF file containing modeled quantities (for many 
#days/many reaches), this program uses the uncertainty quantification produced
#by RAPID to create a file with simple error statistics: modeled average, RMSE,
#bias, and standard error. 
#Note that fields for observed average, NSE and correlation are also produced
#for consistency with other RRR programs, though they contain '-9999.0'.
#Author:
#Cedric H. David, 2011-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import netCDF4
import numpy
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_out_ncf
# 3 - rrr_uqs_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_out_ncf=sys.argv[2]
rrr_uqs_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_out_ncf)
print('- '+rrr_uqs_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22) 

try:
     with open(rrr_out_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open'+rrr_out_ncf)
     raise SystemExit(22) 


#*******************************************************************************
#Read rrr_obs_shp
#*******************************************************************************
print('Reading rrr_obs_shp')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')

IS_obs_tot=len(rrr_obs_lay)
print('- Number of river reaches in rrr_obs_shp: '+str(IS_obs_tot))

if 'COMID_1' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID_1'
elif 'FLComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='FLComID'
elif 'ARCID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ARCID'
elif 'ComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ComID'
else:
     print('ERROR - COMID_1, FLComID, ARCID, or ComID do not exist in '        \
           +rrr_obs_shp)
     raise SystemExit(22) 
if 'SOURCE_FEA' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='SOURCE_FEA'
elif 'Code' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='Code'
elif 'ReachCode' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='ReachCode'
else:
     print('ERROR - SOURCE_FEA, Code, or ReachCode do not exist in '           \
           +rrr_obs_shp)
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

if 'Qout_err' in f.variables:
     YS_uq_name='Qout_err'
elif 'V_err' in f.variables:
     YS_uq_name='V_err'
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
     ZV_riv_bas_bQ=f.variables[YS_uq_name][0,:]
     ZV_riv_bas_sQ=f.variables[YS_uq_name][1,:]
     ZV_riv_bas_rQ=f.variables[YS_uq_name][2,:]
else:
     print(' . UQ estimates NOT available')
     raise SystemExit(22) 


#*******************************************************************************
#Read netCDF file dynamic data
#*******************************************************************************
print('Reading netCDF file dynamic data')

ZV_riv_bas_aQ=numpy.zeros(IS_riv_bas)
for JS_R in range(IS_R):
     ZV_riv_bas_aQ=ZV_riv_bas_aQ+f.variables[YS_out_name][JS_R]
ZV_riv_bas_aQ=ZV_riv_bas_aQ/IS_R


#*******************************************************************************
#Make hash table
#*******************************************************************************
print('- Making hash table')
IM_hsh={}
for JS_riv_bas in range(IS_riv_bas):
     IM_hsh[IV_riv_bas_id[JS_riv_bas]]=JS_riv_bas


#*******************************************************************************
#Compute flow statistics
#*******************************************************************************
print('- Computing flow statistics')

with open(rrr_uqs_csv, 'wb') as csvfile:
     #'wb' here ensures creation of a new file instead of appending.
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow(['rivid','Qobsbar','Qmodbar','RMSE','Bias',            \
                         'STDE','Nash','Correl']) 
     for JS_obs_tot in range(IS_obs_tot):
          IS_riv_bas_id=IV_obs_tot_id_srt[JS_obs_tot]
          if IS_riv_bas_id in IM_hsh:
             csvwriter.writerow([IS_riv_bas_id,                                \
                                 round(-9999,2),                               \
                                 round(ZV_riv_bas_aQ[IM_hsh[IS_riv_bas_id]],2),\
                                 round(ZV_riv_bas_rQ[IM_hsh[IS_riv_bas_id]],2),\
                                 round(ZV_riv_bas_bQ[IM_hsh[IS_riv_bas_id]],2),\
                                 round(ZV_riv_bas_sQ[IM_hsh[IS_riv_bas_id]],2),\
                                 round(-9999,2),                               \
                                 round(-9999,2),                               \
                                ])


#*******************************************************************************
#End
#*******************************************************************************
