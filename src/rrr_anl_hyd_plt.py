#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_hyd_plt.py
#*******************************************************************************

#Purpose:
#Given a shapefile of unique integer identifiers for observing stations, and two 
#folders containing csv files with timeseries of observations/model simulations,
#this program creates one graph per station that shows the corresponding 
#hydrographs.  The start date of the timeseries and the interval between data
#points are also needed.
#Author:
#Cedric H. David, 2016-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import fiona
import csv
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import datetime


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_obs_csv
# 3 - rrr_mod_csv
# 4 - rrr_sts_csv
# 5 - rrr_plt_dir
# 6 - rrr_str_dat
# 7 - rrr_end_dat
# 8 - ZS_max_val


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 9:
     print('ERROR - 8 and only 8 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_obs_csv=sys.argv[2]
rrr_mod_csv=sys.argv[3]
rrr_sts_csv=sys.argv[4]
rrr_plt_dir=sys.argv[5]
rrr_str_dat=sys.argv[6]
rrr_end_dat=sys.argv[7]
ZS_max_val=float(sys.argv[8])


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_obs_csv)
print('- '+rrr_mod_csv)
print('- '+rrr_sts_csv)
print('- '+rrr_plt_dir)
print('- '+rrr_str_dat)
print('- '+rrr_end_dat)
print('- '+str(ZS_max_val))


#*******************************************************************************
#Check if files and directories exist 
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22) 

try:
     with open(rrr_obs_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open'+rrr_obs_csv)
     raise SystemExit(22) 

try:
     with open(rrr_mod_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open'+rrr_mod_csv)
     raise SystemExit(22) 

if not os.path.isdir(rrr_plt_dir):
     os.mkdir(rrr_plt_dir)


#*******************************************************************************
#Read rrr_obs_obs
#*******************************************************************************
print('Read rrr_obs_shp')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')
IS_obs_tot=len(rrr_obs_lay)
print('- The number of gauge features is: '+str(IS_obs_tot))

if 'COMID_1' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID_1'
elif 'FLComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='FLComID'
elif 'ARCID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ARCID'
elif 'COMID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID'
else:
     print('ERROR - COMID_1, FLComID, or ARCID do not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'STATION_NM' in rrr_obs_lay[0]['properties']:
     YV_obs_nm='STATION_NM'
elif 'Name' in rrr_obs_lay[0]['properties']:
     YV_obs_nm='Name'
else:
     print('ERROR - STATION_NM or Name do not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

IV_obs_tot_id=[]
YV_obs_tot_nm=[]
for JS_obs_tot in range(IS_obs_tot):
     IV_obs_tot_id.append(int(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_id]))
     YV_obs_tot_nm.append(str(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_nm]))


#*******************************************************************************
#Get temporal information from command line options
#*******************************************************************************
print('Get temporal information from command line options')

dt_str=datetime.datetime.strptime(rrr_str_dat,'%Y-%m-%d')
print('- Start date selected is: '+str(dt_str))

dt_end=datetime.datetime.strptime(rrr_end_dat,'%Y-%m-%d')
print('- End date selected is: '+str(dt_end))


#*******************************************************************************
#Read timeseries from csv files
#*******************************************************************************
rrr_str_dat=datetime.datetime.strptime(rrr_str_dat, "%Y-%m-%d")
rrr_end_dat=datetime.datetime.strptime(rrr_end_dat, "%Y-%m-%d")
YS_obs_nam = ''
YS_obs_nam_uq = ''
YS_mod_nam = ''
YS_mod_nam_uq = ''

with open(rrr_obs_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     YV_header = next(iter(csvreader))
     IV_headid = [int(h) for h in YV_header[1:]]
     YS_obs_nam = YV_header[0]
     ZH_obs = {rid: [] for rid in IV_headid}
     ZH_time = {rid: [] for rid in IV_headid}
     for row in csvreader:
          dat = datetime.datetime.strptime(row[0], "%Y-%m-%d")
          if dat >= rrr_str_dat and dat <= rrr_end_dat:
               for i, rid in enumerate(IV_headid):
                    ZH_obs[rid].append(float(row[i+1]))
                    ZH_time[rid].append(dat)

with open(rrr_mod_csv) as csvfile:
     csvreader=csv.reader(csvfile)
     YV_header = next(iter(csvreader))
     IV_headid = [int(h) for h in YV_header[1:]]
     YS_mod_nam = YV_header[0]
     ZH_mod = {rid: [] for rid in IV_headid}
     for row in csvreader:
          dat = datetime.datetime.strptime(row[0], "%Y-%m-%d")
          if dat >= rrr_str_dat and dat <= rrr_end_dat:
               for i, rid in enumerate(IV_headid):
                    ZH_mod[rid].append(float(row[i+1]))
                    if dat not in ZH_time[rid]:
                         ZH_time[rid].append(dat)

rrr_obs_uq_csv = rrr_obs_csv.replace(".csv", "_uq.csv")
rrr_mod_uq_csv = rrr_mod_csv.replace(".csv", "_uq.csv")

if os.path.isfile(rrr_obs_uq_csv):
     with open(rrr_obs_uq_csv) as csvfile:
          csvreader=csv.reader(csvfile)
          YV_header = next(iter(csvreader))
          IV_headid = [int(h) for h in YV_header[1:]]
          YS_obs_nam_uq = YV_header[0]
          ZH_obs_uq = {rid: [] for rid in IV_headid}
          for row in csvreader:
               dat = datetime.datetime.strptime(row[0], "%Y-%m-%d")
               if dat >= rrr_str_dat and dat <= rrr_end_dat:
                    for i, rid in enumerate(IV_headid):
                         ZH_obs_uq[rid].append(float(row[i+1]))

if os.path.isfile(rrr_mod_uq_csv):
     with open(rrr_mod_uq_csv) as csvfile:
          csvreader=csv.reader(csvfile)
          YV_header = next(iter(csvreader))
          IV_headid = [int(h) for h in YV_header[1:]]
          YS_mod_nam_uq = YV_header[0]
          ZH_mod_uq = {rid: [] for rid in IV_headid}
          for row in csvreader:
               dat = datetime.datetime.strptime(row[0], "%Y-%m-%d")
               if dat >= rrr_str_dat and dat <= rrr_end_dat:
                    for i, rid in enumerate(IV_headid):
                         ZH_mod_uq[rid].append(float(row[i+1]))


#*******************************************************************************
#Read statistics from csv file
#*******************************************************************************
with open(rrr_sts_csv) as csvfile:
     csvreader = csv.reader(csvfile)
     YV_header = next(iter(csvreader))
     IV_headid = [h for h in YV_header]
     ZH_stats = {int(row[0]): {h: float(row[i+1]) for i, h                     \
                 in enumerate(IV_headid[1:])} for row in csvreader}


#*******************************************************************************
#Generate plots
#*******************************************************************************
print('Generate plots')

for JS_obs_tot in range(IS_obs_tot):

     #--------------------------------------------------------------------------
     #Read timeseries from csv files
     #--------------------------------------------------------------------------
     ZV_Qobs=ZH_obs[IV_obs_tot_id[JS_obs_tot]]
     ZV_Qmod=ZH_mod[IV_obs_tot_id[JS_obs_tot]]

     if os.path.isfile(rrr_obs_uq_csv):
          ZV_Qobs_uq=ZH_obs_uq[IV_obs_tot_id[JS_obs_tot]]
     else:
          ZV_Qobs_uq=[]

     if os.path.isfile(rrr_mod_uq_csv):
          ZV_Qmod_uq=ZH_mod_uq[IV_obs_tot_id[JS_obs_tot]]
     else:
          ZV_Qmod_uq=[]

     #--------------------------------------------------------------------------
     #Ensure same number of values
     #--------------------------------------------------------------------------
     IS_time=min(len(ZV_Qobs),len(ZV_Qmod))
     ZV_Qobs=ZV_Qobs[:IS_time]
     ZV_Qmod=ZV_Qmod[:IS_time]

     if os.path.isfile(rrr_obs_uq_csv):
          ZV_Qobs_uq=ZV_Qobs_uq[:IS_time]
     if os.path.isfile(rrr_mod_uq_csv):
          ZV_Qmod_uq=ZV_Qmod_uq[:IS_time]

     #--------------------------------------------------------------------------
     #Make list of times
     #--------------------------------------------------------------------------
     ZV_time=ZH_time[IV_obs_tot_id[JS_obs_tot]]

     #--------------------------------------------------------------------------
     #Ensure label names have been set, if not use defaults
     #--------------------------------------------------------------------------
     if len(YS_obs_nam) < 1:
          YS_obs_nam = 'Observations'
     if len(YS_mod_nam) < 1:
          YS_mod_nam = 'Model'
     if len(YS_obs_nam_uq) < 1:
          YS_obs_nam_uq = 'Observations'
     if len(YS_mod_nam_uq) < 1:
          YS_mod_nam_uq = 'Model'

     #--------------------------------------------------------------------------
     #Create figure and axes objects (helpful for tailoring graphical options)
     #--------------------------------------------------------------------------
     fig, ax=plt.subplots()

     #--------------------------------------------------------------------------
     #Plot timeseries and legend
     #--------------------------------------------------------------------------
     plt.plot(ZV_time, ZV_Qobs, color='k', linestyle='solid', linewidth=1,     \
              label=YS_obs_nam)
     plt.plot(ZV_time, ZV_Qmod, color='b', linestyle='dotted', linewidth=1,    \
              label=YS_mod_nam)
     
     #--------------------------------------------------------------------------
     #Plot uncertainties
     #--------------------------------------------------------------------------
     if os.path.isfile(rrr_obs_uq_csv):
          plt.fill_between(ZV_time,                                            \
                           [x-y for x,y in zip(ZV_Qobs,ZV_Qobs_uq)],           \
                           [x+y for x,y in zip(ZV_Qobs,ZV_Qobs_uq)],           \
                           color='k', alpha=0.1,                               \
                           label='Uncertainty in {0}'.format(YS_obs_nam_uq))
     if os.path.isfile(rrr_mod_uq_csv):
          plt.fill_between(ZV_time,                                            \
                           [x-y for x,y in zip(ZV_Qmod,ZV_Qmod_uq)],           \
                           [x+y for x,y in zip(ZV_Qmod,ZV_Qmod_uq)],           \
                           color='b', alpha=0.1,                               \
                           label='Uncertainty in {0}'.format(YS_mod_nam_uq))

     #--------------------------------------------------------------------------
     #Format x axis
     #--------------------------------------------------------------------------
     ax.xaxis.set_minor_locator(mdates.AutoDateLocator())
     locator=mdates.AutoDateLocator(minticks=2,maxticks=6)
     ax.xaxis.set_major_locator(locator)
     ax.xaxis.set_major_formatter(mdates.AutoDateFormatter(locator))
     plt.xlim(ZV_time[0],ZV_time[IS_time-1])
     
     #--------------------------------------------------------------------------
     #Format y axis
     #--------------------------------------------------------------------------
     plt.ylim(0,ZS_max_val)
     
     #--------------------------------------------------------------------------
     #Format title, labels, and legend
     #--------------------------------------------------------------------------
     plt.title(YV_obs_tot_nm[JS_obs_tot])
     plt.xlabel('Time')
     plt.ylabel('Discharge ('+r'$m^3 s^{-1}$'+')')
     plt.legend(loc='upper right')
     
     #--------------------------------------------------------------------------
     #Annotate plot with statistics
     #--------------------------------------------------------------------------
     stats_str = "NSE = {0:.2f}\n$\\rho$ = {1:.2f}".format(                    \
                  ZH_stats[IV_obs_tot_id[JS_obs_tot]]['Nash'],                 \
                  ZH_stats[IV_obs_tot_id[JS_obs_tot]]['Correl'])
     bbox_prop = dict(boxstyle="round,pad=0.2", fc="white", ec="lightgrey",    \
                      alpha=1.0)
     plt.text(0.02, 0.97, stats_str, ha='left', va='top',                      \
              transform=ax.transAxes, bbox=bbox_prop)
     
     #--------------------------------------------------------------------------
     #(Optional) plot in real time
     #--------------------------------------------------------------------------
     #plt.show()

     #--------------------------------------------------------------------------
     #Save into a file and close plot
     #--------------------------------------------------------------------------
     rrr_plt_pdf=rrr_plt_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+     \
                  '.pdf'
     plt.savefig(rrr_plt_pdf)
     plt.close()


#*******************************************************************************
#End
#*******************************************************************************
