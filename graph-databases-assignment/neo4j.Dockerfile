FROM neo4j:latest
USER neo4j
COPY documents/web-Stanford.csv.tar.gz /var/lib/neo4j/import/web-Stanford.csv.tar.gz
RUN cd /var/lib/neo4j/import && tar -xf web-Stanford.csv.tar.gz
