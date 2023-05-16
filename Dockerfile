FROM postgres:12-alpine

WORKDIR /scripts

COPY scripts/setup_user.sql /scripts

COPY scripts/salesdb /scripts/salesdb
RUN cat /scripts/salesdb/*.sql > /tmp/sales.sql

RUN echo "psql -U postgres -f /tmp/sales.sql" > /docker-entrypoint-initdb.d/salesdb.sh
RUN echo "psql -d salesdb -U postgres -f /scripts/setup_user.sql" >> /docker-entrypoint-initdb.d/salesdb.sh

ADD scripts/flightsdb/flightsdb.tar.xz /tmp/

RUN echo "createdb flightsdb" >> /docker-entrypoint-initdb.d/salesdb.sh
RUN echo "psql -d flightsdb -U postgres -f /tmp/flightsdb.sql" >> /docker-entrypoint-initdb.d/salesdb.sh
RUN echo "psql -d flightsdb -U postgres -f /scripts/setup_user.sql" >> /docker-entrypoint-initdb.d/salesdb.sh
