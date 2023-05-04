#!/usr/bin/env python3
#*******************************************************************************
#rrr_riv_tot_gen_all_meritbasins.py
#*******************************************************************************

#Purpose:
#Given a river shapefile from MERIT Basins, and given an expected maximum number 
#of upstream river reaches per reach, this program creates a series of csv files
#with the following information:
# - rrr_con_csv 
#   . River ID
#   . ID of unique downstream river
#   . Number of upstream rivers
#   . ID of 1st upstream river
#   . (...)
#   . ID of nth upstream river
# - rrr_kfc_csv
#   . Travel time for flow wave at 1km/hour
# - rrr_xfc_csv
#   . The value 0.1
# - rrr_srt_csv
#   . Integer to use for sorting rivers, here a topological sort 
# - rrr_crd_csv
#   . River ID
#   . Longitude of a point related to each river reach
#   . Latitude of a point related to each river reach
#
#The benefit of generating all these files together is to ensure that they are 
#sorted in a similar manner.
#Author:
#Cedric H. David, 2022-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - mer_riv_shp
# 2 - IS_max_up
# 3 - rrr_con_csv
# 4 - rrr_kfc_csv
# 5 - rrr_xfc_csv
# 6 - rrr_srt_csv
# 7 - rrr_crd_csv
#(8)- BS_srt


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 8 or IS_arg > 9:
     print('ERROR - A minimum of 7 and a maximum of 8 arguments can be used')
     raise SystemExit(22) 

mer_riv_shp=sys.argv[1]
IS_max_up=int(sys.argv[2])
rrr_con_csv=sys.argv[3]
rrr_kfc_csv=sys.argv[4]
rrr_xfc_csv=sys.argv[5]
rrr_srt_csv=sys.argv[6]
rrr_crd_csv=sys.argv[7]
if IS_arg==9:
     BS_srt=sys.argv[8]
else:
     BS_srt=''


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+mer_riv_shp)
print('- '+str(IS_max_up))
print('- '+rrr_con_csv)
print('- '+rrr_kfc_csv)
print('- '+rrr_xfc_csv)
print('- '+rrr_srt_csv)
print('- '+rrr_crd_csv)
print('- '+BS_srt)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(mer_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+mer_riv_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Read shapefile
#*******************************************************************************
print('Read shapefile')

#-------------------------------------------------------------------------------
#Open file 
#-------------------------------------------------------------------------------
print('- Open file')

mer_riv_lay=fiona.open(mer_riv_shp, 'r')
IS_riv_tot=len(mer_riv_lay)
print('- The number of river features is: '+str(IS_riv_tot))

#-------------------------------------------------------------------------------
#Read attributes
#-------------------------------------------------------------------------------
print('- Read attributes')

if 'COMID' in mer_riv_lay[0]['properties']:
     YV_riv_id='COMID'
else:
     print('ERROR - COMID does not exist in '+mer_riv_shp)
     raise SystemExit(22) 

if 'lengthkm' in mer_riv_lay[0]['properties']:
     YV_riv_lkm='lengthkm'
else:
     print('ERROR - lengthkm does not exist in '+mer_riv_shp)
     raise SystemExit(22) 

IV_riv_tot_id=[]
ZV_riv_lkm=[]
for JS_riv_tot in range(IS_riv_tot):
     IV_riv_tot_id.append(int(mer_riv_lay[JS_riv_tot]['properties'][YV_riv_id]))
     ZV_riv_lkm.append(float(mer_riv_lay[JS_riv_tot]['properties'][YV_riv_lkm]))

#-------------------------------------------------------------------------------
#Reading shapes
#-------------------------------------------------------------------------------
print('- Read shapes')

ZV_x_ups=[]
ZV_y_ups=[]
ZV_x_dwn=[]
ZV_y_dwn=[]
ZV_x_crd=[]
ZV_y_crd=[]
for JS_riv_tot in range(IS_riv_tot):
     mer_riv_crd=mer_riv_lay[JS_riv_tot]['geometry']['coordinates']
     IS_point=len(mer_riv_crd)
     #Upstream and downstream points of each polyline:
     ZV_x_dwn.append(mer_riv_crd[0][0])
     ZV_y_dwn.append(mer_riv_crd[0][1])
     ZV_x_ups.append(mer_riv_crd[IS_point-1][0])
     ZV_y_ups.append(mer_riv_crd[IS_point-1][1])
     #Second to last downstream points for each polyline:
     ZV_x_crd.append(mer_riv_crd[1][0])
     ZV_y_crd.append(mer_riv_crd[1][1])


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
     ZM_hsh[(ZV_x_ups[JS_riv_tot],ZV_y_ups[JS_riv_tot])]=JS_riv_tot

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
     if (ZV_x_dwn[JS_riv_tot],ZV_y_dwn[JS_riv_tot]) in ZM_hsh:
          JS_riv_tot2=ZM_hsh[(ZV_x_dwn[JS_riv_tot],ZV_y_dwn[JS_riv_tot])]
          #At this point JS_riv_tot2 is known to be downstream of JS_riv_tot
          IV_down[JS_riv_tot]=IV_riv_tot_id[JS_riv_tot2]
          #Populate IV_down 
          IV_nbup[ZM_hsh[(ZV_x_dwn[JS_riv_tot],ZV_y_dwn[JS_riv_tot])]]+=1
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
print('- Maximum topological order: '+str(max(IV_top_order)))

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

print('- Topological sort computed')


##*******************************************************************************
#Compute pfac
#*******************************************************************************
print('Processing routing parameters')
ZV_kfac=[float(0)] * IS_riv_tot
ZV_xfac=[float(0)] * IS_riv_tot

for JS_riv_tot in range(IS_riv_tot):
     ZV_kfac[JS_riv_tot]=ZV_riv_lkm[JS_riv_tot]*1000*3.6
     ZV_xfac[JS_riv_tot]=0.1


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing files')

with open(rrr_con_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IV_line=[IV_riv_tot_id[JS_riv_tot], 
                   IV_down[JS_riv_tot], 
                   IV_nbup[JS_riv_tot]] 
          IV_line=IV_line+IM_up[JS_riv_tot]
          csvwriter.writerow(IV_line) 

with open(rrr_kfc_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([round(ZV_kfac[JS_riv_tot],4)])

with open(rrr_xfc_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([round(ZV_xfac[JS_riv_tot],4)])

with open(rrr_srt_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          csvwriter.writerow([IV_top_sort[JS_riv_tot]]) 

with open(rrr_crd_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IV_line=[IV_riv_tot_id[JS_riv_tot], 
                   ZV_x_crd[JS_riv_tot], 
                   ZV_y_crd[JS_riv_tot]] 
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
