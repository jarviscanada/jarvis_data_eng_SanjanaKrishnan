#!/bin/bash

#Parse CLI arguments

psql_host=$1
psql_port=$2    
db_name=$3      
psql_user=$4    
psql_password=$5

#Validate number of arguments

if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters."
  echo "Usage: ./host_info.sh psql_host psql_port db_name psql_user psql_password"
  exit 1
fi

#Collecting hardware info

hostname=$(hostname -f)
lscpu_out=$(lscpu)

cpu_number=$(echo "$lscpu_out" | egrep "^CPU\(s\):" | awk '{print $2}' | xargs)
cpu_architecture=$(echo "$lscpu_out" | egrep "^Architecture:" | awk '{print $2}' | xargs)
cpu_model=$(echo "$lscpu_out" | egrep "^Model name:" | cut -d':' -f2 | xargs)
cpu_mhz=$(echo "$cpu_model" | awk -F'@ ' '{print $2}' | sed 's/GHz//' | awk '{printf "%.0f\n", $1 * 1000}')
l2_cache=$(echo "$lscpu_out" | egrep "^L2 cache:" | awk '{print $3}' | sed 's/K//' | xargs)
total_mem=$(free -k | awk '/Mem:/ {print $2}')
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

#SQL Statement

insert_stmt="INSERT INTO host_info(hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, L2_cache, total_mem, timestamp)
VALUES('$hostname', $cpu_number, '$cpu_architecture', '$cpu_model', $cpu_mhz, $l2_cache, $total_mem, '$timestamp');"

# Execute SQL command

export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?
