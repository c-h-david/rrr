#!/usr/bin/env python
#*******************************************************************************
#rrr_cat_tot_gen_one_nhdplus.py
#*******************************************************************************

#Purpose:
#Given a catchment shapefile from NHDPlus, this program creates a csv file with 
#the following information:
# - rrr_cat_file 
#   . Catchment ID
#   . Catchment contributing area in square kilometers
#   . Longitude of catchment centroid 
#   . Latitude of catchment centroid 
#Author:
#Cedric H. David, 2007-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import dbf
import shapefile


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - nhd_cat_file
# 2 - rrr_cat_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

nhd_cat_file=sys.argv[1]
rrr_cat_file=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+nhd_cat_file)
print('- '+rrr_cat_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(nhd_cat_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+nhd_cat_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

#-------------------------------------------------------------------------------
#Read reach IDs (much faster using dbf than shapefile module)
#-------------------------------------------------------------------------------
print('- Read attributes')
nhd_cat_dbf=dbf.Table(nhd_cat_file)
nhd_cat_dbf.open()

record=nhd_cat_dbf[0]
if hasattr(record,'comid'):
     YS_id_name='comid'
elif hasattr(record,'featureid'):
     YS_id_name='featureid'
else:
     print('ERROR - No attribute named comid or featureid in '+nhd_cat_file)
     raise SystemExit(22) 

IV_cat_tot_id=[]
ZV_cat_sqkm=[]
for record in nhd_cat_dbf:
     IV_cat_tot_id.append(record[YS_id_name])    
     ZV_cat_sqkm.append(record['areasqkm'])    

IS_cat_tot=len(IV_cat_tot_id)

#-------------------------------------------------------------------------------
#Reading shapes
#-------------------------------------------------------------------------------
print('- Read shapes')
nhd_cat_shp=shapefile.Reader(nhd_cat_file)

#For formulas used here, see:
#https://en.wikipedia.org/wiki/Centroid#Centroid_of_polygon
ZV_cat_x_cen=[]
ZV_cat_y_cen=[]
for JS_cat_tot in range(IS_cat_tot):
     shape=nhd_cat_shp.shape(JS_cat_tot)
     #Current polygon feature in the shapefile
     shpoints=shape.points
     #Object with all vertices of the current polygon feature
     IS_point=len(shpoints)
     #Number of vertices in the current polygon feature
     IV_idx=shape.parts
     #Start indices for each part of the multipart polygon feature 
     IS_part=len(IV_idx)
     #Number of parts in the multipart polygon feature
     IV_idx.append(IS_point)
     #Add the total number of vertices to allow for looping from start to end
     ZV_prt_area=[]
     ZV_prt_x_cen=[]
     ZV_prt_y_cen=[]
     #area, longitude and latitude of each part of the multipart
     for JS_part in range(IS_part):
          #Start/end indices of the part in the multipart polygon shapefiles
          IS_p_str=IV_idx[JS_part]
          IS_p_end=IV_idx[JS_part+1]
          #Area of each part in the multipart polygon shapefile:
          ZS_area=0
          for JS_point in range(IS_p_str,IS_p_end-1):
               ZS_area += ( shpoints[JS_point  ][0]*shpoints[JS_point+1][1]    \
                           -shpoints[JS_point+1][0]*shpoints[JS_point  ][1])
          ZS_area += ( shpoints[IS_p_end-1][0]*shpoints[IS_p_str  ][1]         \
                      -shpoints[IS_p_str  ][0]*shpoints[IS_p_end-1][1])
          ZS_area /= 2
          #Centroid of each part in the multipart polygon shapefile:
          ZS_x=0
          ZS_y=0
          for JS_point in range(IS_p_str,IS_p_end-1):
               ZS_x += ( shpoints[JS_point  ][0]+shpoints[JS_point+1][0] )     \
                      *( shpoints[JS_point  ][0]*shpoints[JS_point+1][1]       \
                        -shpoints[JS_point+1][0]*shpoints[JS_point  ][1])
               ZS_y += ( shpoints[JS_point  ][1]+shpoints[JS_point+1][1] )     \
                      *( shpoints[JS_point  ][0]*shpoints[JS_point+1][1]       \
                        -shpoints[JS_point+1][0]*shpoints[JS_point  ][1])
          ZS_x += ( shpoints[IS_p_end-1][0]+shpoints[IS_p_str  ][0] )          \
                 *( shpoints[IS_p_end-1][0]*shpoints[IS_p_str  ][1]            \
                   -shpoints[IS_p_str  ][0]*shpoints[IS_p_end-1][1])
          ZS_y += ( shpoints[IS_p_end-1][1]+shpoints[IS_p_str  ][1] )          \
                 *( shpoints[IS_p_end-1][0]*shpoints[IS_p_str  ][1]            \
                   -shpoints[IS_p_str  ][0]*shpoints[IS_p_end-1][1])
          ZS_x /= (ZS_area * 6.0)
          ZS_y /= (ZS_area * 6.0)
          #Append area and centroid coordinates of each part in the multipart:
          ZV_prt_area.append(ZS_area)
          ZV_prt_x_cen.append(ZS_x)
          ZV_prt_y_cen.append(ZS_y)
     #Calculate and append centroid coordinates of polygon in the shapefile:
     ZS_cat_x_cen =sum([ZV_prt_area[i]*ZV_prt_x_cen[i] for i in range(IS_part)])
     ZS_cat_x_cen /=sum(ZV_prt_area)
     ZV_cat_x_cen.append(ZS_cat_x_cen)
     ZS_cat_y_cen =sum([ZV_prt_area[i]*ZV_prt_y_cen[i] for i in range(IS_part)])
     ZS_cat_y_cen /=sum(ZV_prt_area)
     ZV_cat_y_cen.append(ZS_cat_y_cen)

print('- Total number of catchments: '+str(IS_cat_tot))


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing files')

with open(rrr_cat_file, 'wb') as csvfile:
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
