#!/bin/bash

SQL_PASS=Password123!
SQL_USER=sa
SQL_DOCKER_NAME="msSql-test"
SQL_PORT=1433


function sleepBeforeMigration {
    echo "-----Sleeping Before Migration-----"
    sleep 12
}

function dockerMigration {
    echo "-----Migrating Docker Images-----"
    docker exec $SQL_DOCKER_NAME ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P $SQL_PASS -Q "CREATE DATABASE PlanManagement;"
#    docker run -i msSql-flyway -url="jdbc:sqlserver://$SQL_DOCKER_NAME:$SQL_PORT;instanceName=SQLEXPRESS;databaseName=PlanManagement;" -locations="filesystem:/var/flyway" -user=$SQL_USER -password=$SQL_PASS -connectRetries=10 migrate
    docker run --net mssqlservertest_default --rm -v C:\\Users\\g825714\\MyProjects\\MsSqlServerTest\\docker\\flyway\\db\\migration:/flyway/sql boxfuse/flyway:5.2.4 -url="jdbc:sqlserver://$SQL_DOCKER_NAME:$SQL_PORT;databaseName=PlanManagement;" -user=$SQL_USER -password=$SQL_PASS migrate
}

function dockerCompose {
    echo "-----Starting Up Docker Images-----"
#    docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SQL_PASS" -e "MSSQL_PID=Express" --name $SQL_DOCKER_NAME -p $SQL_PORT:$SQL_PORT -d mcr.microsoft.com/mssql/server:2017-latest-ubuntu
    docker-compose up -d
}

dockerCompose
sleepBeforeMigration
dockerMigration
