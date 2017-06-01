FROM centos:7
MAINTAINER Brad Futch, brad@galacticfog.com

ENV KONG_VERSION 0.10.3

RUN yum install -y epel-release
RUN yum install -y wget https://github.com/Mashape/kong/releases/download/$KONG_VERSION/kong-$KONG_VERSION.el7.noarch.rpm && \
    yum clean all
RUN yum install -y postgresql-server postgresql-contrib

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.1.3/dumb-init_1.1.3_amd64 && \
    chmod +x /usr/local/bin/dumb-init

VOLUME ["/etc/kong/"]

COPY config.docker/kong.yml /etc/kong/kong.yml

ADD setup.sh setup.sh
RUN chmod +x setup.sh

ENTRYPOINT ["./setup.sh"]

EXPOSE 8000 8443 8001 7946
CMD ["kong", "start"]
