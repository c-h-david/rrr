# RRR
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3236649.svg)](https://doi.org/10.5281/zenodo.3236649)

[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-yellow.svg)](https://github.com/c-h-david/rrr/blob/main/LICENSE)

[![Docker Images](https://img.shields.io/badge/docker-images-blue?logo=docker)](https://hub.docker.com/r/chdavid/rrr/tags)

[![GitHub CI Status](https://github.com/c-h-david/rrr/actions/workflows/github_actions_CI.yml/badge.svg)](https://github.com/c-h-david/rrr/actions/workflows/github_actions_CI.yml)

[![GitHub CD Status](https://github.com/c-h-david/rrr/actions/workflows/github_actions_CD.yml/badge.svg)](https://github.com/c-h-david/rrr/actions/workflows/github_actions_CD.yml)

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
- The Multi-Error-Removed Improved-Terrain (MERIT) Basins

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

## Installation with Docker
Installing RRR is **by far the easiest with Docker**. This document was
written and tested using
[Docker Community Edition](https://www.docker.com/community-edition#/download)
which is available for free and can be installed on a wide variety of operating
systems. To install it, follow the instructions in the link provided above.

Note that the experienced users may find more up-to-date installation
instructions in
[Dockerfile](https://github.com/c-h-david/rrr/blob/main/Dockerfile).

### Download RRR
Downloading RRR with Docker can be done using:

```
$ docker pull chdavid/rrr
```

### Install packages
The beauty of Docker is that there is **no need to install anymore packages**.
RRR is ready to go! To run it, just use:

```
$ docker run --rm -e EARTHDATA_USERNAME="yourUsername" -e EARTHDATA_PASSWORD="yourPassword" -it chdavid/rrr
```

## Testing with Docker
Testing scripts are currently under development.

Note that the experienced users may find more up-to-date testing instructions
in
[docker.test.yml](https://github.com/c-h-david/rrr/blob/main/docker.test.yml).

## Installation on Debian
This document was written and tested on a machine with a **clean** image of 
[Debian 11.7.0 ARM64](https://cdimage.debian.org/cdimage/archive/11.7.0/arm64/iso-cd/debian-11.7.0-arm64-netinst.iso)
installed, *i.e.* **no update** was performed, and **no upgrade** either. 
Similar steps **may** be applicable for Ubuntu.

Note that the experienced users may find more up-to-date installation 
instructions in
[github\_actions\_CI.yml](https://github.com/c-h-david/rrr/blob/main/.github/workflows/github_actions_CI.yml).

### Download RRR
First, make sure that `git` is installed: 

```
$ sudo apt-get install -y --no-install-recommends git
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
[requirements.apt](https://github.com/c-h-david/rrr/blob/main/requirements.apt)
and can be installed with `apt-get`. All packages can be installed at once using:

```
$ sudo apt-get install -y --no-install-recommends $(grep -v -E '(^#|^$)' requirements.apt)
```

> Alternatively, one may install the APT packages listed in 
> [requirements.apt](https://github.com/c-h-david/rrr/blob/main/requirements.apt)
> one by one, for example:
>
> ```
> $ sudo apt-get install -y --no-install-recommends python3.9
>```

Also make sure that `python3` points to `python3.9`:

```
$ sudo rm -f /usr/bin/python3
$ sudo ln -s /usr/bin/python3.9 /usr/bin/python3
```

### Install Python packages
Python packages from the Python Package Index (PyPI) are summarized in
[requirements.pip](https://github.com/c-h-david/rrr/blob/main/requirements.pip)
and can be installed with `pip`. But first, let's make sure that the latest
version of `pip` is installed

```
$ wget https://bootstrap.pypa.io/pip/get-pip.py
$ sudo python3 get-pip.py --no-cache-dir `grep 'pip==' requirements.pip` `grep 'setuptools==' requirements.pip` `grep 'wheel==' requirements.pip`
$ rm get-pip.py
```

All packages can be installed at once using:

```
$ sudo pip3 install --no-cache-dir -r requirements.pip
```

> Alternatively, one may install the PyPI packages listed in 
> [requirements.pip](https://github.com/c-h-david/rrr/blob/main/requirements.pip)
> one by one, for example:
>
> ```
> $ sudo pip3 install dbf==0.99.2
> ```

## Testing on Debian
Testing scripts are currently under development.

Note that the experienced users may find more up-to-date testing instructions 
in
[github\_actions\_CI.yml](https://github.com/c-h-david/rrr/blob/main/.github/workflows/github_actions_CI.yml).
