FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu

HEALTHCHECK CMD ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Password123! -Q "SELECT 1;" || exit 1