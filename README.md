# IDS tool SNORT on a docker : docker-snort

#### [Snort](https://www.snort.org/) in Docker for Network Functions Virtualization (NFV)

The Snort Version 2.9.17 and DAQ Version 2.0.7

# Docker Usage
Ensure containers network for snort to access container traffic.
```
$ cd docker-snort
$ docker build -t docker-snort .
$ docker run -it --rm --net=host docker-snort bash
```
```
$ docker run -it --rm --net=host docker-snort snort -i eth0 -c /etc/snort/etc/snort.conf -A console
```

# Snort Usage

A basic rule for testing. Add this rule in the file at `/mysnortrules/rules/local.rules`

```
alert icmp any any -> any any (msg:"Pinging...";sid:1000004;)
```

Running Snort and alerts output to the console (screen).

```
$ snort -i eth0 -c /etc/snort/etc/snort.conf -A console
```

Running Snort and alerts output to the UNIX socket

```
$ snort -i eth0 -A unsock -l /tmp -c /etc/snort/etc/snort.conf
```

Ping in the container then the alert message will show on the console

```
ping 8.8.8.8
```
