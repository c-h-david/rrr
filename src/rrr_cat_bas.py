#!/usr/bin/env python
#*******************************************************************************
#rrr_cat_bas.py
#*******************************************************************************

#Purpose:
#Given a catchment file (CSV) and a list of river IDs (CSV), this program
#creates a new catchment file (CSV) that is a subset of the original file with
#the following information:
# - rrr_cat_csv 
#   . Catchment ID
#   . Catchment contributing area in square kilometers
#   . Longitude of catchment centroid 
#   . Latitude of catchment centroid 
#Author:
#Cedric H. David, 2020-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_cat_csv
# 2 - rrr_bas_csv
# 3 - rrr_cbs_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22) 

rrr_cat_csv=sys.argv[1]
rrr_bas_csv=sys.argv[2]
rrr_cbs_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_cat_csv)
print('- '+rrr_bas_csv)
print('- '+rrr_cbs_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_cat_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_cat_csv)
     raise SystemExit(22) 

try:
     with open(rrr_bas_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_bas_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Reading catchment file
#*******************************************************************************
print('Reading catchment file')

IV_cat_tot_id=[]
ZV_cat_tot_skm=[]
ZV_cat_tot_lon=[]
ZV_cat_tot_lat=[]
with open(rrr_cat_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_cat_tot_id.append(int(row[0]))
          ZV_cat_tot_skm.append(float(row[1]))
          ZV_cat_tot_lon.append(float(row[2]))
          ZV_cat_tot_lat.append(float(row[3]))

IS_cat_tot=len(IV_cat_tot_id)
print('- Number of catchments in rrr_cat_csv: '+str(IS_cat_tot))


#*******************************************************************************
#Reading basin file
#*******************************************************************************
print('Reading basin file')

IV_riv_bas_id=[]
with open(rrr_bas_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_bas_id.append(int(row[0]))

IS_riv_bas=len(IV_riv_bas_id)
print('- Number of river reaches in rrr_bas_csv: '+str(IS_riv_bas))


#*******************************************************************************
#Creating hash table
#*******************************************************************************
print('Creating hash table')

IM_hsh={}
for JS_cat_tot in range(IS_cat_tot):
     IM_hsh[IV_cat_tot_id[JS_cat_tot]]=JS_cat_tot

print("- Hash table created")


#*******************************************************************************
#Checking all river reaches in basin are in catchment file
#*******************************************************************************
print('Checking all river reaches in basin are in catchment file')

for JS_riv_bas in range(IS_riv_bas):
     if IV_riv_bas_id[JS_riv_bas] not in IM_hsh:
          print('ERROR - river ID '+str(IV_riv_bas_id[JS_riv_bas])+' not in '  \
                +rrr_cat_csv)
          raise SystemExit(22) 
     
print("- Success")


#*******************************************************************************
#Creating new catchment information
#*******************************************************************************
print('Creating new catchment information')

IV_riv_bas_id_srt=IV_riv_bas_id
IV_riv_bas_id_srt.sort()

IV_cat_bas_id=[-9999]*IS_riv_bas
ZV_cat_bas_skm=[-9999]*IS_riv_bas
ZV_cat_bas_lon=[-9999]*IS_riv_bas
ZV_cat_bas_lat=[-9999]*IS_riv_bas
for JS_riv_bas in range(IS_riv_bas):
     JS_cat_tot=IM_hsh[IV_riv_bas_id_srt[JS_riv_bas]]
     IV_cat_bas_id[JS_riv_bas] =IV_cat_tot_id[JS_cat_tot]
     ZV_cat_bas_skm[JS_riv_bas]=ZV_cat_tot_skm[JS_cat_tot]
     ZV_cat_bas_lon[JS_riv_bas]=ZV_cat_tot_lon[JS_cat_tot]
     ZV_cat_bas_lat[JS_riv_bas]=ZV_cat_tot_lat[JS_cat_tot]

print("- Done")


#*******************************************************************************
#Writing new catchment file
#*******************************************************************************
print('Writing new catchment file')
with open(rrr_cbs_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_bas in range(IS_riv_bas):
          IV_line=[IV_cat_bas_id[JS_riv_bas],                                  \
                   ZV_cat_bas_skm[JS_riv_bas],                                 \
                   ZV_cat_bas_lon[JS_riv_bas],                                 \
                   ZV_cat_bas_lat[JS_riv_bas]]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
