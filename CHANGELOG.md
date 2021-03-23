### 5.5.0

* 🐛 Varnish now runs in foreground mode, which means it doesn't need to check every second if it is running.
* 🐛 dnscheck now correctly handles backends that have a port specified.

### 5.4.0

* 🔧 Allow configuration of the `vsl_reclen` parameter for altering the default size of the SHM log.

### 5.3.0

* Enhancement of the selection of backends being monitored by dnscheck:

 * Better identification of backends
 * Allow to disable dns check for some backends (adding nodnscheck in the line)
 * Get unique backends

Thanks to @jesusfcr for doing this work!

### 5.2.0

* Change base image to use s6 - this changes how the scripts are managed. More like managed services now. Thanks to @axozoid for doing this work!


### 5.1.1

* Bugfix: `reload_varnish.sh` was using a wrong value to compare configs.


### 5.1.0

* Update to `dnscheck.sh` script to manage any number of backends, not just the one set
in environment variable in the default configuration.

### 5.0.0

* Re-tag of `3.6-qs-gotpl-2` for the semver versioning scheme.

### Deprecated Versions

These images follow a non-semver versioning, and should be considered EOL.

The Docker image tag corresponds to the Alpine Linux version used.  The Varnish
version used is whatever Alpine have packaged.

| Image tag | Alpine Version | Varnish version | `querystring` | Gomplate |
|-----------|----------------|-----------------|---------------|----------|
| latest | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | YES | YES |
| 3.6-qs-gotpl-2 | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | YES | YES |
| 3.6-querystring | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | YES | NO |
| 3.6, 3 | [3.6.0](https://www.alpinelinux.org/posts/Alpine-3.6.0-released.html) | [4.1.3-r0](https://pkgs.alpinelinux.org/packages?name=varnish&branch=v3.6) | NO | NO |
