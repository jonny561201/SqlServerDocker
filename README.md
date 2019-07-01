#Sample SQL Server Project with Docker
    - Orchestrated setup of Sql Server Docker container
    - Created a sample project that starts up a base Sql Server docker image
    - Executes the creation of a Database against Sql Docker container
    - Runs Flyway migrations against Sql Server using Flyway Docker container
    
# Execute Project
    Using bash terminal execute test.sh file

# run a sql script from docker exec
    -- get ip address of docker images
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
    