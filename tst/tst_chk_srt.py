#!/usr/bin/env python
#*******************************************************************************
#tst_chk_srt.py
#*******************************************************************************

#Purpose:
#Given a river connectivity file and a river ID file, this program checks that 
#the river ID file is sorted from upstream to downstream.  The river ID file 
#can contain all the rivers of the domain, or only a subset of it.  
#Author:
#Cedric H. David, 2007-2020


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_con_file
# 2 - rrr_riv_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 3 or IS_arg > 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

rrr_con_file=sys.argv[1]
rrr_riv_file=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_con_file)
print('- '+rrr_riv_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_con_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_file)
     raise SystemExit(22) 

try:
     with open(rrr_riv_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read files
#*******************************************************************************
print('Reading input files')

#-------------------------------------------------------------------------------
#rrr_con_file
#-------------------------------------------------------------------------------
IV_riv_tot_id=[]
IV_down_id=[]
with open(rrr_con_file,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id.append(int(row[0]))
          IV_down_id.append(int(row[1]))
IS_riv_tot=len(IV_riv_tot_id)
print('- Number of river reaches in rrr_con_file: '+str(IS_riv_tot))

#-------------------------------------------------------------------------------
#rrr_riv_file
#-------------------------------------------------------------------------------
IV_riv_bas_id=[]
with open(rrr_riv_file,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_bas_id.append(int(row[0]))
IS_riv_bas=len(IV_riv_bas_id)
print('- Number of river reaches in rrr_riv_file: '+str(IS_riv_bas))


#*******************************************************************************
#Checking upstream to downstream sorting 
#*******************************************************************************
print('Checking upstream to downstream sorting')

#-------------------------------------------------------------------------------
#Create hash table
#-------------------------------------------------------------------------------
IM_hsh={}
for JS_riv_bas in range(IS_riv_bas):
     IM_hsh[IV_riv_bas_id[JS_riv_bas]]=JS_riv_bas
#This hash table contains the index of each reach ID in rrr_riv_file

#-------------------------------------------------------------------------------
#Check sorting
#-------------------------------------------------------------------------------
for JS_riv_tot in range(IS_riv_tot):
#Looping through all reach IDs in rrr_con_file
     if IV_riv_tot_id[JS_riv_tot] in IM_hsh:
     #Checking that the reach ID in rrr_con_file is in rrr_riv_file
          JS_riv_bas1=IM_hsh[IV_riv_tot_id[JS_riv_tot]]
          #JS_riv_bas1 is the index of reach ID in rrr_riv_file
          if IV_down_id[JS_riv_tot] in IM_hsh:
          #checking that the ID downstream of JS_riv_bas1 is in rrr_riv_file
               JS_riv_bas2=IM_hsh[IV_down_id[JS_riv_tot]]
               #JS_riv_bas2 is the index of the downstream ID in rrr_riv_file
          else:
               JS_riv_bas2=IS_riv_bas
               #Largest value if downstream ID not in rrr_riv_file (also 
               #applies to ID=0. 
          if JS_riv_bas1 > JS_riv_bas2:
          #checking that ID downstream is not earlier in rrr_riv_file
               print('ERROR - rrr_riv_file not sorted from upstream to '       \
                     'downstream')
               print('Reach ID '+str(IV_riv_tot_id[JS_riv_bas1])+              \
                     ' is located above of '+str(IV_down_id[JS_riv_bas1]))
               raise SystemExit(22) 
print('Success!!!')


#*******************************************************************************
#End
#*******************************************************************************
