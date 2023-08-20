#!/bin/bash
echo "Start load generation"
INGRESS_PATHS=('/' '/team' '/v1')
i=1
while [ $i -le 50 ]
do
  echo "Iteration: $i"
  for INGRESS_PATH in ${INGRESS_PATHS[@]}
  do
    echo "Send request to http://localhost$INGRESS_PATH"
    curl -s http://localhost$INGRESS_PATH 1>/dev/null
    sleep 1
  done
  i=$(( $i + 1 ))
  sleep 1
done
echo "Load generation finished"