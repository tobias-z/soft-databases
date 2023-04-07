FROM mcr.microsoft.com/mssql/server:2022-latest

USER root
RUN /opt/mssql/bin/mssql-conf set sqlagent.enabled true
USER mssql

CMD /opt/mssql/bin/sqlservr
