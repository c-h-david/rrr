#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_cdf.py
#*******************************************************************************

#Purpose:
#Given a table of statistics relating simulations of observations, this program
#program creates a series of graphs with cumulative distribution functions of 
#the errors.
#Author:
#Cedric H. David, 2017-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import csv
import numpy
import matplotlib.pyplot as plt
import matplotlib.ticker as tkr


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_sts_csv
# 2 - rrr_cdf_dir


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

rrr_sts_csv=sys.argv[1]
rrr_cdf_dir=sys.argv[2]

rrr_cdf_dir=os.path.join(rrr_cdf_dir, '')
#Add trailing slash to directory name if not present, do nothing otherwise


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_sts_csv)
print('- '+rrr_cdf_dir)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_sts_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_sts_csv)
     raise SystemExit(22) 

if not os.path.isdir(rrr_cdf_dir):
     os.mkdir(rrr_cdf_dir)


#*******************************************************************************
#Reading rrr_sts_csv
#*******************************************************************************
print('Reading rrr_sts_csv')

with open(rrr_sts_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     IS_obs=sum(1 for row in csvreader)-1

print('- Number of river reaches in rrr_sts_csv: '+str(IS_obs))

with open(rrr_sts_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     YV_hdr = next(iter(csvreader))
     IS_hdr = len(YV_hdr)
     ZH_sts = {YS_hdr: numpy.zeros(IS_obs) for YS_hdr in YV_hdr}
     for JS_obs in range(IS_obs):
          row = next(iter(csvreader))
          for JS_hdr in range(IS_hdr):
               ZH_sts[YV_hdr[JS_hdr]][JS_obs]=row[JS_hdr]

print('- Number of metrics in rrr_sts_csv: '+str(IS_hdr-1))


#*******************************************************************************
#Assigning values to separate arrays
#*******************************************************************************
print('Assigning values to separate arrays')

if 'Qobsbar' not in ZH_sts:
     print('ERROR - Qobsbar is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_obr=ZH_sts['Qobsbar']

if 'Qmodbar' not in ZH_sts:
     print('ERROR - Qmodbar is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_mbr=ZH_sts['Qmodbar']

if 'RMSE' not in ZH_sts:
     print('ERROR - RMSE is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_RMS=ZH_sts['RMSE']

if 'Bias' not in ZH_sts:
     print('ERROR - Bias is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_bia=ZH_sts['Bias']

if 'STDE' not in ZH_sts:
     print('ERROR - STDE is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_STD=ZH_sts['STDE']

if 'Nash' not in ZH_sts:
     print('ERROR - Nash is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_NSE=ZH_sts['Nash']

if 'Correl' not in ZH_sts:
     print('ERROR - Correl is not a header in '+rrr_sts_csv)
     raise SystemExit(22) 
else:
     ZV_cor=ZH_sts['Correl']


#*******************************************************************************
#Computing cumulative distributions
#*******************************************************************************
print('Computing cumulative distributions')

IV_pct=[i*5 for i in range(21)]
#An array with percentage values going from 0 to 100 with increments of 5

#-------------------------------------------------------------------------------
#Counting and replacing zero values in temporal averages
#-------------------------------------------------------------------------------
print('- Counting and replacing zero values in temporal averages')

IS_zeros=(ZV_mbr==0).sum()
print(' . There are '+str(IS_zeros)+' zero values for temporal averages')

numpy.place(ZV_mbr,ZV_mbr==0,numpy.nan)
print(' . These values were replaced by NaN')

#-------------------------------------------------------------------------------
#Plotting cumulative distributions
#-------------------------------------------------------------------------------
print('- Plotting cumulative distributions')

IS_fig=4
for JS_fig in range(IS_fig):
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Specifics for each figure
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     if JS_fig==0:
          ZV_fix=numpy.copy(ZV_mbr)
          YS_title='All stations'
     if JS_fig==1:
          ZV_fix=numpy.copy(ZV_mbr)
          numpy.place(ZV_fix,ZV_obr<100,numpy.nan)
          YS_title='All stations with large flow'
     if JS_fig==2:
          ZV_fix=numpy.copy(ZV_mbr)
          numpy.place(ZV_fix,[ZS_cor<0.8 for ZS_cor in ZV_cor],numpy.nan)
          YS_title='All stations with large correlation'
     if JS_fig==3:
          ZV_fix=numpy.copy(ZV_mbr)
          numpy.place(ZV_fix,[ZS_cor<0.8 for ZS_cor in ZV_cor],numpy.nan)
          numpy.place(ZV_fix,[ZS_obr<100 for ZS_obr in ZV_obr],numpy.nan)
          YS_title='All stations with large correlation and large flow'
     #Using list comprehension for '<' is better here than direct '<' over numpy 
     #arrays because of the runtime warning for NaNs in numpy array comparison.

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Compute percentile
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     if not numpy.isnan(ZV_fix).all():
          ZV_bia_cdf=numpy.nanpercentile(numpy.absolute(numpy.divide(ZV_bia,   \
                                         ZV_fix)),IV_pct)
          ZV_STD_cdf=numpy.nanpercentile(numpy.absolute(numpy.divide(ZV_STD,   \
                                         ZV_fix)),IV_pct)
          ZV_RMS_cdf=numpy.nanpercentile(numpy.absolute(numpy.divide(ZV_RMS,   \
                                         ZV_fix)),IV_pct)
     else:
          ZV_bia_cdf=[0*i for i in IV_pct]
          ZV_STD_cdf=[0*i for i in IV_pct]
          ZV_RMS_cdf=[0*i for i in IV_pct]

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Plot CDFs
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     plt.plot(ZV_bia_cdf, IV_pct, color='y', linestyle='dotted', linewidth=0.5,\
              label='Normalized Absolute Bias')
     plt.plot(ZV_STD_cdf, IV_pct, color='b', linestyle='dotted', linewidth=0.5,\
              label='Normalized STDE')
     plt.plot(ZV_RMS_cdf, IV_pct, color='g', linestyle='solid', linewidth=1,   \
              label='Normalized RMSE')

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Plot and annotate median values 
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZS_x=round(ZV_bia_cdf[10],2)
     ZS_y=IV_pct[10]
     plt.plot(ZS_x,ZS_y, color='y', marker='+')
     plt.axes().annotate('('+str(ZS_x)+','+str(ZS_y)+')',                      \
                         xy=(ZS_x,ZS_y),                                       \
                         xytext=(-13,-12),                                     \
                         textcoords='offset points',                           \
                         fontsize=6,                                           \
                         color='y')

     ZS_x=round(ZV_STD_cdf[10],2)
     ZS_y=IV_pct[10]
     plt.plot(ZS_x,ZS_y, color='b', marker='+')
     plt.axes().annotate('('+str(ZS_x)+','+str(ZS_y)+')',                      \
                         xy=(ZS_x,ZS_y),                                       \
                         xytext=(-13,8),                                       \
                         textcoords='offset points',                           \
                         fontsize=6,                                           \
                         color='b')

     ZS_x=round(ZV_RMS_cdf[10],2)
     ZS_y=IV_pct[10]
     plt.plot(ZS_x,ZS_y, color='g', marker='+')
     plt.axes().annotate('('+str(ZS_x)+','+str(ZS_y)+')',                      \
                         xy=(ZS_x,ZS_y),                                       \
                         xytext=(6,-1),                                        \
                         textcoords='offset points',                           \
                         fontsize=6,                                           \
                         color='g')

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Format figure
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     plt.xlim(0,2)
     plt.ylim(0,100)
     plt.axes().yaxis.set_major_locator(tkr.MultipleLocator(25))
     plt.xlabel('Quantity normalized using mean simulated discharge (-)')
     plt.ylabel('Proportion (%)')
     plt.legend(loc='lower right')
     plt.title(YS_title)

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Save figure and clear it
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     plt.savefig(rrr_cdf_dir+YS_title+'.pdf')
     plt.clf()


#*******************************************************************************
#End
#*******************************************************************************
