#!/bin/sh

LOG=/tmp/liveness-log

echo " --- Liveness Probe Started --- " > "${LOG}"

if /opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false; then
echo "producer executed" >> "${LOG}"
else
        echo "exit1" >> "${LOG}"
        exit 1;
fi

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
