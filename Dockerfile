ARG UBUNTU_VER=20.04

FROM ubuntu:$UBUNTU_VER

RUN echo "Etc/UTC" > /etc/timezone
RUN apt update && apt -y install tzdata && dpkg-reconfigure --frontend noninteractive tzdata && apt -y upgrade && apt -y install zsh git cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev libmaxminddb-dev fd-find libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 libmagic-dev libjansson-dev libjansson4 pkg-config libgoogle-perftools-dev google-perftools libjemalloc-dev libkrb5-dev
RUN DEBIAN_FRONTEND=noninteractive apt install -y tcpdump tshark
WORKDIR /data
ARG ZEEK_VER=3.2.2
ADD https://download.zeek.org/zeek-${ZEEK_VER}.tar.gz /data/
RUN tar xzvf zeek-${ZEEK_VER}.tar.gz
WORKDIR zeek-${ZEEK_VER}
RUN ./configure; make; make install
COPY local.zeek /usr/local/zeek/share/zeek/site/local.zeek
ENV PATH "$PATH:/usr/local/zeek/bin"
WORKDIR /data
RUN rm -rvf /data/zeek*
RUN chsh -s /bin/zsh

RUN apt install -y rustc cargo

ARG SURICATA_VER=6.0.1
ADD https://www.openinfosecfoundation.org/download/suricata-${SURICATA_VER}.tar.gz /data
RUN tar xzf suricata-${SURICATA_VER}.tar.gz
WORKDIR /data/suricata-${SURICATA_VER}
RUN ./configure && make && make install-conf

#RUN apt install -y software-properties-common && add-apt-repository ppa:oisf/suricata-stable && apt update && apt install -y suricata

