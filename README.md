# Arbimon II
Bio-Acoustic Analyzer - JOBS

v 1.0.1


## How to see latest logs:

1) ssh to Bastion server:
```sh
ssh ec2-user@54.159.71.198 -i ~/.ssh/arbimon2-bastion.pem
```

2) on Bastion server ssh to Job server:
```sh
ssh-job
```

3) Change user to arbimon2
```sh
sudo su arbimon2
```

4) List current active background processes
```sh
forever list
```

You should see a list like that:
```
info:    Forever processes running
data:        uid  command         script                                  forever pid  id logfile                             uptime
data:    [0] XwGh /usr/bin/nodejs /var/lib/arbimon2/jobqueue/bin/jobqueue 1422    1428    /var/lib/arbimon2/.forever/XwGh.log 0:0:10:16.81
```

5) Then you need to open logfile with a preferred tool
```sh
tail /var/lib/arbimon2/.forever/XwGh.log
```
To see all file, just use

```sh
cat /var/lib/arbimon2/.forever/XwGh.log
```


## How to see restart job server:

Repeat steps 1-4 from `How to see latest logs`.

5) Then you need to get uid and run the command:
```sh
forever restart XwGh
```

## If the issue is appeared:

```
error: Forever detected script exited with code: null
error: Script restart attempt #1
```

Stop the process and start queue:

```sh
forever stop XwGh
cd /var/lib/arbimon2/jobqueue
./start_queue-debug.sh
```

## How to delete outdated logs and temp files:

1) Open directory with logs
```sh
cd /var/lib/arbimon2/.forever/
```

2) List current active background processes
```sh
forever list
```

3) Get uid of the current active process and use it in the following command
```sh
rm -v !("XwGh.log")
```
This will delete all log files except file of the current process

4) Go to jobs temp directory and delete folders which relate to old jobs
```sh
cd /mnt/jobs-temp/
```

---
### Quick Setup:
 - python 2.7 - comes with Ubuntu

 - All dependencies  in one line
   ```
   sudo apt-get install -y python-pip libmysqlclient-dev python-dev gfortran libopenblas-dev liblapack-dev  libpng12-dev libfreetype6-dev libsndfile1 libsndfile-dev libsamplerate-dev
   python-virtualenv r-base r-base-dev libfftw3-3 libfftw3-dev r-cran-rgl bwidget
   ```


 - Install all python dependencies, create python virtual enviroment and build
    ```
    ./setup/setup.sh
    ```

---


### System dependencies:


 - python 2.7 - comes with Ubuntu


 - pip - python dependencies
   ```
   sudo apt-get install pip
   or
   sudo apt-get install python-pip
   ```

 - R statistics
   ```
    sudo apt-get install r-base
    sudo apt-get install r-base-dev
    sudo apt-get install libfftw3-3 libfftw3-dev libsndfile1-dev r-cran-rgl bwidget
   ```


 - R packages (tuneR,seewave)
   ```
   sudo Rscript scripts/setup/r-packages.R
   ```


 - MySQL-python dependencies
   ```
   sudo apt-get install libmysqlclient-dev python-dev
   ```


 - python virtualenv
   ```
   sudo apt-get install virtualenv
   ```


 - scipy dependencies
   ```
   sudo apt-get install gfortran libopenblas-dev liblapack-dev
   ```

 - libsamplerate
   ```
   sudo apt-get install  libsamplerate-dev
   ```

 - matplotlib dependencies
   ```
   sudo apt-get install libpng12-dev libfreetype6-dev
   ```


 - scikits.audiolab dependencies
   ```
   sudo apt-get install libsndfile-dev
   ```


 - node global dependencies(`sudo npm install -g <package>`):
  - bower
  - grunt-cli


 - individual python dependencies (`sudo pip install`):
    - numpy
    - scipy
    - MySQL-python
    - scikit-learn
    - boto
    - pypng
    - matplotlib
    - wsgiref
    - argparse
    - virtualenv
    - joblib
    - scikits.audiolab
    - Pillow
    - networkx
    - scikit-image
    - scikits.samplerate

## Deployment (AWS)

From Bastion:
```
ssh-job
```

Find the code:
```
cd /var/lib/arbimon2/jobs
```

Manually update the files. (git didn't work for me)

