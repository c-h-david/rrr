#!/usr/bin/env python3
#*******************************************************************************
#rrr_riv_tot_cst.py
#*******************************************************************************

#Purpose:
#Given a shapefile with river reaches, a shapefile with coastline, and a buffer;
#this program determines those reaches that have a NextDownID=0 and also
#intersect with the buffered coastline. These coastal river reaches are saved in
#a shapefile.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import shapely.prepared
import rtree


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_riv_shp
# 2 - rrr_cst_shp
# 3 - ZS_buf
# 4 - rrr_snp_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22)

rrr_riv_shp=sys.argv[1]
rrr_cst_shp=sys.argv[2]
ZS_buf=float(sys.argv[3])
rrr_snp_shp=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print(' - '+rrr_riv_shp)
print(' - '+rrr_cst_shp)
print(' - '+str(ZS_buf))
print(' - '+rrr_snp_shp)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22)

try:
     with open(rrr_cst_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_cst_shp)
     raise SystemExit(22)


#*******************************************************************************
#Read river shapefile
#*******************************************************************************
print('Read river shapefile')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')

if 'COMID' in rrr_riv_lay[0]['properties']:
     YS_riv_id='COMID'
elif 'ARCID' in rrr_riv_lay[0]['properties']:
     YS_riv_id='ARCID'
else:
     print('ERROR - COMID, or ARCID do not exist in '+rrr_riv_shp)
     raise SystemExit(22)

if 'NextDownID' in rrr_riv_lay[0]['properties']:
     YS_riv_dn='NextDownID'
else:
     print('ERROR - NextDownID does not exist in '+rrr_riv_shp)
     raise SystemExit(22)

IS_riv_shp=len(rrr_riv_lay)
print(' - The number of river features is: '+str(IS_riv_shp))


#*******************************************************************************
#Create spatial index for the bounds of each river feature
#*******************************************************************************
print('Create spatial index for the bounds of each river feature')

index=rtree.index.Index()
for rrr_riv_fea in rrr_riv_lay:
     rrr_riv_did=rrr_riv_fea['properties'][YS_riv_dn]
     if rrr_riv_did==0:
     #here only looking at the terminal river reaches: NextDownID=0
          rrr_riv_fid=int(rrr_riv_fea['id'])
          #the 1st argument of index.insert has to be 'int', not 'long' or 'str'
          rrr_riv_shy=shapely.geometry.shape(rrr_riv_fea['geometry'])
          #get geometry
          index.insert(rrr_riv_fid, rrr_riv_shy.bounds)
          #creates an index between the feature ID and the feature bounds

print(' - Spatial index created')


#*******************************************************************************
#Read coast shapefile
#*******************************************************************************
print('Read coast shapefile')

rrr_cst_lay=fiona.open(rrr_cst_shp, 'r')

IS_cst_shp=len(rrr_cst_lay)
print(' - The number of coast features is: '+str(IS_cst_shp))


#*******************************************************************************
#Intersect river IDs with buffered coast
#*******************************************************************************
print('Intersect river IDs with buffered coast')

IV_riv_cst=[]

for rrr_cst_fea in rrr_cst_lay:
     rrr_cst_shy=shapely.geometry.shape(rrr_cst_fea['geometry'])
     #shapely geometric object for each gauge
     rrr_buf_shy=rrr_cst_shy.buffer(ZS_buf)
     #shapefly geometric object for a disc buffered around each gauge
     rrr_buf_pre=shapely.prepared.prep(rrr_buf_shy)
     #a 'prepared' geometric object allows for faster processing after
     IV_riv_fid=[int(x) for x in list(index.intersection(rrr_buf_shy.bounds))]
     #List of feature IDs where reach bounds intersect with buffer bounds

     for IS_riv_fid in IV_riv_fid:
          #---------------------------------------------------------------------
          #current reach might be within buffer of current gauge
          #---------------------------------------------------------------------
          rrr_riv_fea=rrr_riv_lay[IS_riv_fid]
          rrr_riv_shy=shapely.geometry.shape(rrr_riv_fea['geometry'])
          if rrr_buf_pre.intersects(rrr_riv_shy):
               #----------------------------------------------------------------
               #Current reach is actually within buffer of current gauge
               #----------------------------------------------------------------
               IV_riv_cst.append(rrr_riv_fea['properties'][YS_riv_id])


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
#Copying river shapefile while only retaining coastal reaches
#*******************************************************************************
print('Copying river shapefile while only retaining coastal reaches')

#-------------------------------------------------------------------------------
#Copy Coordinate Reference System
#-------------------------------------------------------------------------------
print('- Copy Coordinate Reference System')

rrr_riv_crs=rrr_riv_lay.crs
rrr_snp_crs=rrr_riv_crs.copy()
#print(rrr_snp_crs)

#-------------------------------------------------------------------------------
#Copy Schema
#-------------------------------------------------------------------------------
print('- Copy Schema')

rrr_riv_sch=rrr_riv_lay.schema
rrr_snp_sch=rrr_riv_sch.copy()
#print(rrr_snp_sch)

#-------------------------------------------------------------------------------
#Create Shapefile
#-------------------------------------------------------------------------------
print('- Create Shapefile')

rrr_snp_lay=fiona.open(rrr_snp_shp, 'w',                                       \
                       crs=rrr_snp_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_snp_sch                                      \
                       )

for rrr_riv_fea in rrr_riv_lay:
     rrr_riv_prp=rrr_riv_fea['properties']
     rrr_riv_geo=rrr_riv_fea['geometry']
     if rrr_riv_prp[YS_riv_id] in IV_riv_cst:
          rrr_snp_prp=rrr_riv_prp.copy()
          rrr_snp_geo=rrr_riv_geo.copy()
          rrr_snp_lay.write({                                                  \
                             'properties': rrr_snp_prp,                        \
                             'geometry': rrr_snp_geo,                          \
                             })
print('- New shapefile populated')

rrr_snp_lay.close()
print('- Closing shapefile so that values are saved')


#*******************************************************************************
#End
#*******************************************************************************
