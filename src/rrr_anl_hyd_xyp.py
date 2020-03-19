#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_hyd_xyp.py
#*******************************************************************************

#Purpose:
#Given two tables of statistics relating simulations and observations, a title,
#a maximum value for the x and y axes, and a folder path; this program program
#creates a series of XY plots that include linear regressions and save the plots
#as pdf files in the directory.
#Author:
#Cedric H. David, 2018-2020


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import pandas
import numpy
import matplotlib.pyplot as plt


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_stx_csv
# 2 - rrr_sty_csv
# 3 - YS_title
# 4 - ZS_max
# 5 - rrr_xyp_dir


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22) 

rrr_stx_csv=sys.argv[1]
rrr_sty_csv=sys.argv[2]
YS_title=sys.argv[3]
ZS_max=float(sys.argv[4])
rrr_xyp_dir=sys.argv[5]

rrr_xyp_dir=os.path.join(rrr_xyp_dir, '')
#Add trailing slash to directory name if not present, do nothing otherwise


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_stx_csv)
print('- '+rrr_sty_csv)
print('- '+YS_title)
print('- '+str(ZS_max))
print('- '+rrr_xyp_dir)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_stx_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_stx_csv)
     raise SystemExit(22) 

try:
     with open(rrr_sty_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_sty_csv)
     raise SystemExit(22) 

if not os.path.isdir(rrr_xyp_dir):
     os.mkdir(rrr_xyp_dir)


#*******************************************************************************
#Reading rrr_stx_csv
#*******************************************************************************
print('Reading rrr_stx_csv')

dfx=pandas.read_csv(rrr_stx_csv)
#Read the csv file into a dataframe using Pandas

ZV_stx_RMSE=dfx['RMSE'].values
ZV_stx_Bias=dfx['Bias'].values
ZV_stx_STDE=dfx['STDE'].values

ZV_stx_Bias=numpy.abs(ZV_stx_Bias)

print('- Done')


#*******************************************************************************
#Reading rrr_sty_csv
#*******************************************************************************
print('Reading rrr_sty_csv')

dfy=pandas.read_csv(rrr_sty_csv)
#Read the csv file into a dataframe using Pandas

ZV_sty_RMSE=dfy['RMSE'].values
ZV_sty_Bias=dfy['Bias'].values
ZV_sty_STDE=dfy['STDE'].values

ZV_sty_Bias=numpy.abs(ZV_sty_Bias)

print('- Done')


#*******************************************************************************
#Checking that all statistics have same size
#*******************************************************************************
print('Checking that all statistics have same size')

IS_stt=len(ZV_stx_RMSE)
if len(ZV_stx_Bias)==IS_stt and len(ZV_stx_STDE)==IS_stt and                   \
   len(ZV_sty_RMSE)==IS_stt and len(ZV_sty_Bias)==IS_stt and                   \
   len(ZV_sty_STDE)==IS_stt:
     print('- The common size of all statistics is: '+str(IS_stt))
else:
     print('ERROR - Statistics do not have same size')
     raise SystemExit(22)


##*******************************************************************************
##Optional: Removing smallest errors
##*******************************************************************************
#print('Optional: Removing smallest errors')
#
#ZS_thr=1
#
#IV_rem_Bias=[]
#IV_rem_STDE=[]
#IV_rem_RMSE=[]
#for JS_stt in range(IS_stt):
#     if ZV_stx_Bias[JS_stt]<ZS_thr or ZV_sty_Bias[JS_stt]<ZS_thr:
#          IV_rem_Bias.append(JS_stt)
#     if ZV_stx_STDE[JS_stt]<ZS_thr or ZV_sty_STDE[JS_stt]<ZS_thr:
#          IV_rem_STDE.append(JS_stt)
#     if ZV_stx_RMSE[JS_stt]<ZS_thr or ZV_sty_RMSE[JS_stt]<ZS_thr:
#          IV_rem_RMSE.append(JS_stt)
#
#ZV_stx_Bias=numpy.delete(ZV_stx_Bias,IV_rem_Bias)
#ZV_sty_Bias=numpy.delete(ZV_sty_Bias,IV_rem_Bias)
#ZV_stx_STDE=numpy.delete(ZV_stx_STDE,IV_rem_STDE)
#ZV_sty_STDE=numpy.delete(ZV_sty_STDE,IV_rem_STDE)
#ZV_stx_RMSE=numpy.delete(ZV_stx_RMSE,IV_rem_RMSE)
#ZV_sty_RMSE=numpy.delete(ZV_sty_RMSE,IV_rem_RMSE)
#
#print('- Removed all values smaller than: '+str(ZS_thr))


#*******************************************************************************
#Computing zero-intercept linear regressions and coefficients of determination
#*******************************************************************************
print('Computing zero-intercept linear regressions and coefficients of '+      \
      'determination')

#-------------------------------------------------------------------------------
#Bias
#-------------------------------------------------------------------------------
ZS_slp_Bias=numpy.sum(numpy.multiply(ZV_stx_Bias,ZV_sty_Bias))                 \
           /numpy.sum(numpy.square(ZV_stx_Bias))

ZV_fit_Bias=ZS_slp_Bias*ZV_stx_Bias

ZS_R2_Bias=1-numpy.sum(numpy.square(ZV_fit_Bias-ZV_sty_Bias))                  \
            /numpy.sum(numpy.square(ZV_sty_Bias-numpy.mean(ZV_sty_Bias)))

print('- Bias')
print(' . Slope: '+str(round(ZS_slp_Bias,4)))
print(' . R2:    '+str(round(ZS_R2_Bias,4)))

#-------------------------------------------------------------------------------
#STDE
#-------------------------------------------------------------------------------
ZS_slp_STDE=numpy.sum(numpy.multiply(ZV_stx_STDE,ZV_sty_STDE))                 \
           /numpy.sum(numpy.square(ZV_stx_STDE))

ZV_fit_STDE=ZS_slp_STDE*ZV_stx_STDE

ZS_R2_STDE=1-numpy.sum(numpy.square(ZV_fit_STDE-ZV_sty_STDE))                  \
            /numpy.sum(numpy.square(ZV_sty_STDE-numpy.mean(ZV_sty_STDE)))

print('- STDE')
print(' . Slope: '+str(round(ZS_slp_STDE,4)))
print(' . R2:    '+str(round(ZS_R2_STDE,4)))

#-------------------------------------------------------------------------------
#RMSE
#-------------------------------------------------------------------------------
ZS_slp_RMSE=numpy.sum(numpy.multiply(ZV_stx_RMSE,ZV_sty_RMSE))                 \
           /numpy.sum(numpy.square(ZV_stx_RMSE))

ZV_fit_RMSE=ZS_slp_RMSE*ZV_stx_RMSE

ZS_R2_RMSE=1-numpy.sum(numpy.square(ZV_fit_RMSE-ZV_sty_RMSE))                  \
            /numpy.sum(numpy.square(ZV_sty_RMSE-numpy.mean(ZV_sty_RMSE)))

print('- RMSE')
print(' . Slope: '+str(round(ZS_slp_RMSE,4)))
print(' . R2:    '+str(round(ZS_R2_RMSE,4)))


#*******************************************************************************
#Generating XY plots
#*******************************************************************************
print('Generating XY plots')

#-------------------------------------------------------------------------------
#Plotting Bias
#-------------------------------------------------------------------------------
plt.scatter(ZV_stx_Bias,ZV_sty_Bias,marker='.',color='y',label='Bias')

plt.plot(ZV_stx_Bias,ZV_fit_Bias,color='y',linestyle='dotted',linewidth=0.5,   \
         label='y='+str(round(ZS_slp_Bias,2))+'x'+', '                         \
              +r'$R^2=$'+str(round(ZS_R2_Bias,2)))

plt.xlim(0,ZS_max)
plt.ylim(0,ZS_max)
plt.xlabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.ylabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.legend(loc='upper left')
plt.title(YS_title)

#plt.xlim(0.01,ZS_max)
#plt.xscale('log')
#plt.ylim(0.01,ZS_max)
#plt.yscale('log')

plt.savefig(rrr_xyp_dir+'Bias'+'.pdf')
plt.clf()
print('- Completed Bias')

#-------------------------------------------------------------------------------
#Plotting STDE
#-------------------------------------------------------------------------------
plt.scatter(ZV_stx_STDE,ZV_sty_STDE,marker='.',color='b',label='STDE')

plt.plot(ZV_stx_STDE,ZV_fit_STDE,color='b',linestyle='dotted',linewidth=0.5,   \
         label='y='+str(round(ZS_slp_STDE,2))+'x'+', '                         \
              +r'$R^2=$'+str(round(ZS_R2_STDE,2)))

plt.xlim(0,ZS_max)
plt.ylim(0,ZS_max)
plt.xlabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.ylabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.legend(loc='upper left')
plt.title(YS_title)

#plt.xlim(0.01,ZS_max)
#plt.xscale('log')
#plt.ylim(0.01,ZS_max)
#plt.yscale('log')

plt.savefig(rrr_xyp_dir+'STDE'+'.pdf')
plt.clf()
print('- Completed STDE')

#-------------------------------------------------------------------------------
#Plotting RMSE
#-------------------------------------------------------------------------------
plt.scatter(ZV_stx_RMSE,ZV_sty_RMSE,marker='.',color='g',label='RMSE')

plt.plot(ZV_stx_RMSE,ZV_fit_RMSE,color='g',linestyle='dotted',linewidth=0.5,   \
         label='y='+str(round(ZS_slp_RMSE,2))+'x'+', '                         \
              +r'$R^2=$'+str(round(ZS_R2_RMSE,2)))

plt.xlim(0,ZS_max)
plt.ylim(0,ZS_max)
plt.xlabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.ylabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.legend(loc='upper left')
plt.title(YS_title)

#plt.xlim(0.01,ZS_max)
#plt.xscale('log')
#plt.ylim(0.01,ZS_max)
#plt.yscale('log')

plt.savefig(rrr_xyp_dir+'RMSE'+'.pdf')
plt.clf()
print('- Completed RMSE')

#-------------------------------------------------------------------------------
#Plotting Combined
#-------------------------------------------------------------------------------
plt.scatter(ZV_stx_Bias,ZV_sty_Bias,marker='.',color='y',label='Bias')

plt.plot(ZV_stx_Bias,ZV_fit_Bias,color='y',linestyle='dotted',linewidth=0.5,   \
         label='y='+str(round(ZS_slp_Bias,2))+'x'+', '                         \
              +r'$R^2=$'+str(round(ZS_R2_Bias,2)))

plt.scatter(ZV_stx_STDE,ZV_sty_STDE,marker='.',color='b',label='STDE')

plt.plot(ZV_stx_STDE,ZV_fit_STDE,color='b',linestyle='dotted',linewidth=0.5,   \
         label='y='+str(round(ZS_slp_STDE,2))+'x'+', '                         \
              +r'$R^2=$'+str(round(ZS_R2_STDE,2)))

plt.scatter(ZV_stx_RMSE,ZV_sty_RMSE,marker='.',color='g',label='RMSE')

plt.plot(ZV_stx_RMSE,ZV_fit_RMSE,color='g',linestyle='dotted',linewidth=0.5,   \
         label='y='+str(round(ZS_slp_RMSE,2))+'x'+', '                         \
              +r'$R^2=$'+str(round(ZS_R2_RMSE,2)))

plt.xlim(0,ZS_max)
plt.ylim(0,ZS_max)
plt.xlabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.ylabel('Discharge error ('+r'$m^3 s^{-1}$'+')')
plt.legend(loc='lower right')
plt.title(YS_title)

#plt.xlim(0.01,ZS_max)
#plt.xscale('log')
#plt.ylim(0.01,ZS_max)
#plt.yscale('log')

plt.savefig(rrr_xyp_dir+'Comb'+'.pdf')
plt.clf()
print('- Completed Combined')


#*******************************************************************************
#End
#*******************************************************************************
