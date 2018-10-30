#!/bin/sh

# Time to update!
new_config="reload_$(date +%FT%H:%M:%S)"

# Check if we are able to connect at all
if varnishadm vcl.list > /dev/null; then
  [[ ! -z $DEBUG ]] && echo vcl.list succeeded
else
  echo "Unable to run varnishadm vcl.list"
  exit 1
fi

if varnishadm vcl.list | awk ' { print $NF } ' | grep -q $new_config; then
  echo Trying to use new config $new_config, but that is already in use
  exit 2
fi

current_config=$( varnishadm vcl.list | awk ' /^active/ { print $NF } ' )

if [[ ! -z $DEBUG ]]; then
  echo "Loading vcl from $VARNISH_CONFIG_FILE"
  echo "Current running config name is $current_config"
  echo "Using new config name $new_config"
fi

if varnishadm vcl.load $new_config $VARNISH_CONFIG_FILE; then
  [[ ! -z $DEBUG ]] && echo "varnishadm vcl.load succeded"
else
  echo "varnishadm vcl.load failed"
  exit 1
fi

if varnishadm vcl.use $new_config; then
  [[ ! -z $DEBUG ]] && echo "varnishadm vcl.use succeded"
else
  echo "varnishadm vcl.use failed"
  exit 1
fi
[[ ! -z $DEBUG ]] && varnishadm vcl.list
exit 0
