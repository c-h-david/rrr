#!/usr/bin/env python3
#*******************************************************************************
#rrr_cat_tot_gen_one_meritbasins.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from MERIT Basins, this program creates a csv file with 
#the following information:
# - rrr_cat_csv 
#   . Catchment ID
#   . Catchment contributing area in square kilometers
#   . Longitude of catchment centroid 
#   . Latitude of catchment centroid 
#Author:
#Cedric H. David, 2022-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - mer_cat_shp
# 2 - rrr_cat_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

mer_cat_shp=sys.argv[1]
rrr_cat_csv=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+mer_cat_shp)
print('- '+rrr_cat_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(mer_cat_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+mer_cat_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

#-------------------------------------------------------------------------------
#Open file 
#-------------------------------------------------------------------------------
print('- Open file')

mer_cat_lay=fiona.open(mer_cat_shp, 'r')
IS_cat_tot=len(mer_cat_lay)
print('- The number of catchment features is: '+str(IS_cat_tot))

#-------------------------------------------------------------------------------
#Read attributes
#-------------------------------------------------------------------------------
print('- Read attributes')

if 'COMID' in mer_cat_lay[0]['properties']:
     YV_cat_id='COMID'
else:
     print('ERROR - COMID does not exist in '+mer_cat_shp)
     raise SystemExit(22) 

if 'areasqkm' in mer_cat_lay[0]['properties']:
     YV_cat_sqkm='areasqkm'
elif 'unitarea' in mer_cat_lay[0]['properties']:
     YV_cat_sqkm='unitarea'
else:
     print('ERROR - Neither areasqkm nor unitarea exist in '+mer_cat_shp)
     raise SystemExit(22) 

IV_cat_tot_id=[]
ZV_cat_sqkm=[]
for JS_cat_tot in range(IS_cat_tot):
     mer_cat_prp=mer_cat_lay[JS_cat_tot]['properties']
     IV_cat_tot_id.append(int(mer_cat_prp[YV_cat_id]))
     ZV_cat_sqkm.append(float(mer_cat_prp[YV_cat_sqkm]))

#-------------------------------------------------------------------------------
#Read geometry
#-------------------------------------------------------------------------------
print('- Read geometry')

ZV_cat_x_cen=[]
ZV_cat_y_cen=[]
for JS_cat_tot in range(IS_cat_tot):
     mer_cat_geo=mer_cat_lay[JS_cat_tot]['geometry']
     #extracted the geometry for one feature in this shapefile.
     mer_cat_pnt=shapely.geometry.shape(mer_cat_geo).centroid
     #create the centroid for this one feature.
     mer_cat_cen=mer_cat_pnt.coords[:][0]
     #extracted the coordinates for the centroid
     ZV_cat_x_cen.append(mer_cat_cen[0])
     ZV_cat_y_cen.append(mer_cat_cen[1])
     #assigned coordinates to array


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing files')

with open(rrr_cat_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_cat_tot in range(IS_cat_tot):
          IV_line=[IV_cat_tot_id[JS_cat_tot],                                  \
                   round(ZV_cat_sqkm[JS_cat_tot],4),                           \
                   ZV_cat_x_cen[JS_cat_tot],                                   \
                   ZV_cat_y_cen[JS_cat_tot]]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
