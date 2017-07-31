#!/bin/sh

LOOKUP_ADDRESS="${VARNISH_BACKEND_ADDRESS}"

touch /tmp/lookup.curr


if [[ ! -z $KUBERNETES_SERVICE_HOST ]]; then
  LOOKUP_ADDRESS="${LOOKUP_ADDRESS}.svc.cluster.local"
fi

while true; do

  sleep ${VARNISH_DNS_TTL:-17}

  # Check DNS
  dig "${LOOKUP_ADDRESS}" +short | head -n 1 > /tmp/lookup.new

  # Compare old vs new
  cmp -s /tmp/lookup.new /tmp/lookup.curr
  if [[ 1 -eq $? ]]; then

    # DNS has changed - time to update!
    mv /tmp/lookup.new /tmp/lookup.curr
    new_config="reload_$(date +%FT%H:%M:%S)"
    varnishadm vcl.load $new_config $VARNISH_CONFIG_FILE && varnishadm vcl.use $new_config

  fi

done

