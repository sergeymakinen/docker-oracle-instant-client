FROM ubuntu:16.04

LABEL maintainer "sergey@makinen.ru"

ENV DEBIAN_FRONTEND noninteractive

ENV ORACLE_INSTANTCLIENT_MAJOR 11.2
ENV ORACLE_INSTANTCLIENT_VERSION 11.2.0.4
ENV ORACLE /usr/local/oracle
ENV ORACLE_HOME $ORACLE/lib/oracle/$ORACLE_INSTANTCLIENT_MAJOR/client64
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$ORACLE/lib/oracle/$ORACLE_INSTANTCLIENT_MAJOR/client64/lib
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:$ORACLE/include/oracle/$ORACLE_INSTANTCLIENT_MAJOR/client64

RUN apt-get update && apt-get install -y libaio1 \
        curl rpm2cpio cpio \
    && mkdir $ORACLE && TMP_DIR="$(mktemp -d)" && cd "$TMP_DIR" \
    && curl -L "https://github.com/sergeymakinen/docker-oracle-instant-client/raw/assets/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm" -o basic.rpm \
    && rpm2cpio basic.rpm | cpio -i -d -v && mv usr/* $ORACLE && rm -rf ./* \
    && ln -s libclntsh.so.11.1 $ORACLE/lib/oracle/11.2/client64/lib/libclntsh.so.11.2 \
    && ln -s libocci.so.11.1 $ORACLE/lib/oracle/11.2/client64/lib/libocci.so.11.2 \
    && curl -L "https://github.com/sergeymakinen/docker-oracle-instant-client/raw/assets/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm" -o devel.rpm \
    && rpm2cpio devel.rpm | cpio -i -d -v && cp -r usr/* $ORACLE && rm -rf "$TMP_DIR" \
    && rm -rf /var/lib/apt/lists/* && apt-get purge -y --auto-remove curl rpm2cpio cpio
