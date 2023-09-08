#!/usr/bin/env python3
#*******************************************************************************
#rrr_lsm_tot_snp.py
#*******************************************************************************

#Purpose:
#Given a shapefile of gauging stations that includes estimates of average
#discharge, a shapefile of river reaches that also includes an estime of average
#discharge, a distance buffer, and a magnitude factor, this program creates a
#new shapefile of gauging stations were the most appropriate river ID has been
#appended as an attribute. The search for river IDs is done by intersection
#within the buffer around each gauge. Magnitude is checked by ensuring that
#gauge_discharge is within [1/factor, factor]*river_discharge. Potential
#duplicate gauges on any given river reach are also filtered by distance, name,
#and magnitude.
#Author:
#Cedric H. David, 2022-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import fiona
import shapely.geometry
import shapely.prepared
import rtree


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_obs_shp
# 2 - rrr_riv_shp
# 3 - ZS_buf
# 4 - ZS_mag
# 5 - rrr_snp_shp


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 6:
     print('ERROR - 5 and only 5 arguments can be used')
     raise SystemExit(22)

rrr_obs_shp=sys.argv[1]
rrr_riv_shp=sys.argv[2]
ZS_buf=float(sys.argv[3])
ZS_mag=float(sys.argv[4])
rrr_snp_shp=sys.argv[5]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print(' - '+rrr_obs_shp)
print(' - '+rrr_riv_shp)
print(' - '+str(ZS_buf))
print(' - '+str(ZS_mag))
print(' - '+rrr_snp_shp)


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_obs_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_obs_shp)
     raise SystemExit(22)

try:
     with open(rrr_riv_shp) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_shp)
     raise SystemExit(22)


#*******************************************************************************
#Read gauge shapefile
#*******************************************************************************
print('Read gauge shapefile')

rrr_obs_lay=fiona.open(rrr_obs_shp, 'r')

if 'Sttn_Nm' in rrr_obs_lay[0]['properties']:
     YS_obs_nm='Sttn_Nm'
else:
     print('ERROR - Sttn_Nm does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

if 'meanQ' in rrr_obs_lay[0]['properties']:
     YS_obs_av='meanQ'
else:
     print('ERROR - meanQ does not exist in '+rrr_obs_shp)
     raise SystemExit(22)

IS_obs_shp=len(rrr_obs_lay)
print(' - The number of gauge features is: '+str(IS_obs_shp))


#*******************************************************************************
#Read river shapefile
#*******************************************************************************
print('Read river shapefile')

rrr_riv_lay=fiona.open(rrr_riv_shp, 'r')

if 'COMID' in rrr_riv_lay[0]['properties']:
     YS_riv_id='COMID'
elif 'ARCID' in rrr_riv_lay[0]['properties']:
     YS_riv_id='ARCID'
else:
     print('ERROR - COMID, or ARCID do not exist in '+rrr_riv_shp)
     raise SystemExit(22)

if 'meanQ' in rrr_riv_lay[0]['properties']:
     YS_riv_av='meanQ'
elif 'Q' in rrr_riv_lay[0]['properties']:
     YS_riv_av='Q'
else:
     print('ERROR - meanQ, or Q do not exist in '+rrr_riv_shp)
     raise SystemExit(22)

IS_riv_shp=len(rrr_riv_lay)
print(' - The number of river features is: '+str(IS_riv_shp))


#*******************************************************************************
#Create spatial index for the bounds of each river feature
#*******************************************************************************
print('Create spatial index for the bounds of each river feature')

index=rtree.index.Index()
for rrr_riv_fea in rrr_riv_lay:
     rrr_riv_fid=int(rrr_riv_fea['id'])
     #the first argument of index.insert has to be 'int', not 'long' or 'str'
     rrr_riv_shy=shapely.geometry.shape(rrr_riv_fea['geometry'])
     index.insert(rrr_riv_fid, rrr_riv_shy.bounds)
     #creates an index between the feature ID and the bounds of that feature

print(' - Spatial index created')


#*******************************************************************************
#Snap river IDs onto appropriate gauges
#*******************************************************************************
print('Snap river IDs onto appropriate gauges')

HM_snp={}
IS_buf=0

for rrr_obs_fea in rrr_obs_lay:
     rrr_obs_shy=shapely.geometry.shape(rrr_obs_fea['geometry'])
     #shapely geometric object for each gauge
     rrr_buf_shy=rrr_obs_shy.buffer(ZS_buf)
     #shapefly geometric object for a disc buffered around each gauge
     rrr_buf_pre=shapely.prepared.prep(rrr_buf_shy)
     #a 'prepared' geometric object allows for faster processing after
     IV_riv_fid=[int(x) for x in list(index.intersection(rrr_buf_shy.bounds))]
     #List of feature IDs where reach bounds intersect with buffer bounds

     BS_buf=False
     #Boolean to be updated if a river reach is within buffer for this gauge
     ZS_cls=ZS_buf
     #The closest distance between this gauge and all potential reaches

     for IS_riv_fid in IV_riv_fid:
          #---------------------------------------------------------------------
          #current reach might be within buffer of current gauge
          #---------------------------------------------------------------------
          rrr_riv_fea=rrr_riv_lay[IS_riv_fid]
          rrr_riv_shy=shapely.geometry.shape(rrr_riv_fea['geometry'])
          if rrr_buf_pre.intersects(rrr_riv_shy):
               #----------------------------------------------------------------
               #Current reach is actually within buffer of current gauge
               #----------------------------------------------------------------
               BS_buf=BS_buf or True
               ZS_dst=rrr_riv_shy.distance(rrr_obs_shy)
               obs_nm=rrr_obs_fea['properties'][YS_obs_nm]
               obs_av=rrr_obs_fea['properties'][YS_obs_av]
               riv_id=rrr_riv_fea['properties'][YS_riv_id]
               riv_av=rrr_riv_fea['properties'][YS_riv_av]
               BS_bad=obs_av>=  ZS_mag*riv_av or                               \
                      obs_av<=1/ZS_mag*riv_av
               #BS_bad in case want to check for magnitude along with distance
               if ZS_dst<=ZS_cls:
               #if ZS_dst<=ZS_cls and not BS_bad:
                    #-----------------------------------------------------------
                    #Current reach is within buffer, (magnitude), and closer
                    #-----------------------------------------------------------
                    ZS_cls=ZS_dst
                    HM_snp[obs_nm]={'obs_av':obs_av,                           \
                                    'riv_id':riv_id,                           \
                                    'riv_av':riv_av,                           \
                                    'ZS_dst':ZS_dst }
     if BS_buf:
          #---------------------------------------------------------------------
          #current gauge has at least one reach in buffer
          #---------------------------------------------------------------------
          IS_buf=IS_buf+1
          obs_nm=rrr_obs_fea['properties'][YS_obs_nm]
          if obs_nm in HM_snp and                                              \
            (HM_snp[obs_nm]['obs_av']>=  ZS_mag*HM_snp[obs_nm]['riv_av'] or    \
             HM_snp[obs_nm]['obs_av']<=1/ZS_mag*HM_snp[obs_nm]['riv_av']):
               #----------------------------------------------------------------
               #current gauge has a reach snapped to it and has wrong magnitude
               #----------------------------------------------------------------
               del HM_snp[obs_nm]
          if obs_nm not in HM_snp:
               #----------------------------------------------------------------
               #current has at least one reach in buffer but no snapped reach
               #----------------------------------------------------------------
               print('WARNING - MAGNITUDE '+obs_nm+' was not included')

IS_snp=len(HM_snp)
print(' - Number of gauges within buffer of a reach: '                         \
      +str(IS_buf)+'/'+str(IS_obs_shp))
print(' - Number of gauges within buffer of a reach and acceptable magnitude: '\
      +str(IS_snp)+'/'+str(IS_obs_shp))


#*******************************************************************************
#Notes on efficient geospatial operations
#*******************************************************************************
#Geospatial operations can be very computationally demanding unless some tricks
#are used. My experience has indicated that:
# - One should build the spatial index on the features that are the most
#   numerous. That is because the index.intersection() function is very fast and
#   hence allows for a near instantaneous subselection of only those out of many
#   features that are potentially within the desired spatial scope.
# - For the features that are relatively less numerous (not the ones above), one
#   should 'prepare' the geometry before performing the desired geospatial
#   operation and use the prepared objects in the operation. This step is
#   particularly key when the geometry is made of many points because it
#   dramatically speeds up the geospatial operations.


#*******************************************************************************
#Remove gauges where multiple gauges are on a same river ID
#*******************************************************************************
print('Remove gauges where multiple gauges are on a same river ID')

#-------------------------------------------------------------------------------
#Determine river IDs with duplicate gauges
#-------------------------------------------------------------------------------
IV_all_ids=[HM_snp[obs_nm]['riv_id'] for obs_nm in HM_snp]
#All of the river IDs associated with gauges
IV_dup_ids=[riv_id for riv_id in IV_all_ids if IV_all_ids.count(riv_id)>1]
#List of river IDs that have more than one gauge, river IDs may be repeated
IV_uni_ids=list(set(IV_dup_ids))
#List of unique river IDs that have multiple gauges

IS_dup_ids=len(IV_dup_ids)
IS_uni_ids=len(IV_uni_ids)

print(' - Number of river reaches with more than one gauge: '                  \
     +str(IS_uni_ids))
print(' - Number of gauges located on these reaches:        '                  \
     +str(IS_dup_ids))
print(' - Number of duplicate gauges needing to be removed: '                  \
     +str(IS_dup_ids-IS_uni_ids))

#-------------------------------------------------------------------------------
#Create dictionary of river IDs and associated station names w/ their averages
#-------------------------------------------------------------------------------
HM_dup={}
for riv_id in IV_uni_ids:
     HM_dup[riv_id]={}
     HM_dup[riv_id]['sta']=[]
     for obs_nm in HM_snp:
          if HM_snp[obs_nm]['riv_id']==riv_id:
               HM_dup[riv_id]['sta'].append(obs_nm)

for riv_id in IV_uni_ids:
     avg=0
     for obs_nm in HM_dup[riv_id]['sta']:
          avg=avg+HM_snp[obs_nm]['obs_av']/len(HM_dup[riv_id]['sta'])
     HM_dup[riv_id]['avg']=avg

#-------------------------------------------------------------------------------
#Check potential magnitude mismatch of more than 1% among gauges on a same reach
#-------------------------------------------------------------------------------
for riv_id in HM_dup:
     BS_pb=False
     for obs_nm in HM_dup[riv_id]['sta']:
          if HM_snp[obs_nm]['obs_av']>=  1.01*HM_dup[riv_id]['avg'] or         \
             HM_snp[obs_nm]['obs_av']<=1/1.01*HM_dup[riv_id]['avg']:
               BS_pb=BS_pb or True
     if BS_pb:
          obs_ok='temp'
          ZS_dif=999999999
          for obs_nm in HM_dup[riv_id]['sta']:
               if abs(HM_snp[obs_nm]['obs_av']-HM_snp[obs_nm]['riv_av'])<ZS_dif:
                    obs_ok=obs_nm
                    ZS_dif=abs(HM_snp[obs_nm]['obs_av']                        \
                              -HM_snp[obs_nm]['riv_av'])
          for obs_nm in HM_dup[riv_id]['sta']:
               if obs_nm!=obs_ok:
                    print('WARNING - DUPLICATE at',riv_id,                     \
                          HM_dup[riv_id]['sta'],'removing',obs_nm,             \
                          'another gauge has average closer to prior estimate')
                    HM_dup[riv_id]['sta'].remove(obs_nm)
                    del HM_snp[obs_nm]

#-------------------------------------------------------------------------------
#Remove GRDC gauges from list if only one of duplicates is GRDC
#-------------------------------------------------------------------------------
for riv_id in HM_dup:
     YV_nms=HM_dup[riv_id]['sta'].copy()
     if len(YV_nms)>1:
          YV_grd=[obs_nm for obs_nm in YV_nms if 'GRDC' in obs_nm]
          if len(YV_grd)==1:
               obs_nm=YV_grd[0]
               print('WARNING - DUPLICATE at',riv_id,HM_dup[riv_id]['sta'],    \
                     'removing',obs_nm, 'assuming GRDC is duplicate')
               YV_nms.remove(obs_nm)
               HM_dup[riv_id]['sta'].remove(obs_nm)
               del HM_snp[obs_nm]

#-------------------------------------------------------------------------------
#Remove non-USGS gauges from list if only one of duplicates is non-USGS
#-------------------------------------------------------------------------------
for riv_id in HM_dup:
     YV_nms=HM_dup[riv_id]['sta'].copy()
     if len(YV_nms)>1:
          YV_nus=[obs_nm for obs_nm in YV_nms if 'USGS' not in obs_nm]
          if len(YV_nus)==1:
               obs_nm=YV_nus[0]
               print('WARNING - DUPLICATE at',riv_id,HM_dup[riv_id]['sta'],    \
                     'removing',obs_nm, 'assuming non-USGS is duplicate')
               YV_nms.remove(obs_nm)
               HM_dup[riv_id]['sta'].remove(obs_nm)
               del HM_snp[obs_nm]

#-------------------------------------------------------------------------------
#Pick closest distance in all other cases
#-------------------------------------------------------------------------------
for riv_id in HM_dup:
     YV_nms=HM_dup[riv_id]['sta'].copy()
     if len(YV_nms)>1:
          obs_ok='temp'
          ZS_dif=999999999
          for obs_nm in HM_dup[riv_id]['sta']:
               if abs(HM_snp[obs_nm]['ZS_dst'])<ZS_dif:
                    obs_ok=obs_nm
                    ZS_dif=abs(HM_snp[obs_nm]['ZS_dst'])
          for obs_nm in HM_dup[riv_id]['sta']:
               if obs_nm!=obs_ok:
                    print('WARNING - DUPLICATE at',riv_id,                     \
                          HM_dup[riv_id]['sta'],'removing',obs_nm,             \
                          'because another gauge is closer to reach')
                    HM_dup[riv_id]['sta'].remove(obs_nm)
                    del HM_snp[obs_nm]

#-------------------------------------------------------------------------------
#Making sure one unique gauge per rivid
#-------------------------------------------------------------------------------
IV_snp_ids=[HM_snp[obs_nm]['riv_id'] for obs_nm in HM_snp]
YV_snp_nms=[obs_nm                   for obs_nm in HM_snp]

for riv_id in IV_snp_ids:
     if IV_snp_ids.count(riv_id)>1:
          print('ERROR - Snapping process incomplete, multiple gauges for'+    \
                riv_id)
          raise SystemExit(22)


#*******************************************************************************
#Overall snapping summary
#*******************************************************************************
print('Overall snapping summary')

print(' - '+rrr_riv_shp)
print(' - Gauges in shapefile           '+str(IS_obs_shp))
print(' - Gauges within buffer          '+str(IS_buf))
print(' - Gauges removed because of mag '+str(IS_buf-IS_snp))
print(' - Gauges removed as duplicates  '+str(IS_dup_ids-IS_uni_ids))
print(' - Expected remaining gauges     '+str(IS_snp-(IS_dup_ids-IS_uni_ids)))
print(' - Expected remaining gauges v2  '+str(len(HM_snp)))

if len(HM_snp)==0:
     print('WARNING - No station to be snapped: not creating a shapefile')
     raise SystemExit(-22)


#*******************************************************************************
#Copying gauge shapefile and appending with river ID
#*******************************************************************************
print('Copying gauge shapefile and appending with river ID')

rrr_obs_crs=rrr_obs_lay.crs
rrr_snp_crs=rrr_obs_crs.copy()
#print(rrr_snp_crs)
print('- Coordinate Reference System copied')

rrr_obs_sch=rrr_obs_lay.schema
rrr_snp_sch=rrr_obs_sch.copy()
rrr_snp_sch['properties']['rivid']='int:9'
#print(rrr_snp_sch)
print('- Schema copied')

rrr_snp_lay=fiona.open(rrr_snp_shp, 'w',                                       \
                       crs=rrr_snp_crs,                                        \
                       driver='ESRI Shapefile',                                \
                       schema=rrr_snp_sch                                      \
                       )
print('- New shapefile created')

for JS_obs_shp in range(IS_obs_shp):
     rrr_obs_fea=rrr_obs_lay[JS_obs_shp]
     rrr_obs_prp=rrr_obs_fea['properties']
     rrr_obs_geo=rrr_obs_fea['geometry']
     if rrr_obs_prp[YS_obs_nm] in HM_snp:

          rrr_snp_prp=rrr_obs_prp.copy()
          rrr_snp_geo=rrr_obs_geo.copy()

          rrr_snp_prp['rivid']=HM_snp[rrr_obs_prp[YS_obs_nm]]['riv_id']

          rrr_snp_lay.write({                                                  \
                             'properties': rrr_snp_prp,                        \
                             'geometry': rrr_snp_geo,                          \
                             })
print('- New shapefile populated')

rrr_snp_lay.close()
print('- Closing shapefile so that values are saved')


#*******************************************************************************
#End
#*******************************************************************************
