FROM ubuntu:16.04

RUN mkdir /app/

WORKDIR /app/

RUN apt-get update -y && \
    apt-get install -y \
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
    r-cran-rgl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
COPY scripts /app/scripts

RUN scripts/setup/setup.sh

COPY . /app/


CMD ["/bin/sh"]