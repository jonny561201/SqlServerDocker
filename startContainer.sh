#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source ${SCRIPT_DIR}/variables


function waitForHealthyContainer {
    if [[ "$(docker inspect -f='{{.State.Status}}' ${SQL_DOCKER_NAME})" = "exited" ]] ; then
        echo -e "${RED}ERROR: Docker container exited prematurely!!!"
        exit 1
    fi
    until [[ "$(docker inspect -f='{{.State.Health.Status}}' ${SQL_DOCKER_NAME})" = "healthy" ]]; do
        echo "...waiting for container to become healthy..."
        sleep 1
    done
    echo -e "${GREEN}Container is healthy!${WHITE}"
}

function dockerSqlCreateDatabase {
    echo -e "${YELLOW}----------Creating $DB_NAME Database----------${WHITE}"
    docker exec ${SQL_DOCKER_NAME} ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P ${SQL_PASS} -Q "CREATE DATABASE $DB_NAME;"
}

function dockerFlywayMigration {
    DOCKER_VOLUME=${SCRIPT_DIR}/docker/flyway/db/migration
    WINDOWS_VOLUME=$(echo ${DOCKER_VOLUME} | sed -e 's/^\///' -e 's/\//\\/g' -e 's/^./\0:/')
    echo -e "${YELLOW}----------Flyway Volume set to: $DOCKER_VOLUME${WHITE}"
    echo -e "${YELLOW}----------Executing Flyway Migrations----------${WHITE}"
    docker run --net=host --rm -v /${WINDOWS_VOLUME}:/flyway/sql boxfuse/flyway:5.2.4 -url="jdbc:sqlserver://localhost:$SQL_PORT;databaseName=$DB_NAME;" -user=${SQL_USER} -password=${SQL_PASS} migrate
}

function startDockerContainer {
    echo -e "${YELLOW}----------Starting Up Docker Container----------${WHITE}"
    docker run --name=${SQL_DOCKER_NAME} -d=true -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=Password123!' -e 'MSSQL_PID=Express' -p "$SQL_PORT:$SQL_PORT" ${CONTAINER_NAME}
}

function deleteExistingContainer {
    if [[ ! -z $(docker ps -a -q -f "name=$SQL_DOCKER_NAME") ]] ; then
        echo -e "${YELLOW}----------Deleting Exiting Container----------${WHITE}"
        docker rm -f "$SQL_DOCKER_NAME"
    fi
}

function validateImageExists {
    echo -e "${YELLOW}----------Validating Docker Image----------${WHITE}"
    IMAGE_STATE=$(docker images -q ${CONTAINER_NAME})
    if [[ -z "$IMAGE_STATE" ]] ; then
        echo -e "${RED}ERROR: Please execute script file to create container!!!"
        exit 1
    fi
}


deleteExistingContainer
validateImageExists
startDockerContainer
waitForHealthyContainer
dockerSqlCreateDatabase
dockerFlywayMigration