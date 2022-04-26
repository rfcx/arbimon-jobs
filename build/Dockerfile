FROM ubuntu:16.04 as base

# OS dependencies
RUN apt-get update -yq \
    && apt-get -yq install curl gnupg ca-certificates \
    && curl -L https://deb.nodesource.com/setup_16.x | bash \
    && apt-get update -yq \
    && apt-get install -yq nodejs
RUN npm install -g grunt-cli forever

# App dependencies
WORKDIR /app/jobqueue
COPY jobqueue/package.json ./package.json
RUN npm install

# App code
COPY jobqueue .

CMD ["node", "main.js"]


# ---

FROM base as arbimon-jobs

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
        opus-tools \
        python-dev \
        python-opencv \
        python-pip \
        python-tk \
        python-virtualenv \
        r-base \
        r-base-dev \
        r-cran-rgl \
        sox

RUN mkdir /app/jobs
WORKDIR /app/jobs
COPY requirements.txt ./requirements.txt
COPY scripts ./scripts

RUN scripts/setup/setup.sh

COPY . /app/jobs

WORKDIR /app/jobqueue
