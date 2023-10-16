#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_hyd_sum.py
#*******************************************************************************

#Purpose:
#Given n CSV files with timeseries, and the name of a new CSV file, this program
#adds computes the sum of all timeseries and saves it in the new CSV file.
#Author:
#Cedric H. David, 2023-2023


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
# 1 - rrr_spa_csv
# 2 - rrr_spa_csv
# . - rrr_spa_csv
# n - rrr_spa_csv
#n+1- rrr_sum_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 4 :
     print('ERROR - A minimum of 3 arguments must be used')
     raise SystemExit(22)

rrr_sum_csv=sys.argv[IS_arg-1]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+str(IS_arg-2)+' timeseries file(s) provided')
print('- '+rrr_sum_csv)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
for JS_arg in range(1,IS_arg-1):
     rrr_spa_csv=sys.argv[JS_arg]
     try:
          with open(rrr_spa_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_spa_csv)
          raise SystemExit(22)


#*******************************************************************************
#Read first timeseries
#*******************************************************************************
print('Read first timeseries')

rrr_spa_csv=sys.argv[1]
#The first timeseries file

df1=pandas.read_csv(rrr_spa_csv)
#Read the csv file using Pandas

YS_tim1=df1.columns.values[0]
#The header of the first column which contains dates

df1[YS_tim1]=pandas.to_datetime(df1[YS_tim1])
#Convert the first column to DateTime

df1.set_index(YS_tim1,inplace=True)
#Sets the index of the dataframe as the first column

IS_tim1=df1.shape[0]
#Number of timesteps

ZV_tim1=df1.index.values.tolist()
#Array with time values

dfs=df1.copy(deep=True)
#New object created with a copy of df1

dfs.index.rename('Date',inplace=True)
#Renamed index to 'Date'


#*******************************************************************************
#Read other timeseries
#*******************************************************************************
print('Read other timeseries')

for JS_arg in range(2,IS_arg-1):

     rrr_spa_csv=sys.argv[JS_arg]
     #The first timeseries file

     dfj=pandas.read_csv(rrr_spa_csv)
     #Read the csv file using Pandas

     YS_timj=dfj.columns.values[0]
     #The header of the first column which contains dates

     dfj[YS_timj]=pandas.to_datetime(dfj[YS_timj])
     #Convert the first column to DateTime

     dfj.set_index(YS_timj,inplace=True)
     #Sets the index of the dataframe as the first column

     IS_timj=dfj.shape[0]
     #Number of timesteps

     ZV_timj=dfj.index.values.tolist()
     #Array with time values

     if ZV_timj==ZV_tim1:
          dfs=dfs.add(dfj)
     else:
          print('ERROR - Unable inconsistent time values')
          raise SystemExit(22)


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Write CSV file')

dfs.to_csv(rrr_sum_csv)

print('- Done')


#*******************************************************************************
#End
#*******************************************************************************
