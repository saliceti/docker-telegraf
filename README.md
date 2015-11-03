Telegraf as a docker container
==============================

This container allows monitor a docker host, like a CoreOS system,
using telegraf.

It runs as a priviliged container, and with the system directories
`/proc/`, `/dev` and `/sys` map in the directory `/host` of the container.

Instead of patching telegraf to use the new path to gather variables,
the use [`proot`](http://proot.me/) to remap the file reads.

How to build and run
--------------------

Build it:
```
docker build -t 'telegraf' .
```

Run it:

```
docker run \
    -v /proc:/host/proc \
    -v /sys:/host/sys \
    -v /dev:/host/dev \
    -e TELEGRAF_INFLUX_DB_URL=http://influxdb.domain.com:1234 \
    -e TELEGRAF_INFLUX_DB_NAME=grafana \
    -e TELEGRAF_INFLUX_DB_USER_NAME=influx \
    -e TELEGRAF_INFLUX_DB_PASSWORD=password \
    telegraf
```

Known issues
------------

The disk plugin does not work, it fails saying that `/etc/mtab` is missing
(but it is present). Also, we don't map the volumes. Because that
it is disabled:

```
* Plugin: disk
2015/11/03 16:21:28 error getting disk usage info: open /etc/mtab: no such file or directory

```
