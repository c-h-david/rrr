#*******************************************************************************
#Dockerfile
#*******************************************************************************

#Purpose:
#This file describes the operating system prerequisites for RRR, and is used by
#the Docker software.
#Author:
#Cedric H. David, 2018-2018


#*******************************************************************************
#Usage
#*******************************************************************************
#docker build -t rrr:myimage -f Dockerfile .             #Create image
#docker run --rm --name rrr_mycontainer     \
#           -it rrr:myimage                              #Run image in container
#docker run --rm --name rrr_mycontainer     \
#           -v $PWD/input:/home/rrr/input   \
#           -v $PWD/output:/home/rrr/output \
#           -it rrr:myimage                              #Run and map volumes
#docker save -o rrr_myimage.tar rrr:myimage              #Save a copy of image
#docker load -i rrr_myimage.tar                          #Load a saved image


#*******************************************************************************
#Operating System
#*******************************************************************************
FROM ubuntu:trusty


#*******************************************************************************
#Copy files into Docker image (this ignores the files listed in .dockerignore)
#*******************************************************************************
WORKDIR /home/rrr/
COPY . . 


#*******************************************************************************
#Operating System Requirements
#*******************************************************************************
RUN  apt-get update && \
     apt-get install -y --no-install-recommends $(grep -v -E '(^#|^$)' requirements.apt) && \
     rm -rf /var/lib/apt/lists/*


#*******************************************************************************
#Python requirements
#*******************************************************************************
RUN  pip install $(grep setuptools requirements.pip) && \
     pip install $(grep numpy requirements.pip) && \
     pip install -r requirements.pip


#*******************************************************************************
#Intended (default) command at execution of image (not used during build)
#*******************************************************************************
CMD  /bin/bash


#*******************************************************************************
#End
#*******************************************************************************
