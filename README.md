# varnish-alpine-docker

A very small Varnish docker image based on Alpine Linux, with

*   Templating support (via gomplate)
*   `querystring` vmod included

Based upon [thiagofigueiro/varnish-alpine-docker](https://github.com/thiagofigueiro/varnish-alpine-docker)

Includes a metrics endpoint suitable for use with Promemetheus, using <https://github.com/jonnenauha/prometheus_varnish_exporter>

## Environment variables
*   `VARNISH_MEMORY` - how much memory Varnish can use for caching. Defaults to 100M.
*   `VARNISH_GOMPLATE_FILE` - a template file to use, filled in with your environment variables. No default set. Needs `VARNISH_CONFIG_FILE` set.
*   `VARNISH_CONFIG_FILE` - path to a VCL file. Use this _or_ the two options below:
*   `VARNISH_BACKEND_ADDRESS` - host/ip of your backend.  Defaults to 192.168.1.65.
*   `VARNISH_BACKEND_PORT` - TCP port of your backend.  Defaults to 80.
*   `VARNISH_SKIP_METRICS` - Skip exposing a metrics endpoint.
*   `VARNISH_NCSA_FORMAT` - Custom varnishncsa format. Defaults to `%h %l %u %t "%r" %s %b "%{Referer}i" "%{User-agent}i"`

## Quick start

Run with defaults:

```bash
docker run -Pit --name=varnish-alpine egeland/varnish-alpine-docker
```

Specify your backend configuration:

```bash
docker run -e VARNISH_BACKEND_ADDRESS=a.b.c.d \
           -e VARNISH_BACKEND_PORT=nn \
           -e VARNISH_MEMORY=1G \
           -Pit --name=varnish-alpine egeland/varnish-alpine-docker
```

Build image locally:

```bash
git clone git@github.com:egeland/varnish-alpine-docker.git
cd varnish-alpine-docker
docker build -t varnish-alpine-docker .
```

## Software

*   [Varnish](https://www.varnish-cache.org/)
*   [Gomplate](https://github.com/hairyhenderson/gomplate)
*   [Alpine Linux](https://www.alpinelinux.org/)
*   [Docker Alpine](https://github.com/gliderlabs/docker-alpine)

### Versions

As of version `5.0.0` the generated image follows a semver versioning scheme.

See the [CHANGELOG.md](CHANGELOG.md) for details of each release.

## Acknowledgements
*   <https://github.com/thiagofigueiro/varnish-alpine-docker>
*   <https://github.com/jacksoncage/varnish-docker>
