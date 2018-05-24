#!/usr/bin/env python
#*******************************************************************************
#rrr_cpl_riv_lsm_bvc.py
#*******************************************************************************

#Purpose:
#Given one file with estimates of time-varying external inflow (in m^3) into the
#river network, and another similar file assumed to contain the "true" values of
#the same quantities, along with a multiplying factor allowing to convert the
#inputs into m^3/s, a connectivity file, and a radius of search (number of river
#reaches), this program computes the corresponding bias, standard error, and
#error convariances and saves these values in a new CSV file.
#Author:
#Cedric H. David, 2018-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import numpy
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_mod_ncf
# 2 - rrr_tru_ncf
# 3 - ZS_conv
# 4 - YS_opt
# 5 - rrr_con_csv
# 6 - IS_riv_rad
# 7 - rrr_bvc_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 8:
     print('ERROR - 7 and only 7 arguments must be used')
     raise SystemExit(22) 

rrr_mod_ncf=sys.argv[1]
rrr_tru_ncf=sys.argv[2]
ZS_conv=eval(sys.argv[3])
YS_opt=sys.argv[4]
rrr_con_csv=sys.argv[5]
IS_riv_rad=int(sys.argv[6])
rrr_bvc_csv=sys.argv[7]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_mod_ncf)
print('- '+rrr_tru_ncf)
print('- '+str(ZS_conv))
print('- '+YS_opt)
print('- '+rrr_con_csv)
print('- '+str(IS_riv_rad))
print('- '+rrr_bvc_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_mod_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_mod_ncf)
     raise SystemExit(22)

try:
     with open(rrr_tru_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_tru_ncf)
     raise SystemExit(22)

try:
     with open(rrr_con_csv) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_con_csv)
     raise SystemExit(22)


#*******************************************************************************
#Check read option provided
#*******************************************************************************
print('Check read option provided')

if YS_opt=='once':
     print('- The covariance computation will read the .nc files at once')
elif YS_opt=='incr':
     print('- The covariance computation will read the .nc files incrementally')
elif YS_opt=='skip':
     print('- The covariance computation will be skipped')
else:
     print('ERROR - The option given is neither once, incr, nor skip: '+YS_opt)
     raise SystemExit(22)


#*******************************************************************************
#Reading netCDF file 1
#*******************************************************************************
print('Reading netCDF file 1')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f1 = netCDF4.Dataset(rrr_mod_ncf, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'COMID' in f1.dimensions:
     YS_rivid1='COMID'
elif 'rivid' in f1.dimensions:
     YS_rivid1='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

IS_riv_tot1=len(f1.dimensions[YS_rivid1])
print('- The number of river reaches is: '+str(IS_riv_tot1))

if 'Time' in f1.dimensions:
     YS_time1='Time'
elif 'time' in f1.dimensions:
     YS_time1='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

IS_time1=len(f1.dimensions[YS_time1])
print('- The number of time steps is: '+str(IS_time1))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f1.variables:
     YS_var1='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_mod_ncf)
     raise SystemExit(22) 

IV_riv_tot_id1=f1.variables[YS_rivid1][:]
ZV_time1=f1.variables[YS_time1][:]

if '_FillValue' in  f1.variables[YS_var1].ncattrs(): 
     ZS_fill1=f1.variables[YS_var1]._FillValue
     print('- The fill value is: '+str(ZS_fill1))
else:
     ZS_fill1=None

if 'long_name' in  f1.variables[YS_var1].ncattrs(): 
     YS_long_name1=f1.variables[YS_var1].long_name
else:
     YS_long_name1=None

if 'units' in  f1.variables[YS_var1].ncattrs(): 
     YS_units1=f1.variables[YS_var1].units
else:
     YS_units1=None

if 'coordinates' in  f1.variables[YS_var1].ncattrs(): 
     YS_coordinates1=f1.variables[YS_var1].coordinates
else:
     YS_coordinates1=None

if 'grid_mapping' in  f1.variables[YS_var1].ncattrs(): 
     YS_grid_mapping1=f1.variables[YS_var1].grid_mapping
else:
     YS_grid_mapping1=None

if 'cell_methods' in  f1.variables[YS_var1].ncattrs(): 
     YS_cell_methods1=f1.variables[YS_var1].cell_methods
else:
     YS_cell_methods1=None


#*******************************************************************************
#Reading netCDF file 2
#*******************************************************************************
print('Reading netCDF file 2')

#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
f2 = netCDF4.Dataset(rrr_tru_ncf, 'r')

#-------------------------------------------------------------------------------
#Get dimension sizes
#-------------------------------------------------------------------------------
if 'COMID' in f2.dimensions:
     YS_rivid2='COMID'
elif 'rivid' in f2.dimensions:
     YS_rivid2='rivid'
else:
     print('ERROR - Neither COMID nor rivid exist in '+rrr_tru_ncf)
     raise SystemExit(22) 

IS_riv_tot2=len(f2.dimensions[YS_rivid2])
print('- The number of river reaches is: '+str(IS_riv_tot2))

if 'Time' in f2.dimensions:
     YS_time2='Time'
elif 'time' in f2.dimensions:
     YS_time2='time'
else:
     print('ERROR - Neither Time nor time exist in '+rrr_tru_ncf)
     raise SystemExit(22) 

IS_time2=len(f2.dimensions[YS_time2])
print('- The number of time steps is: '+str(IS_time2))

#-------------------------------------------------------------------------------
#Get variables
#-------------------------------------------------------------------------------
if 'm3_riv' in f2.variables:
     YS_var2='m3_riv'
else:
     print('ERROR - m3_riv does not exist in '+rrr_tru_ncf)
     raise SystemExit(22) 

IV_riv_tot_id2=f2.variables[YS_rivid2][:]
ZV_time2=f2.variables[YS_time2][:]

if '_FillValue' in  f2.variables[YS_var2].ncattrs(): 
     ZS_fill2=f2.variables[YS_var2]._FillValue
     print('- The fill value is: '+str(ZS_fill2))
else:
     ZS_fill2=None

if 'long_name' in  f2.variables[YS_var2].ncattrs(): 
     YS_long_name2=f2.variables[YS_var2].long_name
else:
     YS_long_name2=None

if 'units' in  f2.variables[YS_var2].ncattrs(): 
     YS_units2=f2.variables[YS_var2].units
else:
     YS_units2=None

if 'coordinates' in  f2.variables[YS_var2].ncattrs(): 
     YS_coordinates2=f2.variables[YS_var2].coordinates
else:
     YS_coordinates2=None

if 'grid_mapping' in  f2.variables[YS_var2].ncattrs(): 
     YS_grid_mapping2=f2.variables[YS_var2].grid_mapping
else:
     YS_grid_mapping2=None

if 'cell_methods' in  f2.variables[YS_var2].ncattrs(): 
     YS_cell_methods2=f2.variables[YS_var2].cell_methods
else:
     YS_cell_methods2=None


#*******************************************************************************
#Reading connectivity file
#*******************************************************************************
print('Reading connectivity file')

with open(rrr_con_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     IS_col=len(next(csvreader))
     IS_max_up=IS_col-3

print('- Maximum number of upstream reaches in rrr_con_file: '+str(IS_max_up))

IV_riv_tot_id3=[]
IV_riv_dwn_id=[]
IV_riv_ups_nb=[]
IM_riv_ups_id=[]
with open(rrr_con_csv,'r') as csvfile:
     csvreader=csv.reader(csvfile)
     for row in csvreader:
          IV_riv_tot_id3.append(int(row[0]))
          IV_riv_dwn_id.append(int(row[1]))
          IV_riv_ups_nb.append(int(row[2]))
          IM_riv_ups_id.append([int(rivid) for rivid in row[3:]])

IS_riv_tot3=len(IV_riv_tot_id3)
print('- Number of river reaches in rrr_con_file: '+str(IS_riv_tot3))


#*******************************************************************************
#Check consistency
#*******************************************************************************
print('Check consistency')

if IS_riv_tot1==IS_riv_tot2 and IS_riv_tot1==IS_riv_tot3:
     IS_riv_tot=IS_riv_tot1
     print('- Common number of river reaches: '+str(IS_riv_tot))
else: 
     print('ERROR - The number of river reaches differ')
     raise SystemExit(22) 
     
if IS_time1==IS_time2: 
     IS_time=IS_time1
     print('- Common number of time steps: '+str(IS_time))
else: 
     print('ERROR - The number of time steps differ')
     raise SystemExit(22) 
     
if (IV_riv_tot_id1==IV_riv_tot_id2).all() and                                  \
   (IV_riv_tot_id1==IV_riv_tot_id3).all():
     IV_riv_tot_id=IV_riv_tot_id1
     print('- The river reach IDs are the same')
else: 
     print('ERROR - The river reach IDs differ')
     raise SystemExit(22) 
     
if (ZV_time1==ZV_time2).all():
     ZV_time=ZV_time1
     print('- The time variables are the same')
else: 
     print('ERROR - The time variables differ')
     raise SystemExit(22) 
     

#*******************************************************************************
#Creating hash table
#*******************************************************************************
print('Creating hash table')

IM_hsh={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

print("- Hash table created")


#*******************************************************************************
#Computing estimates of error
#*******************************************************************************
print('Computing estimates of error')

#-------------------------------------------------------------------------------
#Computing biases
#-------------------------------------------------------------------------------
print('- Computing biases')

ZV_vol_av1=numpy.zeros(IS_riv_tot)
ZV_vol_av2=numpy.zeros(IS_riv_tot)
ZV_vol_bia=numpy.zeros(IS_riv_tot)

for JS_time in range(IS_time):
     ZV_vol_in1=f1.variables[YS_var1][JS_time,:]*ZS_conv
     ZV_vol_in2=f2.variables[YS_var2][JS_time,:]*ZS_conv

     ZV_vol_av1=ZV_vol_av1+ZV_vol_in1
     ZV_vol_av2=ZV_vol_av2+ZV_vol_in2

ZV_vol_av1=ZV_vol_av1/IS_time
ZV_vol_av2=ZV_vol_av2/IS_time
ZV_vol_bia=ZV_vol_av1-ZV_vol_av2
#The bias (the mean of the error) is now computed

#-------------------------------------------------------------------------------
#Computing standard errors
#-------------------------------------------------------------------------------
print('- Computing standard errors')

ZV_vol_dif=numpy.zeros(IS_riv_tot)
ZV_vol_sde=numpy.zeros(IS_riv_tot)

for JS_time in range(IS_time):
     ZV_vol_in1=f1.variables[YS_var1][JS_time,:]*ZS_conv
     ZV_vol_in2=f2.variables[YS_var2][JS_time,:]*ZS_conv

     ZV_vol_dif=ZV_vol_in1-ZV_vol_in2
     #The current difference between the two values, i.e. the current error
     ZV_vol_dev=ZV_vol_dif-ZV_vol_bia
     #The deviation between the current error and the mean error
     ZV_vol_sde=ZV_vol_sde+numpy.square(ZV_vol_dev)
     #Updating the value of the standard deviation of the error

ZV_vol_sde=ZV_vol_sde/(IS_time-1)
ZV_vol_sde=numpy.sqrt(ZV_vol_sde)
#The standard error (the standard deviation of the error) is now computed

#-------------------------------------------------------------------------------
#Computing error covariances
#-------------------------------------------------------------------------------
print('- Computing error covariances')

ZV_vol_sd2=numpy.zeros(IS_riv_tot)
#Another version of the standard error, which is used to check covariances here.
#The variance is included in the variance/covariance matrix and the standard
#error is its square root.
ZV_vol_cva=numpy.zeros(IS_riv_tot)
#The average of the covariance between each river reach and all others.
ZV_vol_cve=numpy.zeros(IS_riv_tot)
#The median  of the covariance between each river reach and all others.
ZV_vol_cvn=numpy.zeros(IS_riv_tot)
#The mininum of the covariance between each river reach and all others.
ZV_vol_cvx=numpy.zeros(IS_riv_tot)
#The maximum of the covariance between each river reach and all others.
ZV_vol_cvu=numpy.zeros(IS_riv_tot)
#The average of the covariance between each river reach and all others upstream.
ZM_vol_cvd=numpy.zeros((IS_riv_tot,IS_riv_rad))
#The covariances between each river reach and others downstream (within radius).
IV_ups_all=[0 for JS_riv_tot in range(IS_riv_tot)]
#The number of all upstream river reaches

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Computation by reading netCDF files all at once
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if YS_opt=='once':

     ZM_vol_in1=f1.variables[YS_var1][:,:]*ZS_conv
     ZM_vol_in2=f2.variables[YS_var2][:,:]*ZS_conv

     ZM_vol_dif=ZM_vol_in1-ZM_vol_in2
     ZM_vol_dev=ZM_vol_dif-ZV_vol_bia

     for JS_riv_tot in range(IS_riv_tot):
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          #Determination of downstream indexes
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          IV_riv_dwn_ix_rad=[]
          #List of all indexes (within radius) downstream of the current index
          IS_riv_dwn_id=IV_riv_dwn_id[JS_riv_tot]
          #ID of the river that is directly downstream of the current index
          JS_riv_dwn=0
          while JS_riv_dwn<IS_riv_rad:
               JS_riv_dwn=JS_riv_dwn+1
               #At large radius, a while loop is much faster than a for loop!
               if IS_riv_dwn_id != 0:
                    IS_riv_dwn_ix=IM_hsh[IS_riv_dwn_id]
                    IV_riv_dwn_ix_rad.append(IS_riv_dwn_ix)
                    IS_riv_dwn_id=IV_riv_dwn_id[IS_riv_dwn_ix]
                    #Update the ID to that of the next downstream river
               else:
                    break
                    #This break statement exits the for loop if no more dnstream

          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          #Determination of upstream indexes
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          IV_riv_ups_ix_all=[]
          #List of all indexes upstream of the current index
          IV_riv_ups_id=IM_riv_ups_id[JS_riv_tot][0:IV_riv_ups_nb[JS_riv_tot]]
          #IDs of the river that is directly upstream of the current index
          JS_riv_ups=0
          while JS_riv_ups<1000000000:
               JS_riv_ups=JS_riv_ups+1
               #At large radius, a while loop is much faster than a for loop!
               IV_riv_nxt_id=[]
               for JS_riv_ups_id in IV_riv_ups_id:
                    JS_riv_ups_ix=IM_hsh[JS_riv_ups_id]
                    IV_riv_ups_ix_all.append(JS_riv_ups_ix)
                    IV_riv_nxt_id=IV_riv_nxt_id                                \
                                 +IM_riv_ups_id[JS_riv_ups_ix]                 \
                                               [0:IV_riv_ups_nb[JS_riv_ups_ix]]
                                 #The + here is used for concatenation of lists
               if len(IV_riv_nxt_id)!=0:
                    IV_riv_ups_id=IV_riv_nxt_id
               else:
                    break
                    #This break statement exits the for loop if no more upstream

          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          #Computation of covariances
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          ZV_vol_cov=numpy.zeros(IS_riv_tot)
          #A 1-D array with all the covariances for the reach at JS_riv_tot
          for JS_time in range(IS_time):
               ZV_vol_dev=ZM_vol_dev[JS_time,:]

               ZV_vol_cov=ZV_vol_cov+ZV_vol_dev[JS_riv_tot]*ZV_vol_dev

          ZV_vol_cov=ZV_vol_cov/(IS_time-1)
          ZV_vol_sd2[JS_riv_tot]=numpy.sqrt(ZV_vol_cov[JS_riv_tot])
          ZV_vol_cvo=numpy.delete(ZV_vol_cov,JS_riv_tot)
          #Removed the one variance element from the covariances
          ZV_vol_cva[JS_riv_tot]=numpy.mean(ZV_vol_cvo)
          ZV_vol_cve[JS_riv_tot]=numpy.median(ZV_vol_cvo)
          ZV_vol_cvn[JS_riv_tot]=numpy.min(ZV_vol_cvo)
          ZV_vol_cvx[JS_riv_tot]=numpy.max(ZV_vol_cvo)
          if len(IV_riv_ups_ix_all)!=0:
               ZV_vol_cvu[JS_riv_tot]=numpy.mean(ZV_vol_cov[IV_riv_ups_ix_all])
          else:
               ZV_vol_cvu[JS_riv_tot]=0
          for JS_riv_dwn in range(len(IV_riv_dwn_ix_rad)):
               ZM_vol_cvd[JS_riv_tot][JS_riv_dwn]=                             \
                                       ZV_vol_cov[IV_riv_dwn_ix_rad[JS_riv_dwn]]
          IV_ups_all[JS_riv_tot]=len(IV_riv_ups_ix_all)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Computation by reading netCDF files incrementally
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if YS_opt=='incr':

     for JS_riv_tot in range(IS_riv_tot):
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          #Determination of downstream indexes
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          IV_riv_dwn_ix_rad=[]
          #List of all indexes (within radius) downstream of the current index
          IS_riv_dwn_id=IV_riv_dwn_id[JS_riv_tot]
          #ID of the river that is directly downstream of the current index
          JS_riv_dwn=0
          while JS_riv_dwn<IS_riv_rad:
               JS_riv_dwn=JS_riv_dwn+1
               #At large radius, a while loop is much faster than a for loop!
               if IS_riv_dwn_id != 0:
                    IS_riv_dwn_ix=IM_hsh[IS_riv_dwn_id]
                    IV_riv_dwn_ix_rad.append(IS_riv_dwn_ix)
                    IS_riv_dwn_id=IV_riv_dwn_id[IS_riv_dwn_ix]
                    #Update the ID to that of the next downstream river
               else:
                    break
                    #This break statement exits the for loop if no more dnstream

          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          #Determination of upstream indexes
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          IV_riv_ups_ix_all=[]
          #List of all indexes upstream of the current index
          IV_riv_ups_id=IM_riv_ups_id[JS_riv_tot][0:IV_riv_ups_nb[JS_riv_tot]]
          #IDs of the river that is directly upstream of the current index
          JS_riv_ups=0
          while JS_riv_ups<1000000000:
               JS_riv_ups=JS_riv_ups+1
               #At large radius, a while loop is much faster than a for loop!
               IV_riv_nxt_id=[]
               for JS_riv_ups_id in IV_riv_ups_id:
                    JS_riv_ups_ix=IM_hsh[JS_riv_ups_id]
                    IV_riv_ups_ix_all.append(JS_riv_ups_ix)
                    IV_riv_nxt_id=IV_riv_nxt_id                                \
                                 +IM_riv_ups_id[JS_riv_ups_ix]                 \
                                               [0:IV_riv_ups_nb[JS_riv_ups_ix]]
                                 #The + here is used for concatenation of lists
               if len(IV_riv_nxt_id)!=0:
                    IV_riv_ups_id=IV_riv_nxt_id
               else:
                    break
                    #This break statement exits the for loop if no more upstream

          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          #Computation of covariances
          #-   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
          ZV_vol_cov=numpy.zeros(IS_riv_tot)
          #A 1-D array with all the covariances for the reach at JS_riv_tot
          for JS_time in range(IS_time):
               ZV_vol_in1=f1.variables[YS_var1][JS_time,:]*ZS_conv
               ZV_vol_in2=f2.variables[YS_var2][JS_time,:]*ZS_conv

               ZV_vol_dif=ZV_vol_in1-ZV_vol_in2
               ZV_vol_dev=ZV_vol_dif-ZV_vol_bia

               ZV_vol_cov=ZV_vol_cov+ZV_vol_dev[JS_riv_tot]*ZV_vol_dev

          ZV_vol_cov=ZV_vol_cov/(IS_time-1)
          ZV_vol_sd2[JS_riv_tot]=numpy.sqrt(ZV_vol_cov[JS_riv_tot])
          ZV_vol_cvo=numpy.delete(ZV_vol_cov,JS_riv_tot)
          #Removed the one variance element from the covariances
          ZV_vol_cva[JS_riv_tot]=numpy.mean(ZV_vol_cvo)
          ZV_vol_cve[JS_riv_tot]=numpy.median(ZV_vol_cvo)
          ZV_vol_cvn[JS_riv_tot]=numpy.min(ZV_vol_cvo)
          ZV_vol_cvx[JS_riv_tot]=numpy.max(ZV_vol_cvo)
          if len(IV_riv_ups_ix_all)!=0:
               ZV_vol_cvu[JS_riv_tot]=numpy.mean(ZV_vol_cov[IV_riv_ups_ix_all])
          else:
               ZV_vol_cvu[JS_riv_tot]=0
          for JS_riv_dwn in range(len(IV_riv_dwn_ix_rad)):
               ZM_vol_cvd[JS_riv_tot][JS_riv_dwn]=                             \
                                       ZV_vol_cov[IV_riv_dwn_ix_rad[JS_riv_dwn]]
          IV_ups_all[JS_riv_tot]=len(IV_riv_ups_ix_all)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Skipping covariance computation
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if YS_opt=='skip':
     print(' . Skipped')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Check the previous standard error computation from the variance equations
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZS_rdif_max=0
for JS_riv_tot in range(IS_riv_tot):
     if ZV_vol_sde[JS_riv_tot]!=0:
          ZS_rdif=abs((ZV_vol_sd2[JS_riv_tot]-ZV_vol_sde[JS_riv_tot])          \
                      /ZV_vol_sde[JS_riv_tot])
          ZS_rdif_max=max(ZS_rdif_max,ZS_rdif)

if ZS_rdif_max<=5e-6:
     print(' . Acceptable max relative difference in standard errors using two'\
          +' different methods: '+str(ZS_rdif_max))
else:
     print('ERROR - Unacceptable max relative difference in standard errors '  \
           'using two different methods')
     if YS_opt!='skip': raise SystemExit(22)

#-------------------------------------------------------------------------------
#Close netCDF files
#-------------------------------------------------------------------------------
f1.close()
f2.close()


#*******************************************************************************
#Write summarized results in a file
#*******************************************************************************
print('Write summarized results in a file')

with open(rrr_bvc_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     csvwriter.writerow(['rivid', 'modbar','trubar','bias','stderr','covavg',  \
                         'covmed','covmin','covmax',                           \
                         'nbupst','covupsavg','covdwn'])
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([IV_riv_tot_id[JS_riv_tot],                       \
                              ZV_vol_av1[JS_riv_tot],                          \
                              ZV_vol_av2[JS_riv_tot],                          \
                              ZV_vol_bia[JS_riv_tot],                          \
                              ZV_vol_sde[JS_riv_tot],                          \
                              ZV_vol_cva[JS_riv_tot],                          \
                              ZV_vol_cve[JS_riv_tot],                          \
                              ZV_vol_cvn[JS_riv_tot],                          \
                              ZV_vol_cvx[JS_riv_tot],                          \
                              IV_ups_all[JS_riv_tot],                          \
                              ZV_vol_cvu[JS_riv_tot]    ]                      \
                            +list(ZM_vol_cvd[JS_riv_tot]))


#*******************************************************************************
#Printing some diagnostic quantities
#*******************************************************************************
print('Printing some diagnostic quantities')

#-------------------------------------------------------------------------------
#Basic quantities
#-------------------------------------------------------------------------------
YS_str=str(numpy.round(ZV_vol_av1.mean(),4))
print('- Spatial and temporal mean of model:          '+YS_str)
YS_str=str(numpy.round(ZV_vol_av2.mean(),4))
print('- Spatial and temporal mean of ensemble:       '+YS_str)
YS_str=str(numpy.round(ZV_vol_bia.mean(),4))
print('- Spatial mean of bias:                        '+YS_str)
YS_str=str(numpy.round(ZV_vol_sde.mean(),4))
print('- Spatial mean of standard error:              '+YS_str)
YS_str=str(numpy.round(ZV_vol_cva.mean(),4))
print('- Spatial mean of spatial mean of covariances: '+YS_str)

#-------------------------------------------------------------------------------
#More advanced quantities
#-------------------------------------------------------------------------------
ZV_vol_av1[ZV_vol_av1==0]=numpy.nan

ZS_str=numpy.nanmedian(numpy.abs((numpy.divide(ZV_vol_bia,ZV_vol_av1))))
YS_str=str(numpy.round(ZS_str,2))
print('- Median ratio of bias over model              '+YS_str) 
ZS_str=numpy.nanmedian(numpy.abs((numpy.divide(ZV_vol_sde,ZV_vol_av1))))
YS_str=str(numpy.round(ZS_str,2))
print('- Median ratio of standard error over model    '+YS_str) 


#*******************************************************************************
#End
#*******************************************************************************
