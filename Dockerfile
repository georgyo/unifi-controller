FROM debian:latest
MAINTAINER George Shammas <george@shamm.as>

ENV DEBIAN_FRONTENED=noninteractive
RUN \
  apt-get update && \
  apt-get install -y gnupg && \  
  echo deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti >> /etc/apt/sources.list && \
  apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv 06e85760c0a52c50 && \
  echo deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen >> /etc/apt/sources.list && \
  apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv 9ecbec467f0ceb10 && \
  echo deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main >>/etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --no-tty --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
  apt-get update && \
  apt-get upgrade -y && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
  apt-get install --allow-unauthenticated -y oracle-java8-installer unifi
  
EXPOSE 8080 8081 8443 8843 8880
VOLUME ["/var/lib/unifi/data"]
WORKDIR /var/lib/unifi

ADD run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
