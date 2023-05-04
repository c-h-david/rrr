#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_hyd_obs_trk.py
#*******************************************************************************

#Purpose:
#Given an observing stations shapefile with unique integer identifiers and 
#unique station codes, a name for the dataset, a start date, and an end date,
#this program obtains data from WaterTrek and produces a csv file in which the 
#time series of observed quantities are stored. 
#Author:
#Cedric H. David, 2018-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import datetime
import fiona
import requests
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_out_str
# 3 - rrr_iso_beg
# 4 - rrr_iso_end
# 5 - rrr_hyd_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22) 

rrr_obs_shp=sys.argv[1]
rrr_out_str=sys.argv[2]
rrr_iso_beg=sys.argv[3]
rrr_iso_end=sys.argv[4]
rrr_hyd_csv=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_obs_shp)
print('- '+rrr_out_str)
print('- '+rrr_iso_beg)
print('- '+rrr_iso_end)
print('- '+rrr_hyd_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Compute expected length of timeseries
#*******************************************************************************
print('Compute expected length of time series')

rrr_str_beg=datetime.datetime.strptime(rrr_iso_beg,'%Y-%m-%dT%H:%M:%S')        \
            .strftime('%Y-%m-%d')
rrr_str_end=datetime.datetime.strptime(rrr_iso_end,'%Y-%m-%dT%H:%M:%S')        \
            .strftime('%Y-%m-%d')

ZS_stmp=( datetime.datetime.strptime(rrr_iso_beg,'%Y-%m-%dT%H:%M:%S')          \
         -datetime.datetime(1970, 1, 1)).total_seconds()
#Timestamp of the beginning of the interval in Unix epoch.

if divmod(ZS_stmp,86400)[1]!=0.0:
     print('ERROR - The time interval does NOT start at midnight: '            \
           +rrr_iso_beg)
     raise SystemExit(22) 

ZS_secs=( datetime.datetime.strptime(rrr_iso_end,'%Y-%m-%dT%H:%M:%S')          \
         -datetime.datetime.strptime(rrr_iso_beg,'%Y-%m-%dT%H:%M:%S'))         \
        .total_seconds()
#Number of seconds in the interval

IS_days=int(divmod(ZS_secs,3600*24)[0])+1
print('- The number of daily time steps corresponding to the request is: '     \
      +str(IS_days))


#*******************************************************************************
#Obtaining credentials for the server from a local file
#*******************************************************************************
print('Obtaining credentials for the server from a local file')

url='https://watertrek.jpl.nasa.gov'
print('- '+url)

cred=requests.utils.get_netrc_auth(url)
print('- The credentials were obtained from ~/.netrc file')


#*******************************************************************************
#Read rrr_obs_shp
#*******************************************************************************
print('Read rrr_obs_shp')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')
IS_obs_tot=len(rrr_obs_lay)
print('- Number of river reaches in rrr_obs_shp: '+str(IS_obs_tot))

if 'COMID_1' in rrr_obs_lay[0]['properties']:
     YV_obs_id='COMID_1'
elif 'FLComID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='FLComID'
elif 'ARCID' in rrr_obs_lay[0]['properties']:
     YV_obs_id='ARCID'
else:
     print('ERROR - COMID_1, FLComID, or ARCID do not exist in '+rrr_obs_shp)
     raise SystemExit(22) 

if 'SOURCE_FEA' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='SOURCE_FEA'
elif 'Code' in rrr_obs_lay[0]['properties']:
     YV_obs_cd='Code'
else:
     print('ERROR - Neither SOURCE_FEA nor Code exist in '+rrr_obs_shp)
     raise SystemExit(22) 

IV_obs_tot_id=[]
YV_obs_tot_cd=[]
for JS_obs_tot in range(IS_obs_tot):
     IV_obs_tot_id.append(int(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_id]))
     YV_obs_tot_cd.append(str(rrr_obs_lay[JS_obs_tot]['properties'][YV_obs_cd]))


z = sorted(zip(IV_obs_tot_id,YV_obs_tot_cd))
IV_obs_tot_id_srt,YV_obs_tot_cd_srt=zip(*z)
#Sorting the lists together based on increasing value of the river ID.
IV_obs_tot_id_srt=list(IV_obs_tot_id_srt)
YV_obs_tot_cd_srt=list(YV_obs_tot_cd_srt)
#Because zip creates tuples and not lists


#*******************************************************************************
#Check that service works for one known value
#*******************************************************************************
print('Check that service works for one known value')

url1='https://watertrek.jpl.nasa.gov/hydrology/rest/'

url2=url1+'streamgauge/site_no/'+'14246900'+'/discharge/from/'+'1997-01-01'    \
         +'/through/'+'1997-01-01'+'?format=json'

data=requests.get(url2, auth=cred)
if not data.ok:
     print('ERROR - status code '+str(data.status_code)+                       \
           ' returned when downloading '+url2)
     raise SystemExit(22)
exec('ZH_tmp='+data.content)

if ZH_tmp['data'][0]['datetime']=='1997-01-01T00:00:00' and                    \
   ZH_tmp['data'][0]['discharge']==16537.03841: 
     print('- Successfully checked value for USGS observations corresponding ' \
           'to Columbia River at Beaver Army Terminal, near Quincy, OR for '   \
           '1997-01-01T00:00:00')
else:
     print('ERROR - Unable to check known value')
     raise SystemExit(22) 


#*******************************************************************************
#Get WaterTrek data
#*******************************************************************************
print('Get WaterTrek data')

#-------------------------------------------------------------------------------
#Creating a networking session and assigning associated credentials
#-------------------------------------------------------------------------------
print('- Creating a networking session and assigning associated credentials')

s=requests.Session()
s.auth=cred

#-------------------------------------------------------------------------------
#Allocating memory for Python dictionary
#-------------------------------------------------------------------------------
print('- Allocating memory for Python dictionary')

YV_days=['']*IS_days
for JS_days in range(IS_days):
     YV_days[JS_days]=(datetime.datetime.strptime(rrr_iso_beg,                 \
                                                  '%Y-%m-%dT%H:%M:%S')         \
                      +datetime.timedelta(days=JS_days)).strftime('%Y-%m-%d')

ZH_avg={IS_obs_tot_id:{YS_days:None for YS_days in YV_days}                    \
        for IS_obs_tot_id in IV_obs_tot_id_srt}

#-------------------------------------------------------------------------------
#Looping over all stations
#-------------------------------------------------------------------------------
print('- Looping over all stations')

for JS_obs_tot in range(IS_obs_tot):
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Gathering data
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     print(' . Gathering data for gauge '+str(JS_obs_tot+1)+'/'+str(IS_obs_tot))
     IS_obs_tot_id=IV_obs_tot_id_srt[JS_obs_tot]
     YS_obs_tot_cd=YV_obs_tot_cd_srt[JS_obs_tot]
     url2=url1+'streamgauge/site_no/'+YS_obs_tot_cd+'/discharge/from/'         \
              +rrr_str_beg                                                     \
              +'/through/'                                                     \
              +rrr_str_end                                                     \
              +'?format=json'
     #data=requests.get(url2,auth=cred)
     data=s.get(url2)
     if not data.ok:
          print('ERROR - status code '+str(data.status_code)+                  \
                ' returned when downloading '+url2)
          raise SystemExit(22)
     exec('ZH_tmp='+data.content)
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     #Checking and reformatting data
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
     ZH_hyd={}
     if len(ZH_tmp['data'])==IS_days:
          for JS_days in range(IS_days):
               ZH_hyd[ZH_tmp['data'][JS_days]['datetime']]                     \
                     =ZH_tmp['data'][JS_days]['discharge']
     else:
          print('ERROR - Unexpected number of data points: '                   \
               +str(len(ZH_tmp['data']))+' instead of '+str(IS_days)+', '      \
               +'for RIVID: '+str(IS_obs_tot_id))
          raise SystemExit(22) 
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Computing daily averages
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     for JS_days in range(IS_days):
          ZS_avg=ZH_hyd[YV_days[JS_days]+'T00:00:00']
          ZH_avg[IS_obs_tot_id][YV_days[JS_days]]=ZS_avg

#-------------------------------------------------------------------------------
#Closing the networking session
#-------------------------------------------------------------------------------
print('- Closing the networking session')

s.close()


#*******************************************************************************
#Write CSV file
#*******************************************************************************
print('Write CSV file')

with open(rrr_hyd_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     #csvwriter.writerow([rrr_out_str]+YV_obs_tot_cd_srt)
     csvwriter.writerow([rrr_out_str]+IV_obs_tot_id_srt)
     for JS_days in range(IS_days):
          IV_line=[YV_days[JS_days]]                                           \
                 +[ZH_avg[i][YV_days[JS_days]] for i in IV_obs_tot_id_srt]
          csvwriter.writerow(IV_line) 
#Write hydrographs


#*******************************************************************************
#End
#*******************************************************************************
