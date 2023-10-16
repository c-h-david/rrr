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
#Read coast shapefile
#*******************************************************************************
print('Read coast shapefile')

rrr_cst_lay=fiona.open(rrr_cst_shp, 'r')

rrr_cst_geo = shapely.geometry.shape(rrr_cst_lay[0]['geometry'])
#get geometry of coast

IS_cst_shp=len(rrr_cst_lay)
print(' - The number of coast features is: '+str(IS_cst_shp))


#*******************************************************************************
#Intersect river IDs with buffered coast
#*******************************************************************************
print('Intersect river IDs with buffered coast')

IV_riv_cst=[]

for rrr_riv_fea in rrr_riv_lay:
     rrr_riv_did=rrr_riv_fea['properties'][YS_riv_dn]
     if rrr_riv_did==0:
     #here only looking at the terminal river reaches: NextDownID=0
          rrr_riv_shy=shapely.geometry.shape(rrr_riv_fea['geometry'])
          #get geometry
          rrr_cst_dis = rrr_cst_geo.distance(rrr_riv_shy)
          #calculate distance to coast
          #----------------------------------------------------------------
          #Current reach is actually within buffer distance of coast
          #----------------------------------------------------------------
          if rrr_cst_dis < ZS_buf:
              IV_riv_cst.append(rrr_riv_fea['properties'][YS_riv_id])
              # Add id to list


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
