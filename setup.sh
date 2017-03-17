#!/bin/sh

read -r -d '' DATABASE <<EOM
database: ${DATABASE-postgres}
postgres:
  host: "${POSTGRES_HOSTNAME-postgres}"
  port: ${POSTGRES_PORT-5432}
  database: ${POSTGRES_NAME-kong}
  user: ${POSTGRES_USER-kong}
  password: ${POSTGRES_PASSWORD-letmein} 
EOM

echo "$DATABASE" >> /etc/kong/kong.yml
