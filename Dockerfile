FROM debian:jessie

ARG JOBS=4
ENV JOBS=$JOBS
RUN echo "Running the compilation with # of JOBS = $JOBS"

ARG OCC_VERSION=6.9.1
ENV OCC_VERSION=$OCC_VERSION
RUN echo "Compiling with OpenCascade $OCC_VERSION"

ARG ROOT_VERSION=6.16.00
ENV ROOT_VERSION=$ROOT_VERSION
RUN echo "Compiling with ROOT $ROOT_VERSION"

RUN apt-get update
RUN echo "reusing 'apt-get update'" && \
#RUN apt-get update && \
    apt-get install --yes --no-install-recommends \
      binutils \
      ca-certificates \
      cmake \
      curl \
      dpkg-dev \
      g++ \
      gcc \
      libgdal-dev \
      libhdf4-alt-dev \
      liblzma-dev \
      libreadline-dev \
      libvtk6-dev \
      libX11-dev \
      libXext-dev \
      libXft-dev \
      libXi-dev \
      libXpm-dev \
      libz-dev \
      make \
      ninja-build \
      #python \
      tar \
      wget \
      # Opencascade deps: \
      fdupes \
      flex \
      libfreetype6-dev \
      ftgl-dev \
      libqt4-dev \
      libtool \
      #rsync \
      tcl-dev \
      tk-dev \
      tcsh \
 && ls

RUN apt-get install --yes --no-install-recommends git-core

# Update CMake to v3.6.3
RUN git clone --depth 1 -b v3.6.3 https://github.com/Kitware/CMake.git
RUN \
  cd CMake && \
  mkdir build && \
  cd build && \
  cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr && \
  make -j4 && \
  make install && \
  ldconfig && \
  cd ../.. && \
  cmake --version

ADD opencascade-$OCC_VERSION.tgz /tmp
RUN ls -ltr /tmp

RUN apt-get install --yes --no-install-recommends autoconf automake libx11-dev libxmu-dev

RUN cd /tmp/opencascade-$OCC_VERSION && \
    ## if v7.x
    #mkdir build && cd build && 
    #cmake \
    #    -DUSE_VTK=OFF \
    #    -DUSE_FREEIMAGE=OFF \
    #    -DUSE_TBB=ON \
    #    -DUSE_GL2PS=OFF \
    #    -DCMAKE_INSTALL_PREFIX=/usr/local \
    #    -DCMAKE_BUILD_TYPE=Release \
    #    .. && \
    #make -j$JOBS && \
    #make install && \\
    ## elif v6.x
    ./build_configure && \
    ./configure  --disable-debug --disable-production \
      #--with-tbb-include= --with-tbb-library= \
      --with-vtk-include=/usr/include/vtk-6.1 --with-vtk-library=/usr/lib/x86_64-linux-gnu \
      --prefix=/usr/local && \
    make -j$JOBS && \
    make prefix=/usr/local install && \
    ## end
    cd / && \
    rm -r /tmp/opencascade-$OCC_VERSION

RUN ls /usr/local /usr/local/lib
#ENV CASROOT=/usr/local/include/opencascade/
ENV CASROOT=/usr/local



RUN wget https://root.cern.ch/download/root_v$ROOT_VERSION.source.tar.gz && \
    tar -xf root_v$ROOT_VERSION.source.tar.gz && \
    rm root_v$ROOT_VERSION.source.tar.gz

RUN cd ./root-$ROOT_VERSION/build \
 && cmake -Dgeocad=ON .. \
 && cmake --build . -- -j$JOBS

RUN apt-get install --yes --no-install-recommends \
      vim-nox

WORKDIR /root
