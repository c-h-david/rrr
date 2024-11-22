#!/usr/bin/env python3
# *****************************************************************************
# rrr_lsm_tot_ldas.py
# *****************************************************************************

# Purpose:
# Given and model name, a temporal frequency key, a start date, an end date,
# and a folder path, this script downloads LDAS data from GES-DISC using the
# earthaccess library
# Author:
# Cedric H. David, Manu Tom 2018-24


# *****************************************************************************
# Import Python modules
# *****************************************************************************
import sys
import os.path
import datetime
import earthaccess
import glob
import subprocess
import requests
import simplejson


# *****************************************************************************
# Declaration of variables (given as command line arguments)
# *****************************************************************************
# 1 - rrr_lsm_exp
# 2 - rrr_lsm_mod
# 3 - rrr_lsm_frq
# 4 - rrr_iso_beg
# 5 - rrr_iso_end
# 6 - rrr_lsm_dir
# (7)- rrr_lsm_org


# *****************************************************************************
# Get command line arguments
# *****************************************************************************
IS_arg = len(sys.argv)
if IS_arg < 7 or IS_arg > 8:
    print('ERROR - A minimum of 6 and a maximum of 7 arguments can be used')
    raise SystemExit(22)

rrr_lsm_exp = sys.argv[1]
rrr_lsm_mod = sys.argv[2]
rrr_lsm_frq = sys.argv[3]
rrr_iso_beg = sys.argv[4]
rrr_iso_end = sys.argv[5]
rrr_lsm_dir = sys.argv[6]
if IS_arg == 8:
    rrr_lsm_org = sys.argv[7]
else:
    rrr_lsm_org = ''


# *****************************************************************************
# Print input information
# *****************************************************************************
print('Command line inputs')
print('- '+rrr_lsm_exp)
print('- '+rrr_lsm_mod)
print('- '+rrr_lsm_frq)
print('- '+rrr_iso_beg)
print('- '+rrr_iso_end)
print('- '+rrr_lsm_dir)
print('- '+rrr_lsm_org)


# *****************************************************************************
# Check if directory exists
# *****************************************************************************
rrr_lsm_dir = os.path.join(rrr_lsm_dir, '')
# add trailing slash if it is not there

if not os.path.isdir(rrr_lsm_dir):
    os.mkdir(rrr_lsm_dir)


# *****************************************************************************
# Check LDAS arguments
# *****************************************************************************
print('Check LDAS arguments')

if rrr_lsm_exp == 'NLDAS' or rrr_lsm_exp == 'GLDAS':
    print('- LDAS name is valid')
else:
    print('ERROR - Invalid LDAS name')
    raise SystemExit(22)

if rrr_lsm_mod == 'VIC' or rrr_lsm_mod == 'NOAH' or rrr_lsm_mod == 'MOS'      \
                      or rrr_lsm_mod == 'CLSM':
    print('- Model name is valid')
else:
    print('ERROR - Invalid model name')
    raise SystemExit(22)

if rrr_lsm_frq == 'H' or rrr_lsm_frq == 'M' or rrr_lsm_frq == '3H':
    print('- Data frequency is valid')
else:
    print('ERROR - Invalid data frequency')
    raise SystemExit(22)


# *****************************************************************************
# Check temporal information
# *****************************************************************************
print('Check temporal information')

rrr_dat_beg = datetime.datetime.strptime(rrr_iso_beg, '%Y-%m-%dT%H:%M:%S')
rrr_dat_end = datetime.datetime.strptime(rrr_iso_end, '%Y-%m-%dT%H:%M:%S')

if rrr_dat_end >= rrr_dat_beg:
    print('- Beginning of interval is before end of interval')
else:
    print('ERROR - Beginning of interval is NOT before end of interval')
    raise SystemExit(22)

rrr_dat_stp = rrr_dat_beg
IS_count = 0
# Initialized when to stop downloading and the number of files to download

# -----------------------------------------------------------------------------
# If requesting hourly data
# -----------------------------------------------------------------------------
if rrr_lsm_frq == 'H':
    if rrr_dat_beg.minute == 0 and rrr_dat_beg.second == 0:
        print('- Interval starts at the top of an hour')
    else:
        print('ERROR - The interval does NOT start at the top of an hour: '
              + rrr_iso_beg)
        raise SystemExit(22)

    while rrr_dat_stp <= rrr_dat_end:
        rrr_dat_stp = rrr_dat_stp + datetime.timedelta(hours=1)
        # Adding one hour
        IS_count = IS_count + 1
    print('- The number of files to be downloaded is: '+str(IS_count))

# -----------------------------------------------------------------------------
# If requesting 3-hourly data
# -----------------------------------------------------------------------------
if rrr_lsm_frq == '3H':
    if rrr_dat_beg.hour % 3 == 0 and rrr_dat_beg.minute == 0 and    \
            rrr_dat_beg.second == 0:
        print('- Interval starts at the top of a 3-hour')
    else:
        print('ERROR - The interval does NOT start at the top of a 3-hour: '
              + rrr_iso_beg)
        raise SystemExit(22)

    while rrr_dat_stp <= rrr_dat_end:
        rrr_dat_stp = rrr_dat_stp+datetime.timedelta(hours=3)
        # Adding one hour
        IS_count = IS_count+1
    print('- The number of files to be downloaded is: ' + str(IS_count))

# -----------------------------------------------------------------------------
# If requesting monthly data
# -----------------------------------------------------------------------------
if rrr_lsm_frq == 'M':
    if rrr_dat_beg.day == 1 and rrr_dat_beg.hour == 0 \
            and rrr_dat_beg.minute == 0 and rrr_dat_beg.second == 0:
        print('- Interval starts at the top of a month')
    else:
        print('ERROR - The interval does NOT start at the top of a month: '
              + rrr_iso_beg)
        raise SystemExit(22)

    while rrr_dat_stp <= rrr_dat_end:
        rrr_dat_stp = (rrr_dat_stp+datetime.timedelta(days=32)).replace(day=1)
        # Adding one month done by adding 32 days and replacing the day by 1
        IS_count = IS_count+1
    print('- The number of files to be downloaded is: '+str(IS_count))

# *****************************************************************************
# Check if retaining LDAS directory structure
# *****************************************************************************
print('Check if retaining LDAS directory structure')

if rrr_lsm_org == 'org_no':
    print('- Not retaining LDAS directory structure')

if (rrr_lsm_org != 'org_no') and (rrr_lsm_org != ''):
    print('ERROR: '+rrr_lsm_org+' does not match org_no')
    raise SystemExit(22)

# *****************************************************************************
# Earthaccess download parameters
# *****************************************************************************
if (rrr_lsm_exp == "GLDAS"):
    spatial_res = "10"
    boundingBox = (-180, -60, 180, 90)
elif (rrr_lsm_exp == "NLDAS"):
    spatial_res = "0125"
    boundingBox = (-125, 25, -67, 53)
else:
    print("ERROR - Invalid LDAS")
    raise SystemExit(22)


# *****************************************************************************
# Earthaccess download function
# *****************************************************************************
def earthaccess_dwnld(file_count):
    retries = 0  # Initialize the number of retries

    earthaccess.login()

    dwnld_files_srch = earthaccess.search_data(
        short_name=rrr_lsm_exp + "_" + rrr_lsm_mod + spatial_res +
        "_" + rrr_lsm_frq,
        cloud_hosted=True,
        version=2.0,
        bounding_box=boundingBox,
        temporal=(rrr_iso_beg, rrr_iso_end),
        count=file_count
    )

    while True:  # Run the loop indefinitely until condition met
        try:
            if len(dwnld_files_srch) > 0:
                files_dwnld_list = earthaccess.download(dwnld_files_srch,
                                                        rrr_lsm_dir)
                print("LDAS files downloaded: ", files_dwnld_list)

                # Count the number of properly downloaded files
                valid_files = sum(1 for file in files_dwnld_list
                                  if isinstance(file, str)
                                  or issubclass(type(file), str))

                print("Granules properly downloaded: ", valid_files)
                print("Granules to be downloaded: ", file_count)

                if valid_files >= file_count:
                    # If the number of valid files meets or exceeds the
                    # required count, exit the loop
                    break
                else:
                    # Increment the number of retries
                    retries += 1
                    print(f"Retry {retries}...")
            else:
                print("ERROR - Invalid search parameters for LDAS download")
                raise SystemExit(22)

        except requests.exceptions.HTTPError as e:
            print(f"HTTPError occurred during download: {e}")
            print("Retrying...")
            retries += 1
            continue  # Retry the download

        except simplejson.errors.JSONDecodeError as e:
            print(f"JSON Decode Error occurred during download: {e}")
            print("Retrying...")
            retries += 1
            continue  # Retry the download

        except Exception as e:
            print(f"Exception occurred during download: {e}")
            print("Retrying...")
            retries += 1
            continue  # Retry the download

    if valid_files < file_count:
        print(f"Failed to download {file_count} files after retries.")

    return len(dwnld_files_srch)


# *****************************************************************************
# Test download for one file
# *****************************************************************************
print('Checking that service and credentials work for one file')
num_granules = earthaccess_dwnld(1)


# *****************************************************************************
# Bulk download
# *****************************************************************************
if (num_granules > 0):
    print('Downloading all files')
    earthaccess_dwnld(IS_count)  # 8*31=248, 24x31=744

    print('Removing surplus variables from netCDF files')
    # Iterate through each NetCDF file and delete surplus variables
    for nc_file in glob.glob(rrr_lsm_dir + "/*.nc4"):
        # keep only Qs_acc and Qsb_acc, remove rest
        command = ["ncks", "-v", "Qs_acc,Qsb_acc", nc_file, nc_file, "-O"]
        subprocess.run(command, check=True)


# *****************************************************************************
# End
# *****************************************************************************
