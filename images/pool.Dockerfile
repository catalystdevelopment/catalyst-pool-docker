FROM node:8
MAINTAINER n8tb1t <n8tb1t@gmail.com>

ENV NODE_ENV=development
ENV TERM=xterm

RUN apt-get update && apt-get install -y \
    libssl-dev \
    libboost-all-dev \
    apt-utils \
    locales \
    mc \
    vim \
    zsh \
    && rm -rf /var/lib/apt/lists/*

ARG LOCALE_LANG_COUNTRY="en_US"
ARG LOCALE_CODIFICATION="UTF-8"
ARG LOCALE_CODIFICATION_ENV="utf8"

ARG TIME_ZONE

RUN ln -fs /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
    && dpkg-reconfigure -f noninteractive tzdata \
    && localedef -i ${LOCALE_LANG_COUNTRY} -c -f ${LOCALE_CODIFICATION} -A /usr/share/locale/locale.alias ${LOCALE_LANG_COUNTRY}.${LOCALE_CODIFICATION}

ENV LANG=${LOCALE_LANG_COUNTRY}.${LOCALE_CODIFICATION_ENV}

RUN apt-get purge -y --auto-remove apt-utils

RUN git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh --depth 1 \
    && cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc

WORKDIR /catalyst/pool

RUN git clone https://github.com/dvandal/cryptonote-nodejs-pool.git --depth 1 . \
    && rm -rf .git && yarn install

COPY config/config.json .

CMD if [ "$MODULE" = "ALL" ] ; then node init.js; else node init.js -module=$MODULE; fi
