FROM nginx:latest
MAINTAINER n8tb1t <n8tb1t@gmail.com>

WORKDIR /www

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN curl -L https://github.com/dvandal/cryptonote-nodejs-pool/tarball/master \
    > site.tar.gz && \
    tar -xvf site.tar.gz  --strip 1 && \
    cp -a /www/website_example/. /usr/share/nginx/html && \
    rm -rf *

WORKDIR /usr/share/nginx/html

COPY config/site-config.js ./config.js
