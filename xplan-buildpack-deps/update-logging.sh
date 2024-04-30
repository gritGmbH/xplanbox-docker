#!/bin/bash

# fail on command failures
set -e
# do not expand non existing files
shopt -s nullglob

# fix log4j.properties (if exists)
for elem in /target/usr/local/tomcat/webapps/*/WEB-INF/classes/log4j.properties 
do
    echo "Changeing ${elem}" 
    sed -ri "s/^(log4j\.rootLogger)=([^\n]*)$/\1=INFO, stdout/" "${elem}"
    sed -ri "s/^(log4j\.appender\.stdout\.Threshold)=([^\n]*)$/\1=WARN/" "${elem}"
done

# fix log4j2.yaml (if exists) up to 7.1.3
# 7.1.3 has only stdout via format switch
#
#for elem in /target/usr/local/tomcat/webapps/*/WEB-INF/classes/log4j2.yaml 
#do
#	echo "Changeing ${elem}"
#	/yq -i "del(.Configuration.Loggers.Root.AppenderRef[] | select( .ref != \"STDOUT\"), .Configuration.Appenders.RollingFile)" "${elem}"
#done