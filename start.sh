#!/bin/sh

mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`


if [ -f "$VARNISH_GOMPLATE_FILE" -a -r "$VARNISH_GOMPLATE_FILE" ]; then
  VARNISH_CONFIG_FILE='/etc/varnish/default.vcl'
  echo "Creating ${VARNISH_CONFIG_FILE} from gomplate ${VARNISH_GOMPLATE_FILE}"
  gomplate --file ${VARNISH_GOMPLATE_FILE} --out ${VARNISH_CONFIG_FILE}
  varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY}
elif [[ ! -z $VARNISH_CONFIG_FILE ]]; then
  echo "Using supplied ${VARNISH_CONFIG_FILE}"
  varnishd -f ${VARNISH_CONFIG_FILE} -s malloc,${VARNISH_MEMORY}
else
  echo "Using only backend ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}, no config file"
  varnishd -s malloc,${VARNISH_MEMORY} -a :80 -b ${VARNISH_BACKEND_ADDRESS}:${VARNISH_BACKEND_PORT}
fi
sleep 1

until (varnishtop -1); do
  echo "Waiting for varnish to start"
  sleep 5
done

if [[ ! -z $VARNISH_DNS_REFRESH ]]; then
  ./dnscheck.sh &
fi

if [[ -z $DEBUG ]]; then
  : ${VARNISH_NCSA_FORMAT:='%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i"'}
  varnishncsa -F "${VARNISH_NCSA_FORMAT}"
else
  echo "Debug logging enabled"
  varnishlog
fi

