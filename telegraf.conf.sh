#!/bin/bash

set -e

if [ ! -z "${TELEGRAF_INFLUX_DB_URL:-}" ]; then
  cat <<EOF
[influxdb]
# The full HTTP endpoint URL for your InfluxDB instance
url = "${TELEGRAF_INFLUX_DB_URL}" # required.

# The target database for metrics. This database must already exist
database = "${TELEGRAF_INFLUX_DB_NAME}"

username = "${TELEGRAF_INFLUX_DB_USER_NAME}"
password = "${TELEGRAF_INFLUX_DB_PASSWORD}"

# Set the user agent for the POSTs (can be useful for log differentiation)
# user_agent = "telegraf"
# tags = { "dc": "us-east-1" }

# Tags can also be specified via a normal map, but only one form at a time:
EOF
fi

cat <<EOF
[influxdb.tags]
EOF
echo ${TELEGRAF_INFLUX_TAGS:-} | tr : '\n'

cat <<EOF
# [agent]
# interval = "10s"
# debug = false
# hostname = "prod3241"

# PLUGINS

# Read metrics about cpu usage
[cpu]
  # no configuration

# Read metrics about disk usage by mount point
EOF

#if [ -f "/etc/mtab" ]; then
#  cat <<EOF
#[disk]
#  # no configuration
#EOF
#fi

cat <<EOF
# Read metrics about docker containers
[docker]
  # no configuration

# Read metrics about disk IO by device
[io]
  # no configuration

# Read metrics about memory usage
[mem]
  # no configuration
EOF

if [ ! -z "$MEMCACHE" ]; then
  cat <<EOF
# Read metrics from one or many memcached servers
[memcached]

EOF
fi

# An array of address to gather stats about. Specify an ip on hostname
# with optional port. ie localhost, 10.0.0.1:11211, etc.
#
# If no servers are specified, then localhost is used as the host.
servers = ["localhost"]

# Read metrics from one or many mysql servers
[mysql]

# specify servers via a url matching:
#  [username[:password]@][protocol[(address)]]/[?tls=[true|false|skip-verify]]
#  e.g. root:root@http://10.0.0.18/?tls=false
#
# If no servers are specified, then localhost is used as the host.
servers = ["localhost"]

# Read metrics about network interface usage
[net]

# By default, telegraf gathers stats from any up interface (excluding loopback)
# Setting interfaces will tell it to gather these explicit interfaces,
# regardless of status.
#
# interfaces = ["eth0", ... ]

# Read metrics from one or many postgresql servers
[postgresql]

# specify servers via an array of tables
[[postgresql.servers]]

# specify address via a url matching:
#   postgres://[pqgotest[:password]]@localhost?sslmode=[disable|verify-ca|verify-full]
# or a simple string:
#   host=localhost user=pqotest password=... sslmode=...
#
# All connection parameters are optional. By default, the host is localhost
# and the user is the currently running user. For localhost, we default
# to sslmode=disable as well.
#

address = "sslmode=disable"

# A list of databases to pull metrics about. If not specified, metrics for all
# databases are gathered.

# databases = ["app_production", "blah_testing"]

# [[postgresql.servers]]
# address = "influx@remoteserver"

# Read metrics from one or many redis servers
[redis]

# An array of URI to gather stats about. Specify an ip or hostname
# with optional port add password. ie redis://localhost, redis://10.10.3.33:18832,
# 10.0.0.1:10000, etc.
#
# If no servers are specified, then localhost is used as the host.
servers = ["localhost"]

# Read metrics about swap memory usage
[swap]
  # no configuration

# Read metrics about system load
[system]
  # no configuration
EOF
