FROM centos:7
MAINTAINER Anthony Skipper, anthony@galacticfog.com

ENV KONG_VERSION 0.10.3

RUN yum install -y epel-release
RUN yum install -y wget https://github.com/Mashape/kong/releases/download/$KONG_VERSION/kong-$KONG_VERSION.el7.noarch.rpm && \
    yum clean all
RUN yum install -y postgresql-server postgresql-contrib

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init

VOLUME ["/etc/kong/"]

# TODO: This file doesn't seem to be used anymore
# COPY config.docker/kong.yml /etc/kong/kong.yml

# Overrite the nginx_kong.lua Kong uses to generate the /usr/local/kong/nginx-kong.conf file
COPY config.docker/nginx_kong.lua /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua

ADD setup.sh setup.sh
RUN chmod +x setup.sh

RUN yum install -y tar && yum clean all
RUN mkdir -p /usr/local/custom
RUN chmod +rwx /usr/local/custom
COPY gestalt-security-kong.tar /usr/local/custom/gestalt-security-kong.tar
RUN cd /usr/local/custom && chmod +rx gestalt-security-kong.tar && tar xvf ./gestalt-security-kong.tar
RUN yum upgrade -y

ENTRYPOINT ["./setup.sh"]

EXPOSE 8000 8443 8001 7946
CMD ["kong", "start"]
