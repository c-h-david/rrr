#!/usr/bin/env python2
#*******************************************************************************
#XXXXXXXXXXXXXXXXXX.py
#*******************************************************************************

#Purpose:
################################
#Author:
#Cedric H. David, 2016-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import os.path
import csv
import math


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_st1_csv
# 2 - rrr_st2_csv
# 3 - rrr_sgn_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 4:
     print('ERROR - 3 and only 3 arguments can be used')
     raise SystemExit(22) 

rrr_st1_csv=sys.argv[1]
rrr_st2_csv=sys.argv[2]
rrr_sgn_csv=sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_st1_csv)
print('- '+rrr_st2_csv)
print('- '+rrr_sgn_csv)


#*******************************************************************************
#Check if files and directory exist 
#*******************************************************************************
try:
     with open(rrr_st1_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_st1_csv)
     raise SystemExit(22) 

try:
     with open(rrr_st2_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_st2_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Read statistics files 
#*******************************************************************************
print('Reading statistics files')

ZV_RMSE1=[]
ZV_Nash1=[]
with open(rrr_st1_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_RMSE1.append(float(row[3]))
          ZV_Nash1.append(float(row[4]))
IS_obs_tot1=len(ZV_RMSE1)


ZV_RMSE2=[]
ZV_Nash2=[]
with open(rrr_st2_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_RMSE2.append(float(row[3]))
          ZV_Nash2.append(float(row[4]))
IS_obs_tot2=len(ZV_RMSE2)

if IS_obs_tot1==IS_obs_tot2:
     IS_size=IS_obs_tot1
     print('Common number of stations: '+str(IS_size))
else:
     print('ERROR - The number of stations is different: '                     \
           +str(IS_obs_tot1)+' <> '+str(IS_obs_tot2))
     raise SystemExit(99) 


#*******************************************************************************
#Compute the number of nonzero differences
#*******************************************************************************
ZV_x=ZV_RMSE1
ZV_y=ZV_RMSE2

IS_nonzero=0
for JS_size in range(IS_size):
     if (ZV_y[JS_size]-ZV_x[JS_size]!=0):
          IS_nonzero=IS_nonzero+1
#print(IS_nonzero)


#*******************************************************************************
#Populate D and abs_D (absolute and relative differences, of size IS_nonzero)
#*******************************************************************************
ZV_D=[]
ZV_abs_D=[]

for JS_size in range(IS_size):
     if(ZV_y[JS_size]-ZV_x[JS_size]!=0):
          ZV_D.append(ZV_y[JS_size]-ZV_x[JS_size])
          ZV_abs_D.append(abs(ZV_y[JS_size]-ZV_x[JS_size]))
#print(ZV_D)
#print(ZV_abs_D)


#*******************************************************************************
#Populate sor_abs_D (sorted absolute differences) and store sorting order
#*******************************************************************************
ZV_sor_abs_D=[0]*IS_nonzero
IV_corres=[0]*IS_nonzero

for JS_nonzero in range(IS_nonzero):
     ZV_sor_abs_D[JS_nonzero]=ZV_abs_D[JS_nonzero]
     IV_corres[JS_nonzero]=JS_nonzero
     #copy abs_D into sor_abs_D and initialize IV_corres
#print(ZV_sor_abs_D)
#print(IV_corres)

z = sorted(zip(ZV_sor_abs_D,IV_corres))
ZV_sor_abs_D,IV_corres=zip(*z)
#print(ZV_sor_abs_D)
#print(IV_corres)


#*******************************************************************************
#Populate rank_sor_abs_D (Wilcoxon ranks, no signs yet, ties are averaged 
#*******************************************************************************
ZV_rank_sor_abs_D=[0]*IS_nonzero
for JS_nonzero in range(IS_nonzero):
     ZV_rank_sor_abs_D[JS_nonzero]=JS_nonzero+1
     #ranks without worrying about ties, Wilcoxon ranks start at 1, not 0
#print(ZV_rank_sor_abs_D)

for JS_nonzero in range(IS_nonzero-1):

     IS_ties=0
     for JS_nonzero2 in range(JS_nonzero+1,IS_nonzero):
          if (abs(ZV_sor_abs_D[JS_nonzero]-ZV_sor_abs_D[JS_nonzero2])<=1e-6): 
               #print *, JS_nonzero, JS_nonzero2, 'are equal'
               IS_ties=IS_ties+1
     #print('Number of consecutive ties after '+str(JS_nonzero)+':'             \
     #      +str(IS_ties))
     #Here are computed the number of consecutive ties after JS_nonzero

     if (IS_ties!=0): 
          ZS_temp=sum(ZV_rank_sor_abs_D[JS_nonzero:JS_nonzero+1+IS_ties])      \
                 /(IS_ties+1)
          for JS_nonzero2 in range(JS_nonzero,JS_nonzero+IS_ties):
               ZV_rank_sor_abs_D[JS_nonzero2]=ZS_temp
     #If there is at least one tie after JS_nonzero, then all of the ranks are
     #averaged, and the same value is assigned to all
     #Ties now assigned the same rank
#print(ZV_rank_sor_abs_D)


#*******************************************************************************
#Populate R (these are the Wilcoxon signed-ranks)
#*******************************************************************************
ZV_R=[0]*IS_size

JS_nonzero=-1 #Because Python indexing is zero-based
for JS_size in range(IS_size):
     if(ZV_y[JS_size]-ZV_x[JS_size]!=0):
          JS_nonzero=JS_nonzero+1
          for JS_nonzero2 in range(IS_nonzero):
               if (IV_corres[JS_nonzero2]==JS_nonzero):
                    ZV_R[JS_size]=math.copysign(ZV_rank_sor_abs_D[JS_nonzero2],\
                                                ZV_D[JS_nonzero])
                    #ZV_rank_sor_abs and ZV_D have same size (IS_nonzero) but 
                    #not same ordering
#print(ZV_R)


#*******************************************************************************
#Compute total rank, W+ and W- 
#*******************************************************************************
ZS_totalrank=0
for JS_nonzero in range(IS_nonzero):
     ZS_totalrank=ZS_totalrank+JS_nonzero+1
     #+1 added from because Python indexing is zero-based

IS_Splus=0
IS_Sminus=0
ZS_Wplus=0
ZS_Wminus=0

for JS_size in range(IS_size):
     if(ZV_R[JS_size]>0): 
          IS_Splus=IS_Splus+1    
     if(ZV_R[JS_size]<0):
          IS_Sminus=IS_Sminus+1    
     if(ZV_R[JS_size]>0):
          ZS_Wplus=ZS_Wplus+ZV_R[JS_size]    
     if(ZV_R[JS_size]<0):
          ZS_Wminus=ZS_Wminus-ZV_R[JS_size]    

print('Common size of two samples (N)    :'+ str(IS_size))
print('Number of non-zero differences (n):'+ str(IS_nonzero))

print('Sign test                         :')
print('S+                                :'+ str(IS_Splus))
print('S-                                :'+ str(IS_Sminus))

print('Wilcoxon signed-ranks test        :')
print('Total rank should be              :'+ str(ZS_totalrank))
print('W+                                :'+ str(ZS_Wplus))
print('W-                                :'+ str(ZS_Wminus))
print('WARNING use stats tables with n!   ')


##-------------------------------------------------------------------------------
##Print outputs
##-------------------------------------------------------------------------------
#     with open(rrr_sts_csv, 'ab') as csvfile:
#          csvwriter = csv.writer(csvfile, dialect='excel')
#          csvwriter.writerow([IV_obs_tot_id[JS_obs_tot],                       \
#                              round(ZS_obsbar,2),                              \
#                              round(ZS_modbar,2),                              \
#                              round(ZS_modRMS,2),                              \
#                              round(ZS_modNash,2),                             \
#                             ]) 


#*******************************************************************************
#End
#*******************************************************************************
