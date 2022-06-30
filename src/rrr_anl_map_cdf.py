#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_map_cdf.py
#*******************************************************************************

#Purpose:
#Given several CSV tables of spatial statistics related to RAPID simulations and
#a folder name, this program creates a series of graphs with cumulative
#distribution functions.
#Author:
#Cedric H. David, 2021-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import pandas
import numpy
import matplotlib.pyplot as plt
import matplotlib.ticker as tkr


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_map_csv
# ...
#n-1- rrr_map_csv
# n - rrr_cdf_dir


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 3:
     print('ERROR - At least 2 arguments must be used')
     raise SystemExit(22) 

IS_map=IS_arg-2

rrr_cdf_dir=sys.argv[IS_arg-1]
rrr_cdf_dir=os.path.join(rrr_cdf_dir, '')
#Add trailing slash to directory name if not present, do nothing otherwise


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
for JS_map in range(IS_map):
     print('- '+sys.argv[JS_map+1])
print('- '+rrr_cdf_dir)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
for JS_map in range(IS_map):
     rrr_map_csv=sys.argv[JS_map+1]
     try:
          with open(rrr_map_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_map_csv)
          raise SystemExit(22)

if not os.path.isdir(rrr_cdf_dir):
     os.mkdir(rrr_cdf_dir)


#*******************************************************************************
#Gathering headers from first file (assuming consistency across files)
#*******************************************************************************
print('Gathering headers from first file')
rrr_map_csv=sys.argv[1]

df=pandas.read_csv(rrr_map_csv)

YS_map=df.columns[0]
IV_riv=numpy.array(df[YS_map].tolist())
IS_riv=len(IV_riv)

YV_sts=list(df.columns)
YV_sts=YV_sts[1:]
IS_sts=len(YV_sts)

print('- Number of river reaches: '+str(IS_riv))
print('- Number of spatial statistic metrics: '+str(IS_sts))


#*******************************************************************************
#Plotting cumulative distribution functions
#*******************************************************************************
print('Plotting cumulative distribution functions')

IV_pct=[i*1 for i in range(101)]
#An array with percentage values going from 0 to 100 with increments of 5

#-------------------------------------------------------------------------------
#Plotting one spatial statistic over multiple experiments
#-------------------------------------------------------------------------------
print('- Plotting one spatial statistic over multiple experiments')

for JS_sts in range(IS_sts):
     YS_sts=YV_sts[JS_sts]
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Create curves
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     for JS_map in range(IS_map):
          rrr_map_csv=sys.argv[JS_map+1]
          df=pandas.read_csv(rrr_map_csv)
          YS_map=df.columns[0]
          ZV_sts=numpy.array(df[YS_sts].tolist())
          if YS_sts[0]=='T': ZV_sts=ZV_sts/3600
          if not numpy.isnan(ZV_sts).all():
               ZV_cdf=numpy.nanpercentile(ZV_sts,IV_pct)
               ZS_mea=int(round(numpy.nanmean(ZV_sts)))
          else:
               ZV_cdf=[0*i for i in IV_pct]
          if JS_map==0:
               plt.plot(ZV_cdf,IV_pct,color='k',linestyle='solid',linewidth=1, \
                        label=YS_map+' ($\mu$='+str(ZS_mea)+')')
          else:
               plt.plot(ZV_cdf,IV_pct,linestyle='dotted',linewidth=0.5,        \
                        label=YS_map+' ($\mu$='+str(ZS_mea)+')')

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Format figure
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     plt.ylim(0,100)
     plt.axes().yaxis.set_major_locator(tkr.MultipleLocator(25))
     plt.ylabel('Proportion (%)')

     if YS_sts[0]=='Q':
          plt.xlim(10**0.5,10**6)
          plt.xlabel('Discharge ($m^3/s$)')
          plt.xscale('log')

     if YS_sts[0]=='T':
          plt.xlim(0,5000)
          plt.xlabel('Event duration (h)')

     if YS_sts[0]=='N':
          plt.xlim(0,400)
          plt.xlabel('Number of events (-)')

     plt.legend(loc='lower right',prop={'family': 'monospace'})

     YS_tit='Title'
     if YS_sts=='Qout_avg': YS_tit='Spatial Distribution of Mean Discharge'
     if YS_sts=='Qout_max': YS_tit='Spatial Distribution of Maximum Discharge'
     if YS_sts=='Qout_min': YS_tit='Spatial Distribution of Minimum Discharge'
     if YS_sts[-1]=='p':    YS_tit='Spatial Distribution of '+YS_sts[-3:-1]    \
                                  +' Percentile Discharge'
     if YS_sts[0]=='T' and YS_sts[-4:]=='_avg':
          YS_tit='Spatial Distribution of Mean Event Duration for '            \
                +YS_sts[1:3]+' Percentile'
     if YS_sts[0]=='T' and YS_sts[-4:]=='_max':
          YS_tit='Spatial Distribution of Maximum Event Duration for '         \
                +YS_sts[1:3]+' Percentile'
     if YS_sts[0]=='T' and YS_sts[-4:]=='_min':
          YS_tit='Spatial Distribution of Minimum Event Duration for '         \
                +YS_sts[1:3]+' Percentile'
     if YS_sts[0]=='N':
          YS_tit='Spatial Distribution of Number of Events for '               \
                +YS_sts[1:3]+' Percentile'
     plt.title(YS_tit)

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Save and clear figure
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     plt.savefig(rrr_cdf_dir+YS_sts+'.pdf')
     plt.clf()

#-------------------------------------------------------------------------------
#Plotting multiple spatial statistics over multiple experiments
#-------------------------------------------------------------------------------
print('- Plotting multiple spatial statistics over multiple experiments')

YV_sts=YV_sts[0:3]

for YS_sts in YV_sts:
     YS_col='k'
     if YS_sts[-4:]=='_avg': YS_col='b'
     if YS_sts[-4:]=='_max': YS_col='r'
     if YS_sts[-4:]=='_min': YS_col='g'

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Create curves
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     for JS_map in range(IS_map):
          rrr_map_csv=sys.argv[JS_map+1]
          df=pandas.read_csv(rrr_map_csv)
          YS_map=df.columns[0]
          ZV_sts=numpy.array(df[YS_sts].tolist())
          if YS_sts[0]=='T': ZV_sts=ZV_sts/3600
          if not numpy.isnan(ZV_sts).all():
               ZV_cdf=numpy.nanpercentile(ZV_sts,IV_pct)
               ZS_mea=int(round(numpy.nanmean(ZV_sts)))
          else:
               ZV_cdf=[0*i for i in IV_pct]
          if JS_map==0:
               plt.plot(ZV_cdf,IV_pct,color=YS_col,linestyle='solid',          \
                        linewidth=1.0,                                         \
                        label=YS_map+' '+YS_sts+' ($\mu$='+str(ZS_mea)+')')
          if JS_map==1:
               plt.plot(ZV_cdf,IV_pct,color=YS_col,linestyle='dashed',         \
                        linewidth=0.5,                                         \
                        label=YS_map+' '+YS_sts+' ($\mu$='+str(ZS_mea)+')')
          if JS_map==2:
               plt.plot(ZV_cdf,IV_pct,color=YS_col,linestyle='dotted',         \
                        linewidth=0.5,                                         \
                        label=YS_map+' '+YS_sts+' ($\mu$='+str(ZS_mea)+')')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Format figure
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
plt.ylim(0,100)
plt.axes().yaxis.set_major_locator(tkr.MultipleLocator(25))
plt.ylabel('Proportion (%)')
#
if YS_sts[0]=='Q':
     plt.xlim(10**0.5,10**6)
     plt.xlabel('Discharge ($m^3/s$)')
     plt.xscale('log')

if YS_sts[0]=='T':
     plt.xlim(0,5000)
     plt.xlabel('Event duration (h)')

plt.legend(loc='lower right',prop={'family': 'monospace'})

YS_tit=''
plt.title(YS_tit)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Save and clear figure
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
plt.savefig(rrr_cdf_dir+YS_sts[0:5]+'cmb.pdf')
plt.clf()


#*******************************************************************************
#End
#*******************************************************************************
