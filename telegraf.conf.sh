#!/bin/bash

cat <<EOF

# Telegraf configuration

# Telegraf is entirely plugin driven. All metrics are gathered from the
# declared plugins.

# Even if a plugin has no configuration, it must be declared in here
# to be active. Declaring a plugin means just specifying the name
# as a section with no variables. To deactivate a plugin, comment
# out the name and any variables.

# Use 'telegraf -config telegraf.toml -test' to see what metrics a config
# file would generate.

# One rule that plugins conform to is wherever a connection string
# can be passed, the values '' and 'localhost' are treated specially.
# They indicate to the plugin to use their own builtin configuration to
# connect to the local system.

# NOTE: The configuration has a few required parameters. They are marked
# with 'required'. Be sure to edit those to make this configuration work.

# Tags can also be specified via a normal map, but only one form at a time:
[tags]
$(echo ${TELEGRAF_INFLUX_TAGS:-} | tr : '\n')

# Configuration for telegraf agent
[agent]
  # Default data collection interval for all plugins
  interval = "10s"
  # Rounds collection interval to 'interval'
  # ie, if interval="10s" then always collect on :00, :10, :20, etc.
  round_interval = true

  # Default data flushing interval for all outputs
  flush_interval = "10s"
  # Jitter the flush interval by a random range
  # ie, a jitter of 5s and interval 10s means flush will happen every 10-15s
  flush_jitter = "5s"
  # Number of times to retry each data flush
  flush_retries = 2

  # Run telegraf in debug mode
  debug = false
  # Override default hostname, if empty use os.Hostname()
  hostname = ""


###############################################################################
#                                  OUTPUTS                                    #
###############################################################################

[outputs]

# Configuration for influxdb server to send metrics to
[outputs.influxdb]
  # The full HTTP endpoint URL for your InfluxDB instance
  # Multiple urls can be specified for InfluxDB cluster support. Server to
  # write to will be randomly chosen each interval.
  urls = ["${TELEGRAF_INFLUX_DB_URL}"] # required.
  # The target database for metrics. This database must already exist
  database = "${TELEGRAF_INFLUX_DB_NAME}"
  # Precision of writes, valid values are n, u, ms, s, m, and h
  # note: using second precision greatly helps InfluxDB compression
  precision = "s"

  # Connection timeout (for the connection with InfluxDB), formatted as a string.
  # Valid time units are "ns", "us" (or "µs"), "ms", "s", "m", "h".
  # If not provided, will default to 0 (no timeout)
  # timeout = "5s"
  username = "${TELEGRAF_INFLUX_DB_USER_NAME}"
  password = "${TELEGRAF_INFLUX_DB_PASSWORD}"

  # Set the user agent for the POSTs (can be useful for log differentiation)
  # user_agent = "telegraf"


###############################################################################
#                                  PLUGINS                                    #
###############################################################################

# Read metrics about cpu usage
[cpu]
  # Whether to report per-cpu stats or not
  percpu = true
  # Whether to report total system cpu stats or not
  totalcpu = true
  # Comment this line if you want the raw CPU time metrics
  drop = ["cpu_time"]

# Read metrics about disk usage by mount point
[disk]

# Read metrics about disk IO by device
[io]
  # no configuration

# Read metrics about memory usage
[mem]
  # no configuration

# Read metrics about swap memory usage
[swap]
  # no configuration

# Read metrics about system load & uptime
[system]
  # no configuration
EOF
