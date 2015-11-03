#!/bin/bash
set -x

# Render configuration
/telegraf.conf.sh > /etc/opt/telegraf/telegraf.conf

# Remap all directories in /host
for dir in /host/*; do
	proot_args="$proot_args -b $dir:${dir##/host}" # ${dir##/host} => remove prefixed '/host' from $dir
done

proot $proot_args \
	/opt/telegraf/telegraf \
	-pidfile /var/run/telegraf/telegraf.pid \
	-config /etc/opt/telegraf/telegraf.conf $@
