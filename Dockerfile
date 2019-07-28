FROM debian:stretch
MAINTAINER George Shammas <george@shamm.as>

ENV DEBIAN_FRONTENED=noninteractive
RUN \
  apt-get update && apt-get -y upgrade && \
  apt-get install -y gnupg procps apt-transport-https ca-certificates && \
  echo deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti >> /etc/apt/sources.list && \
  apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv 4A228B2D358A5094178285BE06E85760C0A52C50 && \
  echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main" >> /etc/apt/sources.list && \
  apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv 9DA31620334BD75D9DCB49F368818C72E52529D4 && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install --allow-unauthenticated -y default-jre-headless unifi


EXPOSE 8080 8081 8443 8843 8880
VOLUME ["/var/lib/unifi/data"]
WORKDIR /var/lib/unifi

ADD run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/bin/bash", "/run.sh"]

