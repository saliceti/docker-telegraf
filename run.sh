#!/bin/bash
set -x

user_data=$(cat user-data.yml)
#user_data=$(curl -s http://169.254.169.254/latest/user-data/)

influxdb_url=$(echo -e "$user_data" | grep influxdb_url: | awk '{print $2}')
[[ -z "${influxdb_url}" ]] && exit 1
echo $influxdb_url

job_name=$(echo -e "$user_data" | grep job_name: | awk '{print $2}')
[[ -z "${job_name}" ]] && exit 1

sed -e "s@{{ influxdb_url }}@${influxdb_url}@" -e "s/{{ influxdb_database }}/influxdb/" -e "s/{{ influxdb_user }}/influxdb/" -e "s/{{ influxdb_pass }}/somepassword/" -e "s/{{ influxdb_tags }}/job_name = \"${job_name}\"/" -i /etc/opt/telegraf/telegraf.conf
[[ $? -ne 0 ]] && exit 1
cat /etc/opt/telegraf/telegraf.conf

# Remap all directories in /host
for dir in /host/*; do
	proot_args="$proot_args -b $dir:${dir##/host}" # ${dir##/host} => remove prefixed '/host' from $dir
done

proot $proot_args \
	/opt/telegraf/telegraf \
	-pidfile /var/run/telegraf/telegraf.pid \
	-config /etc/opt/telegraf/telegraf.conf $@
