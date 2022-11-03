FROM postgres:12-bullseye

LABEL maintainer="loyayz - https://loyayz.com"

ENV SCWS_URL http://www.xunsearch.com/scws/down/scws-1.2.3.tar.bz2
ENV ZHPARSER_URL https://github.com/amutu/zhparser/archive/refs/heads/master.tar.gz

RUN apt-get update \
      && apt-get install -y --no-install-recommends \
           ca-certificates \
           wget \
           bzip2 \
           make \
           gcc \
           libc6-dev \
           postgresql-server-dev-$PG_MAJOR \
           \
      ## install scws
      && cd / \
      && wget -q -O - $SCWS_URL | tar xjf - \
      && SCWS_DIR=${SCWS_URL##*/} \
      && SCWS_DIR=${SCWS_DIR%%.tar*} \
      && cd $SCWS_DIR && ./configure && make install \
      ## install zhparser
      && cd / \
      && wget -q -O - $ZHPARSER_URL | tar xzf - \
      && cd zhparser-master && make install \
      # clean
      && apt-get purge -y \
            ca-certificates \
            wget \
            bzip2 \
            make \
            gcc \
            libc6-dev \
            postgresql-server-dev-$PG_MAJOR \
      && apt-get autoremove --purge -y \
      && rm -rf /$SCWS_DIR \
            /zhparser-master \
            /var/lib/apt/lists/*

RUN mkdir -p /docker-entrypoint-initdb.d
COPY ./load-extensions.sh /docker-entrypoint-initdb.d/10_zhparser.sh
