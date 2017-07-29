#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`


if [[ -z $VARNISH_CONFIG_FILE ]]; then
    varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}
else
  if [[ ! -z $VARNISH_GOMPLATE_FILE ]]; then
    echo "Creating ${VARNISH_CONFIG_FILE} from gomplate ${VARNISH_GOMPLATE_FILE}"
    gomplate --file ${VARNISH_GOMPLATE_FILE} --out ${VARNISH_CONFIG_FILE}
  fi
  varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY}
fi
sleep 1

until (varnishtop -1); do
  echo "Waiting for varnish to start"
  sleep 5
done

if [[ -z $DEBUG ]]; then
  varnishncsa
else
  echo "Debug logging enabled"
  varnishlog
fi

