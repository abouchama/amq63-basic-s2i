#!/bin/sh

LOG=/tmp/liveness-log

echo " --- Liveness Probe Started --- " > "${LOG}"

/opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false
echo "producer executed" >> "${LOG}"
/opt/amq/bin/activemq consumer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1
echo "consumer executed" >> "${LOG}"

CONNECT_RESULT=$?
echo ${CONNECT_RESULT} >> "${LOG}"

if [ "${CONNECT_RESULT}" -eq 0 ] ; then
        echo "exit0" >> "${LOG}"
        exit 0;
    else
        echo "exit1" >> "${LOG}"
        exit 1;
fi
