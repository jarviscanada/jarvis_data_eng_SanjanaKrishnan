#!/bin/bash

# This script controls a PostgreSQL Docker container (create, start, stop)

# Capture command-line arguments
cmd=$1
db_username=$2
db_password=$3

# Start Docker service if it's not running
sudo systemctl status docker || sudo systemctl start docker

# Check if the PostgreSQL container already exists
docker container inspect jrvs-psql > /dev/null 2>&1
container_status=$?

case $cmd in
  create)
    # If the container already exists, print message and exit
    if [ $container_status -eq 0 ]; then
      echo "Container already exists."
      exit 1
    fi

    # Check number of arguments
    if [ $# -ne 3 ]; then
      echo "Usage: ./psql_docker.sh create <db_username> <db_password>"
      exit 1
    fi

    # Create a Docker volume for PostgreSQL data persistence
    docker volume create pgdata

    # Create and run the PostgreSQL container
    docker run --name jrvs-psql \
      -e POSTGRES_USER=$db_username \
      -e POSTGRES_PASSWORD=$db_password \
      -d -v pgdata:/var/lib/postgresql/data \
      -p 5432:5432 postgres:9.6-alpine

    # Exit with the status of the last command
    exit $?
    ;;

  start|stop)
    # If container doesn't exist, show error and exit
    if [ $container_status -ne 0 ]; then
      echo "Container has not been created."
      exit 1
    fi

    # Start or stop the container depending on the command
    docker container $cmd jrvs-psql
    exit $?
    ;;

  *)
    # Invalid command handler
    echo "Illegal command."
    echo "Usage: ./psql_docker.sh {create|start|stop} [db_username] [db_password]"
    exit 1
    ;;
esac

