#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_avg.py
#*******************************************************************************

#Purpose:
#Given a a csv file in which the time series of observed or modeled quantities 
#are stored, this program produces a csv file in which the monthly averages
#of the same quantities are stored.
#Author:
#Cedric H. David, 2018-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import pandas


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_hyd_csv
# 2 - rrr_avg_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

rrr_hyd_csv=sys.argv[1]
rrr_avg_csv=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_hyd_csv)
print('- '+rrr_avg_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_hyd_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_hyd_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Read rrr_hyd_csv
#*******************************************************************************
print('Read rrr_hyd_csv')

df1=pandas.read_csv(rrr_hyd_csv)
#Read the csv file using Pandas

YS_name=df1.columns.values[0]
#The header of the first column (e.g. USGS, RAPID, etc.) which contains dat$es

df1[YS_name]=pandas.to_datetime(df1[YS_name])
#Convert the first column to DateTime

df1.set_index(YS_name,inplace=True)
#Sets the index of the dataframe as the first column

IS_row1=df1.shape[0]
IS_col1=df1.shape[1]

IS_max_NaN1=0
for col in df1:
    IS_max_NaN1=max(IS_max_NaN1, len(df1[col])-df1[col].count())

print('- Number of time steps in rrr_hyd_csv: '+str(IS_row1))
print('- Number of river reaches in rrr_hyd_csv: '+str(IS_col1-1))
print('- Max number of NaNs per river reach in rrr_hyd_csv: '+str(IS_max_NaN1))
if IS_max_NaN1 !=0: print('WARNING: There are NaNs')


#*******************************************************************************
#Compute monthly averages
#*******************************************************************************
print('Compute monthly averages')

df2=df1.resample('M').mean()
#Compute the monthly average

IS_row2=df2.shape[0]
IS_col2=df2.shape[1]

IS_max_NaN2=0
for col in df2:
    IS_max_NaN2=max(IS_max_NaN2, len(df2[col])-df2[col].count())

print('- Number of time steps in rrr_avg_csv: '+str(IS_row2))
print('- Number of river reaches in rrr_avg_csv: '+str(IS_col2-1))
print('- Max number of NaNs per river reach in rrr_avg_csv: '+str(IS_max_NaN2))
if IS_max_NaN2 !=0: print('WARNING: There are NaNs')


#*******************************************************************************
#Write rrr_avg_csv
#*******************************************************************************
print('Write rrr_avg_csv')

df2.to_csv(rrr_avg_csv)


#*******************************************************************************
#End
#*******************************************************************************
