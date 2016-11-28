#!/usr/bin/python
#*******************************************************************************
#rrr_cat_tot_gen_one_hydrosheds.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from HydroSHEDS, this program creates a csv file with 
#the following information:
# - rrr_cat_file 
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
import csv
import dbf
import shapefile
import math


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - hsd_cat_file
# 2 - rrr_cat_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 3:
     print('ERROR - 2 and only 2 arguments can be used')
     raise SystemExit(22) 

hsd_cat_file=sys.argv[1]
rrr_cat_file=sys.argv[2]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+hsd_cat_file)
print('- '+rrr_cat_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(hsd_cat_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+hsd_cat_file)
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
#Read reach IDs (much faster using dbf than shapefile module)
#-------------------------------------------------------------------------------
print('- Read attributes')
hsd_cat_dbf=dbf.Table(hsd_cat_file)
hsd_cat_dbf.open()

IV_cat_tot_id=[]
IV_cat_up_cells=[]
for record in hsd_cat_dbf:
     IV_cat_tot_id.append(record['arcid'])    
     IV_cat_up_cells.append(record['up_cells'])    

IS_cat_tot=len(IV_cat_tot_id)

#-------------------------------------------------------------------------------
#Reading shapes
#-------------------------------------------------------------------------------
print('- Read shapes')
hsd_cat_shp=shapefile.Reader(hsd_cat_file)

ZV_cat_x_str=[]
ZV_cat_y_str=[]
ZV_cat_x_end=[]
ZV_cat_y_end=[]
ZV_cat_x_cen=[]
ZV_cat_y_cen=[]
for JS_cat_tot in range(IS_cat_tot):
     shape=hsd_cat_shp.shape(JS_cat_tot)
     IS_point=len(shape.points)
     #Start point of each feature in the polyline:
     ZV_cat_x_str.append(shape.points[0][0])
     ZV_cat_y_str.append(shape.points[0][1])
     #End point of each feature in the polyline:
     ZV_cat_x_end.append(shape.points[IS_point-1][0])
     ZV_cat_y_end.append(shape.points[IS_point-1][1])
     #Centroid point of each feature in the polyline:
     #(located at the weighted average x and y coordinates of the midpoints of 
     #all line segments in the line feature; where the weight of a particular 
     #midpoint is the length of the correspondent line segment)
     ZV_cat_x_mid=[0]*(IS_point-1)
     ZV_cat_y_mid=[0]*(IS_point-1)
     ZV_cat_lengt=[0]*(IS_point-1)
     for JS_point in range(IS_point-1):
          ZV_cat_x_mid[JS_point]=( shape.points[JS_point][0]                   \
                                  +shape.points[JS_point+1][0]                 \
                                                              )/2
          ZV_cat_y_mid[JS_point]=( shape.points[JS_point][1]                   \
                                  +shape.points[JS_point+1][1]                 \
                                                              )/2
          ZV_cat_lengt[JS_point]=( ( shape.points[JS_point][0]                 \
                                    -shape.points[JS_point+1][0]               \
                                                                )**2           \
                                  +( shape.points[JS_point][1]                 \
                                    -shape.points[JS_point+1][1]               \
                                                                )**2           \
                                                                    )**0.5
     ZV_cat_x_cen.append(1/sum(ZV_cat_lengt)*                                  \
              sum([ZV_cat_x_mid[i]*ZV_cat_lengt[i] for i in range(IS_point-1)]))
     ZV_cat_y_cen.append(1/sum(ZV_cat_lengt)*                                  \
              sum([ZV_cat_y_mid[i]*ZV_cat_lengt[i] for i in range(IS_point-1)]))

print('- Total number of catchments: '+str(IS_cat_tot))


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

with open(rrr_cat_file, 'wb') as csvfile:
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
