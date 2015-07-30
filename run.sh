#!/bin/bash
NAME="unifi"
DESC="Ubiquiti UniFi Controller"

BASEDIR="/usr/lib/unifi"
MAINCLASS="com.ubnt.ace.Launcher"

PIDFILE="/var/run/${NAME}/${NAME}.pid"
PATH=/bin:/usr/bin:/sbin:/usr/sbin

MONGOPORT=27117
MONGOLOCK="${BASEDIR}/data/db/mongod.lock"

JVM_OPTS="${JVM_OPTS:-${JVM_EXTRA_OPTS} -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Xmx1024M}"

OUTFILE="${LOGFILE:-&1}"
ERRFILE="${LOGFILE:-&2}"

set_java_home () {
	arch=`dpkg --print-architecture 2>/dev/null`
	support_java_ver='6 7'
	java_list=''
	for v in ${support_java_ver}; do
		java_list=`echo ${java_list} java-$v-openjdk-${arch}`
		java_list=`echo ${java_list} java-$v-openjdk`
	done

	cur_java=`update-alternatives --query java | awk '/^Value: /{print $2}'`
	cur_real_java=`readlink -f ${cur_java} 2>/dev/null`
	for jvm in ${java_list}; do
		jvm_real_java=`readlink -f /usr/lib/jvm/${jvm}/bin/java 2>/dev/null`
		[ "${jvm_real_java}" != "" ] || continue
		if [ "${jvm_real_java}" == "${cur_real_java}" ]; then
			JAVA_HOME="/usr/lib/jvm/${jvm}"
			return
		fi
	done

	alts_java=`update-alternatives --query java | awk '/^Alternative: /{print $2}'`
	for cur_java in ${alts_java}; do
		cur_real_java=`readlink -f ${cur_java} 2>/dev/null`
		for jvm in ${java_list}; do
			jvm_real_java=`readlink -f /usr/lib/jvm/${jvm}/bin/java 2>/dev/null`
			[ "${jvm_real_java}" != "" ] || continue
			if [ "${jvm_real_java}" == "${cur_real_java}" ]; then
				JAVA_HOME="/usr/lib/jvm/${jvm}"
				return
			fi
		done
	done

	JAVA_HOME=/usr/lib/jvm/java-6-openjdk
}


set_java_home

# JSVC - for running java apps as services
JSVC=`which jsvc`

#JSVC_OPTS="-debug"
JSVC_OPTS="${JSVC_OPTS}\
 -home ${JAVA_HOME} \
 -nodetach \
 -cp /usr/share/java/commons-daemon.jar:${BASEDIR}/lib/ace.jar \
 -pidfile ${PIDFILE} \
 -procname ${NAME} \
 -outfile $OUTFILE \
 -errfile $ERRFILE \
 ${JSVC_EXTRA_OPTS} \
 ${JVM_OPTS}"


if [[ ! -f /usr/lib/unifi/data/keystore ]]; then
    keytool -genkey -keyalg RSA -alias unifi -keystore /usr/lib/unifi/data/keystore -storepass aircontrolenterprise -keypass aircontrolenterprise -validity 1825 -keysize 4096 -dname "cn=unfi"
fi
exec $JSVC $JSVC_OPTS com.ubnt.ace.Launcher start

