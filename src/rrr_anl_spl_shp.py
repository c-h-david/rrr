#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_spl_shp.py
#*******************************************************************************

#Purpose:
#Given a polyline/polygon shapefile that contains mean times, and a river
#shapefile, this script subsamples the rivers based on the polygon/polyline
#features.
#Authors:
#Etienne Fluet Chouinard, Cedric H. David, Md Safat Sikder, 2016-2022


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import progressbar
import shapely.geometry
import shapely.prepared
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

prg_bar=progressbar.ProgressBar(maxval=IS_riv_tot-1,                           \
        widgets=[progressbar.Bar('=','- [',']'),' ',progressbar.Percentage()])

#prg_bar.start()
IV_riv_fid=[0]*IS_riv_tot
hsh_riv_prp={}
hsh_riv_geo={}
hsh_riv_shy={}
hsh_riv_bnd={}
IV_riv_tot_id=[0]*IS_riv_tot
for JS_riv_tot in range(IS_riv_tot):
     #prg_bar.update(JS_riv_tot)
     riv_fea=rrr_riv_lay[JS_riv_tot]
     riv_fid=int(riv_fea['id'])
     riv_prp=riv_fea['properties']
     riv_geo=riv_fea['geometry']
     riv_shy=shapely.geometry.shape(riv_geo)
     IV_riv_fid[JS_riv_tot]=riv_fid
     IV_riv_tot_id[JS_riv_tot]=int(riv_prp[YV_riv_id])
     hsh_riv_prp[riv_fid]=riv_prp
     hsh_riv_geo[riv_fid]=riv_geo
     hsh_riv_shy[riv_fid]=riv_shy
     hsh_riv_bnd[riv_fid]=riv_shy.bounds
#prg_bar.finish()


#*******************************************************************************
#Open rrr_pol_shp
#*******************************************************************************
print('Open rrr_pol_shp')

rrr_pol_lay=fiona.open(rrr_pol_shp, 'r')
IS_pol_tot=len(rrr_pol_lay)
print('- The number of polyline/polygon features is: '+str(IS_pol_tot))

prg_bar=progressbar.ProgressBar(maxval=IS_pol_tot-1,                           \
        widgets=[progressbar.Bar('=','- [',']'),' ',progressbar.Percentage()])

#prg_bar.start()
IV_pol_fid=[0]*IS_pol_tot
hsh_pol_prp={}
hsh_pol_shy={}
hsh_pol_bnd={}
for JS_pol_tot in range(IS_pol_tot):
     #prg_bar.update(JS_pol_tot)
     pol_fea=rrr_pol_lay[JS_pol_tot]
     pol_fid=int(pol_fea['id'])
     pol_prp=pol_fea['properties']
     pol_shy=shapely.geometry.shape(pol_fea['geometry'])
     IV_pol_fid[JS_pol_tot]=pol_fid
     hsh_pol_prp[pol_fid]=pol_prp
     hsh_pol_shy[pol_fid]=pol_shy
     hsh_pol_bnd[pol_fid]=pol_shy.bounds
#prg_bar.finish()


#*******************************************************************************
#Create spatial index for the bounds of each river feature
#*******************************************************************************
print('Create spatial index for the bounds of each river feature')

prg_bar=progressbar.ProgressBar(maxval=IS_riv_tot-1,                           \
        widgets=[progressbar.Bar('=','- [',']'),' ',progressbar.Percentage()])

#prg_bar.start()
index=rtree.index.Index()
for JS_riv_tot in range(IS_riv_tot):
     #prg_bar.update(JS_riv_tot)
     riv_fid=IV_riv_fid[JS_riv_tot]
     index.insert(riv_fid,hsh_riv_bnd[riv_fid])
     #the first argument of index.insert has to be 'int', not 'long' or 'str'
#prg_bar.finish()


#*******************************************************************************
#Find intersections 
#*******************************************************************************
print('Find intersections')

IS_spl_cnt=0
#The total count of river features intersecting with polyline/polygon features

IM_spl_cnt={}
IM_spl_tim={}
for JS_riv_tot in range(IS_riv_tot):
     IM_spl_cnt[IV_riv_tot_id[JS_riv_tot]]=0
     #A hash table associating each river reach ID with the number of subsamples
     IM_spl_tim[IV_riv_tot_id[JS_riv_tot]]=[]
     #A hash table associating each river reach ID with the subsample times 

prg_bar=progressbar.ProgressBar(maxval=IS_pol_tot-1,                           \
        widgets=[progressbar.Bar('=','- [',']'),' ',progressbar.Percentage()])

#prg_bar.start()
for JS_pol_tot in range(IS_pol_tot):
     #prg_bar.update(JS_pol_tot)
     pol_fid=IV_pol_fid[JS_pol_tot]
     pol_prp=hsh_pol_prp[pol_fid]
     pol_shy=hsh_pol_shy[pol_fid]
     pol_bnd=hsh_pol_bnd[pol_fid]
     pol_pre=shapely.prepared.prep(pol_shy)
     IV_riv_ids=[int(x) for x in list(index.intersection(pol_bnd))]
     for riv_fid in IV_riv_ids:
          #---------------------------------------------------------------------
          #print('The bounds of riv_fid='+str(riv_fid)+                        \
          #      ' intersect with the bounds of pol_fid='+str(pol_fid))
          #---------------------------------------------------------------------
          riv_shy=hsh_riv_shy[riv_fid]
          riv_prp=hsh_riv_prp[riv_fid]
          if pol_pre.intersects(riv_shy):
               #----------------------------------------------------------------
               #print('riv_fid='+str(riv_fid)+                                 \
               #      ' intersects with pol_fid='+str(pol_fid))
               #----------------------------------------------------------------
               IS_spl_cnt=IS_spl_cnt+1
               IS_riv_id=int(riv_prp[YV_riv_id])
               ZS_pol_tim=float(pol_prp['Mean_time'])
               IM_spl_cnt[IS_riv_id]=IM_spl_cnt[IS_riv_id]+1
               IM_spl_tim[IS_riv_id].append(ZS_pol_tim)
#prg_bar.finish()

print('- The number of river features intersecting with the polyline/polygon'  \
      +' features is: '+str(IS_spl_cnt))


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

if 'DSContArea' in rrr_spl_sch['properties']:
     rrr_spl_sch['properties']['DSContArea']='float:24.5'
     #Default for MERIT Hydro v00 Basins v01 is 'float:24.15' is inadequate
if 'USContArea' in rrr_spl_sch['properties']:
     rrr_spl_sch['properties']['USContArea']='float:24.5'
     #Default for MERIT Hydro v00 Basins v01 is 'float:24.15' is inadequate
#print(rrr_spl_sch)
print('- Known schema issues fixed')

rrr_spl_lay=fiona.open(rrr_spl_shp, 'w',                                       \
                       crs=rrr_spl_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_spl_sch                                      \
                       )
print('- New shapefile created')

for JS_riv_tot in range(IS_riv_tot):
     riv_fid=IV_riv_fid[JS_riv_tot]
     rrr_spl_prp=hsh_riv_prp[riv_fid]
     rrr_spl_prp['SUBSAMPLES']=IM_spl_cnt[IV_riv_tot_id[JS_riv_tot]]
     rrr_spl_geo=hsh_riv_geo[riv_fid]
     rrr_spl_lay.write({                                                       \
                        'properties': rrr_spl_prp,                             \
                        'geometry': rrr_spl_geo,                               \
                        })
print('- New shapefile populated')

rrr_spl_lay.close()
print('- Closing rrr_spl_shp so that values are saved')


#*******************************************************************************
#Write outputs
#*******************************************************************************
print('Writing rrr_spl_csv')

with open(rrr_spl_csv, 'w') as csvfile:
     csvwriter = csv.writer(csvfile, dialect='excel')
     for JS_riv_tot in range(IS_riv_tot):
          IS_riv_id=IV_riv_tot_id[JS_riv_tot]
          IV_line=[IS_riv_id,IM_spl_cnt[IS_riv_id]] 
          IV_line=IV_line+IM_spl_tim[IS_riv_id]
          csvwriter.writerow(IV_line) 


#*******************************************************************************
#End
#*******************************************************************************
