#!/usr/bin/env python
#*******************************************************************************
#rrr_riv_tot_scl_prm.py
#*******************************************************************************

#Purpose:
#Given first-guess parameter files for the Muskingum k and x values, and 
#associated scaling factors, this program creates a series of csv files with the
#following information:
# - rrr_k_file 
#   . k 
# - rrr_x_file 
#   . x 
#Author:
#Cedric H. David, 2007-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_kfc_file
# 2 - rrr_xfc_file
# 3 - ZS_lk
# 4 - ZS_lx
# 5 - rrr_k_file
# 6 - rrr_x_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 7:
     print('ERROR - 6 and only 6 arguments can be used')
     raise SystemExit(22) 

rrr_kfc_file=sys.argv[1]
rrr_xfc_file=sys.argv[2]
ZS_lk=float(sys.argv[3])
ZS_lx=float(sys.argv[4])
rrr_k_file=sys.argv[5]
rrr_x_file=sys.argv[6]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_kfc_file)
print('- '+rrr_xfc_file)
print('- '+str(ZS_lk))
print('- '+str(ZS_lx))
print('- '+rrr_k_file)
print('- '+rrr_x_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_kfc_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_kfc_file)
     raise SystemExit(22) 

try:
     with open(rrr_xfc_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_xfc_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read files
#*******************************************************************************
print('Reading input files')

#-------------------------------------------------------------------------------
#kfac file
#-------------------------------------------------------------------------------
ZV_kfac=[]
with open(rrr_kfc_file,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_kfac.append(float(row[0]))
IS_riv_tot1=len(ZV_kfac)
print('- Number of river reaches in rrr_kfc_file: '+str(IS_riv_tot1))

#-------------------------------------------------------------------------------
#xfac file
#-------------------------------------------------------------------------------
ZV_xfac=[]
with open(rrr_xfc_file,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_xfac.append(float(row[0]))
IS_riv_tot2=len(ZV_xfac)
print('- Number of river reaches in rrr_xfc_file: '+str(IS_riv_tot2))


#*******************************************************************************
#Check that sizes of rapid_connect_file and sort_file are the same
#*******************************************************************************
if IS_riv_tot1==IS_riv_tot2:
     IS_riv_tot=IS_riv_tot1
else:
     print('ERROR - The number of river reaches in rapid_connect_file and in ' \
           'sort_file differ')
     raise SystemExit(22) 
     

#*******************************************************************************
#Routing parameters
#*******************************************************************************
print('Processing routing parameters')
ZV_k=[float(0)] * IS_riv_tot
ZV_x=[float(0)] * IS_riv_tot

for JS_riv_tot in range(IS_riv_tot):
     ZV_k[JS_riv_tot]=ZV_kfac[JS_riv_tot]*ZS_lk
     ZV_x[JS_riv_tot]=ZV_xfac[JS_riv_tot]*ZS_lx


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing files')

with open(rrr_k_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([ZV_k[JS_riv_tot]]) 

with open(rrr_x_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([ZV_x[JS_riv_tot]]) 


#*******************************************************************************
#End
#*******************************************************************************
