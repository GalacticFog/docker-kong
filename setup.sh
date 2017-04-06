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

__create_db() {

psql -h $POSTGRES_HOSTNAME -p $POSTGRES_PORT -U $POSTGRES_USER -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE DATABASE "$POSTGRES_NAME";
    GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_NAME" TO "$POSTGRES_USER";
EOSQL
}

# create a .pgpass file which is used for psql
echo "$POSTGRES_HOSTNAME:$POSTGRES_PORT:*:$POSTGRES_USER:$POSTGRES_PASSWORD \n" >> ~/.pgpass

# check that our database exists
psql -h $POSTGRES_HOSTNAME -p $POSTGRES_PORT -U $POSTGRES_USER -lqt | cut -d \| -f 1 | grep -qw $POSTGRES_NAME

if [[ "$?" -eq "0" ]]; then
   echo "database exists";
else
  echo "database does not exist, creating..."
  __create_db $POSTGRES_NAME
fi
