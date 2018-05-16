#!/usr/bin/env python
#*******************************************************************************
#rrr_riv_tot_net_nav.py
#*******************************************************************************

#Purpose:
#Given a csv file with RAPID connectivity, a number of river reaches (radius),
#and a specific river ID, this program determines all of the upstream and
#downstream reaches within the requested radius (for the entire network) and
#also produces two csv files containing the downstream and upstream reaches
#(within radius) for the specific river ID requested.
#Author:
#Cedric H. David, 2018-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_con_csv
# 2 - IS_riv_rad
# 3 - IS_riv_id
# 4 - rrr_dwn_csv
# 5 - rrr_ups_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22) 

rrr_con_csv=sys.argv[1]
IS_riv_rad=int(sys.argv[2])
IS_riv_id=int(sys.argv[3])
rrr_dwn_csv=sys.argv[4]
rrr_ups_csv=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_con_csv)
print('- '+str(IS_riv_rad))
print('- '+str(IS_riv_id))
print('- '+rrr_dwn_csv)
print('- '+rrr_ups_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_con_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Reading connectivity file
#*******************************************************************************
print('Reading connectivity file')

with open(rrr_con_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     IS_col=len(next(csvreader))
     IS_max_up=IS_col-3

print('- Maximum number of upstream reaches in rrr_con_file: '+str(IS_max_up))

IV_riv_tot_id=[]
IV_riv_dwn_id=[]
IV_riv_ups_nb=[]
IM_riv_ups_id=[]
with open(rrr_con_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id.append(int(row[0]))
          IV_riv_dwn_id.append(int(row[1]))
          IV_riv_ups_nb.append(int(row[2]))
          IM_riv_ups_id.append([int(rivid) for rivid in row[3:]])

IS_riv_tot=len(IV_riv_tot_id)
print('- Number of river reaches in rrr_con_file: '+str(IS_riv_tot))


#*******************************************************************************
#Creating hash table
#*******************************************************************************
print('Creating hash table')

IM_hsh={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

print("- Hash table created")


#*******************************************************************************
#Checking that the requested river ID is indeed in the network
#*******************************************************************************
print('Checking that the requested river ID is indeed in the network')

if IS_riv_id in IM_hsh:
     print('- Ok')
else:
     print('ERROR - Unable to find river ID '+str(IS_riv_id))
     raise SystemExit(22) 


#*******************************************************************************
#Finding downstream reaches within radius
#*******************************************************************************
print('Finding downstream reaches within radius')

for JS_riv_tot in range(IS_riv_tot):
     IV_riv_dwn_ix_rad=[]
     #List of all indexes (within radius) downstream of the current index
     IS_riv_dwn_id=IV_riv_dwn_id[JS_riv_tot]
     #ID of the river that is directly downstream of the current index
     for JS_riv_dwn in range(IS_riv_rad):
          if IS_riv_dwn_id != 0:
               IS_riv_dwn_ix=IM_hsh[IS_riv_dwn_id]
               IV_riv_dwn_ix_rad.append(IS_riv_dwn_ix)
               IS_riv_dwn_id=IV_riv_dwn_id[IS_riv_dwn_ix]
               #Update the ID to that of the next downstream river
          else:
               break
               #This break statement exits the for loop if no more downstream
     if IV_riv_tot_id[JS_riv_tot]==IS_riv_id:
          IV_riv_dwn_ix_req=IV_riv_dwn_ix_rad

print('- Ok')


#*******************************************************************************
#Finding upstream reaches within radius
#*******************************************************************************
print('Finding upstream reaches within radius')

for JS_riv_tot in range(IS_riv_tot):
     IV_riv_ups_ix_rad=[]
     #List of all indexes (within radius) upstream of the current index
     IV_riv_ups_id=IM_riv_ups_id[JS_riv_tot][0:IV_riv_ups_nb[JS_riv_tot]]
     #IDs of the river that is directly upstream of the current index
     for JS_riv_ups in range(IS_riv_rad):
          IV_riv_nxt_id=[]
          for JS_riv_ups_id in IV_riv_ups_id:
               JS_riv_ups_ix=IM_hsh[JS_riv_ups_id]
               IV_riv_ups_ix_rad.append(JS_riv_ups_ix)
               IV_riv_nxt_id=IV_riv_nxt_id                                     \
                            +IM_riv_ups_id[JS_riv_ups_ix]                      \
                                          [0:IV_riv_ups_nb[JS_riv_ups_ix]]
                            #The + here is used for concatenation of two lists
          if len(IV_riv_nxt_id)!=0:
               IV_riv_ups_id=IV_riv_nxt_id
          else:
               break
               #This break statement exits the for loop if no more upstream
     if IV_riv_tot_id[JS_riv_tot]==IS_riv_id:
          IV_riv_ups_ix_req=IV_riv_ups_ix_rad
          #Update the IDs to those of the next upstream rivers

print('- Ok')


#*******************************************************************************
#Writing CSV files
#*******************************************************************************
print('Writing CSV files')

IS_riv_dwn=len(IV_riv_dwn_ix_req)

with open(rrr_dwn_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow(['rivid'])
     for JS_riv_dwn in range(IS_riv_dwn):
          JS_riv_ix=IV_riv_dwn_ix_req[JS_riv_dwn]
          JS_riv_id=IV_riv_tot_id[JS_riv_ix]
          csvwriter.writerow([JS_riv_id]) 

IS_riv_ups=len(IV_riv_ups_ix_req)

with open(rrr_ups_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow(['rivid'])
     for JS_riv_ups in range(IS_riv_ups):
          JS_riv_ix=IV_riv_ups_ix_req[JS_riv_ups]
          JS_riv_id=IV_riv_tot_id[JS_riv_ix]
          csvwriter.writerow([JS_riv_id]) 

print('- Ok')


#*******************************************************************************
#End
#*******************************************************************************
