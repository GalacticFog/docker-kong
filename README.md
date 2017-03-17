# Kong in Docker

A fork of [mashape/kong][docker-kong], with a bias towards postgres and better support for configuring the database configuration.

# Supported tags and respective `Dockerfile` links

- `0.8.0` - *([Dockerfile](https://github.com/galacticfog/docker-kong/blob/0.8.0/Dockerfile))*

# How to use this image


```shell
$ docker run -d --name kong \
    -e "POSTGRES_HOSTNAME=postgres" \
    -e "POSTGRES_PORT=5432" \
    -e "POSTGRES_NAME=kong" \
    -e "POSTGRES_USER=kong" \
    -e "POSTGRES_PASS=letmein" \
    -p 8000:8000 \
    -p 8443:8443 \
    -p 8001:8001 \
    -p 7946:7946 \
    -p 7946:7946/udp \
    --security-opt seccomp:unconfined \
    mashape/kong
```

**Note:** If Docker complains that `--security-opt` is an invalid option, just remove it and re-execute the command (it was introduced in Docker 1.3).

If everything went well, and if you created your container with the default ports, Kong should be listening on your host's `8000` ([proxy][kong-docs-proxy-port]), `8443` ([proxy SSL][kong-docs-proxy-ssl-port]) and `8001` ([admin api][kong-docs-admin-api-port]) ports. Port `7946` ([cluster][kong-docs-cluster-port]) is being used only by other Kong nodes.

You can now read the docs at [getkong.org/docs][kong-docs-url] to learn more about Kong.

[docker-kong]: https://github.com/Mashape/docker-kong
