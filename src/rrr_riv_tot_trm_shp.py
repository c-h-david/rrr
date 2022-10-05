#!/usr/bin/env python3
#*******************************************************************************
#rrr_riv_tot_trm_shp.py
#*******************************************************************************

#Purpose:
#Given a shapefile, an attribute name, and a threshold value for that attribute,
#this program creates a new shapefile that is similar to the input shapefile but
#only retains those features for which the attribute has a value greater or
#equal to the threshold.
#Author:
#Cedric H. David, 2022-2022


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_riv_shp
# 2 - YS_trm
# 3 - ZS_trm
# 4 - rrr_trm_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

rrr_riv_shp=sys.argv[1]
YS_trm=sys.argv[2]
ZS_trm=float(sys.argv[3])
rrr_trm_shp=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_riv_shp)
print('- '+YS_trm)
print('- '+str(ZS_trm))
print('- '+rrr_trm_shp)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

#-------------------------------------------------------------------------------
#Open file 
#-------------------------------------------------------------------------------
print('- Open file')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')
IS_riv_tot=len(rrr_riv_lay)
print('- The number of river features is: '+str(IS_riv_tot))

#-------------------------------------------------------------------------------
#Read attributes
#-------------------------------------------------------------------------------
print('- Read attributes')

if YS_trm not in rrr_riv_lay[0]['properties']:
     print('ERROR - The '+YS_trm+' attribute does not exist in '+rrr_riv_shp)
     raise SystemExit(22) 

#-------------------------------------------------------------------------------
#Read driver, crs, and schema
#-------------------------------------------------------------------------------
print('- Read driver, crs and schema')

rrr_riv_drv=rrr_riv_lay.driver
rrr_riv_crs=rrr_riv_lay.crs
rrr_riv_sch=rrr_riv_lay.schema


#*******************************************************************************
#Create a trimmed shapefile based on the threshold
#*******************************************************************************
print('Create a trimmed shapefile based on the threshold')

rrr_trm_drv=rrr_riv_drv
rrr_trm_crs=rrr_riv_crs
rrr_trm_sch=rrr_riv_sch

with fiona.open(rrr_trm_shp,'w',driver=rrr_trm_drv,                            \
                                crs=rrr_trm_crs,                               \
                                schema=rrr_trm_sch) as rrr_trm_lay:
     JS_riv_trm=0
     for JS_riv_tot in range(IS_riv_tot):
          if rrr_riv_lay[JS_riv_tot]['properties'][YS_trm] >= ZS_trm:
               rrr_trm_prp=rrr_riv_lay[JS_riv_tot]['properties']
               rrr_trm_geo=rrr_riv_lay[JS_riv_tot]['geometry']
               rrr_trm_lay.write({                                             \
                                  'properties': rrr_trm_prp,                   \
                                  'geometry': rrr_trm_geo,                     \
                                  })

print(' - New shapefile created')


#*******************************************************************************
#End
#*******************************************************************************
