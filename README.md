# RRR
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3236649.svg)](https://doi.org/10.5281/zenodo.3236649)

[![License (3-Clause BSD)](https://img.shields.io/badge/license-BSD%203--Clause-yellow.svg)](https://github.com/c-h-david/rrr/blob/master/LICENSE)

[![GitHub CI Status](https://github.com/c-h-david/rrr/actions/workflows/github_actions_CI.yml/badge.svg)](https://github.com/c-h-david/rrr/actions)

[![Docker Build](https://img.shields.io/docker/cloud/build/chdavid/rrr.svg)](https://hub.docker.com/r/chdavid/rrr/tags)

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

## Installation with Docker
Installing RRR is **by far the easiest with Docker**. This document was
written and tested using
[Docker Community Edition](https://www.docker.com/community-edition#/download)
which is available for free and can be installed on a wide variety of operating
systems. To install it, follow the instructions in the link provided above.

Note that the experienced users may find more up-to-date installation
instructions in
[Dockerfile](https://github.com/c-h-david/rrr/blob/master/Dockerfile).

### Download RRR
Downloading RRR with Docker can be done using:

```
$ docker pull chdavid/rrr
```

### Install packages
The beauty of Docker is that there is **no need to install anymore packages**.
RRR is ready to go! To run it, just use:

```
$ docker run --rm -it chdavid/rrr
```

## Testing with Docker
Testing scripts are currently under development.

Note that the experienced users may find more up-to-date testing instructions
in
[docker.test.yml](https://github.com/c-h-david/rrr/blob/master/docker.test.yml).

## Installation on Ubuntu
This document was written and tested on a machine with a **clean** image of 
[Ubuntu 16.04.1 Desktop 64-bit](http://old-releases.ubuntu.com/releases/16.04.1/ubuntu-16.04.1-desktop-amd64.iso)
installed, *i.e.* **no update** was performed, and **no upgrade** either. 

Note that the experienced users may find more up-to-date installation 
instructions in
[github\_actions\_CI.yml](https://github.com/c-h-david/rrr/blob/master/.github/workflows/github_actions_CI.yml).

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
[requirements.apt](https://github.com/c-h-david/rrr/blob/master/requirements.apt)
and can be installed with `apt-get`. All packages can be installed at once using:

```
$ sudo apt-get install -y --no-install-recommends $(grep -v -E '(^#|^$)' requirements.apt)
```

> Alternatively, one may install the APT packages listed in 
> [requirements.apt](https://github.com/c-h-david/rrr/blob/master/requirements.apt)
> one by one, for example:
>
> ```
> $ sudo apt-get install -y --no-install-recommends python-dev
>```

### Install Python packages
Python packages from the Python Package Index (PyPI) are summarized in
[requirements.pip](https://github.com/c-h-david/rrr/blob/master/requirements.pip)
and can be installed with `pip`. But first, let's make sure that the latest
version of `pip` is installed

```
$ wget https://bootstrap.pypa.io/pip/2.7/get-pip.py
$ sudo python get-pip.py --no-cache-dir `grep 'pip==' requirements.pip` `grep 'setuptools==' requirements.pip` `grep 'wheel==' requirements.pip`
$ rm get-pip.py
```

All packages can be installed at once using:

```
$ sudo pip install --no-cache-dir `grep 'numpy==' requirements.pip`
$ sudo pip install --no-cache-dir -r requirements.pip
```

> Alternatively, one may install the PyPI packages listed in 
> [requirements.pip](https://github.com/c-h-david/rrr/blob/master/requirements.pip)
> one by one, for example:
>
> ```
> $ sudo pip install dbf==0.96.5
> ```

## Testing on Ubuntu
Testing scripts are currently under development.

Note that the experienced users may find more up-to-date testing instructions 
in
[github\_actions\_CI.yml](https://github.com/c-h-david/rrr/blob/master/.github/workflows/github_actions_CI.yml).
