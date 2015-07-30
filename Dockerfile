FROM debian:latest
MAINTAINER George Shammas <george@shamm.as>

ENV DEBIAN_FRONTENcD=noninteractive
RUN echo deb http://www.ubnt.com/downloads/unifi/debian unifi4 ubiquiti >> /etc/apt/sources.list && \
  echo deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen >> /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install openjdk-7-jre-headless unifi -y
  
EXPOSE 8080 8081 8443 8843 8880
VOLUME ["/var/lib/unifi/data"]
WORKDIR /var/lib/unifi

ADD run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
