#!/usr/bin/python
#*******************************************************************************
#rrr_riv_tot_gen_all_hydrosheds.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from HydroSHEDS, and given an expected maximum number 
#of upstream river reaches per reach, this program creates a series of csv files
#with the following information:
# - rrr_con_file 
#   . River ID
#   . ID of unique downstream river
#   . Number of upstream rivers
#   . ID of 1st upstream river
#   . (...)
#   . ID of nth upstream river
# - rrr_kfc_file
#   . Travel time for flow wave at 1km/hour
# - rrr_xfc_file
#   . The value 0.1
# - rrr_srt_file
#   . Integer to use for sorting rivers, here a topological sort 
# - rrr_crd_file
#   . River ID
#   . Longitude of a point related to each river reach
#   . Latitude of a point related to each river reach
#
#The benefit of generating all these files together is to ensure that they are 
#sorted in a similar manner.
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
# 1 - hsd_riv_file
# 2 - rrr_con_file
# 3 - IS_max_up
# 4 - rrr_kfc_file
# 5 - rrr_xfc_file
# 6 - rrr_srt_file
# 7 - rrr_crd_file
#(8)- BS_srt


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 8 or IS_arg > 9:
     print('ERROR - A minimum of 7 and a maximum of 8 arguments can be used')
     raise SystemExit(22) 

hsd_riv_file=sys.argv[1]
IS_max_up=int(sys.argv[2])
rrr_con_file=sys.argv[3]
rrr_kfc_file=sys.argv[4]
rrr_xfc_file=sys.argv[5]
rrr_srt_file=sys.argv[6]
rrr_crd_file=sys.argv[7]
if IS_arg==9:
     BS_srt=sys.argv[8]
else:
     BS_srt=''


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+hsd_riv_file)
print('- '+str(IS_max_up))
print('- '+rrr_con_file)
print('- '+rrr_kfc_file)
print('- '+rrr_xfc_file)
print('- '+rrr_srt_file)
print('- '+rrr_crd_file)
print('- '+BS_srt)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(hsd_riv_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+hsd_riv_file)
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
print('- Read reach IDs')
hsd_riv_dbf=dbf.Table(hsd_riv_file)
hsd_riv_dbf.open()

IV_riv_tot_id=[]
for record in hsd_riv_dbf:
     IV_riv_tot_id.append(record['arcid'])    

IS_riv_tot=len(IV_riv_tot_id)
print('- Total number of river reaches: '+str(IS_riv_tot))

#-------------------------------------------------------------------------------
#Reading shapes
#-------------------------------------------------------------------------------
print('- Read shapes')
hsd_riv_shp=shapefile.Reader(hsd_riv_file)

#See formlat for distance on a sphere at:
#https://en.wikipedia.org/wiki/Great-circle_distance#Computational_formulas
ZV_x_str=[]
ZV_y_str=[]
ZV_x_end=[]
ZV_y_end=[]
ZV_x_crd=[]
ZV_y_crd=[]
ZV_lengthkm=[]
for JS_riv_tot in range(IS_riv_tot):
     shape=hsd_riv_shp.shape(JS_riv_tot)
     IS_point=len(shape.points)
     #Start and end points of each polyline:
     ZV_x_str.append(shape.points[0][0])
     ZV_y_str.append(shape.points[0][1])
     ZV_x_end.append(shape.points[IS_point-1][0])
     ZV_y_end.append(shape.points[IS_point-1][1])
     ZV_x_crd.append(shape.points[IS_point-2][0])
     ZV_y_crd.append(shape.points[IS_point-2][1])
     #Length of the polyline:
     ZS_lengthkm=0
     for JS_point in range(IS_point-1):
          ZS_lon1=(math.pi/180)*shape.points[JS_point  ][0]
          ZS_lat1=(math.pi/180)*shape.points[JS_point  ][1]
          ZS_lon2=(math.pi/180)*shape.points[JS_point+1][0]
          ZS_lat2=(math.pi/180)*shape.points[JS_point+1][1]
          ZS_dlon=abs(ZS_lon2-ZS_lon1)
          ZS_dlat=abs(ZS_lat2-ZS_lat1)
          ZS_arc=2*math.asin(math.sqrt( (math.sin(ZS_dlat/2))**2               \
                                       +(math.cos(ZS_lat1)*math.cos(ZS_lat2))  \
                                       *(math.sin(ZS_dlon/2))**2             ))
          ZS_lengthkm += ZS_R1*ZS_arc
     ZV_lengthkm.append(ZS_lengthkm)


#*******************************************************************************
#Compute connectivity
#*******************************************************************************
print('Compute connectivity')

#-------------------------------------------------------------------------------
#Create hash tables
#-------------------------------------------------------------------------------
print('- Create hash tables')
ZM_hsh={}

for JS_riv_tot in range(IS_riv_tot):
     ZM_hsh[(ZV_x_str[JS_riv_tot],ZV_y_str[JS_riv_tot])]=JS_riv_tot
     #ZM_hsh2[]=JS_riv_tot

IM_hsh={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

#-------------------------------------------------------------------------------
#Populate connectivity arrays
#-------------------------------------------------------------------------------
print('- Populate connectivity arrays')

IV_down=[0]*IS_riv_tot
IV_nbup=[0]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     if (ZV_x_end[JS_riv_tot],ZV_y_end[JS_riv_tot]) in ZM_hsh:
          JS_riv_tot2=ZM_hsh[(ZV_x_end[JS_riv_tot],ZV_y_end[JS_riv_tot])]
          #At this point JS_riv_tot2 is known to be downstream of JS_riv_tot
          IV_down[JS_riv_tot]=IV_riv_tot_id[JS_riv_tot2]
          #Populate IV_down 
          IV_nbup[ZM_hsh[(ZV_x_end[JS_riv_tot],ZV_y_end[JS_riv_tot])]]+=1
          #Increment IV_nbup

IS_max_up_dat=max(IV_nbup)
print('- Max number of upstream reaches per reach specified: '+str(IS_max_up))
print('- Max number of upstream reaches per reach from data: '                 \
      +str(IS_max_up_dat))
if IS_max_up_dat > IS_max_up:
     IS_max_up=IS_max_up_dat
print('- Max number of upstream reaches per reach used:      '+str(IS_max_up))
#Update the maximum number of upstream reaches per reach from data

IM_up= [[0 for JS_up in range(IS_max_up)] for JS_riv_tot in range(IS_riv_tot)]
IV_nbup=[0] * IS_riv_tot
JS_up=0
for JS_riv_tot in range(IS_riv_tot):
     if IV_down[JS_riv_tot] in IM_hsh:
          JS_riv_tot2=IM_hsh[IV_down[JS_riv_tot]]
          JS_up=IV_nbup[JS_riv_tot2] 
          IV_nbup[JS_riv_tot2] +=1
          IM_up[JS_riv_tot2][JS_up]=IV_riv_tot_id[JS_riv_tot]
#Compute all upstream elements

#-------------------------------------------------------------------------------
#Print some network statistics
#-------------------------------------------------------------------------------
print('- Total number of nonzero elements in network matrix: '                 \
      +str(sum(IV_nbup)))


#*******************************************************************************
#Compute the topological order and a topological sort
#*******************************************************************************
print('Compute a topological sort')

#-------------------------------------------------------------------------------
#Compute the topological order
#-------------------------------------------------------------------------------
IV_top_order=[-9999]*IS_riv_tot
BV_top_order=[False]*IS_riv_tot
BV_top_current=[False]*IS_riv_tot

for JS_riv_tot in range(IS_riv_tot):
     if IV_down[JS_riv_tot] == 0:
          IV_top_order[JS_riv_tot]=1
          BV_top_order[JS_riv_tot]=True
          BV_top_current[JS_riv_tot]=True

IS_count=0
while IS_count<IS_riv_tot:
     for JS_riv_tot in range(IS_riv_tot):
          if BV_top_current[JS_riv_tot] == True:
               for JS_up in range(IV_nbup[JS_riv_tot]):
                    JS_riv_tot2=IM_hsh[IM_up[JS_riv_tot][JS_up]]
                    IV_top_order[JS_riv_tot2]=IV_top_order[JS_riv_tot]+1
                    BV_top_order[JS_riv_tot2]=True
                    BV_top_current[JS_riv_tot2]=True
          BV_top_current[JS_riv_tot]=False
     IS_count=sum(BV_top_order)
     #print(IS_count)

#-------------------------------------------------------------------------------
#Compute a topological sort
#-------------------------------------------------------------------------------
z=zip(IV_top_order,IV_riv_tot_id)
#z is a list of tuples with 1st element: IV_top_order, and 2nd: IV_riv_tot_id
z_srt=sorted(z, key = lambda x : (x[0], -x[1])) 
#z_srt is sorted in increasing IV_top_order and decreasing IV_riv_tot_id

IV_top_sort=[0]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     JS_riv_tot2=IM_hsh[z_srt[JS_riv_tot][1]]
     IV_top_sort[JS_riv_tot2]=JS_riv_tot


#*******************************************************************************
#Compute pfac
#*******************************************************************************
print('Processing routing parameters')
ZV_kfac=[float(0)] * IS_riv_tot
ZV_xfac=[float(0)] * IS_riv_tot

for JS_riv_tot in range(IS_riv_tot):
     ZV_kfac[JS_riv_tot]=ZV_lengthkm[JS_riv_tot]*1000*3.6
     ZV_xfac[JS_riv_tot]=0.1


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing files')

with open(rrr_con_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IV_line=[IV_riv_tot_id[JS_riv_tot], 
                   IV_down[JS_riv_tot], 
                   IV_nbup[JS_riv_tot]] 
          IV_line=IV_line+IM_up[JS_riv_tot]
          csvwriter.writerow(IV_line) 

with open(rrr_kfc_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([ZV_kfac[JS_riv_tot]]) 

with open(rrr_xfc_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([ZV_xfac[JS_riv_tot]]) 

with open(rrr_srt_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([IV_top_sort[JS_riv_tot]]) 

with open(rrr_crd_file, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IV_line=[IV_riv_tot_id[JS_riv_tot], 
                   ZV_lon[JS_riv_tot], 
                   ZV_lat[JS_riv_tot]] 
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
