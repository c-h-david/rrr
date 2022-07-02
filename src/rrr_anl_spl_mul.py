#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_spl_mul.py
#*******************************************************************************

#Purpose:
#Given a CSV file containing a sampling sequence (with river IDs and respective
#times of observations), a repeat cycle, and a number of satellites, this script
#creates a new sampling sequence in which all river IDs that were previously
#sampled by a single satellite are now sampled by multiple equidistant such
#satellites. The river IDs that were never sampled in the previous sequence are
#not either sampled in the new sequence.
#Author:
#Cedric H. David, 2021-2022


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_spl_csv
# 2 - ZS_rep
# 3 - IS_sat
# 4 - rrr_sp2_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

rrr_spl_csv=sys.argv[1]
ZS_rep=float(sys.argv[2])
IS_sat=int(sys.argv[3])
rrr_sp2_csv=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_spl_csv)
print('- '+str(ZS_rep))
print('- '+str(IS_sat))
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
     IV_sp2_cnt[JS_riv_tot]=IS_sat*IV_spl_cnt[JS_riv_tot]
     IM_me2_tim[JS_riv_tot]=[-9999]*IV_sp2_cnt[JS_riv_tot]
     for JS_spl_cnt in range(IV_spl_cnt[JS_riv_tot]):
          for JS_sat in range(IS_sat):
               ZS_me2_tim=IM_mea_tim[JS_riv_tot][JS_spl_cnt]                   \
                         +JS_sat*ZS_rep/IS_sat
               if ZS_me2_tim>=ZS_rep: ZS_me2_tim=ZS_me2_tim-ZS_rep
               if ZS_me2_tim<0: 
                    print('ERROR - ZS_me2_tim is negative: ',ZS_me2_tim)
                    raise SystemExit(22) 
               IM_me2_tim[JS_riv_tot][JS_spl_cnt*IS_sat+JS_sat]=ZS_me2_tim
     IM_me2_tim[JS_riv_tot].sort()
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
