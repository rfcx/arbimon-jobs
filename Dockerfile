FROM ubuntu:16.04

ENV DB__TIMEZONE=Z \
    APP_PATH=/app/jobs \
    SCRIPT_PATH=scripts

RUN mkdir /root/.ssh/

RUN apt-get update -y
RUN apt-get install -y \
    bwidget \
    gfortran \
    libfftw3-3 \
    libfftw3-dev \
    libfreetype6-dev \
    liblapack-dev \
    libmysqlclient-dev \
    libopenblas-dev \
    libpng12-dev \
    libsndfile1 \
    libsndfile-dev \
    libsamplerate-dev \
    python-dev \
    python-opencv \
    python-pip \
    python-virtualenv \
    r-base \
    r-base-dev \
    r-cran-rgl \
    software-properties-common \
    nodejs \
    npm \
    libsox-fmt-all \
    libsox-dev \
    libvorbis-dev \
    libogg-dev \
    vorbis-tools \
    libopus-dev \
    libopusfile-dev \
    libtool \
    opus-tools \
    pkg-config \
    libflac-dev \
    autoconf \
    automake

RUN npm install -g grunt-cli && \
    add-apt-repository ppa:jonathonf/ffmpeg-4 && \
    apt-get update && \
    apt-get install -y ffmpeg libsox-fmt-all && \
    curl -o /tmp/sox-14.4.2.tar.gz https://jztkft.dl.sourceforge.net/project/sox/sox/14.4.2/sox-14.4.2.tar.gz && \
    tar xzf /tmp/sox-14.4.2.tar.gz -C /tmp && \
    curl -o /tmp/libogg-1.3.4.tar.gz https://ftp.osuosl.org/pub/xiph/releases/ogg/libogg-1.3.4.tar.gz && \
    tar xzf /tmp/libogg-1.3.4.tar.gz -C /tmp && \
    curl -o /tmp/libvorbis-1.3.6.tar.gz https://ftp.osuosl.org/pub/xiph/releases/vorbis/libvorbis-1.3.6.tar.gz && \
    tar xzf /tmp/libvorbis-1.3.6.tar.gz -C /tmp && \
    curl -o /tmp/flac-1.3.2.tar.xz https://ftp.osuosl.org/pub/xiph/releases/flac/flac-1.3.2.tar.xz && \
    tar xf /tmp/flac-1.3.2.tar.xz -C /tmp && \
    curl -o /tmp/vorbis-tools-1.4.0.tar.gz https://ftp.osuosl.org/pub/xiph/releases/vorbis/vorbis-tools-1.4.0.tar.gz && \
    tar xf /tmp/vorbis-tools-1.4.0.tar.gz -C /tmp && \
    apt -y remove sox && \
    rm -f /usr/local/bin/sox /usr/bin/sox && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/libogg-1.3.4
RUN ./configure && \
    make && \
    make install

WORKDIR /tmp/libvorbis-1.3.6
RUN ./configure && \
    make && \
    make install

WORKDIR /tmp/vorbis-tools-1.4.0
RUN ./configure && \
    make && \
    make install

WORKDIR /tmp/flac-1.3.2
RUN ./configure && \
    make && \
    make install

WORKDIR /tmp/sox-14.4.2/
RUN ./configure --with-opus=yes  --with-flac=yes --with-oggvorbis=yes && \
    make -s && \
    make install && \
    ln -s /usr/local/bin/sox /usr/bin/sox && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN rm -rf /tmp/*

COPY requirements.txt /app/requirements.txt
COPY scripts /app/scripts

WORKDIR /app/jobs

RUN bash scripts/setup/setup.sh

COPY . /app/jobs/

