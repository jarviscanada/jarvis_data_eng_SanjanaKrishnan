## Linux Cluster Monitoring Agent

## Introduction

The Linux Cluster Monitoring Agent is a data collection and monitoring tool designed to centralize system information across multiple Linux servers. It captures hardware specifications and real-time resource usage data such as CPU, memory, and disk utilization, storing them in a PostgreSQL database for analysis.  

This project was created for the Jarvis Linux Cluster Administration (LCA) team to support resource management and capacity planning across their internal infrastructure. By automating data collection and persistence, it provides a lightweight monitoring solution that can scale with the cluster.  

The system is built using **Bash scripting**, **PostgreSQL**, and **Docker**, with **cron** automation for continuous data capture. Git and GitHub were used for source control, ensuring proper versioning and collaboration practices consistent with DevOps workflows.

## Quick Start

Follow these steps to set up the Linux Cluster Monitoring Agent on your local machine. All commands assume you are in the root directory of the project.

```bash
# 1. Start a PostgreSQL instance using Docker
bash psql_docker.sh create postgres password

# 2. Create the database and tables
psql -h localhost -U postgres -W

# Inside the psql shell:
CREATE DATABASE host_agent;
\q
psql -h localhost -U postgres -d host_agent -f sql/ddl.sql

# 3. Insert static host hardware information (run once per host)
bash scripts/host_info.sh localhost 5432 host_agent postgres password

# 4 Insert real-time host usage data (run once to test)
bash scripts/host_usage.sh localhost 5432 host_agent postgres password

# 5. Automate periodic host usage collection using crontab
crontab -e
# Add the following line to collect usage every minute:
* * * * * bash /home/rocky/dev/jarvis_data_eng_SanjanaKrishnan/linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password &> /tmp/host_usage.log

```

## Implmentation

The Linux Cluster Monitoring Agent is designed to **collect, centralize, and store both static and dynamic metrics** from Linux hosts into a PostgreSQL database. The system is fully automated, lightweight, and built for scalability across multiple servers.

The core idea is to separate **static host information** from **live usage metrics**:

- **Static information** (CPU, memory, architecture, cache) is collected once per host using `host_info.sh`.
- **Dynamic metrics** (CPU idle, CPU kernel, free memory, disk I/O, disk space) are collected every minute using `host_usage.sh`.

Data flows from each host to a centralized PostgreSQL database running in a Docker container. This approach allows administrators or DevOps teams to monitor hardware and usage trends in real time, across a distributed environment.

The project leverages the following technologies:

- **Bash scripting**  for lightweight data collection and automation.
- **PostgreSQL**  centralized storage for all collected metrics.
- **Docker**  isolates and manages the database environment.
- **Crontab**  schedules automated periodic collection of usage metrics.
- **Unix commands**  `vmstat`, `lscpu`, `df`, and `free` are used to extract system information.

## Architecture 

The system architecture is designed to be clear and modular:

1. **Three Linux Hosts**  each host runs the monitoring scripts:
   - `host_info.sh` collects hardware specifications and inserts them into the `host_info` table.
   - `host_usage.sh` collects live system metrics and inserts them into the `host_usage` table every minute.
2. **PostgreSQL Docker Container**  acts as a centralized database storing all host metrics.
3. **Crontab Scheduler**  automates the execution of `host_usage.sh` on each host.

All metrics are timestamped in UTC to ensure consistent historical tracking, and host IDs link usage metrics to the corresponding host information.

A cluster diagram illustrating this architecture is created in `assets/cluster_diagram.png` using draw.io, showing the three hosts, the PostgreSQL DB, and the flow of data.

## Scripts 

1. psql_docker.sh - Manages the PostgreSQL Docker container.

# Create a PostgreSQL container
```bash 
scripts/psql_docker.sh create postgres password
```

# Start the PostgreSQL container
```bash 
scripts/psql_docker.sh start
```
# Stop the PostgreSQL container
```bash 
scripts/psql_docker.sh stop
```
2. host_info.sh - Collects static hardware information from the host and inserts it into the host_info table.

```bash 
scripts/host_info.sh localhost 5432 host_agent postgres password
```
3. host_usage.sh - Collects dynamic system metrics every minute and inserts them into the host_usage table.

```bash 
scripts/host_usage.sh localhost 5432 host_agent postgres password
```
4. Crontab - Automates execution of host_usage.sh for continuous metric collection.

```bash
crontab -e
```

# Add the following line to run the script every minute
* * * * * bash /home/rocky/dev/jarvis_data_eng_SanjanaKrishnan/linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password &> /tmp/host_usage.log

## Database Modeling

The project uses two tables to organize host data: `host_info` for static hardware specs and `host_usage` for dynamic resource metrics.

### host_info

| Column Name      | Data Type   | Description                           |
| ---------------- | ----------- | ------------------------------------- |
| id               | SERIAL (PK) | Unique identifier for each host       |
| hostname         | VARCHAR     | Fully-qualified host machine name     |
| cpu_number       | INT         | Number of CPU cores                   |
| cpu_architecture | VARCHAR     | CPU architecture type (x86_64, etc.) |
| cpu_model        | VARCHAR     | CPU model name                        |
| cpu_mhz          | INT         | CPU speed in MHz                       |
| l2_cache         | INT         | L2 cache size in KB                   |
| total_mem        | BIGINT      | Total system memory in KB             |
| timestamp        | TIMESTAMP   | Time of data collection               |

### host_usage

| Column Name    | Data Type   | Description                                      |
| -------------- | ----------- | ------------------------------------------------ |
| timestamp      | TIMESTAMP   | Time when the usage metrics were collected      |
| host_id        | INT (FK)    | References `host_info.id`                        |
| memory_free    | BIGINT      | Available memory in MB                           |
| cpu_idle       | INT         | CPU idle percentage                              |
| cpu_kernel     | INT         | CPU kernel percentage                            |
| disk_io        | INT         | Disk I/O utilization                             |
| disk_available | BIGINT      | Available disk space in MB                       |

## Test

To ensure that the scripts and database schema are working correctly, the following checks were performed:

1. Verify PostgreSQL container is running

```bash
docker ps
```

2. Check database tables

```bash
psql -h localhost -U postgres -d host_agent -c "\dt"
```

3. Validate inserted host info data

```bash 
psql -h localhost -U postgres -d host_agent -c "SELECT * FROM host_info;"
```

4. Validate inserted host usage data

```bash
psql -h localhost -U postgres -d host_agent -c "SELECT * FROM host_usage LIMIT 5;"
```

## Deployment

## Test

1. **Verify PostgreSQL container is running**
```bash
docker ps
```

2. **Check database tables**
```bash 
psql -h localhost -U postgres -d host_agent -c "\dt"
```

3. **Validate data in host_info and host_data tables**
```bash
psql -h localhost -U postgres -d host_agent -c "SELECT * FROM host_info;"
psql -h localhost -U postgres -d host_agent -c "SELECT * FROM host_usage LIMIT 5;"
```

4. **Crontab verification**
```bash
crontab -l
* * * * * bash /home/rocky/dev/jarvis_data_eng_SanjanaKrishnan/linux_sql/scripts/host_usage.sh localhost 5432 host_agent postgres password &> /tmp/host_usage.log
```

## Improvements

1. **Dynamic Hardware Updates**  
   - Enhance `host_info.sh` to detect and update hardware changes automatically, such as CPU or memory upgrades, without manual re-insertion.

2. **Monitoring Dashboard**  
   - Integrate a visualization layer using Grafana or Tableau to provide real-time metrics and trends for multiple hosts in a user-friendly dashboard.

3. **Error Handling and Logging**  
   - Improve the Bash scripts to include detailed logging and retry mechanisms, ensuring reliable data collection even if the database is temporarily unavailable.

4. **Scalability Enhancements**  
   - Refactor the architecture to allow agents to send data to a central API service instead of directly writing to the database, supporting larger clusters and a microservices approach.

5. **Security Improvements**  
   - Secure database credentials by using environment variables or a secrets manager instead of passing them directly in the scripts.
 
