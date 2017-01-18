#!/usr/bin/python
#*******************************************************************************
#rrr_anl_spl_shp.py
#*******************************************************************************

#Purpose:
#Given a polygon shapefile that contains mean times, and a river shapefile, this
#script subsamples the rivers based on the polygons.  
#Authors:
#Etienne Fluet Chouinard, Cedric H. David, 2016-2017


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import rtree
import csv


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_riv_shp
# 2 - rrr_pol_shp
# 3 - rrr_spl_shp
# 4 - rrr_spl_csv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 5:
     print('ERROR - 4 and only 4 arguments can be used')
     raise SystemExit(22) 

rrr_riv_shp=sys.argv[1]
rrr_pol_shp=sys.argv[2]
rrr_spl_shp=sys.argv[3]
rrr_spl_csv=sys.argv[4]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_riv_shp)
print('- '+rrr_pol_shp)
print('- '+rrr_spl_shp)
print('- '+rrr_spl_csv)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22) 

try:
     with open(rrr_pol_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_pol_shp)
     raise SystemExit(22) 


#*******************************************************************************
#Open rrr_riv_shp
#*******************************************************************************
print('Open rrr_riv_shp')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')
IS_riv_tot=len(rrr_riv_lay)
print('- The number of river features is: '+str(IS_riv_tot))

if 'COMID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='COMID'
elif 'ComID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='ComID'
elif 'ARCID' in rrr_riv_lay[0]['properties']:
     YV_riv_id='ARCID'
else:
     print('ERROR - Neither COMID, ComID, nor ARCID exist in '+rrr_riv_shp)
     raise SystemExit(22) 

IV_riv_tot_id=[]
for JS_riv_tot in range(IS_riv_tot):
     IV_riv_tot_id.append(int(rrr_riv_lay[JS_riv_tot]['properties'][YV_riv_id]))


#*******************************************************************************
#Open rrr_pol_shp
#*******************************************************************************
print('Open rrr_pol_shp')

rrr_pol_lay=fiona.open(rrr_pol_shp, 'r')
IS_pol_tot=len(rrr_pol_lay)
print('- The number of polygon features is: '+str(IS_pol_tot))


#*******************************************************************************
#Create spatial index for the bounds of each river feature
#*******************************************************************************
print('Create spatial index for the bounds of each river feature')

index=rtree.index.Index()
for rrr_riv_feat in rrr_riv_lay:
     riv_fid=int(rrr_riv_feat['id'])
     #the first argument of index.insert has to be 'int', not 'long' or 'str'
     riv_geom=shapely.geometry.shape(rrr_riv_feat['geometry'])
     index.insert(riv_fid, riv_geom.bounds)


#*******************************************************************************
#Find intersections 
#*******************************************************************************
print('Find intersections')

IS_spl_cnt=0
#The total count of river features completely contained in polygon features

IM_spl_cnt={}
IM_spl_tim={}
for JS_riv_tot in range(IS_riv_tot):
     IM_spl_cnt[IV_riv_tot_id[JS_riv_tot]]=0
     #A hash table associating each river reach ID with the number of subsamples
     IM_spl_tim[IV_riv_tot_id[JS_riv_tot]]=[]
     #A hash table associating each river reach ID with the subsample times 

for rrr_pol_feat in rrr_pol_lay:
     pol_fid=int(rrr_pol_feat['id'])
     pol_shy=shapely.geometry.shape(rrr_pol_feat['geometry'])
     for riv_fid in [int(x) for x in list(index.intersection(pol_shy.bounds))]:
          #---------------------------------------------------------------------
          #print('The bounds of riv_fid='+str(riv_fid)+                        \
          #      ' intersect with the bounds of pol_fid='+str(pol_fid))
          #---------------------------------------------------------------------
          rrr_riv_feat=rrr_riv_lay[riv_fid]
          riv_shy=shapely.geometry.shape(rrr_riv_feat['geometry'])
          if pol_shy.contains(riv_shy):
               #----------------------------------------------------------------
               #print('riv_fid='+str(riv_fid)+                                 \
               #      ' is completely inside of pol_fid='+str(pol_fid))
               #----------------------------------------------------------------
               IS_spl_cnt=IS_spl_cnt+1
               IS_riv_id=int(rrr_riv_feat['properties'][YV_riv_id])
               ZS_pol_tim=float(rrr_pol_feat['properties']['Mean_time'])
               IM_spl_cnt[IS_riv_id]=IM_spl_cnt[IS_riv_id]+1
               IM_spl_tim[IS_riv_id].append(ZS_pol_tim)

print('- The number of river features completely contained in polygon features'\
      +' is: '+str(IS_spl_cnt))


#*******************************************************************************
#Create rrr_spl_shp based on rrr_riv_shp and rrr_pol_shp
#*******************************************************************************
print('Create rrr_spl_shp based on rrr_riv_shp and rrr_pol_shp')

rrr_riv_crs=rrr_riv_lay.crs
rrr_spl_crs=rrr_riv_crs.copy()
#print(rrr_spl_crs)
print('- Coordinate Reference System copied')

rrr_riv_sch=rrr_riv_lay.schema
rrr_pol_sch=rrr_pol_lay.schema
rrr_spl_sch=rrr_riv_sch.copy()
rrr_spl_sch['properties']['SUBSAMPLES']='int:9'
#print(rrr_spl_sch)
print('- Schema copied')

rrr_spl_lay=fiona.open(rrr_spl_shp, 'w',                                       \
                       crs=rrr_spl_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_spl_sch                                      \
                       )
print('- New shapefile created')

for JS_riv_tot in range(IS_riv_tot):
     rrr_riv_feat=rrr_riv_lay[JS_riv_tot]
     rrr_spl_prp=rrr_riv_feat['properties']
     rrr_spl_prp['SUBSAMPLES']=IM_spl_cnt[IV_riv_tot_id[JS_riv_tot]]
     rrr_spl_geom=rrr_riv_feat['geometry']
     rrr_spl_lay.write({                                                       \
                        'properties': rrr_spl_prp,                             \
                        'geometry': rrr_spl_geom,                              \
                        })
print('- New shapefile populated')

rrr_spl_lay.close()
print('- Closing rrr_spl_shp so that values are saved')


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing rrr_spl_csv')

with open(rrr_spl_csv, 'wb') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IS_riv_id=IV_riv_tot_id[JS_riv_tot]
          IV_line=[IS_riv_id,IM_spl_cnt[IS_riv_id]] 
          IV_line=IV_line+IM_spl_tim[IS_riv_id]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
