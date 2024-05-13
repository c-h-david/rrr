#!/usr/bin/env python3
# *****************************************************************************
# rrr_tpl.py
# *****************************************************************************

# Purpose:
# The purpose of this program is to provide an example template for the code
# format and style used within RRR. This template illustrates our preferences
# for a variety of coding aspects, including:
# - common header information: Shebang, Script Name, Purpose, Author(s), Dates
# - typical sections of code that are included in most scripts: Import Python
#   modules, Declaration of variables, Get command line arguments, Print input
#   information, Check if files exist.
# - how the choice of commented-out characters specifies Section (****),
#   Subsection (----), and Subsubsection (- - )
# - the use of Newlines: 2 after each Section, 1 after each Subsection and
#   Subsubsection, 1 after consistent code blocks
# - file permission for executable Python files is 755
# - PEP 8 as our preferred style guide, specifically:
#   . the use of spaces rather than tabs for indentation
#   . the number of characters in an identation (4)
#   . the maximum number of characters in any given line (79)
#   . the use of single quotes (')
#
# While not mandatory, using this template allows for ease of human readability
# and general consistency with our code base. Failure to adopt this template
# may be perceived as an implicit invitation for code developers to
# substantially modify your contribution.
# Thank you for your consideration!
# As an example, this program takes any given file as an input, and produces a
# a simple summary metric for that file.
#
# Author:
# Cedric H. David, 2024-2024


# *****************************************************************************
# Import Python modules
# *****************************************************************************
import sys


# *****************************************************************************
# Declaration of variables (given as command line arguments)
# *****************************************************************************
# 1 - rrr_fil_ext


# *****************************************************************************
# Get command line arguments
# *****************************************************************************
IS_arg = len(sys.argv)
if IS_arg != 2:
    print('ERROR - 1 and only 1 argument must be used')
    raise SystemExit(22)

rrr_fil_ext = sys.argv[1]


# *****************************************************************************
# Print input information
# *****************************************************************************
print('Command line inputs')
print('- '+rrr_fil_ext)


# *****************************************************************************
# Check if files exist
# *****************************************************************************
try:
    with open(rrr_fil_ext) as file:
        pass
except IOError as e:
    print('ERROR - Unable to open {0.filename}'.format(e))
    raise SystemExit(22)


# *****************************************************************************
# Notes on naming conventions for RRR Python scripts
# *****************************************************************************

# -----------------------------------------------------------------------------
# A rule of three? Triad, triplets, etc.
# -----------------------------------------------------------------------------
# One way or another, the Python scripts in RRR are in their vast majority
# named using triplets of characters separated by underscores. There is no
# valid reason for this other than that is what we have been doing and we just
# continue to do so.  The scripts in the `rrr/src/` directory all start with
# `rrr`. Those in the `rrr/tst/` directory start with `tst`.

# -----------------------------------------------------------------------------
# Example scripts
# -----------------------------------------------------------------------------
# Notable script names are:
# - rrr_anl_*.py: Analysis of timeseries and maps
# - rrr_cat_*.py: Catchment network processing
# - rrr_cpl_*.py: Coupling of river network and land surface model
# - rrr_lsm_*.py: Land surface model processing
# - rrr_obs_*.py: Observations processing
# - rrr_riv_*.py: River network processing
# - tst_cmp_*.py: Compare files


# *****************************************************************************
# Notes on naming conventions for RRR variables
# *****************************************************************************

# -----------------------------------------------------------------------------
# Hat tip to Fortran 77 implicit rules
# -----------------------------------------------------------------------------
# The variable naming convention used here was inspired by implicit rules in
# Fortran 77. These rules specify that if a variable is not explicitely defined
# (using a Fortran "type" statement), then the first letter of the variable
# name determines the data type implicitly. The default implicit typing rule is
# that if the first letter of the name is I, J, K, L, M, or N, then the data
# type is integer, otherwise it is real.
# In RRR, the first letter of a variable name has the following conventions:
# - I is for an integer that is intended to be fixed (or computed just once)
# - J is for an integer that is intended to iterated upon
# - Y is for a string of characters
# - Z is for a floating point
# In RRR, the second letter of a variable name has the following conventions:
# - S is for a scalar (a 0-dimensional array)
# - V is for a vector (a 1-dimensional array)
# - M is for a matrix (a 2-dimensional array)
# In RRR, the remaining characters of a variable name are as follows:
# - "lower_case_with_underscores" format often composed of triplets of
#   characters, as is done for the Python script names (see above)

# -----------------------------------------------------------------------------
# Example scalar variables (0-D arrays)
# -----------------------------------------------------------------------------
YS_str_tpl = 'string'
IS_int_tpl = 10                         # iterated upon with JS_int_tpl
ZS_flt_tpl = 1.5678

# -----------------------------------------------------------------------------
# Example vector variables (1-D arrays)
# -----------------------------------------------------------------------------
YV_str_tpl = ['string1', 'string2']
IV_flt_tpl = [1, 2]
ZV_flt_tpl = [1.45, 3.788]

# -----------------------------------------------------------------------------
# Example matrix variables (2-D arrays)
# -----------------------------------------------------------------------------
YM_str_tpl = [['string1', 'string2'],
              ['string3', 'string4']]
IM_flt_tpl = [[1, 2],
              [3, 4]]
ZM_flt_tpl = [[1.45, 2.788],
              [3.877, 4.36]]

# -----------------------------------------------------------------------------
# Example RRR input/ouput variable name
# -----------------------------------------------------------------------------
rrr_con_csv = 'rapid_connectivity.csv'
# Starts with `rrr`, `con` for connectivity, `csv` for the file extension.


# *****************************************************************************
# Example tasks executed as part of this script
# *****************************************************************************
print('Example tasks executed as part of this script')

# -----------------------------------------------------------------------------
# Count number of lines in the input file
# -----------------------------------------------------------------------------
print(' - Count number of lines in the input file')

with open(rrr_fil_ext, 'r') as file:
    IS_count = 0
    for line in file:
        IS_count = IS_count + 1
print('  . Number of lines in ', rrr_fil_ext, ': ', IS_count)

# -----------------------------------------------------------------------------
# Iterate over example integer
# -----------------------------------------------------------------------------
print(' - Iterate over example integer')

for JS_int_tpl in range(IS_int_tpl):
    ZS_flt_tpl = ZS_flt_tpl + 1
print('  . Done')


# *****************************************************************************
# End
# *****************************************************************************
