sudo apt-get update -y
sudo apt-get install -y \
    htop \
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
    nfs-common

# generate id rsa
ssh-keygen
cat ~/.ssh/id_rsa.pub

# < after adding deploy key in git repository >
git clone git@github.com:Sieve-Analytics/arbimon2-jobs.git

cd arbimon2-jobs
scripts/setup/setup.sh

export efs_host='fs-06cf134f.efs.us-east-1.amazonaws.com'
sudo mkdir /mnt/efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 $efs_host:/ /mnt/efs