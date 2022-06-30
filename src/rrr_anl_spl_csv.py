#!/usr/bin/env python
#*******************************************************************************
#rrr_anl_spl_csv.py
#*******************************************************************************

#Purpose:
#Given a CSV file containing a sampling sequence (with river IDs and respective
#times of observations) and a time, this script creates a new sampling sequence
#in which all river IDs that were previously sampled at single/multiple times
#are now only sampled together at a unique time. The river IDs that were never
#sampled in the previous sequence are not either sampled in the new sequence.
#Author:
#Cedric H. David, 2021-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_spl_csv
# 2 - ZS_sp2_tim
# 3 - rrr_sp2_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22) 

rrr_spl_csv=sys.argv[1]
ZS_sp2_tim=float(sys.argv[2])
rrr_sp2_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_spl_csv)
print('- '+str(ZS_sp2_tim))
print('- '+rrr_sp2_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_spl_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_spl_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Opening rrr_spl_csv
#*******************************************************************************
print('Opening rrr_spl_csv')

IV_riv_tot_id=[]
IV_spl_cnt=[]
IM_mea_tim=[]
with open(rrr_spl_csv) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          if len(row[2:])==int(row[1]):
               IV_riv_tot_id.append(int(row[0]))
               IV_spl_cnt.append(int(row[1]))
               IM_mea_tim.append(row[2:])
          else:
               print('ERROR - This file is inconsistent: '+rrr_spl_csv)
               raise SystemExit(22) 

IS_riv_tot=len(IV_riv_tot_id)
IS_spl_max=max(IV_spl_cnt)
IS_spl_tot=sum(IV_spl_cnt)
print('- The number of river reaches in subsample file is: '+str(IS_riv_tot))
print('- The maximum number of subsamples per river reach is: '+str(IS_spl_max))
print('- The total number of subsample/river reach pairs is: '+str(IS_spl_tot))


#*******************************************************************************
#Creating new sequence for rrr_sp2_csv
#*******************************************************************************
print('Creating new sequence for rrr_sp2_csv')

IV_sp2_cnt=[0]*IS_riv_tot
IM_me2_tim=[[]]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     if IV_spl_cnt[JS_riv_tot]>0:
          IV_sp2_cnt[JS_riv_tot]=1
          IM_me2_tim[JS_riv_tot]=[ZS_sp2_tim]

IS_sp2_max=max(IV_sp2_cnt)
IS_sp2_tot=sum(IV_sp2_cnt)

print('- The number of river reaches in subsample file is: '+str(IS_riv_tot))
print('- The maximum number of subsamples per river reach is: '+str(IS_sp2_max))
print('- The total number of subsample/river reach pairs is: '+str(IS_sp2_tot))


#*******************************************************************************
#Writing rrr_sp2_csv
#*******************************************************************************
print('Writing rrr_sp2_csv')

with open(rrr_sp2_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IS_riv_id=IV_riv_tot_id[JS_riv_tot]
          IV_line=[IS_riv_id,IV_sp2_cnt[JS_riv_tot]] 
          IV_line=IV_line+IM_me2_tim[JS_riv_tot]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
