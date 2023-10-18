#!/usr/bin/env python3
#*******************************************************************************
#rrr_cat_tot_shp_dis_per.py
#*******************************************************************************

#Purpose:
#Given a shapefile of catchments, an attribute value, and two shapefile names;
#this program dissolves all catchments into one polygon (without inner holes)
#which is saved in the first shapefile, and its perimeter is saved in the second
#shapefile. The attribute value is assigned as "pfaf_2" in the attribute table.
#Author:
#Cedric H. David, 2023-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import shapely.ops


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_pol_shp
# 2 - rrr_pff_str
# 3 - rrr_dis_shp
# 4 - rrr_per_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22)

rrr_pol_shp=sys.argv[1]
rrr_pff_str=sys.argv[2]
rrr_dis_shp=sys.argv[3]
rrr_per_shp=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_pol_shp)
print('- '+rrr_pff_str)
print('- '+rrr_dis_shp)
print('- '+rrr_per_shp)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_pol_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_pol_shp)
     raise SystemExit(22)


#*******************************************************************************
#Dissolve input shapefile
#*******************************************************************************
print('Dissolve input shapefile')

#-------------------------------------------------------------------------------
#Read shapefile
#-------------------------------------------------------------------------------
print('- Read shapefile')

rrr_pol_lay=fiona.open(rrr_pol_shp, 'r')
IS_pol_shp=len(rrr_pol_lay)
print(' . The number of features in shapefile is: '+str(IS_pol_shp))

#-------------------------------------------------------------------------------
#Unify all features into one
#-------------------------------------------------------------------------------
print('- Unify all features into one')

all_pol_shy=[shapely.geometry.shape(rrr_pol_lay[JS_pol_shp]['geometry'])       \
                                            for JS_pol_shp in range(IS_pol_shp)]

rrr_dis_shy=shapely.ops.unary_union(all_pol_shy)

#-------------------------------------------------------------------------------
#Only retain exterior
#-------------------------------------------------------------------------------
print('- Only retain exterior')

if rrr_dis_shy.type=='Polygon':
     rrr_dis_shy=shapely.geometry.Polygon(rrr_dis_shy.exterior)

if rrr_dis_shy.type=='MultiPolygon':
     rrr_dis_shy=shapely.geometry.MultiPolygon(                                \
                shapely.geometry.Polygon(p.exterior) for p in rrr_dis_shy.geoms)

print(' . The dissolved catchment geometry is of type: '+rrr_dis_shy.type)

#-------------------------------------------------------------------------------
#Additional union in case of inner islands
#-------------------------------------------------------------------------------
print('- Additional union in case of inner islands')
rrr_dis_shy=shapely.ops.unary_union(rrr_dis_shy)

#-------------------------------------------------------------------------------
#Get perimeter
#-------------------------------------------------------------------------------
print('- Get perimeter')

rrr_per_shy=rrr_dis_shy.boundary

print(' . The dissolved perimeter geometry is of type: '+rrr_per_shy.type)


#*******************************************************************************
#Creating dissolved shapefile
#*******************************************************************************
print('Creating dissolved shapefile')

#-------------------------------------------------------------------------------
#Copy Coordinate Reference System
#-------------------------------------------------------------------------------
print('- Copy Coordinate Reference System')

rrr_pol_crs=rrr_pol_lay.crs
rrr_dis_crs=rrr_pol_crs.copy()
#print(rrr_dis_crs)

#-------------------------------------------------------------------------------
#Copy Schema
#-------------------------------------------------------------------------------
print('- Copy Schema')

rrr_pol_sch=rrr_pol_lay.schema
rrr_dis_sch=rrr_pol_sch.copy()
rrr_dis_sch['properties'].clear()
rrr_dis_sch['properties']['pfaf_2']='str:2'
#print(rrr_dis_sch)

#-------------------------------------------------------------------------------
#Copy Properties
#-------------------------------------------------------------------------------
print('- Copy Properties')

rrr_dis_prp=rrr_pol_lay[0]['properties'].copy()
rrr_dis_prp.clear()
rrr_dis_prp['pfaf_2']=rrr_pff_str

#-------------------------------------------------------------------------------
#Copy Geometry
#-------------------------------------------------------------------------------
print('- Copy Geometry')

rrr_dis_geo=shapely.geometry.mapping(rrr_dis_shy)

#-------------------------------------------------------------------------------
#Create shapefile
#-------------------------------------------------------------------------------
print('- Create shapefile')

rrr_dis_lay=fiona.open(rrr_dis_shp, 'w',                                       \
                       crs=rrr_dis_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_dis_sch                                      \
                       )

rrr_dis_lay.write({                                                            \
                        'properties': rrr_dis_prp,                             \
                        'geometry': rrr_dis_geo,                               \
                        })

rrr_dis_lay.close()


#*******************************************************************************
#Creating perimeter shapefile
#*******************************************************************************
print('Creating perimeter shapefile')

#-------------------------------------------------------------------------------
#Copy Coordinate Reference System
#-------------------------------------------------------------------------------
print('- Copy Coordinate Reference System')

rrr_pol_crs=rrr_pol_lay.crs
rrr_per_crs=rrr_pol_crs.copy()
#print(rrr_per_crs)

#-------------------------------------------------------------------------------
#Copy Schema
#-------------------------------------------------------------------------------
print('- Copy Schema')

rrr_pol_sch=rrr_pol_lay.schema
rrr_per_sch=rrr_pol_sch.copy()
rrr_per_sch['properties'].clear()
rrr_per_sch['properties']['pfaf_2']='str:2'
rrr_per_sch['geometry']=rrr_per_shy.type
#print(rrr_per_sch)

#-------------------------------------------------------------------------------
#Copy Properties
#-------------------------------------------------------------------------------
print('- Copy Properties')

rrr_per_prp=rrr_pol_lay[0]['properties'].copy()
rrr_per_prp.clear()
rrr_per_prp['pfaf_2']=rrr_pff_str

#-------------------------------------------------------------------------------
#Copy Geometry
#-------------------------------------------------------------------------------
print('- Copy Geometry')

rrr_per_geo=shapely.geometry.mapping(rrr_per_shy)

#-------------------------------------------------------------------------------
#Create shapefile
#-------------------------------------------------------------------------------
print('- Create shapefile')

rrr_per_lay=fiona.open(rrr_per_shp, 'w',                                       \
                       crs=rrr_per_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_per_sch                                      \
                       )

rrr_per_lay.write({                                                            \
                        'properties': rrr_per_prp,                             \
                        'geometry': rrr_per_geo,                               \
                        })

rrr_per_lay.close()


#*******************************************************************************
#End
#*******************************************************************************
