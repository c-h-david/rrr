#!/usr/bin/python
#*******************************************************************************
#rrr_cat_tot_gen_one_hydrosheds.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from HydroSHEDS, this program creates a csv file with 
#the following information:
# - rrr_cat_csv 
#   . Catchment ID
#   . Catchment contributing area in square kilometers
#   . Longitude of catchment centroid 
#   . Latitude of catchment centroid 
#Author:
#Cedric H. David, 2014-2016


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import math
import fiona
import shapely.geometry
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - hsd_cat_shp
# 2 - rrr_cat_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

hsd_cat_shp=sys.argv[1]
rrr_cat_csv=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+hsd_cat_shp)
print('- '+rrr_cat_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(hsd_cat_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+hsd_cat_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Geodetic information
#*******************************************************************************

#-------------------------------------------------------------------------------
#Data for WGS84
#-------------------------------------------------------------------------------
ZS_a=6378.137
#semi-major axis in km (6378.137 is for WGS84)
ZS_f=1/298.257223563
#flatening (298.257223563 is for WGS84)

#-------------------------------------------------------------------------------
#Compute other related geodetic constants 
#-------------------------------------------------------------------------------
ZS_pi=math.pi
#Pi
ZS_b=ZS_a*(1-ZS_f)
#semi-minor axis in km
ZS_c=ZS_a*math.sqrt(1-(1-ZS_f)**2)
#focal distance for the ellipse
ZS_R1=ZS_a*(1-ZS_f/3)
#arithmetic mean of ellipsoid radius
ZS_xi=math.atanh(1-ZS_f)
#dimensionless parameter


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

#-------------------------------------------------------------------------------
#Open file 
#-------------------------------------------------------------------------------
print('- Open file')

hsd_cat_lay=fiona.open(hsd_cat_shp, 'r')
IS_cat_tot=len(hsd_cat_lay)
print('- The number of catchment features is: '+str(IS_cat_tot))

#-------------------------------------------------------------------------------
#Read attributes
#-------------------------------------------------------------------------------
print('- Read attributes')

if 'ARCID' in hsd_cat_lay[0]['properties']:
     YV_cat_id='ARCID'
else:
     print('ERROR - ARCID does not exist in '+hsd_cat_shp)
     raise SystemExit(22) 

if 'UP_CELLS' in hsd_cat_lay[0]['properties']:
     YV_cat_up_cells='UP_CELLS'
else:
     print('ERROR - UP_CELLS does not exist in '+hsd_cat_shp)
     raise SystemExit(22) 

IV_cat_tot_id=[]
IV_cat_up_cells=[]
for JS_cat_tot in range(IS_cat_tot):
     hsd_cat_prp=hsd_cat_lay[JS_cat_tot]['properties']
     IV_cat_tot_id.append(int(hsd_cat_prp[YV_cat_id]))
     IV_cat_up_cells.append(int(hsd_cat_prp[YV_cat_up_cells]))

#-------------------------------------------------------------------------------
#Read geometry
#-------------------------------------------------------------------------------
print('- Read geometry')

ZV_cat_x_str=[]
ZV_cat_y_str=[]
ZV_cat_x_end=[]
ZV_cat_y_end=[]
ZV_cat_x_cen=[]
ZV_cat_y_cen=[]
for JS_cat_tot in range(IS_cat_tot):
     hsd_cat_crd=hsd_cat_lay[JS_cat_tot]['geometry']['coordinates']
     IS_point=len(hsd_cat_crd)
     #Start and end points of each polyline:
     ZV_cat_x_str.append(hsd_cat_crd[0][0])
     ZV_cat_y_str.append(hsd_cat_crd[0][1])
     ZV_cat_x_end.append(hsd_cat_crd[IS_point-1][0])
     ZV_cat_y_end.append(hsd_cat_crd[IS_point-1][1])
     #Centroid of each polyline:
     hsd_cat_lns=shapely.geometry.LineString(hsd_cat_crd)
     hsd_cat_cen=hsd_cat_lns.centroid.coords[:][0]
     ZV_cat_x_cen.append(hsd_cat_cen[0])
     ZV_cat_y_cen.append(hsd_cat_cen[1])


#*******************************************************************************
#Compute contributing area 
#*******************************************************************************
print('Compute contributing area')

#-------------------------------------------------------------------------------
#Create hash tables
#-------------------------------------------------------------------------------
print('- Create hash tables')

IM_hsh={}
for JS_cat_tot in range(IS_cat_tot):
     IM_hsh[IV_cat_tot_id[JS_cat_tot]]=JS_cat_tot

ZM_hsh={}
for JS_cat_tot in range(IS_cat_tot):
     ZM_hsh[(ZV_cat_x_str[JS_cat_tot],ZV_cat_y_str[JS_cat_tot])]=JS_cat_tot

#-------------------------------------------------------------------------------
#Find downstream elements
#-------------------------------------------------------------------------------
print('- Find downstream elements')

IV_down=[0]*IS_cat_tot
for JS_cat_tot in range(IS_cat_tot):
     if (ZV_cat_x_end[JS_cat_tot],ZV_cat_y_end[JS_cat_tot]) in ZM_hsh:
          JS_cat_tot2=ZM_hsh[(ZV_cat_x_end[JS_cat_tot],                        \
                              ZV_cat_y_end[JS_cat_tot])]
          #At this point JS_cat_tot2 is known to be downstream of JS_cat_tot
          IV_down[JS_cat_tot]=IV_cat_tot_id[JS_cat_tot2]

#-------------------------------------------------------------------------------
#Compute contributing area in number of 15s grid cells
#-------------------------------------------------------------------------------
print('- Compute contributing area in number of 15s grid cells')

IV_cat_cells=[0]*IS_cat_tot
for JS_cat_tot in range(IS_cat_tot):
     IV_cat_cells[JS_cat_tot]=IV_cat_up_cells[JS_cat_tot]

for JS_cat_tot in range(IS_cat_tot):
     if IV_down[JS_cat_tot] in IM_hsh:
          JS_cat_tot2=IM_hsh[IV_down[JS_cat_tot]]
          IV_cat_cells[JS_cat_tot2]-=IV_cat_up_cells[JS_cat_tot]

#-------------------------------------------------------------------------------
#Compute contributing area in square kilomters 
#-------------------------------------------------------------------------------
print('- Compute contributing area in square kilometers')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#Method 1: Sphere
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ZV_cat_sqkm=[0]*IS_cat_tot
for JS_cat_tot in range(IS_cat_tot):
     ZS_phi_prime=ZV_cat_y_end[JS_cat_tot]*ZS_pi/180
     #Geodetic latitude
     #The catchment centroid could have been used instead of the end point:
     #ZS_phi_prime=ZV_cat_y_cen[JS_cat_tot]*ZS_pi/180
     #But this end point was instead used in David et al. [2015, WRR]
     ZV_cat_sqkm[JS_cat_tot]=IV_cat_cells[JS_cat_tot]                          \
                            *ZS_R1                                             \
                            *ZS_R1*math.cos(ZS_phi_prime)                      \
                            *(15*ZS_pi/(3600*180))**2
     #Area computed

##- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##Method 2: Spheroid
##- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#ZV_cat_sqkm=[0]*IS_cat_tot
#for JS_cat_tot in range(IS_cat_tot):
#     ZS_phi_prime=ZV_cat_y_end[JS_cat_tot]*ZS_pi/180
#     #geodetic latitude
#     ZS_phi=math.atan(math.tan(ZS_phi_prime)*(1-ZS_f))
#     #angle of cone that is asymptotic to the hyperboloid orthogonal to the 
#     #spheroid
#     ZS_cap_phi=math.atan(math.tan(ZS_phi)*(1-ZS_f))
#     #geocentric latitude
#     ZS_l=ZS_c*math.sqrt(math.cos(ZS_phi)**2+math.sinh(ZS_xi)**2)
#     #distance between point and center of the spheroid 
#     if (ZS_phi_prime!=0): 
#          ZS_r=ZS_l*abs(math.sin(ZS_cap_phi)/math.sin(ZS_phi_prime))
#     else:
#          ZS_r=ZS_a*(1-ZS_f)**2
#     #distance between point and equatorial plane following the orthogonal to 
#     #surface
#     ZV_cat_sqkm[JS_cat_tot]=IV_cat_cells[JS_cat_tot]                          \
#                            *ZS_r                                              \
#                            *ZS_l*math.cos(ZS_phi)                             \
#                            *(15*ZS_pi/(3600*180))**2
#     #Area computed


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing files')

with open(rrr_cat_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_cat_tot in range(IS_cat_tot):
          IV_line=[IV_cat_tot_id[JS_cat_tot],                                  \
                   round(ZV_cat_sqkm[JS_cat_tot],2),                           \
                   ZV_cat_x_cen[JS_cat_tot],                                   \
                   ZV_cat_y_cen[JS_cat_tot]]
                   #ZV_cat_x_end[JS_cat_tot],                                   \
                   #ZV_cat_y_end[JS_cat_tot]]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
