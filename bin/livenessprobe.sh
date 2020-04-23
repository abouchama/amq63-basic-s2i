#!/bin/sh

OUTPUT=/tmp/liveness-output
ERROR=/tmp/liveness-error
LOG=/tmp/liveness-log

echo " --- Liveness Probe Started --- " > "${LOG}"

#!/bin/bash

function producer() {
/opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false
echo "producer executed" >> "${LOG}"
}
function consumer() {
/opt/amq/bin/activemq consumer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1
echo "consumer executed" >> "${LOG}"
}

# this subshell is a scope of try
# try
(
  # this flag will make to exit from current subshell on any error
  # inside it (all functions run inside will also break on any error)
  set -e
  producer
  consumer
  # do more stuff here
)
# and here we catch errors
# catch
errorCode=$?
if [ $errorCode -ne 0 ]; then
  echo "exit0" >> "${LOG}"
        exit 0;
    else
        echo "exit1" >> "${LOG}"
        exit 1;
fi

#/opt/amq/bin/activemq producer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1 --msgTTL 60000 --persistent false
#/opt/amq/bin/activemq consumer --user admin --password admin --brokerUrl tcp://$HOSTNAME:61616 --destination livenessprobeq --messageCount 1

#CONNECT_RESULT=$?
#echo ${CONNECT_RESULT} >> "${LOG}"

#if [ "${CONNECT_RESULT}" -eq 0 ] ; then
#        echo "exit0" >> "${LOG}"
#        exit 0;
#    else
#        echo "exit1" >> "${LOG}"
#        exit 1;
#fi
