FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu

HEALTHCHECK --interval=5s --start-period=3s CMD ./opt/mssql-tools/bin/sqlcmd -S localhost -U sa -P Password123! -Q "SELECT 1;" || exit 1