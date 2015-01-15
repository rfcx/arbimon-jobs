#! /bin/sh

scripts=`dirname $0`



sudo apt-get install -y libcap2-bin git

sudo apt-get install -y python-pip libmysqlclient-dev python-dev gfortran libopenblas-dev liblapack-dev  libpng12-dev libfreetype6-dev libsndfile1 libsndfile-dev python-virtualenv r-base r-base-dev libfftw3-3 libfftw3-dev r-cran-rgl bwidget
sudo $scripts/setup/r-packages.R


U=`whoami`
H=`readlink -f ~/.npm`
sudo chown -R "$U" "$H"
$scripts/setup/setup.sh
