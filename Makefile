#Dockerfile vars
ubuntuver=20.04
zeekver=3.2.2

#vars
IMAGENAME=networkanalysis
VERSION=0.1.0
REPO=dapfeffer
IMAGEFULLNAME=${REPO}/${IMAGENAME}:${VERSION}

.PHONY: help build push all

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "alpver - Alpine Version"
	    @echo "kctlver - kubectl version"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "build"
	    @echo "push"
	    @echo "all"

.DEFAULT_GOAL := all

build:
	    @docker build --pull --build-arg UBUNTU_VER=${ubuntuver} --build-arg ZEEK_VER=${zeekver} -t ${IMAGEFULLNAME} .

push:
	    @docker push ${IMAGEFULLNAME}

all: build push