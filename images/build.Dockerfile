FROM ubuntu:18.04

ENV TERM=xterm

RUN apt-get update

RUN apt-get install -y \
    git \
    apt-utils \
    mc \
    vim \
    zsh

ARG LOCALE_LANG_COUNTRY="en_US"
ARG LOCALE_CODIFICATION="UTF-8"
ARG LOCALE_CODIFICATION_ENV="utf8"

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh --depth 1 \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.2/s6-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/s6-overlay-amd64.tar.gz -C /

ADD https://github.com/just-containers/socklog-overlay/releases/download/v2.1.0-0/socklog-overlay-amd64.tar.gz /tmp/
RUN tar xzf /tmp/socklog-overlay-amd64.tar.gz -C /

RUN apt-get install -y \
      build-essential \
      python-dev \
      g++-8 \
      gcc-8 \
      cmake \
      libboost-all-dev

WORKDIR /catalyst/build
