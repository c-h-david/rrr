#!/usr/bin/env python3
#*******************************************************************************
#rrr_cpl_riv_lsm_att.py
#*******************************************************************************

#Purpose:
#Given and netCDF file and a list of attributes (title, institution, comment,
#semi major axis, and inverse flattening), this program updates the attributes
#of the netCDF file.
#Author:
#Cedric H. David, 2019-2019


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import netCDF4


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_dat_ncf
# 2 - rrr_tit_str
# 3 - rrr_ins_str
# 4 - rrr_com_str
# 5 - ZS_sem
# 6 - ZS_inv


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg=len(sys.argv)
if IS_arg != 7:
     print('ERROR - 6 and only 6 arguments can be used')
     raise SystemExit(22)

rrr_dat_ncf=sys.argv[1]
rrr_tit_str=sys.argv[2]
rrr_ins_str=sys.argv[3]
rrr_com_str=sys.argv[4]
ZS_sem=sys.argv[5]
ZS_inv=sys.argv[6]

if ZS_sem!='':
     ZS_sem=float(ZS_sem)
if ZS_inv!='':
     ZS_inv=float(ZS_inv)


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs')
print('- '+rrr_dat_ncf)
print('- '+rrr_tit_str)
print('- '+rrr_ins_str)
print('- '+rrr_com_str)
print('- '+str(ZS_sem))
print('- '+str(ZS_inv))


#*******************************************************************************
#Check if files exist
#*******************************************************************************
try:
     with open(rrr_dat_ncf) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_dat_ncf)
     raise SystemExit(22)


#*******************************************************************************
#Modifying attributes
#*******************************************************************************
print('Modifying attributes')

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#-------------------------------------------------------------------------------
#Open netCDF file
#-------------------------------------------------------------------------------
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
f = netCDF4.Dataset(rrr_dat_ncf, 'r+')

BS_changes=False

#-------------------------------------------------------------------------------
#Modify global attributes
#-------------------------------------------------------------------------------

#Note: Attributes of type "Character" need be deleted before modified if the
#number of characters is different!

if 'title' in f.ncattrs()  and                                                 \
   'comment' in f.ncattrs() and                                                \
   'institution' in f.ncattrs():
     if f.getncattr('title')!=rrr_tit_str or                                   \
        f.getncattr('comment')!=rrr_com_str or                                 \
        f.getncattr('institution')!= rrr_ins_str:
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          #The requested attributes differ from existing: changes need be made
          #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
          if 'Conventions' in f.ncattrs():
               rrr_con_str=f.getncattr('Conventions')
               f.delncattr('Conventions')
               f.setncattr('Conventions',rrr_con_str)

          if 'title' in f.ncattrs():
               #rrr_tit_str
               f.delncattr('title')
               f.setncattr('title',rrr_tit_str)

          if 'institution' in f.ncattrs():
               #rrr_ins_str
               f.delncattr('institution')
               f.setncattr('institution',rrr_ins_str)

          if 'source' in f.ncattrs():
               rrr_sou_str=f.getncattr('source')
               f.delncattr('source')
               f.setncattr('source',rrr_sou_str)

          if 'history' in f.ncattrs():
               rrr_his_str=f.getncattr('history')
               f.delncattr('history')
               f.setncattr('history',rrr_his_str)

          if 'references' in f.ncattrs():
               rrr_ref_str=f.getncattr('references')
               f.delncattr('references')
               f.setncattr('references',rrr_ref_str)

          if 'comment' in f.ncattrs():
               #rrr_com_str
               f.delncattr('comment')
               f.setncattr('comment',rrr_com_str)

          if 'featureType' in f.ncattrs():
               rrr_fea_str=f.getncattr('featureType')
               f.delncattr('featureType')
               f.setncattr('featureType',rrr_fea_str)
          print('- global attributes modified')
          BS_changes=True
     else:
          print('- No modification made to global attributes')

#-------------------------------------------------------------------------------
#Modify crs attributes
#-------------------------------------------------------------------------------
if 'crs' in f.variables:
     crs=f.variables['crs']
     if 'semi_major_axis' in crs.ncattrs() and                                 \
        'inverse_flattening' in crs.ncattrs():
          if crs.getncattr('semi_major_axis')!=ZS_sem or                       \
             crs.getncattr('inverse_flattening')!=ZS_inv:
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               #The requested attributes differ from existing
               # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
               crs.delncattr('semi_major_axis')
               crs.setncattr('semi_major_axis',ZS_sem)
               crs.delncattr('inverse_flattening')
               crs.setncattr('inverse_flattening',ZS_inv)
               print('- crs attributes modified')
               BS_changes=True
          else:
               print('- No modification made to crs attributes')

#-------------------------------------------------------------------------------
#Close netCDF file
#-------------------------------------------------------------------------------
if BS_changes:
     f.close()
     #Closing the new netCDF file allows saves the file.
     #Only saving when changes where made allows not modifying time stamp.


#*******************************************************************************
#End
#*******************************************************************************
