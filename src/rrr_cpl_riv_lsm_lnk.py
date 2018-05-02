#!/usr/bin/env python2
#*******************************************************************************
#rrr_cpl_riv_lsm_lnk.py
#*******************************************************************************

#Purpose:
#Given a connectivity file, a catchment file, and a runoff file, this program 
#creates a csv file with the following information:
# - rrr_cpl_file
#   . River ID 
#   . Contributing catchment area in square kilometers
#   . Longitude index (1-based) at which to look for the runoff value 
#   . Latitude index (1-based) at which to look for the runoff value 
#Author:
#Cedric H. David, 2011-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import netCDF4


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_con_file
# 2 - rrr_cat_file
# 3 - rrr_lsm_file
# 4 - rrr_cpl_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

rrr_con_file=sys.argv[1]
rrr_cat_file=sys.argv[2]
rrr_lsm_file=sys.argv[3]
rrr_cpl_file=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_con_file)
print('- '+rrr_cat_file)
print('- '+rrr_lsm_file)
print('- '+rrr_cpl_file)


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
     with open(rrr_cat_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_cat_file)
     raise SystemExit(22) 

try:
     with open(rrr_lsm_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read input files
#*******************************************************************************
print('Read input files')

#-------------------------------------------------------------------------------
#Read connectivity file
#-------------------------------------------------------------------------------
print('- Read connectivity file')

IV_riv_tot_id=[]
with open(rrr_con_file) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          IV_riv_tot_id.append(int(row[0]))
IS_riv_tot=len(IV_riv_tot_id)
print('- The number of river reaches is: '+str(IS_riv_tot))

#-------------------------------------------------------------------------------
#Read catchment file
#-------------------------------------------------------------------------------
print('- Read catchment file')

IV_cat_tot_id=[]
ZV_cat_sqkm=[]
ZV_cat_lon=[]
ZV_cat_lat=[]
with open(rrr_cat_file) as csv_file:
     reader=csv.reader(csv_file,dialect='excel',quoting=csv.QUOTE_NONNUMERIC)
     for row in reader:
          IV_cat_tot_id.append(int(row[0]))
          ZV_cat_sqkm.append(row[1])
          ZV_cat_lon.append(row[2])
          ZV_cat_lat.append(row[3])
IS_cat_tot=len(IV_cat_tot_id)
print('- The number of catchments is: '+str(IS_cat_tot))

#-------------------------------------------------------------------------------
#Read netCDF file
#-------------------------------------------------------------------------------
print('- Read netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Open netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f = netCDF4.Dataset(rrr_lsm_file, 'r')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get dimension sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_lsm_lat=len(f.variables['lat'])
print('- The number of latitudes is: '+str(IS_lsm_lat))

IS_lsm_lon=len(f.variables['lon'])
print('- The number of longitudes is: '+str(IS_lsm_lon))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get variable coordinates
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZV_lsm_lat=[]
for JS_lsm_lat in range(IS_lsm_lat):
     #ZV_lsm_lat.append(f.variables['lat'][JS_lsm_lat])
     #Rounding allows reproducing results from ArcGIS and speeds up comparisons:
     ZV_lsm_lat.append(round(f.variables['lat'][JS_lsm_lat],2))

ZV_lsm_lon=[]
for JS_lsm_lon in range(IS_lsm_lon):
     #ZV_lsm_lon.append(f.variables['lon'][JS_lsm_lon])
     #Rounding allows reproducing results from ArcGIS and speeds up comparisons:
     ZV_lsm_lon.append(round(f.variables['lon'][JS_lsm_lon],2))


#*******************************************************************************
#Process data
#*******************************************************************************
print('Process data')

#-------------------------------------------------------------------------------
#Create hash table
#-------------------------------------------------------------------------------
print('- Create hash table')
IM_hsh={}
for JS_cat_tot in range(IS_cat_tot):
     IM_hsh[IV_cat_tot_id[JS_cat_tot]]=JS_cat_tot

#-------------------------------------------------------------------------------
#Assign catchment area, longitude and latitude to each river reach
#-------------------------------------------------------------------------------
print('- Assign catchment area, longitude and latitude to each river reach')

ZV_riv_sqkm=[0]*IS_riv_tot
ZV_riv_lon=[0]*IS_riv_tot
ZV_riv_lat=[0]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     if IV_riv_tot_id[JS_riv_tot] in IM_hsh:
          JS_cat_tot=IM_hsh[IV_riv_tot_id[JS_riv_tot]]
          ZV_riv_sqkm[JS_riv_tot]=ZV_cat_sqkm[JS_cat_tot]
          ZV_riv_lon[JS_riv_tot]=ZV_cat_lon[JS_cat_tot]
          ZV_riv_lat[JS_riv_tot]=ZV_cat_lat[JS_cat_tot]

#-------------------------------------------------------------------------------
#Find nearest coordinates
#-------------------------------------------------------------------------------
print('- Find nearest coordinates')

IV_riv_i_index=[0]*IS_riv_tot
IV_riv_j_index=[0]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     if IV_riv_tot_id[JS_riv_tot] in IM_hsh:
          ZS_lon=ZV_riv_lon[JS_riv_tot]
          ZV_diff_lon=[(abs(ZS_lon - x),i) for (i,x) in enumerate(ZV_lsm_lon)]
          ZV_diff_lon.sort()
          IV_riv_i_index[JS_riv_tot]=ZV_diff_lon[0][1]+1
          #Find nearest longitude
          ZS_lat=ZV_riv_lat[JS_riv_tot]
          ZV_diff_lat=[(abs(ZS_lat - x),i) for (i,x) in enumerate(ZV_lsm_lat)]
          ZV_diff_lat.sort()
          IV_riv_j_index[JS_riv_tot]=ZV_diff_lat[0][1]+1
          #Find nearest latitude


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing file')

with open(rrr_cpl_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IV_line=[IV_riv_tot_id[JS_riv_tot],                                  \
                   ZV_riv_sqkm[JS_riv_tot],                                    \
                   IV_riv_i_index[JS_riv_tot],                                 \
                   IV_riv_j_index[JS_riv_tot]]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
