# Sample MS SQL Server Project with Docker
    - Orchestrated setup of Sql Server Docker container
    - Created a sample project that starts up a base Sql Server docker image
    - Executes the creation of a Database against Sql Docker container
    - Runs Flyway migrations against Sql Server using Flyway Docker container
    
# Execute Project
    1. If Docker Desktop is not installed 
        - execute `do/all.sh` to download and install
    2. Using bash terminal execute createImage.sh
        - will create a new image of Sql Server with healthcheck
    3. Using bash terminal execute startContainer.sh 
        - will start container and execute flyway migration of any files in `docker/flyway/db/migration` directory

# run a sql script from docker exec
    -- get ip address of docker images
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
    