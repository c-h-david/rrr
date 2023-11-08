#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_hyd_sts_dig.py
#*******************************************************************************

#Purpose:
#Given a CSV statistics table, and shapefile with a subset of stations, this
#program produces a summary of statistics and saves a digested version in a new
#CSV file.
#Author:
#Cedric H. David, 2020-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import pandas


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_sts_csv
# 2 - rrr_obs_shp
# 3 - rrr_dig_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 4 :
     print('ERROR - A minimum of 3 arguments must be used')
     raise SystemExit(22)

rrr_sts_csv=sys.argv[1]
rrr_obs_shp=sys.argv[2]
rrr_dig_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_sts_csv)
print('- '+rrr_obs_shp)
print('- '+rrr_dig_csv)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_sts_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_sts_csv)
     raise SystemExit(22)

try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22)


#*******************************************************************************
#Read statistics
#*******************************************************************************
print('Read statistics')

df_sts_csv=pandas.read_csv(rrr_sts_csv)
IS_sts_csv=df_sts_csv.shape[0]

print('- The number of river reaches in statistics file is: '+str(IS_sts_csv))


#*******************************************************************************
#Read gauge shapefile
#*******************************************************************************
print('Read gauge shapefile')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')

if 'Sttn_Nm' in rrr_obs_lay[0]['properties']:
     YS_obs_nam='Sttn_Nm'
else:
     print('ERROR - Sttn_Nm does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

if 'rivid' in rrr_obs_lay[0]['properties']:
     YS_obs_ids='rivid'
else:
     print('ERROR - rivid does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

IS_obs_shp=len(rrr_obs_lay)
print('- The number of gauges in shapefile is: '+str(IS_obs_shp))

IV_obs_ids=[]
for rrr_obs_fea in rrr_obs_lay:
     IV_obs_ids.append(rrr_obs_fea['properties'][YS_obs_ids])


#*******************************************************************************
#Subsample statistics and add normalized metrics
#*******************************************************************************
print('Subsample statistics and add normalized metrics')

df_sub_csv=df_sts_csv.copy(deep=True)

df_sub_csv=df_sub_csv.loc[df_sub_csv['rivid'].isin(IV_obs_ids)]

df_sub_csv['nRMSE']=df_sub_csv['RMSE']/df_sub_csv['Qobsbar']
df_sub_csv['nBias']=df_sub_csv['Bias']/df_sub_csv['Qobsbar']
df_sub_csv['nSTDE']=df_sub_csv['STDE']/df_sub_csv['Qobsbar']

print('- Done')


#*******************************************************************************
#Create digested statistics file
#*******************************************************************************
print('Create digested statistics file')

df_dig_csv=pandas.DataFrame(columns=df_sub_csv.columns)

df_dig_csv.loc[0]=df_sub_csv.mean()

df_dig_csv.loc[1]=df_sub_csv.median()

df_dig_csv.loc[2]=df_sub_csv.quantile(q=0.68)
df_dig_csv.at[2,'Nash']=df_sub_csv['Nash'].quantile(q=0.32)
#68% quantiles differ: normalized errors (small better) and Nash (large better)

df_dig_csv.insert(1,'summary',['mean','median','68%_better_than'])

df_dig_csv=df_dig_csv[['summary','nRMSE','nBias','nSTDE','Nash']]

df_dig_csv.to_csv(path_or_buf=rrr_dig_csv,index=False,float_format='%.2f')

print('- Done')


#*******************************************************************************
#End
#*******************************************************************************
