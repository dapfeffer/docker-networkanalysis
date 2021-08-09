ARG UBUNTU_VER=20.04

FROM ubuntu:$UBUNTU_VER

RUN echo "Etc/UTC" > /etc/timezone
RUN apt update && apt -y install tzdata && dpkg-reconfigure --frontend noninteractive tzdata && apt -y upgrade && apt -y install zsh git cmake make gcc g++ flex bison libpcap-dev libssl-dev python3-dev python-dev swig zlib1g-dev libmaxminddb-dev fd-find libpcre3 libpcre3-dbg libpcre3-dev build-essential autoconf automake libtool libpcap-dev libnet1-dev libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 libmagic-dev libjansson-dev libjansson4 pkg-config libgoogle-perftools-dev google-perftools libjemalloc-dev libkrb5-dev rustc cargo calamaris p7zip-full vim jq
RUN DEBIAN_FRONTEND=noninteractive apt install -y tcpdump tshark
RUN apt clean
WORKDIR /data/src
ARG ZEEK_VER=4.0.3
ADD https://download.zeek.org/zeek-${ZEEK_VER}.tar.gz /data/src/
RUN tar xzvf zeek-${ZEEK_VER}.tar.gz
WORKDIR /data/src/zeek-${ZEEK_VER}
#ADD https://github.com/zeek/zeek/archive/release.tar.gz /data/src/
#RUN tar xzvf release.tar.gz
#WORKDIR /data/src/zeek-release
RUN ./configure; make; make install
COPY local.zeek /usr/local/zeek/share/zeek/site/local.zeek
ENV PATH "$PATH:/usr/local/zeek/bin"
WORKDIR /data/src
RUN chsh -s /bin/zsh

ARG SURICATA_VER=6.0.3
ADD https://www.openinfosecfoundation.org/download/suricata-${SURICATA_VER}.tar.gz /data/src/
RUN tar xzvf suricata-${SURICATA_VER}.tar.gz
WORKDIR /data/src/suricata-${SURICATA_VER}
RUN ./configure && make && make install && make install-conf && ldconfig

WORKDIR /data
ADD suricata.yaml /data/
#ADD https://rules.emergingthreats.net/open/suricata-5.0/emerging.rules.tar.gz /data/
#RUN tar xzvf emerging.rules.tar.gz
ADD https://rules.emergingthreats.net/open/suricata-5.0/emerging-all.rules /data/
ADD https://www.snort.org/downloads/community/community-rules.tar.gz /data/

# activate all the rules
#RUN sed 's/^#alert/alert/' emerging-all.rules > emerging-all-all.rules
RUN sed 's/^#alert/alert/' emerging-all.rules | sed 's/.*ET DELETED .*//' | sed 's/.*GPL DELETED .*//' > all.rules
RUN tar xzvf community-rules.tar.gz && cat community-rules/community.rules >> all.rules

# add custom rules
ADD suricata-custom.rules /data/
RUN cat /data/suricata-custom.rules >> all.rules

#RUN apt install -y software-properties-common && add-apt-repository ppa:oisf/suricata-stable && apt update && apt install -y suricata

CMD /bin/bash
