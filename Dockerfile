FROM ubuntu:16.04

LABEL maintainer "sergey@makinen.ru"

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html
COPY oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm
COPY oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm /tmp/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm
RUN apt-get update && apt-get install -y libaio1 alien \
    && alien -ik /tmp/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm \
    && rm /tmp/oracle-instantclient11.2-basic-11.2.0.4.0-1.x86_64.rpm \
    && alien -ik /tmp/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm \
    && rm /tmp/oracle-instantclient11.2-devel-11.2.0.4.0-1.x86_64.rpm \
    && ln -s libclntsh.so.11.1 /usr/lib/oracle/11.2/client64/lib/libclntsh.so.11.2 \
    && ln -s libocci.so.11.1 /usr/lib/oracle/11.2/client64/lib/libocci.so.11.2 \
    && rm -rf /var/lib/apt/lists/*
ENV ORACLE_HOME /usr/lib/oracle/11.2/client64
RUN echo '/usr/lib/oracle/11.2/client64/lib' > /etc/ld.so.conf.d/oracle.conf && chmod o+r /etc/ld.so.conf.d/oracle.conf && ldconfig
