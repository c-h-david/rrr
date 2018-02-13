#!/usr/bin/env python2
#*******************************************************************************
#rrr_riv_tot_ext_bas_hydrosheds.py
#*******************************************************************************

#Purpose:
#Given a polygon shapefile that contains HydroSHEDS basins, a bracketed list of
#HydroSHEDS BASIN_ID, and a polyline shapefile that contains HydroSHEDS rivers,
#this script creates a new polygon shapefile with only the requested HydroSHEDS
#basins and a new polyline shapefile with the corresponding HydroSHEDS rivers.
#Author:
#Cedric H. David, 2018-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import shapely.prepared
import rtree
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_bas_shp
# 2 - rrr_bas_lst
# 3 - rrr_riv_shp
# 4 - rrr_ba2_shp
# 5 - rrr_ri2_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22) 

rrr_bas_shp=sys.argv[1]
rrr_bas_lst=sys.argv[2]
rrr_riv_shp=sys.argv[3]
rrr_ba2_shp=sys.argv[4]
rrr_ri2_shp=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_bas_shp)
print('- '+rrr_bas_lst)
print('- '+rrr_riv_shp)
print('- '+rrr_ba2_shp)
print('- '+rrr_ri2_shp)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_bas_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_bas_shp)
     raise SystemExit(22) 

try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Open rrr_bas_shp
#*******************************************************************************
print('Open rrr_bas_shp')

rrr_bas_lay=fiona.open(rrr_bas_shp, 'r')
IS_bas_tot=len(rrr_bas_lay)
print('- The number of basin features is: '+str(IS_bas_tot))

if 'BASIN_ID' in rrr_bas_lay[0]['properties']:
     YV_bas_id='BASIN_ID'
else:
     print('ERROR - BASIN_ID does not exist in '+rrr_bas_shp)
     raise SystemExit(22) 

IV_bas_tot_id=[]
IH_bas_tot_index={}
for JS_bas_tot in range(IS_bas_tot):
     IS_bas_tot_id=int(rrr_bas_lay[JS_bas_tot]['properties'][YV_bas_id])
     IV_bas_tot_id.append(IS_bas_tot_id)
     IH_bas_tot_index[IS_bas_tot_id]=JS_bas_tot


#*******************************************************************************
#Create list of basin IDs requested
#*******************************************************************************
print('Create list of basin IDs requested')

exec('IV_ba2_tot_id='+rrr_bas_lst)
IS_ba2_tot=len(IV_ba2_tot_id)
print('- The number of basin IDs requested is: '+str(IS_ba2_tot))


#*******************************************************************************
#Open rrr_riv_shp
#*******************************************************************************
print('Open rrr_riv_shp')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')
IS_riv_tot=len(rrr_riv_lay)
print('- The number of river features is: '+str(IS_riv_tot))

if 'ARCID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='ARCID'
else:
     print('ERROR - ARCID does not exist in '+rrr_riv_shp)
     raise SystemExit(22) 

IV_riv_tot_id=[]
IH_riv_tot_index={}
for JS_riv_tot in range(IS_riv_tot):
     IS_riv_tot_id=int(rrr_riv_lay[JS_riv_tot]['properties'][YV_riv_id])
     IV_riv_tot_id.append(IS_riv_tot_id)
     IH_riv_tot_index[IS_riv_tot_id]=JS_riv_tot


#*******************************************************************************
#Create new basin shapefile
#*******************************************************************************
print('Create new basin shapefile')

rrr_bas_crs=rrr_bas_lay.crs
rrr_ba2_crs=rrr_bas_crs.copy()
#print(rrr_ba2_crs)
print('- Coordinate Reference System copied')

rrr_bas_sch=rrr_bas_lay.schema
rrr_ba2_sch=rrr_bas_sch.copy()
#print(rrr_ba2_sch)
print('- Schema copied')

rrr_ba2_lay=fiona.open(rrr_ba2_shp, 'w',                                       \
                       crs=rrr_ba2_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_ba2_sch                                      \
                       )
print('- New shapefile created')


#*******************************************************************************
#Populate new basin shapefile
#*******************************************************************************
print('Populate new basin shapefile')

for JS_ba2_tot in range(IS_ba2_tot):
     rrr_bas_fea=rrr_bas_lay[IH_bas_tot_index[IV_ba2_tot_id[JS_ba2_tot]]]
     rrr_ba2_prp=rrr_bas_fea['properties']
     rrr_ba2_geo=rrr_bas_fea['geometry']
     rrr_ba2_lay.write({                                                       \
                        'properties': rrr_ba2_prp,                             \
                        'geometry': rrr_ba2_geo,                               \
                        })
print('- New shapefile populated')

rrr_ba2_lay.close()
#Closing file to save values and so that it can now be open in read mode


#*******************************************************************************
#Create new river shapefile
#*******************************************************************************
print('Create new river shapefile')

rrr_riv_crs=rrr_riv_lay.crs
rrr_ri2_crs=rrr_riv_crs.copy()
#print(rrr_ri2_crs)
print('- Coordinate Reference System copied')

rrr_riv_sch=rrr_riv_lay.schema
rrr_ri2_sch=rrr_riv_sch.copy()
#print(rrr_ri2_sch)
print('- Schema copied')

rrr_ri2_lay=fiona.open(rrr_ri2_shp, 'w',                                       \
                       crs=rrr_ri2_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_ri2_sch                                      \
                       )
print('- New shapefile created')


#*******************************************************************************
#Create spatial index for the bounds of each river feature
#*******************************************************************************
print('Create spatial index for the bounds of each river feature')

index=rtree.index.Index()
for rrr_riv_fea in rrr_riv_lay:
     riv_fid=int(rrr_riv_fea['id'])
     #the first argument of index.insert has to be 'int', not 'long' or 'str'
     riv_geom=shapely.geometry.shape(rrr_riv_fea['geometry'])
     index.insert(riv_fid, riv_geom.bounds)


#*******************************************************************************
#Find intersections 
#*******************************************************************************
print('Find intersections')

rrr_ba2_lay=fiona.open(rrr_ba2_shp, 'r')
#Open newly created shapefile, now in read mode

IV_ri2_tot_id=[]
#The river IDs in the new river shapefile

print('- Going through each basin feature')
for rrr_ba2_fea in rrr_ba2_lay:
     ba2_fid=int(rrr_ba2_fea['id'])
     ba2_shy=shapely.geometry.shape(rrr_ba2_fea['geometry'])
     print(' . The number of elements that intersect with this basin feature '+\
           'is: '+str(len(list(index.intersection(ba2_shy.bounds)))))
     ba2_pre=shapely.prepared.prep(ba2_shy)
     #This 'prep' step is crucial for performance: ba2_shy.contains() is much 
     #slower than ba2_pre.contains() if it is run many times.
     for riv_fid in [int(x) for x in list(index.intersection(ba2_shy.bounds))]:
          #---------------------------------------------------------------------
          #print('The bounds of riv_fid='+str(riv_fid)+                        \
          #      ' intersect with the bounds of ba2_fid='+str(ba2_fid))
          #---------------------------------------------------------------------
          rrr_riv_fea=rrr_riv_lay[riv_fid]
          riv_shy=shapely.geometry.shape(rrr_riv_fea['geometry'])
          if ba2_pre.contains(riv_shy):
               #----------------------------------------------------------------
               #print('riv_fid='+str(riv_fid)+                                 \
               #      ' is completely inside of ba2_fid='+str(ba2_fid))
               #Using 'contains' appears to be as fast as 'intersects' here
               #----------------------------------------------------------------
               IS_ri2_tot_id=int(rrr_riv_fea['properties'][YV_riv_id])
               IV_ri2_tot_id.append(IS_ri2_tot_id)

IV_ri2_tot_id.sort()
#Sorting in ascending order
IS_ri2_tot=len(IV_ri2_tot_id)
#The number of elements in the list

print('- The number of river features completely contained in requested basin '\
      +'features is: '+str(IS_ri2_tot))


#*******************************************************************************
#Populate new river shapefile
#*******************************************************************************
print('Populate new river shapefile')

for JS_ri2_tot in range(IS_ri2_tot):
     IS_ri2_tot_id=IV_ri2_tot_id[JS_ri2_tot]
     rrr_riv_fea=rrr_riv_lay[IH_riv_tot_index[IS_ri2_tot_id]]
     rrr_ri2_prp=rrr_riv_fea['properties']
     rrr_ri2_geo=rrr_riv_fea['geometry']
     rrr_ri2_lay.write({                                                       \
                        'properties': rrr_ri2_prp,                             \
                        'geometry': rrr_ri2_geo,                               \
                        })
print('- New shapefile populated')

rrr_ri2_lay.close()
#Closing file to save values


#*******************************************************************************
#End
#*******************************************************************************
