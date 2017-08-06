# varnish-alpine-docker

A very small Varnish docker image based on Alpine Linux, with

* Templating support (via gomplate)
* `querystring` vmod included

Based upon [thiagofigueiro/varnish-alpine-docker](https://github.com/thiagofigueiro/varnish-alpine-docker)

## Environment variables
* `VARNISH_MEMORY` - how much memory Varnish can use for caching. Defaults to 100M.
* `VARNISH_GOMPLATE_FILE` - a template file to use, filled in with your environment variables. No default set. Needs `VARNISH_CONFIG_FILE` set.
* `VARNISH_CONFIG_FILE` - path to a VCL file. Use this _or_ the two options below:
* `VARNISH_BACKEND_ADDRESS` - host/ip of your backend.  Defaults to 192.168.1.65.
* `VARNISH_BACKEND_PORT` - TCP port of your backend.  Defaults to 80.

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

* [Varnish](https://www.varnish-cache.org/)
* [Gomplate](https://github.com/hairyhenderson/gomplate)
* [Alpine Linux](https://www.alpinelinux.org/)
* [Docker Alpine](https://github.com/gliderlabs/docker-alpine)

### Versions

The Docker image tag corresponds to the Alpine Linux version used.  The Varnish
version used is whatever Alpine have packaged.

| Image tag | Alpine Version | Varnish version | `querystring` | Gomplate |
|-----------|----------------|-----------------|---------------|----------|
| latest | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | YES | YES |
| 3.6-qs-gotpl-2 | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | YES | YES |
| 3.6-querystring | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | YES | NO |
| 3.6, 3 | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | NO | NO |

## Acknowledgements
* https://github.com/thiagofigueiro/varnish-alpine-docker
* https://github.com/jacksoncage/varnish-docker
