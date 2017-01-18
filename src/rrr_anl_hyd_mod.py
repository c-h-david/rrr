#!/usr/bin/python
#*******************************************************************************
#rrr_anl_hyd_mod.py
#*******************************************************************************

#Purpose:
#Given a netCDF file containing modeled quantities (for many days/many reaches), 
#a csv file containing the unique identifiers corresponding to each reach where
#hydrographs are desired, and (optionally) a number of consecutive values to be 
#averaged together; this program produces a set of csv files in which the 
#(averaged) time series of modeled quantities are stored.   
#Author:
#Cedric H. David, 2011-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import csv
import netCDF4


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_out_ncf
# 2 - rrr_obs_csv
# 3 - rrr_hyd_dir
#(4)- IS_avg


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 4 or IS_arg > 5:
     print('ERROR - A minimum of 3 and a maximum of 4 arguments can be used')
     raise SystemExit(22) 

rrr_out_ncf=sys.argv[1]
rrr_obs_csv=sys.argv[2]
rrr_hyd_dir=sys.argv[3]
if IS_arg==5:
     IS_avg=int(sys.argv[4])
else:
     IS_avg=1


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_out_ncf)
print('- '+rrr_obs_csv)
print('- '+rrr_hyd_dir)
print('- '+str(IS_avg))


#*******************************************************************************
#Check if files and directory exist 
#*******************************************************************************
try:
     with open(rrr_out_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_out_ncf)
     raise SystemExit(22) 

try:
     with open(rrr_obs_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_csv)
     raise SystemExit(22) 

if not os.path.isdir(rrr_hyd_dir):
     os.mkdir(rrr_hyd_dir)


#*******************************************************************************
#Read rrr_obs_csv
#*******************************************************************************
print('Reading rrr_obs_csv')
IV_obs_tot_id=[]
with open(rrr_obs_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_obs_tot_id.append(int(row[0]))
IS_obs_tot=len(IV_obs_tot_id)
print('- Number of river reaches in rrr_obs_csv: '+str(IS_obs_tot))


#*******************************************************************************
#Read netCDF file and creating hydrographs
#*******************************************************************************
print('Reading netCDF file and creating hydrographs')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f = netCDF4.Dataset(rrr_out_ncf, 'r')

#-------------------------------------------------------------------------------
#Get variable names
#-------------------------------------------------------------------------------
if 'rivid' in f.variables:
     YS_id_name='rivid'
elif 'COMID' in f.variables:
     YS_id_name='COMID'
else:
     print('ERROR - neither rivid nor COMID exist in'+rrr_out_ncf)
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

IS_R=len(f.variables[YS_out_name])
print('- Number of time steps: '+str(IS_R))

#-------------------------------------------------------------------------------
#Get river IDs
#-------------------------------------------------------------------------------
print('- Getting river IDs')
IV_riv_bas_id=f.variables[YS_id_name]

#-------------------------------------------------------------------------------
#Make hash table
#-------------------------------------------------------------------------------
print('- Making hash table')
IM_hsh={}
for JS_riv_bas in range(IS_riv_bas):
     IM_hsh[IV_riv_bas_id[JS_riv_bas]]=JS_riv_bas

#-------------------------------------------------------------------------------
#Generate hydrographs
#-------------------------------------------------------------------------------
print('- Generating hydrographs')

for JS_obs_tot in range(IS_obs_tot):
     print('  . processing river ID: '+str(IV_obs_tot_id[JS_obs_tot]))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Get values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZV_out=f.variables[YS_out_name][:,IM_hsh[IV_obs_tot_id[JS_obs_tot]]]
     #This follows the following format for RAPID outputs: Qout(time,rivid)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Average every so many values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Examples: IS_avg=8 to make daily from 3-hourly
     #          IS_avg=1 to make 3-hourly from 3-hourly
     ZS_out_avg=0
     ZV_out_avg=[]
     for JS_R in range(IS_R):
          ZS_out_avg=ZS_out_avg+ZV_out[JS_R]
          if (JS_R%IS_avg==IS_avg-1):
               #modulo is % in python.
               ZS_out_avg=ZS_out_avg/IS_avg
               ZV_out_avg.append(ZS_out_avg)
               ZS_out_avg=0

     IS_out_avg=len(ZV_out_avg)
     #print(IS_out_avg)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Write CSV file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     rrr_hyd_dir=os.path.join(rrr_hyd_dir, '')
     #Add trailing slash to directory name if not present, do nothing otherwise
     rrr_hyd_csv=rrr_hyd_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+     \
                  '_mod.csv'
     with open(rrr_hyd_csv, 'wb') as csvfile:
          csvwriter = csv.writer(csvfile, dialect='excel')
          for JS_out_avg in range(IS_out_avg):
               IV_line=[ZV_out_avg[JS_out_avg]] 
               csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
