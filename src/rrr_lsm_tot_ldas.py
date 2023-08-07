#!/usr/bin/env python3
#*******************************************************************************
#rrr_lsm_tot_ldas.py
#*******************************************************************************

#Purpose:
#Given and model name, a temporal frequency key, a start date, an end date, and
#a folder path, this script downloads LDAS data from GES-DISC using the 
#NASA EarthData credentials stored locally in '~/.netrc' file.
#Author:
#Cedric H. David, 2018-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import datetime
import requests


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_exp
# 2 - rrr_lsm_mod
# 3 - rrr_lsm_frq
# 4 - rrr_iso_beg
# 5 - rrr_iso_end
# 6 - rrr_lsm_dir
#(7)- rrr_lsm_org


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 7 or IS_arg > 8:
     print('ERROR - A minimum of 6 and a maximum of 7 arguments can be used')
     raise SystemExit(22) 

rrr_lsm_exp=sys.argv[1]
rrr_lsm_mod=sys.argv[2]
rrr_lsm_frq=sys.argv[3]
rrr_iso_beg=sys.argv[4]
rrr_iso_end=sys.argv[5]
rrr_lsm_dir=sys.argv[6]
if IS_arg==8:
     rrr_lsm_org=sys.argv[7]
else:
     rrr_lsm_org=''


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_exp)
print('- '+rrr_lsm_mod)
print('- '+rrr_lsm_frq)
print('- '+rrr_iso_beg)
print('- '+rrr_iso_end)
print('- '+rrr_lsm_dir)
print('- '+rrr_lsm_org)


#*******************************************************************************
#Check if directory exists 
#*******************************************************************************
rrr_lsm_dir=os.path.join(rrr_lsm_dir,'')
#add trailing slash if it is not there

if not os.path.isdir(rrr_lsm_dir):
     os.mkdir(rrr_lsm_dir)


#*******************************************************************************
#Check LDAS arguments
#*******************************************************************************
print('Check LDAS arguments')

if rrr_lsm_exp=='NLDAS' or rrr_lsm_exp=='GLDAS':
     print('- LDAS name is valid')
else:
     print('ERROR - Invalid LDAS name')
     raise SystemExit(22) 

if rrr_lsm_mod=='VIC' or rrr_lsm_mod=='NOAH' or rrr_lsm_mod=='MOS'             \
                      or rrr_lsm_mod=='CLSM':
     print('- Model name is valid')
else:
     print('ERROR - Invalid model name')
     raise SystemExit(22) 

if rrr_lsm_frq=='H' or rrr_lsm_frq=='M' or rrr_lsm_frq=='3H':
     print('- Data frequency is valid')
else:
     print('ERROR - Invalid data frequency')
     raise SystemExit(22) 


#*******************************************************************************
#Check temporal information
#*******************************************************************************
print('Check temporal information')

rrr_dat_beg=datetime.datetime.strptime(rrr_iso_beg,'%Y-%m-%dT%H:%M:%S')
rrr_dat_end=datetime.datetime.strptime(rrr_iso_end,'%Y-%m-%dT%H:%M:%S')

if rrr_dat_end>=rrr_dat_beg:
     print('- Beginning of interval is before end of interval')
else:
     print('ERROR - Beginning of interval is NOT before end of interval')
     raise SystemExit(22) 

rrr_dat_stp=rrr_dat_beg
IS_count=0
#Initialized when to stop downloading and the number of files to download

#-------------------------------------------------------------------------------
#If requesting hourly data
#-------------------------------------------------------------------------------
if rrr_lsm_frq=='H':
     if rrr_dat_beg.minute==0 and rrr_dat_beg.second==0:
          print('- Interval starts at the top of an hour')
     else:
          print('ERROR - The interval does NOT start at the top of an hour: '  \
                +rrr_iso_beg)
          raise SystemExit(22) 

     while rrr_dat_stp<=rrr_dat_end:
          rrr_dat_stp=rrr_dat_stp+datetime.timedelta(hours=1)
          #Adding one hour
          IS_count=IS_count+1
     print('- The number of files to be downloaded is: '+str(IS_count))

#-------------------------------------------------------------------------------
#If requesting 3-hourly data
#-------------------------------------------------------------------------------
if rrr_lsm_frq=='3H':
     if rrr_dat_beg.hour %3==0 and rrr_dat_beg.minute==0 and                   \
        rrr_dat_beg.second==0:
          print('- Interval starts at the top of a 3-hour')
     else:
          print('ERROR - The interval does NOT start at the top of a 3-hour: ' \
                +rrr_iso_beg)
          raise SystemExit(22) 

     while rrr_dat_stp<=rrr_dat_end:
          rrr_dat_stp=rrr_dat_stp+datetime.timedelta(hours=3)
          #Adding one hour
          IS_count=IS_count+1
     print('- The number of files to be downloaded is: '+str(IS_count))

#-------------------------------------------------------------------------------
#If requesting monthly data
#-------------------------------------------------------------------------------
if rrr_lsm_frq=='M':
     if rrr_dat_beg.day==1 and rrr_dat_beg.hour==0 and                         \
        rrr_dat_beg.minute==0 and rrr_dat_beg.second==0:
          print('- Interval starts at the top of a month')
     else:
          print('ERROR - The interval does NOT start at the top of a month: '  \
                +rrr_iso_beg)
          raise SystemExit(22) 

     while rrr_dat_stp<=rrr_dat_end:
          rrr_dat_stp=(rrr_dat_stp+datetime.timedelta(days=32)).replace(day=1)
          #Adding one month done by adding 32 days and replacing the day by 1
          IS_count=IS_count+1
     print('- The number of files to be downloaded is: '+str(IS_count))


#*******************************************************************************
#Check if retaining LDAS directory structure
#*******************************************************************************
print('Check if retaining LDAS directory structure')

if rrr_lsm_org=='org_no':
     print('- Not retaining LDAS directory structure')

if (rrr_lsm_org!='org_no') and (rrr_lsm_org!=''):
     print('ERROR: '+rrr_lsm_org+' does not match org_no')
     raise SystemExit(22)


#*******************************************************************************
#Obtaining credentials for the server from a local file
#*******************************************************************************
print('Obtaining credentials for the server from a local file')

url='https://urs.earthdata.nasa.gov'
print('- '+url)

cred=requests.utils.get_netrc_auth(url)
if cred!=None:
     print('- The credentials were obtained from ~/.netrc file')
else:
     print('ERROR - Credentials not available in ~/.netrc file')
     raise SystemExit(22)

cred_obj=requests.auth.HTTPDigestAuth(cred[0],cred[1])


#*******************************************************************************
#Checking that service and credentials work for one known file
#*******************************************************************************

#-------------------------------------------------------------------------------
#If requesting NLDAS hourly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='NLDAS' and rrr_lsm_frq=='H':
     print('Checking that service and credentials work for one known file')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/NLDAS/NLDAS_VIC0125_H.002/2000/001/'           \
                        +'NLDAS_VIC0125_H.A20000101.0000.002.grb'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='25,-125,53,-67'
     payload['LABEL']='NLDAS_VIC0125_H.A20000101.0000.002.grb.SUB.nc4'
     payload['SHORTNAME']='NLDAS_VIC0125_H'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='002'
     payload['VARIABLES']='BGRUN,SSRUN'

     print('- Requesting a subset of NLDAS_VIC0125_H.A20000101.0000.002.grb')
     r=requests.get(url, params=payload, auth=cred_obj)
     #Downloads data from:
     #https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi
     #     ?FILENAME=/data/NLDAS/NLDAS_VIC0125_H.002/2000/001/
     #     NLDAS_VIC0125_H.A20000101.0000.002.grb
     #     &FORMAT=bmM0Lw
     #     &BBOX=25,-125,53,-67
     #     &LABEL=NLDAS_VIC0125_H.A20000101.0000.002.grb.SUB.nc4
     #     &SHORTNAME=NLDAS_VIC0125_H
     #     &SERVICE=L34RS_LDAS
     #     &VERSION=1.02
     #     &DATASET_VERSION=002
     #     &VARIABLES=BGRUN,SSRUN'
     #requests.get() actually downloads the file into memory and also saves some
     #associated download metadata
     if r.ok:
          print('- The request was successful')
     else:
          print('ERROR - Status code '+str(r.status_code))
          raise SystemExit(22)

#-------------------------------------------------------------------------------
#If requesting NLDAS monthly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='NLDAS' and rrr_lsm_frq=='M':
     print('Checking that service and credentials work for one known file')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/NLDAS/NLDAS_VIC0125_M.002/2000/'               \
                        +'NLDAS_VIC0125_M.A200001.002.grb'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='25,-125,53,-67'
     payload['LABEL']='NLDAS_VIC0125_M.A200001.002.grb.SUB.nc4'
     payload['SHORTNAME']='NLDAS_VIC0125_M'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='002'
     payload['VARIABLES']='BGRUN,SSRUN'

     print('- Requesting a subset of NLDAS_VIC0125_M.A200001.002.grb')
     r=requests.get(url, params=payload, auth=cred_obj)
     #Downloads data from:
     #https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi
     #     ?FILENAME=/data/NLDAS/NLDAS_VIC0125_M.002/2000/
     #     NLDAS_VIC0125_M.A200001.002.grb
     #     &FORMAT=bmM0Lw
     #     &BBOX=25,-125,53,-67
     #     &LABEL=NLDAS_VIC0125_M.A200001.002.grb.SUB.nc4
     #     &SHORTNAME=NLDAS_VIC0125_M
     #     &SERVICE=L34RS_LDAS
     #     &VERSION=1.02
     #     &DATASET_VERSION=002
     #     &VARIABLES=BGRUN,SSRUN'
     #requests.get() actually downloads the file into memory and also saves some
     #associated download metadata
     if r.ok:
          print('- The request was successful')
     else:
          print('ERROR - Status code '+str(r.status_code))
          raise SystemExit(22)

#-------------------------------------------------------------------------------
#If requesting GLDAS 3-hourly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='GLDAS' and rrr_lsm_frq=='3H':
     print('Checking that service and credentials work for one known file')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/GLDAS/GLDAS_VIC10_3H.2.0/2000/001/'            \
                        +'GLDAS_VIC10_3H.A20000101.0000.020.nc4'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='-60,-180,90,180'
     payload['LABEL']='GLDAS_VIC10_3H.A20000101.0000.020.nc4.SUB.nc4'
     payload['SHORTNAME']='GLDAS_VIC10_3H'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='2.0'
     payload['VARIABLES']='Qs_acc,Qsb_acc'

     print('- Requesting a subset of GLDAS_VIC10_3H.A2000001.0000.001.grb')
     r=requests.get(url, params=payload, auth=cred_obj)
     #Downloads data from:
     #https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi
     #     ?FILENAME=/data/GLDAS/GLDAS_VIC10_3H.2.0/2000/001/
     #     GLDAS_VIC10_3H.A20000101.0000.020.nc4
     #     &FORMAT=bmM0Lw
     #     &BBOX=-60,-180,90,-180
     #     &LABEL=GLDAS_VIC10_3H.A20000101.0000.020.nc4.SUB.nc4
     #     &SHORTNAME=GLDAS_VIC10_3H
     #     &SERVICE=L34RS_LDAS
     #     &VERSION=1.02
     #     &DATASET_VERSION=2.0
     #     &VARIABLES=Qs_acc,Qsb_acc'
     #requests.get() actually downloads the file into memory and also saves some
     #associated download metadata
     if r.ok:
          print('- The request was successful')
     else:
          print('ERROR - Status code '+str(r.status_code))
          raise SystemExit(22)

#-------------------------------------------------------------------------------
#If requesting GLDAS monthly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='GLDAS' and rrr_lsm_frq=='M':
     print('Checking that service and credentials work for one known file')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/GLDAS/GLDAS_VIC10_M.2.0/2000/'             \
                        +'GLDAS_VIC10_M.A200001.020.nc4'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='-60,-180,90,180'
     payload['LABEL']='GLDAS_VIC10_M.A200001.020.nc4.SUB.nc4'
     payload['SHORTNAME']='GLDAS_VIC10_M'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='2.0'
     payload['VARIABLES']='Qs_acc,Qsb_acc'

     print('- Requesting a subset of GLDAS_VIC10_M.A200001.020.nc4')
     r=requests.get(url, params=payload, auth=cred_obj)
     #Downloads data from:
     #https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi
     #     ?FILENAME=/data/GLDAS/GLDAS_VIC10_M.2.0/2000/
     #     GLDAS_VIC10_M.A200001.020.nc4
     #     &FORMAT=bmM0Lw
     #     &BBOX=-60,-180,90,180
     #     &LABEL=GLDAS_VIC10_M.A200001.020.nc4.SUB.nc4
     #     &SHORTNAME=GLDAS_VIC10_M
     #     &SERVICE=L34RS_LDAS
     #     &VERSION=1.02
     #     &DATASET_VERSION=2.0
     #     &VARIABLES=Qs_acc,Qsb_acc
     #requests.get() actually downloads the file into memory and also saves some
     #associated download metadata
     if r.ok:
          print('- The request was successful')
     else:
          print('ERROR - Status code '+str(r.status_code))
          raise SystemExit(22)

#*******************************************************************************
#Downloading all files
#*******************************************************************************
print('Downloading all files')

#-------------------------------------------------------------------------------
#Creating a networking session and assigning associated credentials
#-------------------------------------------------------------------------------
print('- Creating a networking session and assigning associated credentials')

s=requests.Session()
s.auth=cred_obj

#-------------------------------------------------------------------------------
#If requesting NLDAS hourly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='NLDAS' and rrr_lsm_frq=='H':

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Initializing URL and payload
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Initializing URL and payload')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/NLDAS/NLDAS_VIC0125_H.002/2000/001/'                \
                        +'NLDAS_VIC0125_H.A20000101.0000.002.grb'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='25,-125,53,-67'
     payload['LABEL']='NLDAS_VIC0125_H.A20000101.0000.002.grb.SUB.nc4'
     payload['SHORTNAME']='NLDAS_VIC0125_H'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='002'
     payload['VARIABLES']='BGRUN,SSRUN'

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Looping over all files
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Looping over all files')

     rrr_dat_cur=rrr_dat_beg
     for JS_count in range(IS_count):
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Determine current datetime and various date strings
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_yr=rrr_dat_cur.strftime('%Y')
          YS_mo=rrr_dat_cur.strftime('%m')
          YS_da=rrr_dat_cur.strftime('%d')
          YS_hr=rrr_dat_cur.strftime('%H')
          YS_dy=rrr_dat_cur.strftime('%j')
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Generate file name
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          payload['FILENAME']='/data/NLDAS/NLDAS_'+rrr_lsm_mod+'0125_H.002/'   \
                             +YS_yr+'/'+YS_dy+'/'                              \
                             +'NLDAS_'+rrr_lsm_mod+'0125_H.A'+YS_yr+YS_mo+YS_da\
                             +'.'+YS_hr+'00.002.grb'
          payload['LABEL']   ='NLDAS_'+rrr_lsm_mod+'0125_H.A'+YS_yr+YS_mo+YS_da\
                             +'.'+YS_hr+'00.002.grb.SUB.nc4'
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Create directory if it doesn't exist
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_dir='NLDAS_'+rrr_lsm_mod+'0125_H.002/'+YS_yr+'/'+YS_dy+'/'
          if rrr_lsm_org=='org_no': YS_dir='/'
          if not os.path.isdir(rrr_lsm_dir+YS_dir):
               os.makedirs(rrr_lsm_dir+YS_dir)
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Place request if file does not already exist, and check it is ok
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          if os.path.isfile(rrr_lsm_dir+YS_dir+payload['LABEL']):
               print(' . Skipping '+payload['LABEL'])
          else:
               print(' . Downloading '+payload['LABEL'])
               r=s.get(url, params=payload)
               if not r.ok:
                    print('ERROR - status code '+str(r.status_code)+           \
                          'returned when downloading '+payload['FILENAME'])
                    raise SystemExit(22)
               YS_name=r.headers['content-disposition']
               YS_name=YS_name.replace('attachment; filename=','')
               YS_name=YS_name.replace('"','')
               #The file name is extracted directly from requests.get() results
               open(rrr_lsm_dir+YS_dir+YS_name, 'wb').write(r.content)
               #The file is written on local disk
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Increment current datetime
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          rrr_dat_cur=rrr_dat_cur+datetime.timedelta(hours=1)
     
#-------------------------------------------------------------------------------
#If requesting NLDAS monthly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='NLDAS' and rrr_lsm_frq=='M':

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Initializing URL and payload
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Initializing URL and payload')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/NLDAS/NLDAS_VIC0125_M.002/2000/'               \
                        +'NLDAS_VIC0125_M.A200001.002.grb'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='25,-125,53,-67'
     payload['LABEL']='NLDAS_VIC0125_M.A200001.002.grb.SUB.nc4'
     payload['SHORTNAME']='NLDAS_VIC0125_M'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='002'
     payload['VARIABLES']='BGRUN,SSRUN'

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Looping over all files
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Looping over all files')

     rrr_dat_cur=rrr_dat_beg
     for JS_count in range(IS_count):
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Determine current datetime and various date strings
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_yr=rrr_dat_cur.strftime('%Y')
          YS_mo=rrr_dat_cur.strftime('%m')
          YS_da=rrr_dat_cur.strftime('%d')
          YS_hr=rrr_dat_cur.strftime('%H')
          YS_dy=rrr_dat_cur.strftime('%j')
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Generate file name
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          payload['FILENAME']='/data/NLDAS/NLDAS_'+rrr_lsm_mod+'0125_M.002/'   \
                             +YS_yr+'/'               \
                             +'NLDAS_'+rrr_lsm_mod+'0125_M.A'+YS_yr+''+YS_mo   \
                             +'.002.grb'
          payload['LABEL']   ='NLDAS_'+rrr_lsm_mod+'0125_M.A'+YS_yr+''+YS_mo   \
                             +'.002.grb.SUB.nc4'
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Create directory if it doesn't exist
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_dir='NLDAS_'+rrr_lsm_mod+'0125_M.002/'+YS_yr+'/'
          if rrr_lsm_org=='org_no': YS_dir='/'
          if not os.path.isdir(rrr_lsm_dir+YS_dir):
               os.makedirs(rrr_lsm_dir+YS_dir)
          #Update directory name and make sure it exists
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Place request if file does not already exist, and check it is ok
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          if os.path.isfile(rrr_lsm_dir+YS_dir+payload['LABEL']):
               print(' . Skipping '+payload['LABEL'])
          else:
               print(' . Downloading '+payload['LABEL'])
               r=s.get(url, params=payload)
               if not r.ok:
                    print('ERROR - status code '+str(r.status_code)+           \
                          'returned when downloading '+payload['FILENAME'])
                    raise SystemExit(22)
               YS_name=r.headers['content-disposition']
               YS_name=YS_name.replace('attachment; filename=','')
               YS_name=YS_name.replace('"','')
               #The file name is extracted directly from requests.get() results
               open(rrr_lsm_dir+YS_dir+YS_name, 'wb').write(r.content)
               #The file is written on local disk
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Increment current datetime
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          rrr_dat_cur=(rrr_dat_cur+datetime.timedelta(days=32)).replace(day=1)

#-------------------------------------------------------------------------------
#If requesting GLDAS 3-hourly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='GLDAS' and rrr_lsm_frq=='3H':

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Initializing URL and payload
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Initializing URL and payload')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/GLDAS/GLDAS_VIC10_3H.2.0/2000/001/'            \
                        +'GLDAS_VIC10_3H.A20000101.0000.020.nc4'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='-60,-180,90,180'
     payload['LABEL']='GLDAS_VIC10_3H.A20000101.0000.020.nc4.SUB.nc4'
     payload['SHORTNAME']='GLDAS_VIC10_3H'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='2.0'
     payload['VARIABLES']='Qs_acc,Qsb_acc'

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Looping over all files
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Looping over all files')

     rrr_dat_cur=rrr_dat_beg
     for JS_count in range(IS_count):
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Determine current datetime and various date strings
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_yr=rrr_dat_cur.strftime('%Y')
          YS_mo=rrr_dat_cur.strftime('%m')
          YS_da=rrr_dat_cur.strftime('%d')
          YS_hr=rrr_dat_cur.strftime('%H')
          YS_dy=rrr_dat_cur.strftime('%j')
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Generate file name
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          payload['FILENAME']='/data/GLDAS/GLDAS_'+rrr_lsm_mod+'10_3H.2.0/'    \
                             +YS_yr+'/'+YS_dy+'/'                              \
                             +'GLDAS_'+rrr_lsm_mod+'10_3H.A'+YS_yr+YS_mo+YS_da \
                             +'.'+YS_hr+'00.020.nc4'
          payload['LABEL']   ='GLDAS_'+rrr_lsm_mod+'10_3H.A'+YS_yr+YS_mo+YS_da \
                             +'.'+YS_hr+'00.020.nc4.SUB.nc4'
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Create directory if it doesn't exist
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_dir='GLDAS_'+rrr_lsm_mod+'10_3H.2.0/'+YS_yr+'/'+YS_dy+'/'
          if rrr_lsm_org=='org_no': YS_dir='/'
          if not os.path.isdir(rrr_lsm_dir+YS_dir):
               os.makedirs(rrr_lsm_dir+YS_dir)
          #Update directory name and make sure it exists
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Place request if file does not already exist, and check it is ok
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          if os.path.isfile(rrr_lsm_dir+YS_dir+payload['LABEL']):
               print(' . Skipping '+payload['LABEL'])
          else:
               print(' . Downloading '+payload['LABEL'])
               r=s.get(url, params=payload)
               if not r.ok:
                    print('ERROR - status code '+str(r.status_code)+           \
                          'returned when downloading '+payload['FILENAME'])
                    raise SystemExit(22)
               YS_name=r.headers['content-disposition']
               YS_name=YS_name.replace('attachment; filename=','')
               YS_name=YS_name.replace('"','')
               #The file name is extracted directly from requests.get() results
               open(rrr_lsm_dir+YS_dir+YS_name, 'wb').write(r.content)
               #The file is written on local disk
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Increment current datetime
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          rrr_dat_cur=rrr_dat_cur+datetime.timedelta(hours=3)
     
#-------------------------------------------------------------------------------
#If requesting GLDAS monthly data
#-------------------------------------------------------------------------------
if rrr_lsm_exp=='GLDAS' and rrr_lsm_frq=='M':

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Initializing URL and payload
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Initializing URL and payload')

     url='https://hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi'
     payload={}
     payload['FILENAME']='/data/GLDAS/GLDAS_VIC10_M.2.0/2000/'             \
                        +'GLDAS_VIC10_M.A200001.020.nc4'
     payload['FORMAT']='bmM0Lw'
     payload['BBOX']='-60,-180,90,180'
     payload['LABEL']='GLDAS_VIC10_M.A200001.020.nc4.SUB.nc4'
     payload['SHORTNAME']='GLDAS_VIC10_M'
     payload['SERVICE']='L34RS_LDAS'
     payload['VERSION']='1.02'
     payload['DATASET_VERSION']='2.0'
     payload['VARIABLES']='Qs_acc,Qsb_acc'

     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     #Looping over all files
     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     print('- Looping over all files')

     rrr_dat_cur=rrr_dat_beg
     for JS_count in range(IS_count):
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Determine current datetime and various date strings
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_yr=rrr_dat_cur.strftime('%Y')
          YS_mo=rrr_dat_cur.strftime('%m')
          YS_da=rrr_dat_cur.strftime('%d')
          YS_hr=rrr_dat_cur.strftime('%H')
          YS_dy=rrr_dat_cur.strftime('%j')
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Generate file name
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          payload['FILENAME']='/data/GLDAS/GLDAS_'+rrr_lsm_mod+'10_M.2.0/'     \
                             +YS_yr+'/'                                        \
                             +'GLDAS_'+rrr_lsm_mod+'10_M.A'+YS_yr+YS_mo        \
                             +'.020.nc4'
          payload['LABEL']   ='GLDAS_'+rrr_lsm_mod+'10_M.A'+YS_yr+YS_mo        \
                             +'.020.nc4.SUB.nc4'
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Create directory if it doesn't exist
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          YS_dir='GLDAS_'+rrr_lsm_mod+'10_M.2.0/'+YS_yr+'/'
          if rrr_lsm_org=='org_no': YS_dir='/'
          if not os.path.isdir(rrr_lsm_dir+YS_dir):
               os.makedirs(rrr_lsm_dir+YS_dir)
          #Update directory name and make sure it exists
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Place request if file does not already exist, and check it is ok
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          if os.path.isfile(rrr_lsm_dir+YS_dir+payload['LABEL']):
               print(' . Skipping '+payload['LABEL'])
          else:
               print(' . Downloading '+payload['LABEL'])
               r=s.get(url, params=payload)
               if not r.ok:
                    print('ERROR - status code '+str(r.status_code)+           \
                          'returned when downloading '+payload['FILENAME'])
                    raise SystemExit(22)
               YS_name=r.headers['content-disposition']
               YS_name=YS_name.replace('attachment; filename=','')
               YS_name=YS_name.replace('"','')
               #The file name is extracted directly from requests.get() results
               open(rrr_lsm_dir+YS_dir+YS_name, 'wb').write(r.content)
               #The file is written on local disk
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          #Increment current datetime
          #- + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + - + -
          rrr_dat_cur=(rrr_dat_cur+datetime.timedelta(days=32)).replace(day=1)

#-------------------------------------------------------------------------------
#Closing the networking session
#-------------------------------------------------------------------------------
print('- Closing the networking session')

s.close()


#*******************************************************************************
#End
#*******************************************************************************
