#!/usr/bin/env python2
#*******************************************************************************
#rrr_riv_tot_gen_all_nhdplus.py
#*******************************************************************************

#Purpose:
#Given a river shapefile and a Value Added Attribute table (from NHDPlus), and 
#given an expected maximum number of upstream river reaches per reach, this 
#program creates a series of csv files with the following information:
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
#   . Integer to use for sorting rivers, here the NHDPlus Hydroseq field 
# - rrr_crd_file
#   . River ID
#   . Longitude of a point related to each river reach
#   . Latitude of a point related to each river reach
#
#The benefit of generating all these files together is to ensure that they are 
#sorted in a similar manner.
#The shapefile and the Value Added Attribute table are both needed because they 
#hold the length of river reaches and the connectivity information, 
#respectively. Such use of the two files is also valuable in order to build the 
#connectivity on a subset of an entire NHDPlus region. It is best to generate 
#the longitude/latitude file here instead of where catchments are processed 
#because some river reaches do not have catchments. 
#Author:
#Cedric H. David, 2007-2018


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import csv
import dbf
import shapefile


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - nhd_riv_file
# 2 - nhd_VAA_file
# 3 - IS_max_up
# 4 - rrr_con_file
# 5 - rrr_kfc_file
# 6 - rrr_xfc_file
# 7 - rrr_srt_file
# 8 - rrr_crd_file
#(9)- BS_sort


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg < 9 or IS_arg > 10:
     print('ERROR - A minimum of 8 and a maximum of 9 arguments can be used')
     raise SystemExit(22) 

nhd_riv_file=sys.argv[1]
nhd_VAA_file=sys.argv[2]
IS_max_up=int(sys.argv[3])
rrr_con_file=sys.argv[4]
rrr_kfc_file=sys.argv[5]
rrr_xfc_file=sys.argv[6]
rrr_srt_file=sys.argv[7]
rrr_crd_file=sys.argv[8]
if IS_arg==10:
     BS_srt=sys.argv[9]
else:
     BS_srt=''


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+nhd_riv_file)
print('- '+nhd_VAA_file)
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
     with open(nhd_riv_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+nhd_riv_file)
     raise SystemExit(22) 

try:
     with open(nhd_VAA_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+nhd_VAA_file)
     raise SystemExit(22) 


#*******************************************************************************
#Read files
#*******************************************************************************
print('Reading input files')

#-------------------------------------------------------------------------------
#Domain file
#-------------------------------------------------------------------------------
nhd_riv_dbf=dbf.Table(nhd_riv_file)
nhd_riv_dbf.open()

IV_riv_tot_id=[]
ZV_lengthkm=[]
YV_ftype=[]
for record in nhd_riv_dbf:
     if record['flowdir'].strip()=='With Digitized':
          IV_riv_tot_id.append(record['comid'])    
          ZV_lengthkm.append(record['lengthkm'])
          YV_ftype.append(str(record['ftype']).strip())
#IV_riv_tot_id and ZV_lengthkm only correspond to reaches with known flow dir.
IS_riv_tot=len(IV_riv_tot_id)

IM_hsh0={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh0[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot
#This maps a given river ID to where it is in IV_riv_tot_id

print('- Number of reaches in domain file: '+str(len(nhd_riv_dbf)))
print('- Number of reaches with known dir: '+str(IS_riv_tot))

#-------------------------------------------------------------------------------
#Value Added Attribute file
#-------------------------------------------------------------------------------
IV_FromNode=[0]*IS_riv_tot
IV_ToNode=[0]*IS_riv_tot
IV_Divergence=[0]*IS_riv_tot
IV_Hydroseq=[0]*IS_riv_tot

nhd_VAA_dbf=dbf.Table(nhd_VAA_file)
nhd_VAA_dbf.open()

for record in nhd_VAA_dbf:
     if record['comid'] in IM_hsh0: 
          JS_riv_tot=IM_hsh0[record['comid']]
          IV_FromNode[JS_riv_tot]=record['fromnode']
          IV_ToNode[JS_riv_tot]=record['tonode']
          IV_Divergence[JS_riv_tot]=record['divergence']
          IV_Hydroseq[JS_riv_tot]=record['hydroseq']

#-------------------------------------------------------------------------------
#Sorting the lists (optional)
#-------------------------------------------------------------------------------
#if BS_srt == :
#Not included yet


#*******************************************************************************
#Network connectivity 
#*******************************************************************************
print('Processing network connectivity')

#-------------------------------------------------------------------------------
#Compute connectivity
#-------------------------------------------------------------------------------
for JS_riv_tot in range(IS_riv_tot):
     if IV_FromNode[JS_riv_tot]==0:
          IV_FromNode[JS_riv_tot]=-999
#Some NHDPlus v1 reaches have FLOWDIR='With Digitized' but no info in VAA table

for JS_riv_tot in range(IS_riv_tot):
     if IV_Divergence[JS_riv_tot]==2:
          IV_FromNode[JS_riv_tot]=-999
#Virtually disconnect the upstream node of all minor divergences

for JS_riv_tot in range(IS_riv_tot):
     if YV_ftype[JS_riv_tot]=='Coastline':
          IV_FromNode[JS_riv_tot]=-999
#Virtually disconnect the upstream node of all coastlines (neeeded for NHDPlus2)

IM_hsh1={}
for JS_riv_tot in range(IS_riv_tot):
     if IV_FromNode[JS_riv_tot]!=-999:
          IM_hsh1[IV_FromNode[JS_riv_tot]]=JS_riv_tot
#Create a hash table linking each FromNode to its index in the table 

IV_down=[0] * IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     if IV_ToNode[JS_riv_tot] in IM_hsh1:
          JS_riv_tot2= IM_hsh1[IV_ToNode[JS_riv_tot]]
          IV_down[JS_riv_tot]=IV_riv_tot_id[JS_riv_tot2]
#Determine the downstream reach of each reach

IM_hsh2={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh2[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot
#Create a hash table linking each ComID to its index in the table

IV_nbup=[0] * IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     if IV_down[JS_riv_tot]!=0:
          JS_riv_tot2=IM_hsh2[IV_down[JS_riv_tot]]
          IV_nbup[JS_riv_tot2] +=1
#Compute the number of upstream elements

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
     if IV_down[JS_riv_tot] in IM_hsh2:
          JS_riv_tot2=IM_hsh2[IV_down[JS_riv_tot]]
          JS_up=IV_nbup[JS_riv_tot2] 
          IV_nbup[JS_riv_tot2] +=1
          IM_up[JS_riv_tot2][JS_up]=IV_riv_tot_id[JS_riv_tot]
#Determine the upstream reaches of each reach

#-------------------------------------------------------------------------------
#Optional: Print values on terminal
#-------------------------------------------------------------------------------
#print(str(IV_riv_tot_id))
#print(str(IV_down))
#print(str(IV_nbup))
#print(str(IM_up))

#-------------------------------------------------------------------------------
#Print some network statistics
#-------------------------------------------------------------------------------
print('- Total number of nonzero elements in network matrix: '                 \
      +str(sum(IV_nbup)))


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
#Extract longitudes and latitudes 
#*******************************************************************************
print('Extracting longitudes and latitudes')

nhd_riv_shp=shapefile.Reader(nhd_riv_file)

ZV_lon=[0]*IS_riv_tot
ZV_lat=[0]*IS_riv_tot

for JS_riv_tot in range(len(nhd_riv_dbf)):
     shaperec=nhd_riv_shp.shapeRecord(JS_riv_tot)
     #The shapeRecords() and shapeRecord() methods access both records and shape
     #Using nhd_riv_shp.shapeRecords() seems to stall when the shapefile is big,
     #probably because it creates a huge object. Instead, we access each 
     #shapeRecord(JS_riv_tot) individually, since we know the number of river 
     #reaches from the dbf toolbox above.
     IS_riv_id=shaperec.record[0]
     #this is the river ID of the current river reach
     if IS_riv_id in IM_hsh0:
          #only reaches with known flow direction are used here
          shape=shaperec.shape
          IS_point=len(shape.points)
          #Second to last points of each polyline (IS_point-1 is last):
          ZV_lon[IM_hsh0[IS_riv_id]]=shape.points[IS_point-2][0]
          ZV_lat[IM_hsh0[IS_riv_id]]=shape.points[IS_point-2][1]


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
          csvwriter.writerow([IV_Hydroseq[JS_riv_tot]]) 

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
