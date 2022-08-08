FROM golang

ARG NGINX_VERSION=1.20.2
ARG CONSUL_VERSION=1.0.0
ARG NDK_VERSION=0.3.1
ARG HTTP_ECHO_VERSION=0.2.3

RUN \
  apt-get -yqq update && \
  apt-get -yqq install  \
  build-essential \
  curl \
  dnsutils \
  libpcre3 libpcre3-dev \
  libssl-dev \
  unzip \
  vim \
  zlib1g-dev

WORKDIR /tmp
RUN curl -sLo nginx.tgz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
  tar -xzf nginx.tgz

RUN curl -sLo ndk.tgz https://github.com/simpl/ngx_devel_kit/archive/v${NDK_VERSION}.tar.gz && \
  tar -xzf ndk.tgz

WORKDIR /go/src/github.com/hashicorp/ngx_http_consul_backend_module

COPY go.mod .
COPY go.sum .
RUN go mod download

ADD . .

RUN CGO_CFLAGS="-I /tmp/ngx_devel_kit-${NDK_VERSION}/src" \
  go build -buildmode=c-shared \
  -o /usr/local/nginx/ext/ngx_http_consul_backend_module.so \
  src/ngx_http_consul_backend_module.go

RUN \
  cd /tmp/nginx-${NGINX_VERSION} && \
  CFLAGS="-g -O0" \
  ./configure \
  --with-debug \
  --add-module=/tmp/ngx_devel_kit-${NDK_VERSION} \
  --add-module=/go/src/github.com/hashicorp/ngx_http_consul_backend_module \
  && \
  make && \
  make install


FROM debian:bullseye-slim

COPY --from=0 /usr/local/nginx/ /usr/local/nginx/
COPY docker/nginx.conf /usr/local/nginx/conf/nginx.conf

COPY docker/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
STOPSIGNAL SIGTERM
CMD ["/usr/local/bin/docker-entrypoint.sh"]

