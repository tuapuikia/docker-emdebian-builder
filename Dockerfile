FROM ubuntu:latest
MAINTAINER tuapuikia @stan.wong

ARG DEBIAN_FRONTEND=noninteractive

# Install basic tools
RUN apt-get update \
 && apt-get install -y \
    bc \
    curl \
    git \
    rsync \
    sudo \
    wget \
 && apt-get clean


# Install multistrap and dependencies
RUN apt-get -y install \
    gpgv \
    multistrap \
    perl-base \
    patch \
 && apt-get clean

COPY patch /tmp/patch
RUN patch -p1 < /tmp/patch

COPY multistrap.conf /
COPY build.sh /
CMD /build.sh
VOLUME /chroot
