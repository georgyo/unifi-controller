FROM debian:latest
MAINTAINER George Shammas <george@shamm.as>

ENV DEBIAN_FRONTENED=noninteractive
RUN echo deb http://www.ubnt.com/downloads/unifi/debian unifi4 ubiquiti >> /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
  echo deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen >> /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10 && \
  echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main >>/etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
  apt-get update && \
  apt-get upgrade -y && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-get install oracle-java8-installer unifi -y
  
EXPOSE 8080 8081 8443 8843 8880
VOLUME ["/var/lib/unifi/data"]
WORKDIR /var/lib/unifi

ADD run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
