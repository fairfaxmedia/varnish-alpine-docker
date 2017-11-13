FROM alpine:3.6 as builder

WORKDIR /build
RUN apk update
RUN apk add ca-certificates curl wget tar gzip
RUN wget -O libvmod-querystring.tgz $(curl -sL https://api.github.com/repos/Dridi/libvmod-querystring/releases/latest | grep 'browser_download_url' | grep '\.tar\.gz' | cut -d '"' -f 4)
RUN tar -zxvf libvmod-querystring.tgz && mv vmod-querystring* libvmod-querystring
RUN apk add build-base gcc make libtool varnish varnish-dev file python2
WORKDIR /build/libvmod-querystring
RUN ./configure --with-rst2man=: || cat config.log && \
    make && \
    make check && \
    make install

FROM hairyhenderson/gomplate as gomplate

FROM alpine:3.6
MAINTAINER  Frode Egeland <egeland@gmail.com>
ENV REFRESHED_AT 2017-11-02
ENV VARNISH_BACKEND_ADDRESS 192.168.1.65
ENV VARNISH_MEMORY 100M
ENV VARNISH_BACKEND_PORT 80
EXPOSE 80

RUN  apk --no-cache add varnish bind-tools tini

COPY --from=builder /usr/lib/varnish/vmods/libvmod_querystring.so /usr/lib/varnish/vmods/libvmod_querystring.so
COPY --from=gomplate /gomplate /usr/local/bin/gomplate

ADD *.sh /
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/start.sh"]
