#!/bin/bash

SQL_PASS=Password123!
SQL_USER=sa
SQL_DOCKER_NAME="MsSqlTest"
SQL_PORT=1433
PRESENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


function sleepBeforeMigration {
    echo "----------Sleeping Before Migration----------"
    sleep 12
}

function dockerMigration {
    echo "----------Creating PlanManagement Database----------"
    docker exec $SQL_DOCKER_NAME ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SQL_PASS -Q "CREATE DATABASE PlanManagement;"

    DOCKER_VOLUME="$PRESENT_DIR\\docker\\flyway\\db\\migration"
    echo "----------Flyway Volume set to: $DOCKER_VOLUME"
    echo "----------Executing Flyway Migrations----------"
    docker run --net mssqlservertest_default --rm -v /${DOCKER_VOLUME}:/flyway/sql boxfuse/flyway:5.2.4 -url="jdbc:sqlserver://$SQL_DOCKER_NAME:$SQL_PORT;databaseName=PlanManagement;" -user=$SQL_USER -password=$SQL_PASS migrate
}

function dockerCompose {
    echo "----------Starting Up Docker Images----------"
    docker-compose up -d
}


dockerCompose
sleepBeforeMigration
dockerMigration
