# run a sql script from docker exec
    -- command to execute sql commands
    docker exec -it msSql-test ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Password123! -Q "CREATE DATABASE PlanManagement;"
    
    -- get ip address of docker images
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
    
    -- manually run flyway docker image using ip address
    docker run mssqlservertest_flyway -url="jdbc:sqlserver://172.24.0.2:1433;instanceName=SQLEXPRESS;databaseName=PlanManagement;" -locations=filesystem:/var/flyway -user=sa -password=Password123! migrate