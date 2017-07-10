#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`
if [[ -z $VARNISH_CONFIG_FILE ]]; then
  varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}
else
  varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY}
fi
sleep 1
until varnishlog; do
  sleep 5
  echo "Retrying varnishlog"
done

