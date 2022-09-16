FROM dapfeffer/networkanalysis:base

WORKDIR /data
ADD suricata.yaml /data/
#ADD https://rules.emergingthreats.net/open/suricata-5.0/emerging.rules.tar.gz /data/
#RUN tar xzvf emerging.rules.tar.gz
#ADD https://rules.emergingthreats.net/open/suricata-5.0/emerging-all.rules /data/
#ADD https://www.snort.org/downloads/community/community-rules.tar.gz /data/

# activate all the rules
#RUN sed 's/^#alert/alert/' emerging-all.rules > emerging-all-all.rules
#RUN sed 's/^#alert/alert/' emerging-all.rules | sed 's/.*ET DELETED .*//' | sed 's/.*GPL DELETED .*//' > all.rules
#RUN tar xzvf community-rules.tar.gz && cat community-rules/community.rules >> all.rules

# add custom rules
#ADD suricata-custom.rules /data/
#RUN cat /data/suricata-custom.rules >> all.rules

ADD all.rules.gpg /data/
ADD suricata.sh /data/
ADD zeek.sh /data/
ADD local.zeek /data/
RUN chmod a+x /data/suricata.sh /data/zeek.sh
RUN mkdir /output

#RUN apt install -y software-properties-common && add-apt-repository ppa:oisf/suricata-stable && apt update && apt install -y suricata

CMD /bin/bash
