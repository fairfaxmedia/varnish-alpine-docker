#!/bin/sh

until (varnishtop -1 >/dev/null) ; do
  echo "dnscheck.sh: Waiting for varnish to start"
  sleep 1
done

get_backends()
{
  BACKEND_LIST=$(varnishadm vcl.show $(varnishadm vcl.list | grep active | awk '{print $4}') | grep '.host' | cut -d '"' -f 2)
  > /tmp/backend.list
  for backend in ${BACKEND_LIST}; do

    if [[ $(getent ahostsv4 ${backend} | awk '{print $1}' |head -n 1) = $backend ]] 2>/dev/null ; then
      echo "dnscheck.sh: WARNING: Backend appears to be an IP address, no need to watch its dns"
      continue
    fi

    if ! getent hosts ${backend} >/dev/null; then
      echo "dnscheck.sh: ERROR: ${backend} is not a valid address"
      exit 1
    fi

    echo $backend >> /tmp/backend.list

    touch "/tmp/lookup_${backend}.curr"
  done
}

do_reload()
{
    new_config="reload_$(date +%FT%H:%M:%S)"

    if varnishadm vcl.load $new_config $VARNISH_CONFIG_FILE; then
      [[ ! -z $DEBUG ]] && echo "varnishadm vcl.load succeded" > /tmp/ok
    else
      echo "varnishadm vcl.load failed" > /tmp/err
      exit 1
    fi
}

while true; do

  get_backends
  sleep ${VARNISH_DNS_TTL:-17}
  reload_needed=0

  # Check DNS
  for backend in $(cat /tmp/backend.list); do
    getent ahostsv4 "${backend}" |awk '{print $1}' | head -n 1 > "/tmp/lookup_${backend}.new"

    # Compare old vs new
    cmp -s "/tmp/lookup_${backend}.new" "/tmp/lookup_${backend}.curr"
    if [[ 1 -eq $? ]]; then
      if [[ -s "/tmp/lookup_${backend}.curr" ]]; then
        # DNS has changed!
        echo "dnscheck.sh: DNS changed for ${backend}"
        reload_needed=1
      else
        echo "dnscheck.sh: First check for ${backend} - skipping reload"
      fi
      mv "/tmp/lookup_${backend}.new" "/tmp/lookup_${backend}.curr"
    fi
  done
  if [[ $reload_needed -ne 0 ]]; then
    do_reload
  fi

done
