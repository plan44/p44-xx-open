ARG PROJROOT=/p44-xx-open
ARG BRANCH=main
ARG OPENWRT_VERSTAG=v22.03.5
ARG GITHOSTROOT=https://github.com/plan44
#ARG GITHOSTROOT=https://codeberg.org/plan44
ARG TARGET=omega2
#ARG TARGET=raspberrypi-1
#ARG TARGET=raspberrypi-2

# Base system

FROM debian:11 AS base

RUN apt-get update && apt-get install -y \
    git quilt \
    build-essential clang \
    flex bison g++ gawk \
    gettext git libncurses-dev \
    libssl-dev python3-distutils rsync unzip zlib1g-dev \
    file wget quilt \
    python2.7-dev


# Get P44-XX-OPEN

FROM base AS basep44

ARG BRANCH
ARG PROJROOT
ARG GITHOSTROOT

ENV GIT_SRC=${GITHOSTROOT}/p44-xx-open
ENV BRANCH=${BRANCH}

RUN mkdir -p ${PROJROOT}
RUN git clone ${GIT_SRC} ${PROJROOT}

RUN cd ${PROJROOT} && \
    git checkout ${BRANCH} && \
    git submodule init && \
    git submodule update


# Setup OpenWrt buildroot

FROM basep44 AS openwrtp44

ARG PROJROOT
ARG OPENWRT_VERSTAG
ARG GITHOSTROOT

WORKDIR ${PROJROOT}/openwrt

# - checkout the openwrt version
RUN git checkout ${OPENWRT_VERSTAG}

# - setup openwrt feeds
RUN cp feeds.conf.default feeds.conf && \
    echo "src-git plan44 ${GITHOSTROOT}/plan44-feed.git;p44-xx-open" >>feeds.conf && \
    echo "src-git matter https://github.com/project-chip/matter-openwrt.git" >>feeds.conf && \
    echo "src-git onion https://github.com/OnionIoT/OpenWRT-Packages.git" >>feeds.conf && \
    sed -r -i -e 's/(src-git.*(luci|routing|telephony).*)/#\1/' feeds.conf && \
    ./scripts/feeds update -a


# Setup P44-XX-OPEN build environment

RUN ../p44build/p44b init feeds/plan44/p44-xx-diy-config/p44build

RUN ./p44b prepare && \
    ./p44b instpkg


# Build the openwrt toolchain

FROM openwrtp44 AS targetp44

ARG PROJROOT
ARG OPENWRT_VERSTAG
ARG GITHOSTROOT
ARG TARGET

WORKDIR ${PROJROOT}/openwrt

RUN ./p44b target ${TARGET}


#
# RUN ./p44b build tools/install
#
# RUN ./p44b build toolchain/install
#
#


# By default, let us use the environment from bash, manually

WORKDIR ${PROJROOT}/openwrt
CMD ["bash"]

