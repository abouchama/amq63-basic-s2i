#!/bin/sh

#CONNECT_RESULT=1

/opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false && /opt/amq/bin/activemq consumer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1

CONNECT_RESULT=$?

if [ "${CONNECT_RESULT}" -eq 0 ] ; then
        exit 0;
    else
        exit 1;
    fi
