#!/usr/bin/python
#*******************************************************************************
#rrr_anl_hyd_obs.py
#*******************************************************************************

#Purpose:
#Given a csv file containing observed quantities (for many days/many stations), 
#a csv file containing the unique identifiers corresponding to each station, and
#(optionally) a number of consecutive values to be averaged together; this 
#program produces a set of csv files in which the (averaged) time series of 
#observed quantities are stored.  
#Author:
#Cedric H. David, 2011-2016


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_Qob_csv
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

rrr_Qob_csv=sys.argv[1]
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
print('- '+rrr_Qob_csv)
print('- '+rrr_obs_csv)
print('- '+rrr_hyd_dir)
print('- '+str(IS_avg))


#*******************************************************************************
#Check if files and directory exist 
#*******************************************************************************
try:
     with open(rrr_Qob_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_Qob_csv)
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
#Read rrr_Qob_csv and creating hydrographs
#*******************************************************************************
print('Reading rrr_Qob_csv and creating hydrographs')

#-------------------------------------------------------------------------------
#Generate hydrographs
#-------------------------------------------------------------------------------
print('- Reading rrr_Qob_csv')

ZV_obs=[]
with open(rrr_Qob_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_obs.append(float(row[0]))
IS_M=len(ZV_obs)
print('- Number time steps in rrr_Qob_csv: '+str(IS_M))

#-------------------------------------------------------------------------------
#Generate hydrographs
#-------------------------------------------------------------------------------
print('- Generating hydrographs')

for JS_obs_tot in range(IS_obs_tot):
     print('  . processing river ID: '+str(IV_obs_tot_id[JS_obs_tot]))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Get values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZV_obs=[]
     with open(rrr_Qob_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for row in csvreader:
               ZV_obs.append(float(row[JS_obs_tot]))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Average every so many values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Examples: IS_avg=8 to make daily from 3-hourly
     #          IS_avg=1 to make 3-hourly from 3-hourly
     ZS_obs_avg=0
     ZV_obs_avg=[]
     for JS_M in range(IS_M):
          ZS_obs_avg=ZS_obs_avg+ZV_obs[JS_M]
          if (JS_M%IS_avg==IS_avg-1):
               #modulo is % in python.
               ZS_obs_avg=ZS_obs_avg/IS_avg
               ZV_obs_avg.append(ZS_obs_avg)
               ZS_obs_avg=0

     IS_obs_avg=len(ZV_obs_avg)
     #print(IS_obs_avg)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
#Write CSV file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     rrr_hyd_dir=os.path.join(rrr_hyd_dir, '')
     #Add trailing slash to directory name if not present, do nothing otherwise
     rrr_hyd_csv=rrr_hyd_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+     \
                  '_obs.csv'
     with open(rrr_hyd_csv, 'wb') as csvfile:
          csvwriter = csv.writer(csvfile, dialect='excel')
          for JS_obs_avg in range(IS_obs_avg):
               IV_line=[ZV_obs_avg[JS_obs_avg]] 
               csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
