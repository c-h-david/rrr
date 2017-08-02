#!/usr/bin/python
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
#Cedric H. David, 2016-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os
import fiona
import csv
import matplotlib.pyplot as plt
import matplotlib.dates as mdates
import datetime


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_obs_dir
# 3 - rrr_mod_dir
# 4 - rrr_plt_dir
# 5 - rrr_str_dat
# 6 - ZS_interval
# 7 - ZS_max_val


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 8:
     print('ERROR - 7 and only 7 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_obs_dir=sys.argv[2]
rrr_mod_dir=sys.argv[3]
rrr_plt_dir=sys.argv[4]
rrr_str_dat=sys.argv[5]
ZS_interval=float(sys.argv[6])
ZS_max_val=float(sys.argv[7])


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_obs_dir)
print('- '+rrr_mod_dir)
print('- '+rrr_plt_dir)
print('- '+rrr_str_dat)
print('- '+str(ZS_interval))
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

if not os.path.isdir(rrr_obs_dir):
     print('ERROR - Directory does not exist'+rrr_obs_dir)
     raise SystemExit(22) 

if not os.path.isdir(rrr_mod_dir):
     print('ERROR - Directory does not exist'+rrr_mod_dir)
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

dt_int=datetime.timedelta(ZS_interval)
print('- Interval selected is: '+str(dt_int))


#*******************************************************************************
#Generate plots
#*******************************************************************************
print('Generate plots')

rrr_obs_dir=os.path.join(rrr_obs_dir, '')
rrr_mod_dir=os.path.join(rrr_mod_dir, '')
#Add trailing slash to directory name if not present, do nothing otherwise

for JS_obs_tot in range(IS_obs_tot):
     #--------------------------------------------------------------------------
     #Generate file names from unique IDs
     #--------------------------------------------------------------------------
     rrr_obs_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+     \
                  '_obs.csv'
     rrr_mod_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+     \
                  '_mod.csv'
     rrr_obs_uq_csv=rrr_obs_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+  \
                  '_obs_uq.csv'
     rrr_mod_uq_csv=rrr_mod_dir+'hydrograph_'+str(IV_obs_tot_id[JS_obs_tot])+  \
                  '_mod_uq.csv'

     #--------------------------------------------------------------------------
     #Check that csv files exist
     #--------------------------------------------------------------------------
     try:
          with open(rrr_obs_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_obs_csv)
          raise SystemExit(22) 
     try:
          with open(rrr_mod_csv) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+rrr_mod_csv)
          raise SystemExit(22) 

     #--------------------------------------------------------------------------
     #Read timeseries from csv files
     #--------------------------------------------------------------------------
     ZV_Qobs=[]
     with open(rrr_obs_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for row in csvreader:
               ZV_Qobs.append(float(row[0]))
     ZV_Qmod=[]
     with open(rrr_mod_csv,'rb') as csvfile:
          csvreader=csv.reader(csvfile)
          for row in csvreader:
               ZV_Qmod.append(float(row[0]))

     if os.path.isfile(rrr_obs_uq_csv):
          ZV_Qobs_uq=[]
          with open(rrr_obs_uq_csv,'rb') as csvfile:
               csvreader=csv.reader(csvfile)
               for row in csvreader:
                    ZV_Qobs_uq.append(float(row[0]))
     if os.path.isfile(rrr_mod_uq_csv):
          ZV_Qmod_uq=[]
          with open(rrr_mod_uq_csv,'rb') as csvfile:
               csvreader=csv.reader(csvfile)
               for row in csvreader:
                    ZV_Qmod_uq.append(float(row[0]))

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
     ZV_time=[]
     for JS_time in range(IS_time):
          ZV_time.append(dt_str+JS_time*dt_int)

     #--------------------------------------------------------------------------
     #Plot timeseries
     #--------------------------------------------------------------------------
     plt.plot(ZV_time, ZV_Qobs, color='k', linestyle='solid', linewidth=1,     \
              label='Observations')
     plt.plot(ZV_time, ZV_Qmod, color='b', linestyle='dotted', linewidth=1,    \
              label='RAPID')
     
     #--------------------------------------------------------------------------
     #Plot uncertainties
     #--------------------------------------------------------------------------
     if os.path.isfile(rrr_obs_uq_csv):
          plt.fill_between(ZV_time,                                            \
                           [x-y for x,y in zip(ZV_Qobs,ZV_Qobs_uq)],           \
                           [x+y for x,y in zip(ZV_Qobs,ZV_Qobs_uq)],           \
                           color='k', alpha=0.1,                               \
                           label='Uncertainty in observations')
     if os.path.isfile(rrr_mod_uq_csv):
          plt.fill_between(ZV_time,                                            \
                           [x-y for x,y in zip(ZV_Qmod,ZV_Qmod_uq)],           \
                           [x+y for x,y in zip(ZV_Qmod,ZV_Qmod_uq)],           \
                           color='b', alpha=0.1,                               \
                           label='Uncertainty in RAPID')

     #--------------------------------------------------------------------------
     #Format x axis
     #--------------------------------------------------------------------------
     plt.axes().xaxis.set_minor_locator(mdates.MonthLocator())
     
     plt.axes().xaxis.set_major_locator(mdates.MonthLocator(interval=12))
     plt.axes().xaxis.set_major_formatter(mdates.DateFormatter('%Y-%m'))
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
     plt.legend()
     
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
