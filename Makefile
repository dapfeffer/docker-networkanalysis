#Dockerfile vars
ubuntuver=20.04
zeekver=3.2.3
suricataver=6.0.1

#vars
IMAGENAME=networkanalysis
VERSION=0.1.1
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

.DEFAULT_GOAL := all

build:
	    @docker build --pull --build-arg UBUNTU_VER=${ubuntuver} --build-arg ZEEK_VER=${zeekver} --build-arg SURICATA_VER=${suricataver} -t ${IMAGEFULLNAME} .
	    @docker tag ${IMAGEFULLNAME} ${IMAGELATEST}
push:
	    @docker push ${IMAGEFULLNAME}
	    @docker push ${IMAGELATEST}

pushlocal:
	    @docker tag ${IMAGEFULLNAME} localhost:6000/${IMAGEFULLNAME}
	    @docker push localhost:6000/${IMAGEFULLNAME}

all: build push
