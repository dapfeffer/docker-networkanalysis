#Dockerfile vars
ubuntuver=20.04
zeekver=4.0.3
suricataver=6.0.3

#vars
IMAGENAME=networkanalysis
TIMESTAMP:=$(shell date +%Y%m%d)
#VERSION=0.1.1
#VERSION=${TIMESTAMP}
VERSION=$(shell git describe --always)
REPO=dapfeffer
IMAGEFULLNAME=${REPO}/${IMAGENAME}:${VERSION}
IMAGELATEST=${REPO}/${IMAGENAME}:latest

.PHONY: help build push all

help:
	    @echo "Makefile arguments:"
	    @echo ""
	    @echo "Makefile commands:"
	    @echo "build"
	    @echo "push"
	    @echo "all"

.DEFAULT_GOAL := build

build:
	    @touch suricata-custom.rules
	    @docker build --pull --build-arg UBUNTU_VER=${ubuntuver} --build-arg ZEEK_VER=${zeekver} --build-arg SURICATA_VER=${suricataver} -t ${IMAGEFULLNAME} .
	    @docker tag ${IMAGEFULLNAME} ${IMAGELATEST}
push:
	    @docker push ${IMAGEFULLNAME}
	    @docker push ${IMAGELATEST}

pushlocal:
	    @docker tag ${IMAGEFULLNAME} localhost:6000/${IMAGEFULLNAME}
	    @docker push localhost:6000/${IMAGEFULLNAME}

all: build push
