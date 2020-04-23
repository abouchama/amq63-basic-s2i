#!/bin/sh

OUTPUT=/tmp/liveness-output
ERROR=/tmp/liveness-error
LOG=/tmp/liveness-log

echo " --- Liveness Probe Started --- " > "${LOG}"

#while : ; do
#CONNECT_RESULT=1

/opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false
/opt/amq/bin/activemq consumer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1

#source /opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false
#source /opt/amq/bin/activemq consumer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1

CONNECT_RESULT=$?
echo ${CONNECT_RESULT} >> "${LOG}"

if [ "${CONNECT_RESULT}" -eq 0 ] ; then
        echo "exit0" >> "${LOG}"
        exit 0;
    else
        echo "exit1" >> "${LOG}"
        exit 1;
fi
