ARG base=887044485231.dkr.ecr.eu-west-1.amazonaws.com/arbimon-jobqueue:latest
FROM $base

ENV DB__TIMEZONE=Z \
    APP_PATH=/app/jobs \
    SCRIPT_PATH=scripts

RUN mkdir /root/.ssh/

RUN apt-get update -y \
    && apt-get install -y \
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
        r-cran-rgl

WORKDIR /app
COPY requirements.txt ./requirements.txt
COPY scripts ./scripts

RUN scripts/setup/setup.sh

COPY . /app

WORKDIR /app/jobqueue
