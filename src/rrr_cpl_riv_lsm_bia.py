#!/usr/bin/env python
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
#Cedric H. David, 2021-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import shutil
import csv
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
     print('ERROR - Unable to open '+rrr_Qob_csv)
     raise SystemExit(22) 

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

IV_row=range(IS_riv_bas)
IV_col=range(IS_riv_bas)
IV_val=[1]*IS_riv_bas
ZM_I=csc_matrix((IV_val,(IV_row,IV_col)),shape=(IS_riv_bas,IS_riv_bas))

print('- Done')


#*******************************************************************************
#Computing (I-N)^-1
#*******************************************************************************
print('Computing (I-N)^-1')

IV_bas_tmp_id=IV_riv_bas_id
IV_bas_tmp_cr=IV_riv_bas_id

IV_row=range(IS_riv_bas)
IV_col=range(IS_riv_bas)
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

with open(rrr_Qob_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     row=next(csvreader)
     IS_obs_tot=len(row)
print('- Number of gauges in rrr_Qob_csv: '+str(IS_obs_tot))

ZV_Qob_avg=numpy.empty(IS_obs_tot)
IS_Qob_tim=0
with open(rrr_Qob_csv,'rb') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          ZV_Qob_tmp=numpy.array([float(obs) for obs in row])
          ZV_Qob_avg=ZV_Qob_avg+ZV_Qob_tmp
          IS_Qob_tim=IS_Qob_tim+1

ZV_Qob_avg=ZV_Qob_avg/IS_Qob_tim

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
#Computing corrections for each independent subbasin
#*******************************************************************************
print('Computing corrections for each independent subbasin')

ZV_dke=spsolve(ZM_Sel*ZM_inN*ZM_Sel.transpose(),ZV_Qus_avg-ZM_Sel*ZV_Qri_avg)

print('- Done')


#*******************************************************************************
#Computing independent accumulation of runoff over independent subbasins
#*******************************************************************************
print('Computing independent accumulation of runoff over independent subbasins')

ZV_ske=spsolve(ZM_I-ZM_Net+ZM_Net*ZM_Sel.transpose()*ZM_Sel,ZV_Qex_avg)
ZV_ske=ZM_Sel*ZV_ske

print('- Done')


#*******************************************************************************
#Computing scaling factor for each subbasin
#*******************************************************************************
print('Computing scaling factor for each subbasin')

ZV_lke=ZV_dke/ZV_ske

print('- Done')


#*******************************************************************************
#Computing correction of all runoff
#*******************************************************************************
print('Computing correction of all runoff')

ZV_dQe_avg=spsolve( ZM_I-ZM_Net.transpose()                                    \
                   +ZM_Sel.transpose()*ZM_Sel*ZM_Net.transpose(),              \
                                                      ZM_Sel.transpose()*ZV_lke)
ZV_dQe_avg=ZV_dQe_avg*ZV_Qex_avg

print('- Done')


#*******************************************************************************
#Propagating corrected runoff
#*******************************************************************************
print('Propagating corrected runoff')

ZV_Qrc_avg=spsolve(ZM_I-ZM_Net,ZV_Qex_avg+ZV_dQe_avg)

print('- Done')


#*******************************************************************************
#Checking successful bias correction
#*******************************************************************************
print('Checking successful bias correction')

ZV_dif=ZV_Qus_avg-ZM_Sel*ZV_Qrc_avg

print('- Average value of difference at stations: '+str(ZV_dif.mean()))
print('- Minimum value of difference at stations: '+str(ZV_dif.min()))
print('- Maximum value of difference at stations: '+str(ZV_dif.max()))

print('- Average value of correction factors: '+str(ZV_lke.mean()))
print('- Minimum value of correction factors: '+str(ZV_lke.min()))
print('- Maximum value of correction factors: '+str(ZV_lke.max()))

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
#Computing the constant shift in m3_riv values
#-------------------------------------------------------------------------------
print('- Computing the constant shift in m3_riv values')

ZV_dm3_avg=ZV_dQe_avg[IV_riv_ix1]*ZS_TaR

print(' . Done')

#-------------------------------------------------------------------------------
#Copying netCDF file
#-------------------------------------------------------------------------------
print('- Copying netCDF file')

shutil.copyfile(rrr_m3r_ncf,rrr_m3b_ncf)

print(' . Done')

#-------------------------------------------------------------------------------
#Shifting values in new netCDF file
#-------------------------------------------------------------------------------
print('- Shifting values in new netCDF file')

g = netCDF4.Dataset(rrr_m3b_ncf, 'a')
for JS_m3r_tim in range(IS_m3r_tim):
     g.variables[YV_var][JS_m3r_tim,:]=g.variables[YV_var][JS_m3r_tim,:]       \
                                      +ZV_dm3_avg

g.close()
print(' . Done')


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
