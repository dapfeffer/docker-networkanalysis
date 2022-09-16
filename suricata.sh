#!/bin/bash
if [[ ! -e /data/all.rules ]]; then
    gpg -d --output /data/all.rules /data/all.rules.gpg
fi
suricata -c /data/suricata.yaml -S /data/all.rules -l /output -r $@