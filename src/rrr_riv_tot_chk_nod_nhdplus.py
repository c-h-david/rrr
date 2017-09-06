#!/usr/bin/python
#*******************************************************************************
#rrr_riv_tot_chk_nod_nhdplus.py
#*******************************************************************************

#Purpose:
#Given a river shapefile, a Value Added Attribute table, and optionally a Flow 
#table (all from NHDPlus), this program checks for mismatches between Node IDs 
#and their corresponding geographic coordinates. In case Node/coordinates 
#mismatches are found, the program can check against known distant nodes that
#occur at the U.S. political boundaries. 
#If unexpected distant nodes are found, the Node IDs are reported. 
#
#Author:
#Cedric H. David, 2017-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - nhd_riv_shp
# 2 - nhd_VAA_dbf
#(3)- nhd_flw_dbf


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 3 or IS_arg > 4:
     print('ERROR - A minimum of 2 and a maximum of 3 arguments can be used')
     raise SystemExit(22)

nhd_riv_shp=sys.argv[1]
nhd_VAA_dbf=sys.argv[2]
if IS_arg == 4:
     nhd_flw_dbf = sys.argv[3]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+nhd_riv_shp)
print('- '+nhd_VAA_dbf)
if IS_arg == 4: print('- ' + nhd_flw_dbf)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(nhd_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+nhd_riv_shp)
     raise SystemExit(22) 

try:
     with open(nhd_VAA_dbf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+nhd_VAA_dbf)
     raise SystemExit(22) 

if IS_arg ==4:
     try:
          with open(nhd_flw_dbf) as file:
               pass
     except IOError as e:
          print('ERROR - Unable to open '+nhd_flw_dbf)
          raise SystemExit(22) 


#*******************************************************************************
#Reading input files
#*******************************************************************************
print('Reading input files')

#-------------------------------------------------------------------------------
#Reading nhd_riv_shp
#-------------------------------------------------------------------------------
print('- Reading nhd_riv_shp')

nhd_riv_lay=fiona.open(nhd_riv_shp, 'r')
IS_riv_all=len(nhd_riv_lay)
print(' . The number of river reaches is: '+str(IS_riv_all))

if 'COMID' in nhd_riv_lay[0]['properties']:
     YV_riv_id='COMID'
elif 'ComID' in nhd_riv_lay[0]['properties']:
     YV_riv_id='ComID'
else:
     print('ERROR - COMID and ComID do not exist in '+nhd_riv_shp)
     raise SystemExit(22) 

if 'FLOWDIR' in nhd_riv_lay[0]['properties']:
     YV_riv_fdr='FLOWDIR'
else:
     print('ERROR - FLOWDIR does not exist in '+nhd_riv_shp)
     raise SystemExit(22) 

IV_riv_tot_id=[]
for nhd_riv_fea in nhd_riv_lay:
     if (str(nhd_riv_fea['properties'][YV_riv_fdr]).strip()=='With Digitized'):
          IV_riv_tot_id.append(int(nhd_riv_fea['properties'][YV_riv_id]))

IS_riv_tot=len(IV_riv_tot_id)
print(' . The number of river reaches with known direction is: '               \
      +str(IS_riv_tot))

#-------------------------------------------------------------------------------
#Reading nhd_VAA_dbf
#-------------------------------------------------------------------------------
print('- Reading nhd_VAA_dbf')

nhd_VAA_lay=fiona.open(nhd_VAA_dbf, 'r')
IS_VAA_all=len(nhd_VAA_lay)
print(' . The number of attributes is: '+str(IS_VAA_all))

if 'COMID' in nhd_VAA_lay[0]['properties']:
     YV_VAA_id='COMID'
elif 'ComID' in nhd_VAA_lay[0]['properties']:
     YV_VAA_id='ComID'
else:
     print('ERROR - COMID and ComID do not exist in '+nhd_VAA_dbf)
     raise SystemExit(22) 

if 'FROMNODE' in nhd_VAA_lay[0]['properties']:
     YV_VAA_fnd='FROMNODE'
elif 'FromNode' in nhd_VAA_lay[0]['properties']:
     YV_VAA_fnd='FromNode'
else:
     print('ERROR - FROMNODE and FromNode do not exist in '+nhd_VAA_dbf)
     raise SystemExit(22) 

if 'TONODE' in nhd_VAA_lay[0]['properties']:
     YV_VAA_tnd='TONODE'
elif 'ToNode' in nhd_VAA_lay[0]['properties']:
     YV_VAA_tnd='ToNode'
else:
     print('ERROR - TONODE and ToNode do not exist in '+nhd_VAA_dbf)
     raise SystemExit(22) 

IV_VAA_all_id=[0]*IS_VAA_all
IV_VAA_all_fnd=[0]*IS_VAA_all
IV_VAA_all_tnd=[0]*IS_VAA_all
JS_VAA_all=0
for nhd_VAA_fea in nhd_VAA_lay: 
     IV_VAA_all_id[JS_VAA_all]=int(nhd_VAA_fea['properties'][YV_VAA_id])
     IV_VAA_all_fnd[JS_VAA_all]=int(nhd_VAA_fea['properties'][YV_VAA_fnd])
     IV_VAA_all_tnd[JS_VAA_all]=int(nhd_VAA_fea['properties'][YV_VAA_tnd])
     JS_VAA_all=JS_VAA_all+1

#-------------------------------------------------------------------------------
#Reading nhd_flw_dbf
#-------------------------------------------------------------------------------
if IS_arg==4:

     print('- Reading nhd_flw_dbf')

     nhd_flw_lay=fiona.open(nhd_flw_dbf, 'r')
     IS_flw_all=len(nhd_flw_lay)
     print(' . The number of attributes is: '+str(IS_flw_all))

     if 'NODENUMBER' in nhd_flw_lay[0]['properties']:
          YV_flw_ndn='NODENUMBER'
     else:
          print('ERROR - NODENUMBER does not exist in '+nhd_flw_dbf)
          raise SystemExit(22) 

     if 'HasGeo' in nhd_flw_lay[0]['properties']:
          YV_flw_hsg='HasGeo'
     else:
          print('ERROR - HasGeo does not exist in '+nhd_flw_dbf)
          raise SystemExit(22) 

     IM_nod_dst={}
     for nhd_flw_fea in nhd_flw_lay:
          if (str(nhd_flw_fea['properties'][YV_flw_hsg]).strip()=='N'):
               IS_flw_all_ndn=int(nhd_flw_fea['properties'][YV_flw_ndn])
               if IS_flw_all_ndn in IM_nod_dst:
                    IM_nod_dst[IS_flw_all_ndn]=IM_nod_dst[IS_flw_all_ndn]+1
               else:
                    IM_nod_dst[IS_flw_all_ndn]=1

#-------------------------------------------------------------------------------
#Checking names used
#-------------------------------------------------------------------------------
#print('- Checking names used')
#
#print(' . '+YV_riv_id)
#print(' . '+YV_riv_fdr)
#print(' . '+YV_VAA_id)
#print(' . '+YV_VAA_fnd)
#print(' . '+YV_VAA_tnd)
#print(' . '+YV_flw_ndn)
#print(' . '+YV_flw_hsg)


#*******************************************************************************
#Building hash table relating COMID to index in IV_VAA_all_id
#*******************************************************************************
print('Building hash table relating COMID to index in IV_VAA_all_id')

IM_hsh={}
for JS_VAA_all in range(IS_VAA_all):
     IM_hsh[IV_VAA_all_id[JS_VAA_all]]=JS_VAA_all


#*******************************************************************************
#Finding FromNode and ToNode for each river reach
#*******************************************************************************
print('Finding FromNode and ToNode for each river reach')

IV_riv_tot_fnd=[0]*IS_riv_tot
IV_riv_tot_tnd=[0]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     IV_riv_tot_fnd[JS_riv_tot]=IV_VAA_all_fnd[IM_hsh[IV_riv_tot_id[JS_riv_tot]]]
     IV_riv_tot_tnd[JS_riv_tot]=IV_VAA_all_tnd[IM_hsh[IV_riv_tot_id[JS_riv_tot]]]


#*******************************************************************************
#Extracting and assigning coordinates of nodes for each reach
#*******************************************************************************
print('Extracting and assigning coordinates of nodes for each reach')

IM_hsh2={}
IM_nod_err={}

JS_riv_tot=0
for nhd_riv_fea in nhd_riv_lay:
     if (str(nhd_riv_fea['properties'][YV_riv_fdr]).strip()=='With Digitized'):
          #---------------------------------------------------------------------
          #Determining the FromNode and ToNode values
          #---------------------------------------------------------------------
          IS_riv_tot_id=IV_riv_tot_id[JS_riv_tot]
          IS_riv_tot_fnd=IV_riv_tot_fnd[JS_riv_tot]
          IS_riv_tot_tnd=IV_riv_tot_tnd[JS_riv_tot]
          JS_riv_tot=JS_riv_tot+1

          #---------------------------------------------------------------------
          #Extracting coordinates for upstream and downstream nodes
          #---------------------------------------------------------------------
          if (str(nhd_riv_fea['geometry']['type']).strip()=='LineString'):
               nhd_riv_crd=nhd_riv_fea['geometry']['coordinates']
               IS_point=len(nhd_riv_crd)
               ZS_str_x=nhd_riv_crd[0][0]
               ZS_str_y=nhd_riv_crd[0][1]
               ZS_end_x=nhd_riv_crd[IS_point-1][0]
               ZS_end_y=nhd_riv_crd[IS_point-1][1]
               #This is for single-part polylines

          if (str(nhd_riv_fea['geometry']['type']).strip()=='MultiLineString'):
               nhd_riv_crd=nhd_riv_fea['geometry']['coordinates']
               IS_part=len(nhd_riv_crd)
               IS_point=len(nhd_riv_crd[IS_part-1])
               ZS_str_x=nhd_riv_crd[0][0][0]
               ZS_str_y=nhd_riv_crd[0][0][1]
               ZS_end_x=nhd_riv_crd[IS_part-1][IS_point-1][0]
               ZS_end_y=nhd_riv_crd[IS_part-1][IS_point-1][1]
               #This is for multi-part polylines

          #---------------------------------------------------------------------
          #Rounding values (1m is approx. 0.000009 degrees: keeping 6 decimals)
          #---------------------------------------------------------------------
          ZS_str_x=round(float(ZS_str_x),6)
          ZS_str_y=round(float(ZS_str_y),6)
          ZS_end_x=round(float(ZS_end_x),6)
          ZS_end_y=round(float(ZS_end_y),6)

          #---------------------------------------------------------------------
          #Populating the hash table with upstream element
          #---------------------------------------------------------------------
          if (IS_riv_tot_fnd!=0 and IS_riv_tot_fnd in IM_hsh2):
               if IM_hsh2[IS_riv_tot_fnd]!=(ZS_str_x,ZS_str_y):
                    if IS_riv_tot_fnd in IM_nod_err:
                         IM_nod_err[IS_riv_tot_fnd]=IM_nod_err[IS_riv_tot_fnd]+1
                    else:
                         IM_nod_err[IS_riv_tot_fnd]=1
          if (IS_riv_tot_fnd!=0 and IS_riv_tot_fnd not in IM_hsh2):
               IM_hsh2[IS_riv_tot_fnd]=(ZS_str_x,ZS_str_y)

          #---------------------------------------------------------------------
          #Populating the hash table with downstream element
          #---------------------------------------------------------------------
          if (IS_riv_tot_tnd!=0 and IS_riv_tot_tnd in IM_hsh2):
               if IM_hsh2[IS_riv_tot_tnd]!=(ZS_end_x,ZS_end_y):
                    if IS_riv_tot_tnd in IM_nod_err:
                         IM_nod_err[IS_riv_tot_tnd]=IM_nod_err[IS_riv_tot_tnd]+1
                    else:
                         IM_nod_err[IS_riv_tot_tnd]=1
          if (IS_riv_tot_tnd!=0 and IS_riv_tot_tnd not in IM_hsh2):
               IM_hsh2[IS_riv_tot_tnd]=(ZS_end_x,ZS_end_y)

#*******************************************************************************
#Checking node/coordinates mismatch 
#*******************************************************************************
print('Checking node/coordinates mismatch')

if (len(IM_nod_err)==0):
     print('- Success!!! No node/coordinates mismatch found')
else:
     print('- The number of node/coordinates mismatch found is: '              \
           +str(len(IM_nod_err)))
     if IS_arg!=4:
          print('ERROR - Node/coordinates mismatches cannot be checked if no ' \
                'PlusFlow file is provided:')
          print(sorted(IM_nod_err.keys()))
          raise SystemExit(99) 
     if IS_arg==4:
          BS_error=False
          IV_error=[]
          for key in IM_nod_err:
               if key not in IM_nod_dst:
                    BS_error=True
                    IV_error.append(key)
          if BS_error:
               print('ERROR - Node/coordinates mismatches were not expected '  \
                     'for the following nodes:')
               print(IV_error)
               raise SystemExit(99) 
          else:
               print('- Success!!! All mismatches were expected')
               

#*******************************************************************************
#End
#*******************************************************************************
