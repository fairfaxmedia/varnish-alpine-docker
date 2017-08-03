#!/bin/sh

if [[ $(getent hosts ${VARNISH_BACKEND_ADDRESS} | awk '{print $1}') = $VARNISH_BACKEND_ADDRESS ]] 2>/dev/null ; then
  echo "WARNING: Backend appears to be an IP address, no need to refresh dns"
  exit 0
fi

LOOKUP_ADDRESS="${VARNISH_BACKEND_ADDRESS}"

if [[ ! -z $KUBERNETES_SERVICE_HOST ]] && ! getent hosts ${LOOKUP_ADDRESS} >/dev/null; then
  LOOKUP_ADDRESS="${LOOKUP_ADDRESS}.svc.cluster.local"
fi

if ! getent hosts ${LOOKUP_ADDRESS} >/dev/null; then
  echo "ERROR: ${LOOKUP_ADDRESS} is not a valid address"
  exit 1
fi

touch /tmp/lookup.curr

while true; do

  sleep ${VARNISH_DNS_TTL:-17}

  # Check DNS
  dig "${LOOKUP_ADDRESS}" +short | head -n 1 > /tmp/lookup.new

  # Compare old vs new
  cmp -s /tmp/lookup.new /tmp/lookup.curr
  if [[ 1 -eq $? ]]; then

    # DNS has changed!
    mv /tmp/lookup.new /tmp/lookup.curr
    ./reload_varnish.sh

  fi

done

