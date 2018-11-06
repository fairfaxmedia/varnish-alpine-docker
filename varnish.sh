#!/bin/sh
SLEEP_TIME=15

start_varnish()
{
  if [ -f "/tmp/backend-only" ]; then
    echo "varnish.sh: Using only backend ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}, no config file"
    varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}
  else
    echo "varnish.sh: Using supplied ${VARNISH_CONFIG_FILE}"
    varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY}
  fi
}

wait_for_varnish()
{
  until (varnishtop -1 >/dev/null); do
    echo "Waiting for varnish to start.."
    sleep 5
  done
}

while true; do
  VARNISH_STR="varnishd -f"
  [[ $(ps | grep "${VARNISH_STR}" | grep -v "grep" | wc -l) = 0 ]] && start_varnish
  wait_for_varnish
  sleep ${SLEEP_TIME}
done
