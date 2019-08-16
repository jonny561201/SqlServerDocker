#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/variables


function sleepBeforeMigration {
    echo "----------Sleeping Before Migration----------"
    sleep 10
}

function dockerSqlCreateDatabase {
    echo "----------Creating PlanManagement Database----------"
    docker exec $SQL_DOCKER_NAME ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SQL_PASS -Q "CREATE DATABASE PlanManagement;"
}

function dockerFlywayMigration {
    DOCKER_VOLUME=$SCRIPT_DIR/docker/flyway/db/migration
    WINDOWS_VOLUME=$(echo $DOCKER_VOLUME | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')
    echo "----------Flyway Volume set to: $DOCKER_VOLUME"
    echo "----------Executing Flyway Migrations----------"
    docker run --net=host --rm -v /${WINDOWS_VOLUME}:/flyway/sql boxfuse/flyway:5.2.4 -url="jdbc:sqlserver://localhost:$SQL_PORT;databaseName=PlanManagement;" -user=$SQL_USER -password=$SQL_PASS migrate
}

function dockerCompose {
    echo "----------Starting Up Docker Container----------"
    docker run --name=$SQL_DOCKER_NAME -d=true -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Password123!' -e 'MSSQL_PID=Express' -p "$SQL_PORT:$SQL_PORT" $CONTAINER_NAME
}


dockerCompose
sleepBeforeMigration
dockerSqlCreateDatabase
dockerFlywayMigration