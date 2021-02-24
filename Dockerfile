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
    software-properties-common

RUN add-apt-repository ppa:chris-lea/node.js && \
    apt-get update && \
    apt-get -y install nodejs npm && \
    npm install -g grunt-cli

COPY requirements.txt /app/requirements.txt
COPY scripts /app/scripts

WORKDIR /app/jobs

RUN scripts/setup/setup.sh

COPY . /app/jobs/

