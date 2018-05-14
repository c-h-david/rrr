#!/usr/bin/env python
#*******************************************************************************
#rrr_riv_bas_gen_one_nhdplus.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from NHDPlus, a connectivity table and associated
#sorting integer, this program creates a csv file with the following 
#information:
# - rrr_riv_file
#   . River ID (sorted from upstream to downstream)
#Author:
#Cedric H. David, 2007-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import dbf


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - nhd_riv_file
# 2 - rrr_con_file
# 3 - rrr_srt_file
# 4 - rrr_riv_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

nhd_riv_file=sys.argv[1]
rrr_con_file=sys.argv[2]
rrr_srt_file=sys.argv[3]
rrr_riv_file=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+nhd_riv_file)
print('- '+rrr_srt_file)
print('- '+rrr_riv_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(nhd_riv_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+nhd_riv_file)
     raise SystemExit(22) 

try:
     with open(rrr_con_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_file)
     raise SystemExit(22) 

try:
     with open(rrr_srt_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_srt_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read files
#*******************************************************************************
print('Reading input files')

#-------------------------------------------------------------------------------
#Basin file
#-------------------------------------------------------------------------------
nhd_riv_dbf=dbf.Table(nhd_riv_file)
nhd_riv_dbf.open()

IV_riv_bas_id=[]
for record in nhd_riv_dbf:
     if record['flowdir'].strip()=='With Digitized':
          IV_riv_bas_id.append(record['comid'])    

IS_riv_bas=len(IV_riv_bas_id)

print('- Number of reaches in basin file: '+str(len(nhd_riv_dbf)))
print('- Number of reaches with known dir: '+str(IS_riv_bas))

#-------------------------------------------------------------------------------
#Connectivity file
#-------------------------------------------------------------------------------
IV_riv_tot_id=[]
with open(rrr_con_file,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id.append(int(row[0]))
IS_riv_tot1=len(IV_riv_tot_id)
print('- Number of river reaches in rrr_con_file: '+str(IS_riv_tot1))

#-------------------------------------------------------------------------------
#Sort file
#-------------------------------------------------------------------------------
IV_riv_tot_sort=[]
with open(rrr_srt_file,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_sort.append(int(row[0]))
IS_riv_tot2=len(IV_riv_tot_sort)
print('- Number of river reaches in rrr_srt_file: '+str(IS_riv_tot2))


#*******************************************************************************
#Check that sizes of rrr_con_file and rrr_srt_file are the same
#*******************************************************************************
if IS_riv_tot1==IS_riv_tot2:
     IS_riv_tot=IS_riv_tot1
else:
     print('ERROR - The number of river reaches in rrr_con_file and in '       \
           'rrr_srt_file differ')
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
                'rrr_con_file')
          raise SystemExit(22) 


#*******************************************************************************
#Sort files
#*******************************************************************************
print('Sorting')
z=zip(*sorted(zip(IV_riv_bas_sort,IV_riv_bas_id), reverse=True,                \
              key=lambda x: x[0])    )
IV_riv_bas_sort2, IV_riv_bas_id2=z


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing file')

with open(rrr_riv_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_bas in range(IS_riv_bas):
          csvwriter.writerow([IV_riv_bas_id2[JS_riv_bas]]) 


#*******************************************************************************
#End
#*******************************************************************************
