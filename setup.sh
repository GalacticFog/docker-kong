#!/usr/local/bin/dumb-init /bin/sh
set -x

# Disabling nginx daemon mode
export KONG_NGINX_DAEMON="off"

read -r -d '' DATABASE <<EOM
database = ${DATABASE-postgres}
pg_host = ${POSTGRES_HOSTNAME-postgres}
pg_port = ${POSTGRES_PORT-5432}
pg_database = ${POSTGRES_NAME-kong}
pg_user = ${POSTGRES_USER-kong}
pg_password = ${POSTGRES_PASSWORD-letmein} 
pg_ssl = off
EOM

echo "$DATABASE" >> /etc/kong/kong.conf

__create_db() {

psql -h $POSTGRES_HOSTNAME -p $POSTGRES_PORT -U $POSTGRES_USER -v ON_ERROR_STOP=1 <<-EOSQL
    CREATE DATABASE "$POSTGRES_NAME";
    GRANT ALL PRIVILEGES ON DATABASE "$POSTGRES_NAME" TO "$POSTGRES_USER";
EOSQL
}

# create a .pgpass file which is used for psql
echo "$POSTGRES_HOSTNAME:$POSTGRES_PORT:*:$POSTGRES_USER:$POSTGRES_PASSWORD" >> ~/.pgpass
# this is necessary or the file will be ignored
chmod 0600 ~/.pgpass

# check that our database exists
psql -h $POSTGRES_HOSTNAME -p $POSTGRES_PORT -U $POSTGRES_USER -lqt | cut -d \| -f 1 | grep -qw $POSTGRES_NAME

if [[ "$?" -eq "0" ]]; then
   echo "database exists";
else
  echo "database does not exist, creating..."
  __create_db $POSTGRES_NAME
fi

# run the command that's passed in
exec "$@"
