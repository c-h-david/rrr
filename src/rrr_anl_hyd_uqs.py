#!/usr/bin/env python2
#*******************************************************************************
#rrr_anl_hyd_uqs.py
#*******************************************************************************

#Purpose:
#Given a list of unique integer identifiers for observing stations, and two
#folders where csv timeseries of observed/computed quantities and their 
#uncertaity are stored, this program computes simple statistics comparing 
#observed and modeled timeseries.
#In cases where timeseries of different lengths are given, the smallest length 
#is used unless an optional argument containing the desired length is given.
#Author:
#Cedric H. David, 2017-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_csv
# 2 - rrr_obs_dir
# 3 - rrr_mod_dir
# 4 - rrr_uqs_csv
#(5)- IS_M


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 5 or IS_arg > 6:
     print('ERROR - A minimum of 4 and a maximum of 5 arguments can be used')
     raise SystemExit(22) 

rrr_obs_csv=sys.argv[1]
rrr_obs_dir=sys.argv[2]
rrr_mod_dir=sys.argv[3]
rrr_uqs_csv=sys.argv[4]
if IS_arg==6:
     IS_M=int(sys.argv[5])
else:
     IS_M=1e20


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_csv)
print('- '+rrr_obs_dir)
print('- '+rrr_mod_dir)
print('- '+rrr_uqs_csv)
print('- '+str(IS_M))


#*******************************************************************************
#Check if files and directory exist 
#*******************************************************************************
try:
     with open(rrr_obs_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_csv)
     raise SystemExit(22) 

if not os.path.isdir(rrr_obs_dir):
     print('ERROR - Directory does not exist'+rrr_obs_dir)
     raise SystemExit(22) 

if not os.path.isdir(rrr_mod_dir):
     print('ERROR - Directory does not exist'+rrr_mod_dir)
     raise SystemExit(22) 

rrr_obs_dir=os.path.join(rrr_obs_dir, '')
rrr_mod_dir=os.path.join(rrr_mod_dir, '')
#Add trailing slash to directory name if not present, do nothing otherwise


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
#Check if all files exist
#*******************************************************************************
print('- Checking that all observed/modeled timeseries with uncertainty exist')

for JS_obs_tot in range(IS_obs_tot):
     rrr_Qob_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_obs.csv'
     try:
          with open(rrr_Qob_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_Qob_csv)
          raise SystemExit(22) 
     #observed timeseries
     rrr_Ouq_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_obs_uq.csv'
     try:
          with open(rrr_Ouq_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_Ouq_csv)
          raise SystemExit(22) 
     #observed uncertainty
     rrr_Qmo_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_mod.csv'
     try:
          with open(rrr_Qmo_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_Qmo_csv)
          raise SystemExit(22) 
     #modeled timeseries
     rrr_Muq_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_mod_uq.csv'
     try:
          with open(rrr_Muq_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_Muq_csv)
          raise SystemExit(22) 
     #modeled uncertainty


#*******************************************************************************
#Check length of all hydrographs 
#*******************************************************************************
print('- Checking the length of all hydrographs')

for JS_obs_tot in range(IS_obs_tot):
     rrr_Qob_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_obs.csv'
     with open(rrr_Qob_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          IS_count=sum(1 for row in csvfile)
          #print(IS_count)
          if (IS_count<IS_M):
               IS_M=IS_count
     rrr_Ouq_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_obs_uq.csv'
     with open(rrr_Ouq_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          IS_count=sum(1 for row in csvfile)
          #print(IS_count)
          if (IS_count<IS_M):
               IS_M=IS_count
     rrr_Qmo_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_mod.csv'
     with open(rrr_Qmo_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          IS_count=sum(1 for row in csvfile)
          #print(IS_count)
          if (IS_count<IS_M):
               IS_M=IS_count
     rrr_Muq_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_mod_uq.csv'
     with open(rrr_Muq_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          IS_count=sum(1 for row in csvfile)
          #print(IS_count)
          if (IS_count<IS_M):
               IS_M=IS_count

print('  . Will compute statistics for: '+str(IS_M)+' time steps')


#*******************************************************************************
#Compute flow statistics
#*******************************************************************************
print('- Computing flow statistics')

with open(rrr_uqs_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     #csvwriter.writerow(['rivid','Qobsbar','Qmodbar','modRMSE','modNash']) 
     #Difficult to compare CSV files with headers, removed them here
     #However, 'wb' here ensures creation of a new file instead of appending.

for JS_obs_tot in range(IS_obs_tot):
#-------------------------------------------------------------------------------
#Read hydrographs
#-------------------------------------------------------------------------------
     ZV_obs=[0]*IS_M
     rrr_Qob_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_obs.csv'
     with open(rrr_Qob_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for JS_M in range(IS_M):
               ZV_obs[JS_M]=float(csvreader.next()[0])

     ZV_ouq=[0]*IS_M
     rrr_Ouq_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_obs_uq.csv'
     with open(rrr_Ouq_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for JS_M in range(IS_M):
               ZV_ouq[JS_M]=float(csvreader.next()[0])

     ZV_mod=[0]*IS_M
     rrr_Qmo_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_mod.csv'
     with open(rrr_Qmo_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for JS_M in range(IS_M):
               ZV_mod[JS_M]=float(csvreader.next()[0])

     ZV_muq=[0]*IS_M
     rrr_Muq_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])      \
                 +'_mod_uq.csv'
     with open(rrr_Muq_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for JS_M in range(IS_M):
               ZV_muq[JS_M]=float(csvreader.next()[0])

#-------------------------------------------------------------------------------
#initialize all stats to zero
#-------------------------------------------------------------------------------
     ZS_obsbar=0
     ZS_ouqbar=0
     ZS_modbar=0
     ZS_muqbar=0
     ZS_hitpct=0

#-------------------------------------------------------------------------------
#calculate stats
#-------------------------------------------------------------------------------
     ZS_obsbar=sum(ZV_obs)/IS_M
     ZS_ouqbar=sum(ZV_ouq)/IS_M
     ZS_modbar=sum(ZV_mod)/IS_M
     ZS_muqbar=sum(ZV_muq)/IS_M

     for JS_M in range(IS_M):
          if (ZV_mod[JS_M]+ZV_muq[JS_M] >= ZV_obs[JS_M]-ZV_ouq[JS_M] and       \
              ZV_mod[JS_M]-ZV_muq[JS_M] <= ZV_obs[JS_M]+ZV_ouq[JS_M]):
               ZS_hitpct=ZS_hitpct+1
     ZS_hitpct=100*ZS_hitpct/IS_M

#-------------------------------------------------------------------------------
#Print outputs
#-------------------------------------------------------------------------------
     with open(rrr_uqs_csv, 'ab') as csvfile:
          csvwriter = csv.writer(csvfile, dialect='excel')
          csvwriter.writerow([IV_obs_tot_id[JS_obs_tot],                       \
                              round(ZS_obsbar,2),                              \
                              round(ZS_ouqbar,2),                              \
                              round(ZS_modbar,2),                              \
                              round(ZS_muqbar,2),                              \
                              round(ZS_ouqbar/ZS_obsbar,2),                    \
                              round(ZS_muqbar/abs(ZS_modbar),2),               \
                              round(abs(ZS_modbar-ZS_obsbar)/abs(ZS_modbar),2),\
                              round(ZS_hitpct,2),                              \
                             ]) 


#*******************************************************************************
#End
#*******************************************************************************
