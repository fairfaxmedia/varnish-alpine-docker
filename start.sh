#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`


if [ -f "$VARNISH_GOMPLATE_FILE" -a -r "$VARNISH_GOMPLATE_FILE" ]; then
  VARNISH_CONFIG_FILE='/etc/varnish/default.vcl'
  echo "Creating ${VARNISH_CONFIG_FILE} from gomplate ${VARNISH_GOMPLATE_FILE}"
  gomplate --file ${VARNISH_GOMPLATE_FILE} --out ${VARNISH_CONFIG_FILE}
  varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY} || exit 1
elif [[ ! -z $VARNISH_CONFIG_FILE ]]; then
  echo "Using supplied ${VARNISH_CONFIG_FILE}"
  varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY} || exit 1
else
  echo "Using only backend ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}, no config file"
  varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT} || exit 1
fi
sleep 1

until (varnishtop -1); do
  echo "Waiting for varnish to start"
  sleep 5
done

if [[ ! -z $VARNISH_DNS_REFRESH ]]; then
  ./dnscheck.sh &
fi

/usr/local/bin/prometheus_varnish_exporter -no-exit &

if [[ -z $DEBUG ]]; then
  varnishncsa
else
  echo "Debug logging enabled"
  varnishlog
fi
