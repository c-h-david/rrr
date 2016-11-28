#!/usr/bin/python
#*******************************************************************************
#rrr_riv_bas_gen_one_hydrosheds.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from HydroSHEDS, a connectivity table and associated 
#sorting integer, this program creates a csv file with the following 
#information:
# - rrr_riv_csv
#   . River ID (sorted from upstream to downstream)
#Author:
#Cedric H. David, 2014-2016


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - hsd_riv_shp
# 2 - rrr_con_csv
# 3 - rrr_srt_csv
# 4 - rrr_riv_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

hsd_riv_shp=sys.argv[1]
rrr_con_csv=sys.argv[2]
rrr_srt_csv=sys.argv[3]
rrr_riv_csv=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+hsd_riv_shp)
print('- '+rrr_srt_csv)
print('- '+rrr_riv_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(hsd_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+hsd_riv_shp)
     raise SystemExit(22) 

try:
     with open(rrr_con_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_csv)
     raise SystemExit(22) 

try:
     with open(rrr_srt_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_srt_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Reading input files
#*******************************************************************************
print('Reading input files')

#-------------------------------------------------------------------------------
#Reading river shapefile
#-------------------------------------------------------------------------------
print('- Reading river shapefile')

hsd_riv_lay=fiona.open(hsd_riv_shp, 'r')
IS_riv_bas=len(hsd_riv_lay)
print(' . Number of river reaches in rrr_riv_shp: '+str(IS_riv_bas))

if 'ARCID' in hsd_riv_lay[0]['properties']:
     YV_riv_id='ARCID'
else:
     print('ERROR - ARCID does not exist in '+hsd_riv_shp)
     raise SystemExit(22) 

IV_riv_bas_id=[]
for JS_riv_bas in range(IS_riv_bas):
     hsd_riv_prp=hsd_riv_lay[JS_riv_bas]['properties']
     IV_riv_bas_id.append(int(hsd_riv_prp[YV_riv_id]))

#-------------------------------------------------------------------------------
#Reading connectivity file
#-------------------------------------------------------------------------------
print('- Reading connectivity file')
IV_riv_tot_id=[]
with open(rrr_con_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id.append(int(row[0]))
IS_riv_tot1=len(IV_riv_tot_id)
print(' . Number of river reaches in rrr_con_csv: '+str(IS_riv_tot1))

#-------------------------------------------------------------------------------
#Reading sort file
#-------------------------------------------------------------------------------
print('- Reading sort file')
IV_riv_tot_sort=[]
with open(rrr_srt_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_sort.append(int(row[0]))
IS_riv_tot2=len(IV_riv_tot_sort)
print(' . Number of river reaches in rrr_srt_csv: '+str(IS_riv_tot2))


#*******************************************************************************
#Check that sizes of rrr_con_csv and rrr_srt_csv are the same
#*******************************************************************************
if IS_riv_tot1==IS_riv_tot2:
     IS_riv_tot=IS_riv_tot1
else:
     print('ERROR - The number of river reaches in rrr_con_csv and in ' \
           'rrr_srt_csv differ')
     raise SystemExit(22) 
     

#*******************************************************************************
#Assign sort values to each reach in basin
#*******************************************************************************
IM_hsh={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

IV_riv_bas_sort=[]
for JS_riv_bas in range(IS_riv_bas):
     if IV_riv_bas_id[JS_riv_bas] in IM_hsh:
          JS_riv_tot=IM_hsh[IV_riv_bas_id[JS_riv_bas]]
          IV_riv_bas_sort.append(IV_riv_tot_sort[JS_riv_tot])
     else:
          print('ERROR - Reach ID '+str(IV_riv_bas_id[JS_riv_bas])+'is not in '\
                'rrr_con_csv')
          raise SystemExit(22) 


#*******************************************************************************
#Sort files
#*******************************************************************************
print('Sorting')
z=zip(*sorted(zip(IV_riv_bas_sort,IV_riv_bas_id), reverse=True,                \
              key=lambda x: x[0])    )
IV_riv_bas_sort2, IV_riv_bas_id2=z

#print(IV_riv_bas_sort2[0])
#print(IV_riv_bas_sort[0])


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing file')

with open(rrr_riv_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_bas in range(IS_riv_bas):
          csvwriter.writerow([IV_riv_bas_id2[JS_riv_bas]]) 


#*******************************************************************************
#End
#*******************************************************************************
