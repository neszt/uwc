FROM debian:buster

MAINTAINER Neszt Tibor <tibor@neszt.hu>

RUN \
	apt-get update && apt-get -y upgrade && \
	apt-get -y install libjson-xs-perl libtext-asciitable-perl python golang ruby php-cli clang nodejs npm default-jdk && \
	npm install split

COPY content /

CMD "/run.sh"
