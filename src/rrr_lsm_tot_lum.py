#!/usr/bin/env python
#*******************************************************************************
#rrr_lsm_tot_lum.py
#*******************************************************************************

#Purpose:
#Given surface and subsurface runoff in a netCDF file, a value allowing for the
#conversion factor between runoff units and m/s, and a shapefile referenced on a
#Geographic Coordinate System (i.e. longitude, latitude), this script creates an
#intermediate shapefile with points representative of the grid cell, computes
#the total discharge (accumulated within the shapefile boundaries) for every
#time step of the runoff data, and writes the associated time series in a CSV
#file. If the shapefile touches grid cells that have NoData (e.g. coastal grid
#cells), these points are ignored in the computations. Additional diagnostic
#quantities are also given.
#averaging.
#Author:
#Cedric H. David, 2018-2020


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4
import numpy
import datetime
import fiona
import shapely.geometry
import shapely.prepared
import rtree
import math
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_lsm_ncf
# 2 - ZS_conv
# 3 - rrr_pol_shp
# 4 - rrr_pnt_shp
# 5 - rrr_var_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22) 

rrr_lsm_ncf=sys.argv[1]
ZS_conv=eval(sys.argv[2])
rrr_pol_shp=sys.argv[3]
rrr_pnt_shp=sys.argv[4]
rrr_var_csv=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print(' - '+rrr_lsm_ncf)
print(' - '+str(ZS_conv))
print(' - '+rrr_pol_shp)
print(' - '+rrr_pnt_shp)
print(' - '+rrr_var_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_lsm_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_lsm_ncf)
     raise SystemExit(22) 

try:
     with open(rrr_pol_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_pol_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Read LSM netCDF file
#*******************************************************************************
print('Read LSM netCDF file')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Open netCDF file
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f = netCDF4.Dataset(rrr_lsm_ncf, 'r')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get dimension sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
IS_lsm_lon=len(f.dimensions['lon'])
print(' - The number of longitudes is: '+str(IS_lsm_lon))

IS_lsm_lat=len(f.dimensions['lat'])
print(' - The number of latitudes is: '+str(IS_lsm_lat))

IS_lsm_time=len(f.dimensions['time'])
print(' - The number of time steps is: '+str(IS_lsm_time))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get values of dimension arrays
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZV_lsm_lon=f.variables['lon']
ZV_lsm_lat=f.variables['lat']
ZV_lsm_time=f.variables['time']

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get the interval sizes
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZS_lsm_lon_stp=abs(ZV_lsm_lon[1]-ZV_lsm_lon[0])
print(' - The interval size for longitudes is: '+str(ZS_lsm_lon_stp))

ZS_lsm_lat_stp=abs(ZV_lsm_lat[1]-ZV_lsm_lat[0])
print(' - The interval size for latitudes is: '+str(ZS_lsm_lat_stp))

if len(ZV_lsm_time) > 1:
     ZS_lsm_time_stp=abs(ZV_lsm_time[1]-ZV_lsm_time[0])
     print(' - The interval size for time is: '+str(ZS_lsm_time_stp))
else:
     ZS_lsm_time_stp=0
     print(' - No interval size for time (one unique time step)')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get variable names
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if 'RUNSF' in f.variables:
     YS_rsf_nam='RUNSF'
elif 'SSRUN' in f.variables:
     YS_rsf_nam='SSRUN'
elif 'Qs' in f.variables:
     YS_rsf_nam='Qs'
else:
     print('ERROR - None of RUNSF, SSRUN, or Qs exist in '+rrr_lsm_ncf)
     raise SystemExit(22) 

if 'RUNSB' in f.variables:
     YS_rsb_nam='RUNSB'
elif 'BGRUN' in f.variables:
     YS_rsb_nam='BGRUN'
elif 'Qsb' in f.variables:
     YS_rsb_nam='Qsb'
else:
     print('ERROR - None of RUNSB, BGRUN, or Qsb exist in '+rrr_lsm_ncf)
     raise SystemExit(22) 

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Get fill values
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZS_rsf_fil=netCDF4.default_fillvals['f4']

if YS_rsf_nam in f.variables:
     var=f.variables[YS_rsf_nam]
     if '_FillValue' in  var.ncattrs(): 
          ZS_rsf_fil=var._FillValue
          print(' - The fill value for '+YS_rsf_nam+' is: '+str(ZS_rsf_fil))
     else:
          ZS_rsf_fil=None
else:
     print('ERROR - Unable to find '+YS_rsf_nam+' in '+rrr_lsm_ncf)
     raise SystemExit(22) 
     
ZS_rsb_fil=netCDF4.default_fillvals['f4']

if YS_rsb_nam in f.variables:
     var=f.variables[YS_rsb_nam]
     if '_FillValue' in  var.ncattrs(): 
          ZS_rsb_fil=var._FillValue
          print(' - The fill value for '+YS_rsb_nam+' is: '+str(ZS_rsb_fil))
     else:
          ZS_rsb_fil=None
else:
     print('ERROR - Unable to find '+YS_rsb_nam+' in '+rrr_lsm_ncf)
     raise SystemExit(22) 
     

#*******************************************************************************
#Read polygon shapefile
#*******************************************************************************
print('Read polygon shapefile')

rrr_pol_lay=fiona.open(rrr_pol_shp, 'r')

IS_pol_tot=len(rrr_pol_lay)
print(' - The number of polygon features is: '+str(IS_pol_tot))


#*******************************************************************************
#Create a point shapefile with all the LSM grid cells
#*******************************************************************************
print('Create a point shapefile with all the LSM grid cells')

rrr_pol_drv=rrr_pol_lay.driver
rrr_pnt_drv=rrr_pol_drv

rrr_pol_crs=rrr_pol_lay.crs
rrr_pnt_crs=rrr_pol_crs.copy()

rrr_pnt_sch={'geometry': 'Point',                                              \
             'properties': {'JS_lsm_lon': 'int:4',                             \
                            'JS_lsm_lat': 'int:4'}}

with fiona.open(rrr_pnt_shp,'w',driver=rrr_pnt_drv,                            \
                                crs=rrr_pnt_crs,                               \
                                schema=rrr_pnt_sch) as rrr_pnt_lay:
     for JS_lsm_lon in range(IS_lsm_lon):
          ZS_lsm_lon=ZV_lsm_lon[JS_lsm_lon]
          for JS_lsm_lat in range(IS_lsm_lat):
               ZS_lsm_lat=ZV_lsm_lat[JS_lsm_lat]
               rrr_pnt_prp={'JS_lsm_lon': JS_lsm_lon, 'JS_lsm_lat': JS_lsm_lat}
               rrr_pnt_geo=shapely.geometry.mapping(                           \
                                shapely.geometry.Point((ZS_lsm_lon,ZS_lsm_lat)))
               rrr_pnt_lay.write({                                             \
                                  'properties': rrr_pnt_prp,                   \
                                  'geometry': rrr_pnt_geo,                     \
                                  })

print(' - New shapefile created')


#*******************************************************************************
#Create spatial index for the bounds of each point feature
#*******************************************************************************
print('Create spatial index for the bounds of each point feature')

rrr_pnt_lay=fiona.open(rrr_pnt_shp, 'r')

index=rtree.index.Index()
for rrr_pnt_fea in rrr_pnt_lay:
     rrr_pnt_fid=int(rrr_pnt_fea['id'])
     #the first argument of index.insert has to be 'int', not 'long' or 'str'
     rrr_pnt_shy=shapely.geometry.shape(rrr_pnt_fea['geometry'])
     index.insert(rrr_pnt_fid, rrr_pnt_shy.bounds)
     #creates an index between the feature ID and the bounds of that feature

print(' - Spatial index created')


#*******************************************************************************
#Find LSM grid cells that intersect with the polygon
#*******************************************************************************
print('Find LSM grid cells that intersect with the polygon')

IS_dom_tot=0
IV_dom_lon=[]
IV_dom_lat=[]

for rrr_pol_fea in rrr_pol_lay:
     rrr_pol_shy=shapely.geometry.shape(rrr_pol_fea['geometry'])
     rrr_pol_pre=shapely.prepared.prep(rrr_pol_shy)
     #a 'prepared' geometry allows for faster processing after
     for rrr_pnt_fid in [int(x) for x in                                       \
                                  list(index.intersection(rrr_pol_shy.bounds))]:
          rrr_pnt_fea=rrr_pnt_lay[rrr_pnt_fid]
          rrr_pnt_shy=shapely.geometry.shape(rrr_pnt_fea['geometry'])
          if rrr_pol_pre.contains(rrr_pnt_shy):
               JS_dom_lon=rrr_pnt_fea['properties']['JS_lsm_lon']
               JS_dom_lat=rrr_pnt_fea['properties']['JS_lsm_lat']
               IV_dom_lon.append(JS_dom_lon)
               IV_dom_lat.append(JS_dom_lat)
               IS_dom_tot=IS_dom_tot+1
 
print(' - The number of grid cells found is: '+str(IS_dom_tot))


#*******************************************************************************
#Notes on efficient geospatial operations
#*******************************************************************************
#Geospatial operations can be very computationally demanding unless some tricks
#are used. My experience has indicated that:
# - One should build the spatial index on the features that are the most 
#   numerous. That is because the index.intersection() function is very fast and
#   hence allows for a near instantaneous subselection of only those out of many 
#   features that are potentially within the desired spatial scope.
# - For the features that are relatively less numerous (not the ones above), one
#   should 'prepare' the geometry before performing the desired geospatial
#   operation and use the prepared objects in the operation. This step is
#   particularly key when the geometry is made of many points because it 
#   dramatically speeds up the geospatial operations.


#*******************************************************************************
#Compute surface area of each grid cell
#*******************************************************************************
print('Compute surface area of each grid cell')

ZV_dom_sqm=[0]*IS_dom_tot
for JS_dom_tot in range(IS_dom_tot):
     JS_lsm_lat=IV_dom_lat[JS_dom_tot]
     ZS_lsm_lat=ZV_lsm_lat[JS_lsm_lat]
     ZV_dom_sqm[JS_dom_tot]=6371000*math.radians(ZS_lsm_lat_stp)               \
                           *6371000*math.radians(ZS_lsm_lon_stp)               \
                           *math.cos(math.radians(ZS_lsm_lat))

print(' - The total area of interesecting grid cells is: '+str(sum(ZV_dom_sqm))\
      +' m^2')


#*******************************************************************************
#Find number of NoData points inside shapefile, and corresponding area
#*******************************************************************************
print('Find number of NoData points inside shapefile, and corresponding area')

ZM_rsf_var=f.variables[YS_rsf_nam][0,:,:]
ZM_rsb_var=f.variables[YS_rsb_nam][0,:,:]
#only looking for NoData at the first time step here, this should be consistent

if (not numpy.ma.is_masked(ZM_rsf_var)):
     ZM_rsf_var=numpy.ma.masked_array(ZM_rsf_var, mask=ZM_rsf_var*0)
if (not numpy.ma.is_masked(ZM_rsb_var)):
     ZM_rsb_var=numpy.ma.masked_array(ZM_rsb_var, mask=ZM_rsb_var*0)
#If the netCDF file doesn't have NoData value, it is read as ndarray instead of
#a masked array. The conversion to a mask array with no masked values allows
#simplifying the code below.

IS_dom_msk=0
ZS_sqm=0
for JS_dom_tot in range(IS_dom_tot):
     JS_lsm_lon=IV_dom_lon[JS_dom_tot]
     JS_lsm_lat=IV_dom_lat[JS_dom_tot]
     if (ZM_rsf_var.mask[JS_lsm_lat,JS_lsm_lon] or                             \
         ZM_rsb_var.mask[JS_lsm_lat,JS_lsm_lon]):
          IS_dom_msk=IS_dom_msk+1
     else:
          ZS_sqm=ZS_sqm+ZV_dom_sqm[JS_dom_tot]

print(' - The number of NoData points found is: '+str(IS_dom_msk))
print(' - The area (m2) for the domain is: '+str(ZS_sqm))


#*******************************************************************************
#Compute spatially integrated total runoff
#*******************************************************************************
print('Compute spatially integrated total runoff')

ZV_var=[]
for JS_lsm_time in range(IS_lsm_time):
     ZM_rsf_var=f.variables[YS_rsf_nam][JS_lsm_time,:,:]
     ZM_rsb_var=f.variables[YS_rsb_nam][JS_lsm_time,:,:]
     if (not numpy.ma.is_masked(ZM_rsf_var)):
          ZM_rsf_var=numpy.ma.masked_array(ZM_rsf_var, mask=ZM_rsf_var*0)
     if (not numpy.ma.is_masked(ZM_rsb_var)):
          ZM_rsb_var=numpy.ma.masked_array(ZM_rsb_var, mask=ZM_rsb_var*0)
     ZS_var=0
     ZV_rsf_var=ZM_rsf_var[IV_dom_lat,IV_dom_lon]
     ZV_rsb_var=ZM_rsb_var[IV_dom_lat,IV_dom_lon]
     #Accessing all values at once using multidimensional list-of-locations 
     #indexing is much faster that looping through the values individually.
     ZV_rsf_var=numpy.ma.filled(ZV_rsf_var,fill_value=0)
     ZV_rsb_var=numpy.ma.filled(ZV_rsb_var,fill_value=0)
     #Replacing masked (fill) values by 0
     ZV_dom_var=(ZV_rsf_var+ZV_rsb_var)*ZV_dom_sqm
     #Elementwise addition and multiplication
     ZS_var=sum(ZV_dom_var)
     #Spatial accumulation
     ZV_var.append(ZS_var)
     #Update time series


#*******************************************************************************
#Printing some diagnostic quantities
#*******************************************************************************
print('Printing some diagonostic quantities')

print(' - Spatially accumulated runoff (runoff units * m^2)')
print('  . Temporal mean: '+str(numpy.mean(ZV_var)))
print('  . Temporal max:  '+str(numpy.max(ZV_var)))
print('  . Temporal min:  '+str(numpy.min(ZV_var)))

print(' - Total discharge (m^3/s if the conversion factor is correct)')
print('  . Temporal mean: '+str(numpy.mean(ZV_var)*ZS_conv))
print('  . Temporal max:  '+str(numpy.max(ZV_var)*ZS_conv))
print('  . Temporal min:  '+str(numpy.min(ZV_var)*ZS_conv))

print(' - Spatially averaged runoff (runoff units)')
print('  . Temporal mean: '+str(numpy.mean(ZV_var)/ZS_sqm))
print('  . Temporal max:  '+str(numpy.max(ZV_var)/ZS_sqm))
print('  . Temporal min:  '+str(numpy.min(ZV_var)/ZS_sqm))


##*******************************************************************************
##Determine time strings
##*******************************************************************************
#print('Determine time strings')
#rrr_dat_str=datetime.datetime.strptime('2002-04-01T00:00:00',                \
#                                         '%Y-%m-%dT%H:%M:%S')
#
#YV_lsm_time=[]
#for JS_lsm_time in range(IS_lsm_time):
#     rrr_dat_dlt=datetime.timedelta(hours=ZV_lsm_time[JS_lsm_time])
#     YS_lsm_time=(rrr_dat_str+rrr_dat_dlt).strftime('%Y-%m-%d')
#     YV_lsm_time.append(YS_lsm_time)
#
#
##*******************************************************************************
##Write rrr_var_csv
##*******************************************************************************
#print('Write rrr_var_csv')
#
#with open(rrr_var_csv, 'wb') as csvfile:
#     csvwriter = csv.writer(csvfile, dialect='excel')
#     for JS_lsm_time in range(IS_lsm_time):
#          IV_line=[YV_lsm_time[JS_lsm_time],ZV_var[JS_lsm_time]] 
#          csvwriter.writerow(IV_line) 
#
#
#*******************************************************************************
#End
#*******************************************************************************
