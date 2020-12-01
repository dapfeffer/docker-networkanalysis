FROM ubuntu:20.04

RUN echo "UTC" > /etc/timezone
RUN apt update && apt -y install tzdata && dpkg-reconfigure --frontend noninteractive tzdata && apt -y upgrade && apt -y install zsh git cmake make gcc g++ flex bison libpcap-dev libssl-dev python-dev swig zlib1g-dev libmaxminddb-dev fd-find
WORKDIR /data
ADD https://download.zeek.org/zeek-3.2.2.tar.gz /data/
RUN tar xzvf zeek-3.2.2.tar.gz
WORKDIR zeek-3.2.2
RUN ./configure; make; make install
ENV PATH "$PATH:/usr/local/zeek/bin"
RUN rm -rvf /data/zeek*
