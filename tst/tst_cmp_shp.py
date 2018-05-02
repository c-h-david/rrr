#!/usr/bin/env python2
#*******************************************************************************
#tst_cmp_shp.py
#*******************************************************************************

#Purpose:
#Compare two shapefiles. The geometries are first checked, then all the 
#attributes of the first file are checked within the second file.
#Author:
#Cedric H. David, 2016-2018


#*******************************************************************************
#Prerequisites
#*******************************************************************************
import sys
import fiona


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_old_shp
# 2 - rrr_new_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3 :
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

rrr_old_shp=sys.argv[1]
rrr_new_shp=sys.argv[2]
   

#*******************************************************************************
#Print current variables
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_old_shp)
print('- '+rrr_new_shp)


#*******************************************************************************
#Test if input files exist
#*******************************************************************************
try:
     with open(rrr_old_shp) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_old_shp)
     raise SystemExit(22) 

try:
     with open(rrr_new_shp) as file:
          pass
except IOError as e:
     print('Unable to open '+rrr_new_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Open rrr_old_shp
#*******************************************************************************
print('Open rrr_old_shp')

rrr_old_lay=fiona.open(rrr_old_shp, 'r')

IS_old_tot=len(rrr_old_lay)
print('- The number of features is: '+str(IS_old_tot))

YV_old_prp=rrr_old_lay.schema['properties'].keys()
print('- The number of attributes is: '+str(len(YV_old_prp)))


#*******************************************************************************
#Open rrr_new_shp
#*******************************************************************************
print('Open rrr_new_shp')

rrr_new_lay=fiona.open(rrr_new_shp, 'r')

IS_new_tot=len(rrr_new_lay)
print('- The number of features is: '+str(IS_new_tot))

YV_new_prp=rrr_new_lay.schema['properties'].keys()
print('- The number of attributes is: '+str(len(YV_new_prp)))


#*******************************************************************************
#Compare number of features
#*******************************************************************************
print('Compare number of features')
if IS_old_tot==IS_new_tot:
     print('- The numbers of features are the same')
else:
     print('ERROR - The numbers of features are different: '                   \
           +str(IS_old_tot)+' <> '+str(IS_new_tot))
     raise SystemExit(99) 


#*******************************************************************************
#Compare content of shapefiles
#*******************************************************************************
print('Compare content of shapefiles')

for JS_old_tot in range(IS_old_tot):
     #--------------------------------------------------------------------------
     #Extract the properties and geometry for the current feature of old file
     #--------------------------------------------------------------------------
     rrr_old_fea=rrr_old_lay[JS_old_tot]
     rrr_old_prp=rrr_old_fea['properties']
     rrr_old_geo=rrr_old_fea['geometry']

     #--------------------------------------------------------------------------
     #Extract the properties and geometry for the current feature of new file
     #--------------------------------------------------------------------------
     rrr_new_fea=rrr_new_lay[JS_old_tot]
     rrr_new_prp=rrr_new_fea['properties']
     rrr_new_geo=rrr_new_fea['geometry']
     
     #--------------------------------------------------------------------------
     #Compare geometry
     #--------------------------------------------------------------------------
     if rrr_old_geo!=rrr_new_geo:
          print('ERROR - The geometries of features are different for index: ' \
                +str(JS_old_tot))
          raise SystemExit(99) 

     #--------------------------------------------------------------------------
     #Compare attributes
     #--------------------------------------------------------------------------
     for YS_old_prp in YV_old_prp:
          if rrr_old_prp[YS_old_prp]!=rrr_new_prp[YS_old_prp]:
               print('ERROR - The attributes of features are different for '+  \
                     'index: '+str(JS_old_tot)+', attribute: '+str(JS_old_att))
            
print('Success!!!')


#*******************************************************************************
#End
#*******************************************************************************
