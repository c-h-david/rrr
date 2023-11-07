#!/usr/bin/env python3
#*******************************************************************************
#rrr_cpl_riv_lsm_bia.py
#*******************************************************************************

#Purpose:
#Given a RAPID connectivity file, a list of river IDs sorted from upstream to
#downstream, a runoff file, discharge observations, a list of river IDs where
#observations are available, and a list of river IDs where observations are
#actually used, this program produces a new runoff file that has been bias
#corrected. Note that all rivers in the network have to be included in the file
#where they are sorted (no subbasin capability here). A common multiplying
#factor is used for correcting runoff between the gauges that are used.
#Author:
#Cedric H. David, 2021-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import shutil
import csv
import pandas
import netCDF4
import numpy
from scipy.sparse import csc_matrix
from scipy.sparse.linalg import spsolve


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_con_csv
# 2 - rrr_bas_csv
# 3 - rrr_m3r_ncf
# 4 - rrr_Qob_csv
# 5 - rrr_obs_csv
# 6 - rrr_use_csv
# 7 - rrr_m3b_ncf


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 8:
     print('ERROR - 7 and only 7 arguments must be used')
     raise SystemExit(22) 

rrr_con_csv=sys.argv[1]
rrr_bas_csv=sys.argv[2]
rrr_m3r_ncf=sys.argv[3]
rrr_Qob_csv=sys.argv[4]
rrr_obs_csv=sys.argv[5]
rrr_use_csv=sys.argv[6]
rrr_m3b_ncf=sys.argv[7]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_con_csv)
print('- '+rrr_bas_csv)
print('- '+rrr_m3r_ncf)
print('- '+rrr_Qob_csv)
print('- '+rrr_obs_csv)
print('- '+rrr_use_csv)
print('- '+rrr_m3b_ncf)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_con_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_csv)
     raise SystemExit(22) 

try:
     with open(rrr_bas_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_bas_csv)
     raise SystemExit(22) 

try:
     with open(rrr_m3r_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_m3r_ncf)
     raise SystemExit(22) 

try:
     with open(rrr_Qob_csv) as file:
          pass
except IOError as e:
     print('WARNING - Unable to open '+rrr_Qob_csv+', skipping')
     raise SystemExit(-22)

try:
     with open(rrr_obs_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_csv)
     raise SystemExit(22) 

try:
     with open(rrr_use_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_use_csv)
     raise SystemExit(22) 


#*******************************************************************************
#Reading connectivity file
#*******************************************************************************
print('Reading connectivity file')

IV_riv_tot_id=[]
IV_riv_tot_dn=[]
with open(rrr_con_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id.append(int(row[0]))
          IV_riv_tot_dn.append(int(row[1]))

IS_riv_tot=len(IV_riv_tot_id)
print('- Number of river reaches in rrr_con_csv: '+str(IS_riv_tot))


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

if IS_riv_bas!=IS_riv_tot:
     print('ERROR - Different number of reaches in basin and network')
     raise SystemExit(22) 


#*******************************************************************************
#Creating hash tables
#*******************************************************************************
print('Creating hash tables')

IM_hsh_tot={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh_tot[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

IM_hsh_bas={}
for JS_riv_bas in range(IS_riv_bas):
     IM_hsh_bas[IV_riv_bas_id[JS_riv_bas]]=JS_riv_bas

IV_riv_ix1=[IM_hsh_bas[IS_riv_id] for IS_riv_id in IV_riv_tot_id]
IV_riv_ix2=[IM_hsh_tot[IS_riv_id] for IS_riv_id in IV_riv_bas_id]
#These arrays allow for index mapping such that IV_riv_tot_id[JS_riv_tot]
#                                              =IV_riv_bas_id[JS_riv_bas]
#IV_riv_ix1[JS_riv_tot]=JS_riv_bas
#IV_riv_ix2[JS_riv_bas]=JS_riv_tot

print('- Hash tables created')


#*******************************************************************************
#Creating network matrix
#*******************************************************************************
print('Creating network matrix')

IV_row=[]
IV_col=[]
IV_val=[]
for JS_riv_bas in range(IS_riv_bas):
     JS_riv_tot=IM_hsh_tot[IV_riv_bas_id[JS_riv_bas]]
     if IV_riv_tot_dn[JS_riv_tot]!=0:
          JS_riv_ba2=IM_hsh_bas[IV_riv_tot_dn[JS_riv_tot]]
          IV_row.append(JS_riv_ba2)
          IV_col.append(JS_riv_bas)
          IV_val.append(1)

ZM_Net=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_riv_bas,IS_riv_bas))

print('- Network matrix created')
print('  . Total number of connections: '+str(len(IV_val)))


#*******************************************************************************
#Creating identity matrix
#*******************************************************************************
print('Creating identity matrix')

IV_row=list(range(IS_riv_bas))
IV_col=list(range(IS_riv_bas))
IV_val=[1]*IS_riv_bas
ZM_I=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_riv_bas,IS_riv_bas))

print('- Done')


#*******************************************************************************
#Computing (I-N)^-1
#*******************************************************************************
print('Computing (I-N)^-1')

IV_bas_tmp_id=IV_riv_bas_id
IV_bas_tmp_cr=IV_riv_bas_id

IV_row=list(range(IS_riv_bas))
IV_col=list(range(IS_riv_bas))
IV_val=[1]*IS_riv_bas

for JS_riv_bas in range(IS_riv_bas):
     #--------------------------------------------------------------------------
     #Determine the IDs of all rivers downstream of the current rivers
     #--------------------------------------------------------------------------
     IV_bas_tmp_dn=[IV_riv_tot_dn[IM_hsh_tot[x]] for x in IV_bas_tmp_cr]

     #--------------------------------------------------------------------------
     #Only keep locations where downstream ID is not zero
     #--------------------------------------------------------------------------
     IV_idx=[i for i, x in enumerate(IV_bas_tmp_dn) if x != 0]
     IV_bas_tmp_id=[IV_bas_tmp_id[i] for i in IV_idx]
     IV_bas_tmp_cr=[IV_bas_tmp_cr[i] for i in IV_idx]
     IV_bas_tmp_dn=[IV_bas_tmp_dn[i] for i in IV_idx]

     #--------------------------------------------------------------------------
     #Add a value of one at corresponding location
     #--------------------------------------------------------------------------
     IS_bas_tmp=len(IV_bas_tmp_id)
     for JS_bas_tmp in range(IS_bas_tmp):
          IV_row.append(IM_hsh_bas[IV_bas_tmp_dn[JS_bas_tmp]])
          IV_col.append(IM_hsh_bas[IV_bas_tmp_id[JS_bas_tmp]])
          IV_val.append(1)
     
     #--------------------------------------------------------------------------
     #Update list of current rivers
     #--------------------------------------------------------------------------
     IV_bas_tmp_cr=IV_bas_tmp_dn

ZM_inN=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_riv_bas,IS_riv_bas))

print('- Done')


#*******************************************************************************
#Reading m3_riv_file
#*******************************************************************************
print('Reading m3_riv file')

f=netCDF4.Dataset(rrr_m3r_ncf, 'r')

#-------------------------------------------------------------------------------
#Dimensions
#-------------------------------------------------------------------------------
if 'COMID' in f.dimensions:
     YV_rivid='COMID'
elif 'rivid' in f.dimensions:
     YV_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_m3r_ncf)
     raise SystemExit(22) 

IS_m3r_tot=len(f.dimensions[YV_rivid])
print('- The number of river reaches is: '+str(IS_m3r_tot))

if 'Time' in f.dimensions:
     YV_time='Time'
elif 'time' in f.dimensions:
     YV_time='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_m3r_ncf)
     raise SystemExit(22) 

IS_m3r_tim=len(f.dimensions[YV_time])
print('- The number of time steps is: '+str(IS_m3r_tim))

#-------------------------------------------------------------------------------
#Variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f.variables:
     YV_var='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_m3r_ncf)
     raise SystemExit(22) 

if YV_rivid in f.variables:
     IV_m3r_tot_id=list(f.variables[YV_rivid])
     if IV_m3r_tot_id==IV_riv_tot_id:
          print('- The river IDs in rrr_m3r_ncf and rrr_con_csv are the same')
     else:
          print('ERROR - The river IDs in rrr_m3r_ncf and rrr_con_csv differ')
          raise SystemExit(22) 

if YV_time in f.variables:
     ZS_TaR=f.variables[YV_time][1]-f.variables[YV_time][0]
     print('- The time step in rrr_m3r_ncf was determined as: '+str(ZS_TaR)+   \
           ' seconds')
else:
     ZS_TaR=10800
     print('- No time variables in rrr_m3r_ncf, using default of : '           \
            +str(ZS_TaR)+' seconds')

#-------------------------------------------------------------------------------
#Computing average external inflow
#-------------------------------------------------------------------------------
print('- Computing average external inflow')

ZV_m3r_avg=numpy.empty(IS_riv_tot)
for JS_m3r_tim in range(IS_m3r_tim):
     ZV_m3r_tmp=f.variables[YV_var][JS_m3r_tim,:]
     ZV_m3r_avg=ZV_m3r_avg+ZV_m3r_tmp

ZV_m3r_avg=ZV_m3r_avg/IS_m3r_tim

ZV_Vex_avg=ZV_m3r_avg[IV_riv_ix2]
#External inflow from runoff is now sorted following IV_riv_bas_id

ZV_Qex_avg=ZV_Vex_avg/ZS_TaR
#Converted from accumulated volume to inflow

#-------------------------------------------------------------------------------
#Closing file
#-------------------------------------------------------------------------------
f.close()
#Not sure if that does anything


#*******************************************************************************
#Computing average discharge
#*******************************************************************************
print('Computing average discharge')

ZV_Qri_avg=spsolve(ZM_I-ZM_Net,ZV_Qex_avg)

print('- Done')


#*******************************************************************************
#Reading observation file and computing average
#*******************************************************************************
print('Reading observation file and computing average')

with open(rrr_Qob_csv,'r') as csvfile:
     df=pandas.read_csv(csvfile,header=None)
     ZV_Qob_avg=df.mean().tolist()
     IS_Qob_tim=df.shape[0]
     IS_obs_tot=df.shape[1]
print('- Number of gauges in rrr_Qob_csv: '+str(IS_obs_tot))
print('- Number of time steps in rrr_Qob_csv: '+str(IS_Qob_tim))

print('- Done')


#*******************************************************************************
#Reading available gauges file
#*******************************************************************************
print('Reading available gauges file')

IV_obs_tot_id=[]
with open(rrr_obs_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_obs_tot_id.append(int(row[0]))

if len(IV_obs_tot_id)==IS_obs_tot:
     print('- Number of river reaches in rrr_obs_csv: '+str(IS_obs_tot))
else:
     print('ERROR - the number of reaches in '+rrr_obs_csv+                    \
           'differs from the number of gauges in '+rrr_Qob_csv)
     raise SystemExit(22) 

IM_hsh_obs={}
for JS_obs_tot in range(IS_obs_tot):
     IM_hsh_obs[IV_obs_tot_id[JS_obs_tot]]=JS_obs_tot


#*******************************************************************************
#Reading used gauges file
#*******************************************************************************
print('Reading used gauges file')

IV_obs_use_id=[]
with open(rrr_use_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_obs_use_id.append(int(row[0]))

IS_obs_use=len(IV_obs_use_id)
print('- Number of river reaches in rrr_use_csv: '+str(IS_obs_use))

ZV_Qus_avg=numpy.array([ZV_Qob_avg[IM_hsh_obs[IS_obs_use_id]]                  \
                       for IS_obs_use_id in IV_obs_use_id])


#*******************************************************************************
#Creating selection matrix
#*******************************************************************************
print('Creating selection matrix')

IV_row=[]
IV_col=[]
IV_val=[]
for JS_obs_use in range(IS_obs_use):
     IV_row.append(JS_obs_use)
     IV_col.append(IM_hsh_bas[IV_obs_use_id[JS_obs_use]])
     IV_val.append(1)

ZM_Sel=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_obs_use,IS_riv_bas))

print('- Done')


#*******************************************************************************
#Computing the total lateral inflow for each subbasin
#*******************************************************************************
print('Computing the total lateral inflow for each subbasin')

ZV_lqe_avg=spsolve(ZM_Sel*ZM_inN*ZM_Sel.transpose(),ZV_Qus_avg)

print('- Done')


#*******************************************************************************
#Creating N*(I-St*S)
#*******************************************************************************
print('Creating N*(I-St*S)')

ZM_DNe=ZM_Net-ZM_Net*ZM_Sel.transpose()*ZM_Sel

print('- Done')


#*******************************************************************************
#Computing independent accumulation of runoff over independent subbasins
#*******************************************************************************
print('Computing independent accumulation of runoff over independent subbasins')

ZV_QrD_avg=spsolve(ZM_I-ZM_DNe,ZV_Qex_avg)

print('- Done')


#*******************************************************************************
#Computing scaling factor for each subbasin
#*******************************************************************************
print('Computing scaling factor for each subbasin')

for JS_obs_use in range(IS_obs_use):
     if (ZM_Sel*ZV_QrD_avg)[JS_obs_use]==0:
          print('WARNING - ZERO runoff accumulation for gauge at rivid: '      \
                +str(IV_obs_use_id[JS_obs_use])                                \
                +' - No correction will be applied at that gauge')

ZV_lbd=numpy.divide(ZV_lqe_avg,ZM_Sel*ZV_QrD_avg,where=(ZM_Sel*ZV_QrD_avg)!=0)
ZV_alp=ZV_lbd-1

print('- Done')


#*******************************************************************************
#Computing scaling factor for each reach
#*******************************************************************************
print('Computing scaling factor for each reach')

ZV_LAM=spsolve((ZM_I-ZM_DNe).transpose(),ZM_Sel.transpose()*ZV_alp)
ZV_LAM=ZV_LAM+1

print('- Done')


#*******************************************************************************
#Propagating corrected runoff
#*******************************************************************************
print('Propagating corrected runoff')

ZV_Qrc_avg=spsolve(ZM_I-ZM_Net,ZV_LAM*ZV_Qex_avg)

print('- Done')


#*******************************************************************************
#Checking successful bias correction
#*******************************************************************************
print('Checking successful bias correction')

ZV_dif=numpy.subtract(ZV_Qus_avg,ZM_Sel*ZV_Qrc_avg,where=(ZM_Sel*ZV_QrD_avg)!=0)

print('- Average value of difference at stations: '+str(ZV_dif.mean()))
print('- Minimum value of difference at stations: '+str(ZV_dif.min()))
print('- Maximum value of difference at stations: '+str(ZV_dif.max()))

print('- Average value of correction factors: '+str(ZV_lbd.mean()))
print('- Minimum value of correction factors: '+str(ZV_lbd.min()))
print('- Maximum value of correction factors: '+str(ZV_lbd.max()))

if numpy.max(numpy.absolute(ZV_dif/ZV_Qus_avg)) <= 0.01:
     print('  . Success!!!')
else:
     print('ERROR - Maximum absolute value of relative error at stations '+    \
           'after corrections is greater than 0.01: '+                         \
           str(numpy.max(numpy.absolute(ZV_dif/ZV_Qus_avg)))               )
     raise SystemExit(22) 


#*******************************************************************************
#Creating new m3_riv file
#*******************************************************************************
print('Creating new m3_riv file')

#-------------------------------------------------------------------------------
#Computing multiplying factors in same sort as m3_riv_values
#-------------------------------------------------------------------------------
print('- Computing the constant shift in m3_riv values')

ZV_LAM=ZV_LAM[IV_riv_ix1]

print(' . Done')

#-------------------------------------------------------------------------------
#Copying netCDF file
#-------------------------------------------------------------------------------
print('- Copying netCDF file')

shutil.copyfile(rrr_m3r_ncf,rrr_m3b_ncf)

print(' . Done')

#-------------------------------------------------------------------------------
#Scaling values in new netCDF file
#-------------------------------------------------------------------------------
print('- Scaling values in new netCDF file')

g = netCDF4.Dataset(rrr_m3b_ncf, 'a')
for JS_m3r_tim in range(IS_m3r_tim):
     g.variables[YV_var][JS_m3r_tim,:]=g.variables[YV_var][JS_m3r_tim,:]       \
                                      *ZV_LAM

g.close()

print(' . Done')


#*******************************************************************************
#Display potential warnings
#*******************************************************************************
print('Display potential warnings')

IS_neg=numpy.sum(ZV_lbd<0)
IS_NEG=numpy.sum(ZV_LAM<0)

if IS_neg>0:
     print('WARNING - NEGATIVE runoff corrections for',IS_neg,'subbasin(s)',   \
           'affecting',IS_NEG,'river reaches, in',rrr_m3b_ncf)


##*******************************************************************************
##Writing optional diagnosis files
##*******************************************************************************
#with open('./Qri.csv', 'w') as csvfile:
#     csvwriter = csv.writer(csvfile, dialect='excel')
#     csvwriter.writerow(['COMID','Qri_avg']) 
#     for JS_riv_bas in range(IS_riv_bas):
#          csvwriter.writerow([IV_riv_bas_id[JS_riv_bas],ZV_Qri_avg[JS_riv_bas]]) 
#
#with open('./Qrc.csv', 'w') as csvfile:
#     csvwriter = csv.writer(csvfile, dialect='excel')
#     csvwriter.writerow(['COMID','Qrc_avg']) 
#     for JS_riv_bas in range(IS_riv_bas):
#          csvwriter.writerow([IV_riv_bas_id[JS_riv_bas],ZV_Qrc_avg[JS_riv_bas]]) 
#
#with open('./Qob.csv', 'w') as csvfile:
#     csvwriter = csv.writer(csvfile, dialect='excel')
#     csvwriter.writerow(['COMID','Qob_avg']) 
#     for JS_obs_tot in range(IS_obs_tot):
#          csvwriter.writerow([IV_obs_tot_id[JS_obs_tot],ZV_Qob_avg[JS_obs_tot]]) 


#*******************************************************************************
#End
#*******************************************************************************
