# RRR
[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-yellow.svg)](https://github.com/c-h-david/rrr/blob/master/LICENSE)

[![Build Status](https://travis-ci.org/c-h-david/rrr.svg?branch=master)](https://travis-ci.org/c-h-david/rrr)

[![Docker Build](https://img.shields.io/docker/automated/chdavid/rrr.svg)](https://hub.docker.com/r/chdavid/rrr/)

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
[http://rapid-hub.org/](http://rapid-hub.org/).

## Installation on Ubuntu
This document was written and tested on a machine with a **clean** image of 
[Ubuntu 14.04.0 Desktop 64-bit](http://old-releases.ubuntu.com/releases/14.04.0/ubuntu-14.04-desktop-amd64.iso)
installed, *i.e.* **no update** was performed, and **no upgrade** either. 

Note that the experienced users may find more up-to-date installation 
instructions in
[.travis.yml](https://github.com/c-h-david/rrr/blob/master/.travis.yml).

### Download RRR
First, make sure that `git` is installed: 

```
$ sudo apt-get install -y git
```

Then download RRR:

```
$ git clone https://github.com/c-h-david/rrr
```

Finally, enter the RRR directory:

```
$ cd rrr/
```

### Install APT packages
Software packages for the Advanced Packaging Tool (APT) are summarized in 
[requirements.apt](https://github.com/c-h-david/rrr/blob/master/requirements.apt)
and can be installed with `apt-get`. All packages can be installed at once using:

```
$ sudo apt-get install -y $(grep -v -E '(^#|^$)' requirements.apt)
```

> Alternatively, one may install the APT packages listed in 
> [requirements.apt](https://github.com/c-h-david/rrr/blob/master/requirements.apt)
> one by one, for example:
>
> ```
> $ sudo apt-get install -y python-pip
>```

Note that Ubuntu 14.0.0 does not support `ffmpeg` and instead has `avconv`. A simple
symbolic link will suffice to here:

```
$ sudo ln -s /usr/bin/avconv /usr/bin/ffmpeg
```

### Install Python packages
Python packages from the Python Package Index (PyPI) are summarized in 
[requirements.pip](https://github.com/c-h-david/rrr/blob/master/requirements.pip)
and can be installed with `pip`. All packages can be installed at once using:

```
$ sudo pip install -r requirements.pip
```

> Alternatively, one may install the PyPI packages listed in 
> [requirements.pip](https://github.com/c-h-david/rrr/blob/master/requirements.pip)
> one by one, for example:
>
> ```
> $ sudo pip install cryptography==2.0.3
> ```

### Install NCL
The NCAR Command Language (NCL) can be downloaded using:

```
$ mkdir $HOME/installz
$ cd $HOME/installz
$ wget "https://www.earthsystemgrid.org/download/fileDownload.html?logicalFileId=8201fa1a-cd9b-11e4-bb80-00c0f03d5b7c" -O ncl_ncarg-6.3.0.Linux_Debian6.0_x86_64_nodap_gcc445.tar.gz
$ mkdir ncl_ncarg-6.3.0-install
$ tar -xf ncl_ncarg-6.3.0.Linux_Debian6.0_x86_64_nodap_gcc445.tar.gz --directory=ncl_ncarg-6.3.0-install
```

Then, the environment should be updated using:

```
$ export NCARG_ROOT=$HOME/installz/ncl_ncarg-6.3.0-install
$ export PATH=$PATH:$NCARG_ROOT/bin
```

> Note that these two lines can also be added in `~/.bash_aliases` so that the 
> environment variables persist.

## Testing on Ubuntu
Testing scripts are currently under development.

Note that the experienced users may find more up-to-date testing instructions 
in
[.travis.yml](https://github.com/c-h-david/rrr/blob/master/.travis.yml).
