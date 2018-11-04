#!/bin/sh
SLEEP_TIME=15

start_varnish()
{
  timestp="stamp_$(date +%F_%H:%M:%S)"
  if [ -f "/tmp/backend-only" ]; then
    echo "varnish.sh: [${timestp}] Using only backend ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}, no config file"
    varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}
  else
    echo "varnish.sh: [${timestp}] Using supplied ${VARNISH_CONFIG_FILE}"
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

enable_logging()
{
  if [[ -z $DEBUG ]]; then
    : ${VARNISH_NCSA_FORMAT:='%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i"'}
    CHECK_STR="varnishncsa -F"
    [[ $(ps | grep "${CHECK_STR}" | grep -v "grep" | wc -l) = 0 ]] && varnishncsa -F "${VARNISH_NCSA_FORMAT}"
  else
    echo "Debug logging enabled"
    CHECK_STR="varnishlog"
    [ $(ps | grep "${CHECK_STR}" | grep -v "grep" | wc -l) = 0 ]] && varnishlog
  fi
}

while true; do
  VARNISH_STR="varnishd -f"
  [[ $(ps | grep "${VARNISH_STR}" | grep -v "grep" | wc -l) = 0 ]] && start_varnish
  wait_for_varnish
  enable_logging
  sleep ${SLEEP_TIME}
done
