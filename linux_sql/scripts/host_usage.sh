#!/bin/bash

# Parse CLI arguments

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Validate number of arguments

if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters."
  echo "Usage: ./host_usage.sh psql_host psql_port db_name psql_user psql_password"
  exit 1
fi

# Usage data

hostname=$(hostname -f)
vmstat_out=$(vmstat --unit M)

# Extract metrics 

memory_free=$(echo "$vmstat_out" | tail -1 | awk '{print $4}')
cpu_idle=$(echo "$vmstat_out" | tail -1 | awk '{print $15}')
cpu_kernel=$(echo "$vmstat_out" | tail -1 | awk '{print $14}')
disk_io=$(vmstat -d | tail -1 | awk '{print $10}')
disk_available=$(df -BM / | tail -1 | awk '{print $4}' | sed 's/M//')
timestamp=$(date -u '+%Y-%m-%d %H:%M:%S')

# SQL insert command

host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"

insert_stmt="INSERT INTO host_usage (timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES ('$timestamp', $host_id, $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"


# Execute SQL command

export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?
