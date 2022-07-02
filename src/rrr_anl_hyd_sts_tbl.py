#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_sts_tbl.py
#*******************************************************************************

#Purpose:
#Given a subset list of river IDs where observations are available, several csv
#files with comparison statistics involving various model simulations and a
#common set of observations, this program produces a summary table that is saved
#in a new csv file.
#Author:
#Cedric H. David, 2020-2022


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import csv
import pandas


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_csv
# 2 - rrr_sts_csv
# . - rrr_sts_csv
# n - rrr_sts_csv
#n+1- rrr_tbl_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 4 :
     print('ERROR - A minimum of 3 arguments must be used')
     raise SystemExit(22) 

rrr_obs_csv=sys.argv[1]
rrr_tbl_csv=sys.argv[IS_arg-1]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_csv)
print('- '+str(IS_arg-3)+' statistics file(s) provided')
print('- '+rrr_tbl_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_obs_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_csv)
     raise SystemExit(22) 

for JS_arg in range(2,IS_arg-1):
     rrr_sts_csv=sys.argv[JS_arg]
     try:
          with open(rrr_sts_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_sts_csv)
          raise SystemExit(22) 


#*******************************************************************************
#Read list of gauges
#*******************************************************************************
print('Read list of gauges')

IV_obs_use_id=[]
with open(rrr_obs_csv, 'r') as csvfile:
     csvreader = csv.reader(csvfile, dialect='excel')
     for row in csvreader:
          IV_obs_use_id.append(int(row[0]))

IS_obs_use=len(IV_obs_use_id)
print('- The subset used contains '+str(IS_obs_use)+' gauges')


#*******************************************************************************
#Create summary table
#*******************************************************************************
print('Create summary table')

with open(rrr_tbl_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow(['Name',                                               \
                         'All avg Nash','All med Nash',                        \
                         'Use avg Nash','Use med Nash',                        \
                         'Oth avg Nash','Oth med Nash'])

     #--------------------------------------------------------------------------
     #Loop over all statistics files
     #--------------------------------------------------------------------------
     for JS_arg in range(2,IS_arg-1):
          rrr_sts_csv=sys.argv[JS_arg]
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          #Make pandas dataframes for all stations, stations used, and others
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          df_tot=pandas.read_csv(rrr_sts_csv)
          df_use=df_tot[df_tot['rivid'].isin(IV_obs_use_id)]
          df_oth=df_tot[~df_tot['rivid'].isin(IV_obs_use_id)]

          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          #Compute average and median values of Nash Sutcliffe Efficiency
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          ZS_tot_avg=df_tot['Nash'].mean()
          ZS_tot_med=df_tot['Nash'].median()
          ZS_use_avg=df_use['Nash'].mean()
          ZS_use_med=df_use['Nash'].median()
          ZS_oth_avg=df_oth['Nash'].mean()
          ZS_oth_med=df_oth['Nash'].median()

          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          #Reformat values for clean writing
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          IS_threshold=-1000
          if ZS_tot_avg > IS_threshold:
               YS_tot_avg='%.2f'%ZS_tot_avg
          else:
               YS_tot_avg='-Inf'
          if ZS_tot_med > IS_threshold:
               YS_tot_med='%.2f'%ZS_tot_med
          else:
               YS_tot_med='-Inf'
          if ZS_use_avg > IS_threshold:
               YS_use_avg='%.2f'%ZS_use_avg
          else:
               YS_use_avg='-Inf'
          if ZS_use_med > IS_threshold:
               YS_use_med='%.2f'%ZS_use_med
          else:
               YS_use_med='-Inf'
          if ZS_oth_avg > IS_threshold:
               YS_oth_avg='%.2f'%ZS_oth_avg
          else:
               YS_oth_avg='-Inf'
          if ZS_oth_med > IS_threshold:
               YS_oth_med='%.2f'%ZS_oth_med
          else:
               YS_oth_med='-Inf'

          YS_name=os.path.basename(rrr_sts_csv)
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          #Write in summary table
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          YV_write=[YS_name,                                                   \
                    YS_tot_avg,YS_tot_med,                                     \
                    YS_use_avg,YS_use_med,                                     \
                    YS_oth_avg,YS_oth_med]
          csvwriter.writerow(YV_write)

print('- Done')


#*******************************************************************************
#End
#*******************************************************************************
