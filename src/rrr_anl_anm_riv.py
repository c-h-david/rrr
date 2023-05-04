#!/usr/bin/env python3
#*******************************************************************************
#rrr_anl_anm_riv.py
#*******************************************************************************

#Purpose:
#Given a river model output netCDF file, and a river network shapefile, this
#program creates a video animation of rivers in which the thickness of each 
#river reach in the river network varies with time as a function of the modeled 
#variable within it. Optional command line parameters can be used.  If the first
#and last time steps are provided (as zero-based integers), the animation is 
#created between these time steps.  If an additional georeferenced satellite 
#image is given (with the same coordinate system as the shapefile and provided
#as an 8bit or 24Bit RGB image), it will be added as a background of the video. 
#Authors:
#Klemen Cotar, Ashish Mahabal, Cedric H. David, Md Safat Sikder, 2016-2023


#*******************************************************************************
#Import Python modules
#*******************************************************************************
import sys
import datetime
import netCDF4 
import shapefile
import matplotlib.collections
import matplotlib.pyplot
import rasterio
import matplotlib.animation
import numpy


#*******************************************************************************
#Domain specific hard-coded variables
#*******************************************************************************
YV_title = 'Title'                              # the title of the video
YV_ref   = 'https://github.com/c-h-david/rrr'   # the code repository
date_ini = datetime.datetime(1970, 1, 1, 0, 0)  # first time step in netCDF file
date_stp = datetime.timedelta(0, 10800)         # time step duration in seconds
#These are set at runtime from data and metadata if they exist in netCDF file

BS_wid_auto = True                              # set to False for manual choice
ZS_Qhig = 400000                                # estimated high discharge Q
ZS_Qlow = 100                                   # estimated low discharge Q
#If added control is necessary on the width of river reaches

ZS_Whig = 2                                     # polyline width at high Q
ZS_Wlow = 0.05                                  # polyline width at low Q
#Testing suggests that anything below 0.05 points is invisible, and above 2
#points has graphical artifacts for some river shapes


#*******************************************************************************
#Predefined hard-coded variables
#*******************************************************************************
vid_fps = 30    # frame rate of created video
vid_dpi = 300   # resolution of video in DPI unit
IS_tim_spl = 1  # plot every so many time steps


#*******************************************************************************
#Declaration of variables (given as command line arguments)
#*******************************************************************************
# 1 - rrr_mod_file
# 2 - rrr_riv_file
# 3 - rrr_vid_file
#(4)- IS_tim_str
#(5)- IS_tim_end
#(6)- rrr_img_file


#*******************************************************************************
#Get command line arguments
#*******************************************************************************
IS_arg = len(sys.argv)
if IS_arg < 4 or IS_arg > 7:
     print('ERROR - A minimum of 3 and a maximum of 6 arguments can be used')
     raise SystemExit(22)

rrr_mod_file = sys.argv[1]
rrr_riv_file = sys.argv[2]
rrr_vid_file = sys.argv[3]
if IS_arg > 4:
     IS_tim_str = int(sys.argv[4])
if IS_arg > 5:
     IS_tim_end = int(sys.argv[5])
if IS_arg > 6:
     rrr_img_file = sys.argv[6]


#*******************************************************************************
#Print input information
#*******************************************************************************
print('Command line inputs:')
print('- ' + rrr_mod_file)
print('- ' + rrr_riv_file)
print('- ' + rrr_vid_file)
if IS_arg > 4: print('- ' + str(IS_tim_str))
if IS_arg > 5: print('- ' + str(IS_tim_end))
if IS_arg > 6: print('- ' + rrr_img_file)


#*******************************************************************************
#Check if files exist 
#*******************************************************************************
try:
     with open(rrr_mod_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_mod_file)
     raise SystemExit(22)

try:
     with open(rrr_riv_file) as file:
          pass
except IOError as e:
     print('ERROR - Unable to open '+rrr_riv_file)
     raise SystemExit(22)


#*******************************************************************************
#Read netCDF file and shapefile
#*******************************************************************************
print('Reading netCDF file and shapefile')

#-------------------------------------------------------------------------------
#netCDF file
#-------------------------------------------------------------------------------
print('- Reading netCDF file')
try:
     f = netCDF4.Dataset(rrr_mod_file, "r", format="NETCDF4")
except IOError as e:
     print('ERROR - Unable to read ' + rrr_mod_file)
     raise SystemExit(22)

if 'COMID' in f.dimensions:
     YV_rivid='COMID'
elif 'rivid' in f.dimensions:
     YV_rivid='rivid'
else:
     print('ERROR - Neither COMID nor rivid are dimensions in: '+rrr_mod_file)
     raise SystemExit(22)

if 'Time' in f.dimensions:
     YV_time='Time'
elif 'time' in f.dimensions:
     YV_time='time'
else:
     print('ERROR - Neither Time nor time are dimensions in: '+rrr_mod_file)
     raise SystemExit(22)

if 'Qout' in f.variables:
     YV_var='Qout'
elif 'V' in f.variables:
     YV_var='V'
else:
     print('ERROR - Neither Qout nor V are variables in: '+rrr_mod_file)
     raise SystemExit(22)

IV_riv_tot_id = f.variables[YV_rivid][:]
IS_riv_tot = len(IV_riv_tot_id)
print(' . Number of reaches in rrr_mod_file: '+str(IS_riv_tot))

IS_tim_tot = len(f.dimensions[YV_time])
print(' . Number of time steps in rrr_mod_file: '+str(IS_tim_tot))

if 'time' in f.variables:
     if f.variables['time'][0] != f.variables['time'][1]:
          date_ini=datetime.datetime.utcfromtimestamp(f.variables['time'][0])
          #Using utcfromtimestamp (not fromtimestamp) because times are epoch
          date_stp = datetime.timedelta(0,                                     \
                           float(f.variables['time'][1]-f.variables['time'][0]))

if 'title' in f.ncattrs():
     YV_title=f.title 

if 'references' in f.ncattrs():
     YV_ref=f.references+'\n'+YV_ref

#-------------------------------------------------------------------------------
#Shapefile
#-------------------------------------------------------------------------------
print('- Reading shapefile')

try:
     rrr_riv_shp = shapefile.Reader(rrr_riv_file)
except:
     print('ERROR - Unable to read ' + rrr_riv_file)
     raise SystemExit(22)

IS_fld=len(rrr_riv_shp.fields)
for JS_fld in range(1,IS_fld):
     if rrr_riv_shp.fields[JS_fld][0]=='COMID' or                              \
        rrr_riv_shp.fields[JS_fld][0]=='ComID' or                              \
        rrr_riv_shp.fields[JS_fld][0]=='ARCID':
          IS_rid=JS_fld
try:
    IS_rid
except NameError:
     print('ERROR - Neither COMID, ComID, nor ARCID exist in ' + rrr_riv_file)
     raise SystemExit(22)
     #This ensure that one attribute of the shapefile is the river ID, i.e. the
     #one we're looking for.  The first actual attribute (index [0]) corresponds
     #to 'DeletionFlag'. The indices of fields() and records() are shifted by 1.

IV_riv_bas_id = [record[IS_rid-1] for record in rrr_riv_shp.records()]
IS_riv_bas = len(IV_riv_bas_id)
print(' . Number of reaches in rrr_riv_file: '+str(IS_riv_bas))

IS_pts=0
IS_max=0
for JS_riv_bas in range(IS_riv_bas):
     shape=rrr_riv_shp.shape(JS_riv_bas)
     IS_pts=IS_pts+len(shape.points)
     IS_max=max(IS_max,len(shape.points))
print(' . Number of points in rrr_riv_file: '+str(IS_pts))
print(' . Maximum number of points per feature: '+str(IS_max))

if IS_pts>7500000:
     print('ERROR - The total number of points exceeds 7,500,000')
     raise SystemExit(22)
     #On the testing machine:
     #Each Python list is 72B + number of objects * 8B
     #Each Python floating point object is 24B
     #To estimate the size of the list called 'polyline_pts':
     # - Each point is an object of a list: 8B
     # - Each point uses a list of two objects: 72B+2*8B=88B
     # - Each point has two floats (lon & lat): 2*24B=48B
     # --> this leads to a total of 144B per point
     # --> 7,456,540 points leads to 1GB


#*******************************************************************************
#Find correspondence between reach IDs in both files
#*******************************************************************************
print('Find correspondance between reach IDs in both files')

#-------------------------------------------------------------------------------
#Check sizes
#-------------------------------------------------------------------------------
if IS_riv_bas != IS_riv_tot:
     print('- WARNING - only a subset of model computations will be plotted')

#-------------------------------------------------------------------------------
#Find correspondence
#-------------------------------------------------------------------------------
IM_hsh={}
for JS_riv_tot in range(IS_riv_tot):
     IM_hsh[IV_riv_tot_id[JS_riv_tot]]=JS_riv_tot

IV_riv_bas_index=[0]*IS_riv_bas
for JS_riv_bas in range(IS_riv_bas):
     IV_riv_bas_index[JS_riv_bas]=IM_hsh[IV_riv_bas_id[JS_riv_bas]]


#*******************************************************************************
#Check/fix/set start and end time steps (from command line)
#*******************************************************************************
print('Check/fix/set start and end time steps (from command line options)')

if 'IS_tim_str' in locals():
     IS_tim_str = max(0, IS_tim_str)
     #must be greater than zero
else:
     IS_tim_str = 0

if 'IS_tim_end' in locals():
     IS_tim_end = max(0, min(IS_tim_end, IS_tim_tot))
     #must be greater than zero & less than total number of available time steps
else:
     IS_tim_end = IS_tim_tot

if IS_tim_str > IS_tim_end:
     print('ERROR - End time step cannot be less than start time step.')
     raise SystemExit(22)


#*******************************************************************************
#Prepare canvas to visualize data
#*******************************************************************************
print('Prepare canvas to visualize data')

#-------------------------------------------------------------------------------
#Create a line collection that is used to plot all rivers at once
#-------------------------------------------------------------------------------
#polyline_pts = [shape.points for shape in rrr_riv_shp.shapes()]
##This is too long when shapefiles are large, better to use one shape at a time
polyline_pts=[]
for JS_riv_bas in range(IS_riv_bas):
     shape=rrr_riv_shp.shape(JS_riv_bas)
     polyline_pts.append(shape.points)
#The vertices of each individual polyline are now combined

polyline_clc = matplotlib.collections.LineCollection(polyline_pts,             \
                                                     colors='cyan',            \
                                                     linestyles='solid')
#The line collection is now created

#-------------------------------------------------------------------------------
#Prepare plotting canvas
#-------------------------------------------------------------------------------
plt=matplotlib.pyplot

plt.close()
plt.xlabel('Longitude')
plt.ylabel('Latitude')

plt_fig = plt.figure()
plt_axs = plt.axes()
plt_clc = plt_axs.add_collection(polyline_clc)
plt_axs.autoscale(enable=True, tight=True) #Automatic scaling of x-y axis limits

plt.figtext(0.50, 0.01, YV_ref, size='x-small', horizontalalignment='center')


#*******************************************************************************
#Read and add background image to plot
#*******************************************************************************
if 'rrr_img_file' in locals():
    print('Reading background image')
    try:
        rrr_img_ras = rasterio.open(rrr_img_file, 'r')
        #read background image that has the same coordinate system as shapefile

        x_range = plt_axs.get_xlim()
        y_range = plt_axs.get_ylim()
        #get plot limits that will be used for image subseting (same coords)

        ul = rrr_img_ras.index(x_range[0], y_range[1])
        lr = rrr_img_ras.index(x_range[1], y_range[0])
        #convert upper-left and lower-right limit coordinates to image pixels

        rrr_img_crp = rrr_img_ras.read(window=((ul[0],lr[0]+1),                \
                                               (ul[1],lr[1]+1)),               \
                                       boundless=True)
        #crop the image based on limit pixels 

        rrr_img_crp = numpy.rollaxis(rrr_img_crp, 0, 3)  
        #change array size from 3xMxN to MxNx3
        rrr_img_ras.close()

        plt.imshow(rrr_img_crp, zorder=0,                                      \
                   extent=[x_range[0], x_range[1], y_range[0], y_range[1]])
        #show image in the background of plot
    except:
        print('Unable to read given backround image '+rrr_img_file)


#*******************************************************************************
#Finding high and low flows for best display
#*******************************************************************************
if BS_wid_auto:
     print('Finding high and low flows for best display')

     IV_one=numpy.ones(IS_riv_bas)
     IV_npt=numpy.zeros(IS_riv_bas)
     ZV_Qavg=numpy.zeros(IS_riv_bas)
     ZV_Qmax=numpy.zeros(IS_riv_bas)
     ZV_Qmin=numpy.ones(IS_riv_bas)*1000000000
     for JS_tim in range(IS_tim_str, IS_tim_end, IS_tim_spl):
          ZV_Qout=f.variables[YV_var][JS_tim][IV_riv_bas_index]
          #read netCDF values
          if numpy.ma.is_masked(ZV_Qout):
               BV_yes=~ZV_Qout.mask
          else:
               BV_yes=[True]*IS_riv_bas
          #locations where the netCDF values are not masked
          IV_npt=numpy.where(BV_yes,IV_npt+IV_one,IV_npt)
          #updating the number of actual values (i.e. not NaN) for each reach
          ZV_Qavg=numpy.where(BV_yes,ZV_Qavg+ZV_Qout,ZV_Qavg)
          #updating the average
          ZV_Qmax=numpy.where((BV_yes)&(ZV_Qout>ZV_Qmax),ZV_Qout,ZV_Qmax)
          #updating the maximum
          ZV_Qmin=numpy.where((BV_yes)&(ZV_Qout<ZV_Qmin),ZV_Qout,ZV_Qmin)
          #updating the minimum
     IV_npt=numpy.where(IV_npt==0,-9999,IV_npt)
     #Replacing number of values by -9999 only where there was 0 values to avoid
     #runtime warning during division below
     ZV_Qavg=numpy.where(IV_npt>0,ZV_Qavg/IV_npt,numpy.NaN)
     #Dividing sum of values by number of values. Otherwise: NaN
     ZS_Qhig=numpy.nanmax(ZV_Qmax)
     ZS_Qlow=numpy.nanmean(ZV_Qavg)
     #Finding an estimate of Qhig and Qlow, several other options exist here!

     ZV_Qhig=ZS_Qhig*numpy.ones(IS_riv_bas)
     ZV_Qlow=ZS_Qlow*numpy.ones(IS_riv_bas)
     ZV_Whig=ZS_Whig*numpy.ones(IS_riv_bas)
     ZV_Wlow=ZS_Wlow*numpy.ones(IS_riv_bas)

     #ZV_Qhig=ZV_Qmax
     #ZV_Qlow=ZV_Qmin
     #ZV_Whig=ZS_Whig*numpy.ones(IS_riv_bas)
     #ZV_Wlow=ZS_Wlow*numpy.ones(IS_riv_bas)

     #ZV_Qhig=ZV_Qmax
     #ZV_Qlow=ZV_Qmin
     #ZV_Whig=numpy.zeros(IS_riv_bas)
     #ZV_Wlow=numpy.zeros(IS_riv_bas)
     #for ZS_prc in range(0,100,20):
     #     ZS_Qbot=numpy.nanpercentile(ZV_Qavg,ZS_prc)
     #     ZS_Qtop=numpy.nanpercentile(ZV_Qavg,ZS_prc+20)
     #     for JS_riv_bas in range(IS_riv_bas):
     #          ZS_Qavg=ZV_Qavg[JS_riv_bas]
     #          if (ZS_Qavg>=ZS_Qbot) and (ZS_Qavg<=ZS_Qtop):
     #               ZV_Wlow[JS_riv_bas]=ZS_Wlow+ZS_prc/100.*(ZS_Whig-ZS_Wlow)
     #               ZV_Whig[JS_riv_bas]=ZS_Wlow+(ZS_prc+20)/100.               \
     #                                          *(ZS_Whig-ZS_Wlow)

else:
     print('High and low flows for best display are hard-coded')
     ZV_Qhig=ZS_Qhig*numpy.ones(IS_riv_bas)
     ZV_Qlow=ZS_Qlow*numpy.ones(IS_riv_bas)
     ZV_Whig=ZS_Whig*numpy.ones(IS_riv_bas)
     ZV_Wlow=ZS_Wlow*numpy.ones(IS_riv_bas)

print('- The estimate of high flow to be plotted is: '+str(ZS_Qhig)+ ' m3/s')
print('- The estimate of low  flow to be plotted is: '+str(ZS_Qlow)+ ' m3/s')


#*******************************************************************************
#Plotting and video generation
#*******************************************************************************
print('Plotting and video generation')

#-------------------------------------------------------------------------------
#Initialization of video driver
#-------------------------------------------------------------------------------
try:
     FFMpegWriter = matplotlib.animation.writers['ffmpeg']
except:
     print('ERROR - Unable to initialize video writer')
     raise SystemExit(22)

writer = FFMpegWriter(fps=vid_fps)
#Set additional setting of the driver

#-------------------------------------------------------------------------------
#Video creation
#-------------------------------------------------------------------------------
print("- Video creation start: "                                               \
      +datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))

with writer.saving(plt_fig, rrr_vid_file, vid_dpi):
    ZV_one=numpy.ones(IS_riv_bas)
    for JS_tim in range(IS_tim_str, IS_tim_end, IS_tim_spl):

        date_str = (date_ini + date_stp*JS_tim).strftime("%Y-%m-%d %H:%M")
        #date string to be shown in video title
        plt.title(YV_title + ' ' + '\n' +                                      \
                  date_str + ' UTC')
        #title

        ZV_Qout=f.variables[YV_var][JS_tim][IV_riv_bas_index]
        #This does not seem to be sped up by first reordering the polylines in  
        #the shapefile so that they are sorted similarly to the netCDF file
        if numpy.ma.is_masked(ZV_Qout):
             BV_yes=~ZV_Qout.mask
        else:
             BV_yes=[True]*IS_riv_bas
        #locations where the netCDF values are not masked

        ZV_Qout=numpy.where(BV_yes,ZV_Qout,0*ZV_one)
        #Replaces potential NoData values in the netCDF file by 0 for plotting

        polyline_wid=ZV_Wlow+(ZV_Whig-ZV_Wlow)*(ZV_Qout-ZV_Qlow)               \
                                              /(ZV_Qhig-ZV_Qlow)
        #Plot such that Qlow shows as Wlow and Qhig shows as Whig

        polyline_wid=numpy.where(ZV_Qout>=ZV_Qlow,polyline_wid,ZS_Wlow*ZV_one)
        #Sets width to Wlow if Qout<Qlow (avoids negative values in previous eq)

        polyline_wid=numpy.where(BV_yes,polyline_wid,0*ZV_one)
        #Sets width to zero if NoData

        plt_clc.set_linewidths(polyline_wid)
        #Scale thickness of each river reach by the magnitude of the variable

        writer.grab_frame()
        #This is the time consuming step, all above steps are fast 

print("- Video creation end  : "                                               \
      +datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S"))


#*******************************************************************************
#End
#*******************************************************************************
