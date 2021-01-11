# docker-networkanalysis
## Build image
Image should be build locally by typing the command
```
make build
```

## Usage
Enter container by typing

```
docker run -it -v /local-evidence-folder/:/data/input -v /local-output-folder/:/data/output dapfeffer/networkanalysis:latest
```

Inside the container you can use tools like zeek or suricata to analyze pcap-data. Additionaly, tools like tcpdump and tshark are installed.
