#Dockerfile vars
ubuntuver=20.04
zeekver=4.2.2
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
IMAGEBASE=${REPO}/${IMAGENAME}:base

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
		@touch crowdstrike_intel_snort.rules
		@wget https://rules.emergingthreats.net/open/suricata-5.0/emerging-all.rules.tar.gz
		@wget https://www.snort.org/downloads/community/community-rules.tar.gz
		@tar xzvf emerging-all.rules.tar.gz
		@tar xzvf community-rules.tar.gz
		@sed 's/^#alert/alert/' emerging-all.rules | sed 's/.*ET DELETED .*//' | sed 's/.*GPL DELETED .*//' > all.rules
		@cat community-rules/community.rules >> all.rules
		@cat suricata-custom.rules >> all.rules
		@cat crowdstrike_intel_snort.rules >> all.rules
		@gpg -c all.rules
	    @docker build --pull -t ${IMAGEFULLNAME} -f Dockerfile .
	    @docker tag ${IMAGEFULLNAME} ${IMAGELATEST}
base:
	    @docker build --pull --build-arg UBUNTU_VER=${ubuntuver} --build-arg ZEEK_VER=${zeekver} --build-arg SURICATA_VER=${suricataver} -t ${IMAGEBASE} -f Dockerfile.base .
	    @docker push ${IMAGEBASE}
push:
	    @docker push ${IMAGEFULLNAME}
	    @docker push ${IMAGELATEST}

pushlocal:
	    @docker tag ${IMAGEFULLNAME} localhost:6000/${IMAGEFULLNAME}
	    @docker push localhost:6000/${IMAGEFULLNAME}

all: build push
