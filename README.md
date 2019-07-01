# run a sql script from docker exec
    -- get ip address of docker images
    docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
    