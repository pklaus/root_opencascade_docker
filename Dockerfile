FROM opensuse:42.3

ARG JOBS=4
ENV JOBS=$JOBS

ARG ROOT_VERSION=6.12.06
ENV ROOT_VERSION=$ROOT_VERSION

RUN zypper ref && \
    zypper --non-interactive in \
      cmake \
      curl \
      gcc \
      gcc-c++ \
      libX11-devel \
      libXext-devel \
      libXft-devel \
      libXpm-devel \
      readline \
      tar \
      wget \
      zlib

RUN wget https://root.cern.ch/download/root_v$ROOT_VERSION.source.tar.gz && \
    tar -xf root_v$ROOT_VERSION.source.tar.gz && \
    rm root_v$ROOT_VERSION.source.tar.gz

RUN cd ./root-$ROOT_VERSION/build \
 && cmake .. \
 && cmake --build . -- -j$JOBS
