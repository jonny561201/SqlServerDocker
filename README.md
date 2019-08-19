# Intent
    The Goal of the project is to simplify the creation of a sql server docker container with a healthcheck.
    The project incorporates Flyway as a mechanism to perform versioned database migrations.
    Additionally Flyway allows for population of test data for use on delivery teams looking for a simple base project.
    All versioned sql scripts can be placed in the `docker/flyway/db/migration/` folder.

# Sample MS SQL Server Docker Project
    - Orchestrated setup of Sql Server Docker container
    - Sample project that starts up a base Sql Server docker image
    - Executes the creation of a Database against Sql Docker container
    - Runs Flyway migrations against Sql Server using Flyway Docker container
    
# Execute Project
    1. If Docker Desktop is not installed 
        - execute `do/all.sh` to download and install
        - will be prompted for windows or linux containers (choose linux)
            - sorry, but there is currently no quiet install for docker :(
    2. Using bash terminal execute createImage.sh
        - will create a new image of Sql Server with healthcheck
    3. Using bash terminal execute startContainer.sh 
        - will start container and execute flyway migration of any files in `docker/flyway/db/migration` directory
