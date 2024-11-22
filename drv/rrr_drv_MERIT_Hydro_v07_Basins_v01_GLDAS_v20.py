#!/usr/bin/env python3
# *****************************************************************************
# rrr_drv_MERIT_Hydro_v07_Basins_v01_GLDAS_v20.py
# *****************************************************************************

# Purpose:
# This program is designed to produce input data for RAPID for one entire month
# and can be run with a simple set of instructions. The focus here is on runoff
# from GLDAS v2.0 and hydrography from MERITHydro v0.1 Basins v0.1. The details
# of the execution are included in a simple python class:
# rrr = RRR('74', 'VIC', '3H', '2000-01')
# This class combines the pfaf_level_02 code, the Land Surface Model (LSM) name
# the LSM temporal resolution, and the month in yyyy-mm format.
# Authors:
# Cedric H. David, Kevin Marlis, Manu Tom 2023-24


# *****************************************************************************
# Import Python modules
# *****************************************************************************
import os
import subprocess
import datetime
import dateutil.relativedelta
import glob


# *****************************************************************************
# Define nomenclature inside Python class
# *****************************************************************************
class RRR(object):
    basn_id: str
    lsm_mod: str
    lsm_stp: str
    yyyy_mm: str

    def __init__(self, basn_id, lsm_mod, lsm_stp, yyyy_mm) -> None:
        self.basn_id = basn_id
        self.lsm_mod = lsm_mod
        self.lsm_stp = lsm_stp
        self.yyyy_mm = yyyy_mm

        self.set_paths()

    def set_paths(self):
        # Uses “formatted string literals” also known as f-strings.

        # ---------------------------------------------------------------------
        # Directories
        # ---------------------------------------------------------------------
        self.inp_dir = '/tmp/input/'
        os.makedirs(self.inp_dir, exist_ok=True)
        self.hyd_dir = '/rrr/input/pfaf_{self.basn_id}/'
        self.lsm_dir = (
            f'/tmp/input/pfaf_{self.basn_id}/GLDAS20/{self.lsm_mod}/'
            f'{self.lsm_stp}/{self.yyyy_mm}/'
            )
        os.makedirs(self.lsm_dir, exist_ok=True)
        self.out_dir = '/tmp/'
        os.makedirs(self.out_dir, exist_ok=True)

        # ---------------------------------------------------------------------
        # Hydrography {basn_id}
        # ---------------------------------------------------------------------
        self.riv_shp = (
            f"riv_pfaf_{self.basn_id}_MERIT_Hydro_v07_Basins_v01_"
            f"GLDAS_ENS.shp"
            )
        self.cat_shp = (
            f"cat_pfaf_{self.basn_id}_MERIT_Hydro_v07_Basins_v01.shp"
            )
        self.kfc_csv = f'kfac_pfaf_{self.basn_id}_1km_hour.csv'
        self.xfc_csv = f'xfac_pfaf_{self.basn_id}_0.1.csv'
        self.klo_csv = f'k_pfaf_{self.basn_id}_low.csv'
        self.xlo_csv = f'x_pfaf_{self.basn_id}_low.csv'
        self.knr_csv = f'k_pfaf_{self.basn_id}_nrm.csv'
        self.xnr_csv = f'x_pfaf_{self.basn_id}_nrm.csv'
        self.khi_csv = f'k_pfaf_{self.basn_id}_hig.csv'
        self.xhi_csv = f'x_pfaf_{self.basn_id}_hig.csv'

        self.srt_csv = f'sort_pfaf_{self.basn_id}_topo.csv'
        self.crd_csv = f'coords_pfaf_{self.basn_id}.csv'
        self.bas_csv = f'riv_bas_id_pfaf_{self.basn_id}_topo.csv'
        self.con_csv = f'rapid_connect_pfaf_{self.basn_id}.csv'
        self.cat_csv = f'rapid_catchment_pfaf_{self.basn_id}.csv'

        # ---------------------------------------------------------------------
        # Times {yyyy_mm}
        # ---------------------------------------------------------------------
        self.dat_str = datetime.datetime.strptime(self.yyyy_mm, '%Y-%m')
        self.dat_end = self.dat_str                                           \
            + dateutil.relativedelta.relativedelta(months=1)                  \
            + dateutil.relativedelta.relativedelta(seconds=-1)
        self.iso_str = self.dat_str.isoformat()
        self.iso_end = self.dat_end.isoformat()

        # ---------------------------------------------------------------------
        # Land Surface Model {lsm_mod} {lsm_stp} {yyyy_mm}
        # ---------------------------------------------------------------------
        self.lsm_tmp = (
            f"GLDAS_{self.lsm_mod}_"
            f"{self.lsm_stp}_"
            f"{self.yyyy_mm}_utc_tmp.nc4"
            )
        self.lsm_ncf = (
            f"GLDAS_{self.lsm_mod}_"
            f"{self.lsm_stp}_"
            f"{self.yyyy_mm}_utc.nc4"
            )

        # ---------------------------------------------------------------------
        # Coupling {basn_id}
        # ---------------------------------------------------------------------
        self.cpl_csv = f'rapid_coupling_pfaf_{self.basn_id}_GLDAS.csv'

        # ---------------------------------------------------------------------
        # Lateral inflow {basn_id} {lsm_mod} {lsm_stp} {yyyy_mm}
        # ---------------------------------------------------------------------
        self.m3r_ncf = (
            f"m3_riv_pfaf_{self.basn_id}_"
            f"GLDAS_{self.lsm_mod}_"
            f"{self.lsm_stp}_"
            f"{self.yyyy_mm}_utc.nc4"
            )


# *****************************************************************************
# Driver for downloading
# *****************************************************************************

def drv_dwn(rrr: RRR):
    print('Driver for downloading')

    # -------------------------------------------------------------------------
    # Download GLDAS files
    # -------------------------------------------------------------------------
    print('- Download GLDAS files')
    comnd = ['../src/rrr_lsm_tot_ldas.py']                                    \
        + ['GLDAS']                                                           \
        + [rrr.lsm_mod]                                                       \
        + [rrr.lsm_stp]                                                       \
        + [rrr.iso_str]                                                       \
        + [rrr.iso_end]                                                       \
        + [rrr.lsm_dir]                                                       \
        + ['org_no']
    subprocess.run(comnd, capture_output=True, check=True)


# *****************************************************************************
# Driver fof processing of hydrography
# *****************************************************************************

def drv_hyd(rrr: RRR):
    print('Driver for processing of hydrography')

    # -------------------------------------------------------------------------
    # Connectivity, base parameters, coordinates, sort
    # -------------------------------------------------------------------------
    print('- Connectivity, base parameters, coordinates, sort')
    comnd = ['../src/rrr_riv_tot_gen_all_meritbasins.py']                     \
        + [rrr.hyd_dir + rrr.riv_shp]                                         \
        + ['5']                                                               \
        + [rrr.out_dir + rrr.con_csv]                                         \
        + [rrr.out_dir + rrr.kfc_csv]                                         \
        + [rrr.out_dir + rrr.xfc_csv]                                         \
        + [rrr.out_dir + rrr.srt_csv]                                         \
        + [rrr.out_dir + rrr.crd_csv]
    subprocess.run(comnd, capture_output=True, check=True)

    # -------------------------------------------------------------------------
    # Parameters
    # -------------------------------------------------------------------------
    print('- Parameters')
    comnd = ['../src/rrr_riv_tot_scl_prm.py']                                 \
        + [rrr.out_dir + rrr.kfc_csv]                                         \
        + [rrr.out_dir + rrr.xfc_csv]                                         \
        + ['0.20']                                                            \
        + ['0.00']                                                            \
        + [rrr.out_dir + rrr.klo_csv]                                         \
        + [rrr.out_dir + rrr.xlo_csv]
    subprocess.run(comnd, capture_output=True, check=True)

    comnd = ['../src/rrr_riv_tot_scl_prm.py']                                 \
        + [rrr.out_dir + rrr.kfc_csv]                                         \
        + [rrr.out_dir + rrr.xfc_csv]                                         \
        + ['0.35']                                                            \
        + ['3.00']                                                            \
        + [rrr.out_dir + rrr.knr_csv]                                         \
        + [rrr.out_dir + rrr.xnr_csv]
    subprocess.run(comnd, capture_output=True, check=True)

    comnd = ['../src/rrr_riv_tot_scl_prm.py']                                 \
        + [rrr.out_dir + rrr.kfc_csv]                                         \
        + [rrr.out_dir + rrr.xfc_csv]                                         \
        + ['0.50']                                                            \
        + ['5.00']                                                            \
        + [rrr.out_dir + rrr.khi_csv]                                         \
        + [rrr.out_dir + rrr.xhi_csv]
    subprocess.run(comnd, capture_output=True, check=True)

    # -------------------------------------------------------------------------
    # Sorted subset
    # -------------------------------------------------------------------------
    print('- Sorted subset')
    comnd = ['../src/rrr_riv_bas_gen_one_meritbasins.py']                     \
        + [rrr.hyd_dir + rrr.riv_shp]                                         \
        + [rrr.out_dir + rrr.con_csv]                                         \
        + [rrr.out_dir + rrr.srt_csv]                                         \
        + [rrr.out_dir + rrr.bas_csv]
    subprocess.run(comnd, capture_output=True, check=True)

    # -------------------------------------------------------------------------
    # Contributing catchment information
    # -------------------------------------------------------------------------
    print('- Contributing catchment information')
    comnd = ['../src/rrr_cat_tot_gen_one_meritbasins.py']                     \
        + [rrr.hyd_dir + rrr.cat_shp]                                         \
        + [rrr.out_dir + rrr.cat_csv]
    subprocess.run(comnd, capture_output=True, check=True)


# *****************************************************************************
# Driver for processing land surface model outputs
# *****************************************************************************

def drv_lsm(rrr: RRR):
    print('Driver for processing land surface model outputs')

    # -------------------------------------------------------------------------
    # Combine and accumulate multiple files
    # -------------------------------------------------------------------------
    print('- Combine and accumulate multiple files')
    all_nc4 = sorted(glob.glob(rrr.lsm_dir + '*.nc4'))
    comnd = ['/bin/bash']                                                     \
        + ['../src/rrr_lsm_tot_cmb_acc.sh']                                   \
        + all_nc4                                                             \
        + ['1']                                                               \
        + [rrr.out_dir + rrr.lsm_tmp]
    subprocess.run(comnd, capture_output=True, check=True)

    # -------------------------------------------------------------------------
    # Make file CF compliant
    # -------------------------------------------------------------------------
    print('- Make file CF compliant')
    comnd = ['../src/rrr_lsm_tot_add_cfc.py']                                 \
        + [rrr.out_dir + rrr.lsm_tmp]                                         \
        + [rrr.iso_str]                                                       \
        + ['10800']                                                           \
        + ['1.0']                                                             \
        + [rrr.out_dir + rrr.lsm_ncf]
    subprocess.run(comnd, capture_output=True, check=True)

    # -------------------------------------------------------------------------
    # Delete temporary file
    # -------------------------------------------------------------------------
    print('- Delete temporary file')
    comnd = ['rm']                                                            \
        + [rrr.out_dir + rrr.lsm_tmp]
    subprocess.run(comnd, capture_output=True, check=True)


# *****************************************************************************
# Driver for coupling
# *****************************************************************************

def drv_cpl(rrr: RRR):
    print('Driver for coupling')

    # ------------------------------------------------------------------------
    # Create coupling file
    # ------------------------------------------------------------------------
    print('- Create coupling file')
    comnd = ['../src/rrr_cpl_riv_lsm_lnk.py']                                 \
        + [rrr.out_dir + rrr.con_csv]                                         \
        + [rrr.out_dir + rrr.cat_csv]                                         \
        + [rrr.out_dir + rrr.lsm_ncf]                                         \
        + [rrr.out_dir + rrr.cpl_csv]
    subprocess.run(comnd, capture_output=True, check=True)


# *****************************************************************************
# Driver for volume
# *****************************************************************************

def drv_vol(rrr: RRR):
    print('Driver for volume')

    # -------------------------------------------------------------------------
    # Create volume file
    # -------------------------------------------------------------------------
    print('- Create volume file')
    comnd = ['../src/rrr_cpl_riv_lsm_vol.py']                                 \
        + [rrr.out_dir + rrr.con_csv]                                         \
        + [rrr.out_dir + rrr.crd_csv]                                         \
        + [rrr.out_dir + rrr.lsm_ncf]                                         \
        + [rrr.out_dir + rrr.cpl_csv]                                         \
        + [rrr.out_dir + rrr.m3r_ncf]
    subprocess.run(comnd, capture_output=True, check=False, text=True)

    # --------------------------------------------------------------------------
    # Update netCDF attributes
    # --------------------------------------------------------------------------
    print('- Update netCDF attributes')
    comnd = [
        '../src/rrr_cpl_riv_lsm_att.py',
        rrr.out_dir + rrr.m3r_ncf,
        (
            f"RRR data corresponding to MERIT Hydro 07 Basin 01 pfaf_"
            f"{rrr.basn_id}, GLDAS {rrr.lsm_mod}"
            ),
        "Jet Propulsion Laboratory, California Institute of Technology",
        "",
        "6378137",
        "298.257222101",
        ]
    subprocess.run(comnd, capture_output=True, check=True)


# *****************************************************************************
# Driver for all
# *****************************************************************************

def drv_all(rrr: RRR):

    # -------------------------------------------------------------------------
    # Running all drivers
    # -------------------------------------------------------------------------
    drv_dwn(rrr)
    drv_hyd(rrr)
    drv_lsm(rrr)
    drv_cpl(rrr)
    drv_vol(rrr)


# *****************************************************************************
# For testing purposes
# *****************************************************************************
#
# #----------------------------------------------------------------------------
# #Execution of subprocess
# #----------------------------------------------------------------------------
# comnd=[]
# comnd.append('echo')
# comnd.append('TEST')
# subprocess.run(comnd, capture_output=True, check=True)
# #subprocess.run(comnd, check=True)
# #subprocess.Popen(comnd)
#
# #----------------------------------------------------------------------------
# #Running drivers
# #----------------------------------------------------------------------------
# rrr = RRR('74', 'VIC', '3H', '2000-01')
# drv_dwn(rrr)
# drv_hyd(rrr)
# drv_lsm(rrr)
# drv_cpl(rrr)
# drv_vol(rrr)


# *****************************************************************************
# End
# *****************************************************************************
