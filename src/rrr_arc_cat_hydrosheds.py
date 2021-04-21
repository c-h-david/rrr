#WARNING! 
#This open-source code uses the following proprietary software: 
#(ArcGIS Desktop 10.5 w/ Spatial Analyst)
#*******************************************************************************
#rrr_arc_cat_hydrosheds.py
#*******************************************************************************

#Purpose:
#Given a river shapefile and a flow direction grid from HydroSHEDS, this program
#uses ArcGIS to create a catchment shapefile that has one and only one catchment 
#per river reach.
#Author:
#Cedric H. David, 2017-2021


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import arcpy


#*******************************************************************************
#Declaration of variables
#*******************************************************************************
arc_dir_ras = 'Z:\\Data\\Work\\Research\\GIS\\Datasets\\HydroSHEDS\\original\\usgs.gov\\unzip\\na_dir_15s\\na_dir_15s'
arc_riv_shp = 'Z:\\Data\\Work\\Research\\GIS\\Datasets\\HydroSHEDS\\original\\usgs.gov\\unzip\\na_riv_15s.shp'
arc_cat_shp = 'Z:\\Data\\Work\\Research\\GIS\\Projects\\HydroSHEDS\\shp\\na_cat_15s.shp'


#*******************************************************************************
#Temporary variables
#*******************************************************************************
arc_riv_ras = arc_riv_shp[:-4]+'.img'
arc_cat_ras = arc_cat_shp[:-4]+'.img'
arc_tmp_shp = arc_cat_shp[:-4]+'_tmp.shp'


#*******************************************************************************
#Allow for overwriting of outputs
#*******************************************************************************
arcpy.env.overwriteOutput = True


#*******************************************************************************
#Convert river polyline to river raster
#*******************************************************************************
arcpy.CheckOutExtension('Spatial')
#Need to check out the spatial analyst extension before using it

arcpy.env.outputCoordinateSystem = arc_dir_ras
arcpy.env.extent = arc_dir_ras
arcpy.env.snapRaster = arc_dir_ras
arcpy.PolylineToRaster_conversion(arc_riv_shp, 'ARCID', arc_riv_ras, '',       \
                                  'UP_CELLS', arc_dir_ras)
#The last argument here, the optional 'cell_size', can point to existing raster.
#One could have used arcpy.FeatureToRaster_conversion here, but that tool does
#not allow to set a priority field (here 'UP_CELLS'), without which one cannot
#ensure one-to-one relationships between reaches and catchments (and vice versa)

arcpy.CheckInExtension('Spatial')
#Checking the spatial analyst extension back in after using it


#*******************************************************************************
#Create catchment raster
#*******************************************************************************
arcpy.CheckOutExtension('Spatial')
#Need to check out the spatial analyst extension before using it

arcpy.gp.Watershed_sa(arc_dir_ras, arc_riv_ras, arc_cat_ras, 'Value')

arcpy.CheckInExtension('Spatial')
#Checking the spatial analyst extension back in after using it


#*******************************************************************************
#Create catchment polygon
#*******************************************************************************
arcpy.RasterToPolygon_conversion(arc_cat_ras, arc_tmp_shp, 'NO_SIMPLIFY',      \
                                 'Value')


#*******************************************************************************
#Clean up attributes of catchment polygon
#*******************************************************************************
arcpy.AddField_management(arc_tmp_shp, 'ARCID', 'Integer')
#Creates a new attribute called 'ARCID'

arcpy.CalculateField_management(arc_tmp_shp, 'ARCID', '!gridcode!', 'PYTHON',  \
                                '')
#Copy the values of attribute 'gridcode' into 'ARCID'

arcpy.DeleteField_management(arc_tmp_shp, 'gridcode')
#Delete the 'gridcode' field

arcpy.DeleteField_management(arc_tmp_shp, 'Id')
#Delete the 'Id' field

arcpy.Dissolve_management(arc_tmp_shp, arc_cat_shp, 'ARCID', '', 'MULTI_PART')
#Dissolve catchment shapefile to make sure each ARCID has a unique catchment


#*******************************************************************************
#Delete temporary files
#*******************************************************************************
arcpy.Delete_management(arc_riv_ras)
arcpy.Delete_management(arc_cat_ras)
arcpy.Delete_management(arc_tmp_shp)


#*******************************************************************************
#End
#*******************************************************************************
