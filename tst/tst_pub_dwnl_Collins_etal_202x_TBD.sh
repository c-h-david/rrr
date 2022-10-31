#!/bin/bash
#*******************************************************************************
#tst_pub_dwnl_Collins_etal_202x_TBD.sh
#*******************************************************************************

#Purpose:
#This script downloads all the files corresponding to:
#Collins, E. L., 
#DOI: xx.xxxx/xxxxxxxxxxxx
#The files used are available from:
#Collins, E. L., 
#DOI: xx.xxxx/xxxxxxxxxxxx
#The script returns the following exit codes
# - 0  if all downloads are successful 
# - 22 if there was a conversion problem
# - 44 if one download is not successful
#Author:
#Cedric H. David, 2022-2022.


#*******************************************************************************
#Notes on tricks used here
#*******************************************************************************
#wget -q -nc           --> Quiet, No-clobber (don't overwrite) 
#wget -r               --> Turn on recursive retrieving. 
#wget -nH              --> Disable generation of host-prefixed directories. 
#wget ---cut-dirs=i    --> Ignore i directory components when saving files. 
#wget -P               --> Directory prefix where everything is downloaded


#*******************************************************************************
#Publication message
#*******************************************************************************
echo "********************"
echo "Downloading files from:   https://doi.org/xx.xxxx/xxxxxxxxxxxx"
echo "which correspond to   :   https://doi.org/xx.xxxx/xxxxxxxxxxxx"
echo "These files are under a Creative Commons Attribution (CC BY) license."
echo "Please cite these two DOIs if using these files for your publications."
echo "********************"


#*******************************************************************************
#Download GLDAS2 monthly files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
fld="../input/GLDAS"
exp="GLDAS"
frq="M"
mod="                                                                          \
     CLSM                                                                      \
     NOAH                                                                      \
     VIC                                                                       \
    "
str=(                                                                          \
    "1980-01-01T00:00:00"                                                      \
    "1981-01-01T00:00:00"                                                      \
    "1982-01-01T00:00:00"                                                      \
    )
end=(                                                                          \
    "1980-12-31T23:59:59"                                                      \
    "1981-12-31T23:59:59"                                                      \
    "2009-12-31T23:59:59"                                                      \
    )

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $fld
ndl=${#str[@]}
#ndl is the number of download intervals

for mod in $mod
do
for (( idl=0; idl<${ndl}; idl++ ));
do
     echo "Downloading GLDAS2 monthly data for $mod, from" ${str[$idl]} "to"   \
           ${end[$idl]}
     ../src/rrr_lsm_tot_ldas.py $exp $mod $frq ${str[$idl]} ${end[$idl]} $fld > tmp_dwl
     if [ $? -gt 0 ] ; then echo "Problem downloading" && cat tmp_dwl >&2 ; exit 44 ; fi
     rm tmp_dwl
done
done


#*******************************************************************************
#Download MERIT Hydro Basins input files
#*******************************************************************************

#-------------------------------------------------------------------------------
#Download parameters
#-------------------------------------------------------------------------------
URL="http://hydrology.princeton.edu/data/mpan/MERIT_Basins/MERIT_Hydro_v07_Basins_v01/zip/pfaf_level_02/"
folder="../input/MH07B01_TBD"
list="                                                                         \
      pfaf_74_MERIT_Hydro_v07_Basins_v01.zip	                               \
     "

#-------------------------------------------------------------------------------
#Download process
#-------------------------------------------------------------------------------
mkdir -p $folder
for file in $list
do
     wget -nv -nc $URL/$file -P $folder
     if [ $? -gt 0 ] ; then echo "Problem downloading $file" >&2 ; exit 44 ; fi
done


#*******************************************************************************
#Extract files
#*******************************************************************************
unzip -nq ../input/MH07B01_TBD/pfaf_74_MERIT_Hydro_v07_Basins_v01.zip -d ../input/MH07B01_TBD/
if [ $? -gt 0 ] ; then echo "Problem converting" >&2 ; exit 22 ; fi


#*******************************************************************************
#Done
#*******************************************************************************
