[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-yellow.svg)](https://github.com/c-h-david/rrr/blob/master/LICENSE)

[![Build Status](https://travis-ci.org/c-h-david/rrr.svg?branch=master)](https://travis-ci.org/c-h-david/rrr)



The Reproducible Routing Rituals (RRR) is a Python and bash shell toolbox that 
combines many repetitive pre and post-processing tasks that are common to 
studying the movements of water on and underneath the land surface.  Such tasks 
include the preparation of files corresponding to:
- River network details (connectivity, parameters, sort, coordinates, subset) 
- Contributing catchments information (area, coordinates)
- Reformatted land surface model outputs
- Coupling of LSM outputs and catchments to estimate water inflow into rivers
- Observed gauge data 
- Analysis of these and associated data from a hydrological perpective

Vector-based ("blue line") river networks and associated contributing catchments
can be used from the following datasets:
- The enhanced National Hydrography Dataset (NHDPlus, versions 1 and 2)
- The Hydrological data and maps based on SHuttle Elevation Derivatives at
  multiple Scales (HydroSHEDS)

Surface and subsurface runoff are obtained using model outputs from:
- The Global Land Data Assimilation System (GLDAS)
- The North American Land Data Assimilation System (NLDAS)

Water inflow from the land surface models and into the hydrographic networks are
formatted for use within:
- The Routing Application for Parallel computatIon of Discharge (RAPID)

Observed gauges are gathered from:
- The National Water Information System (NWIS)

Hydrological data analysis is done for the above datasets, as well as model 
outputs from:
- The Routing Application for Parallel computatIon of Discharge (RAPID)

RRR is specifically designed to work hand-in-hand with RAPID.  Further
information on both RAPID and RRR can be found on the the RAPID website at:
http://rapid-hub.org/.

Up-to-date installation instructions can be found in requirements.apt, 
requirements.pip, and .travis.yml files.
