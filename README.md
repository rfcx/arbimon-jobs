# Arbimon II
Bio-Acoustic Analyzer - JOBS

v 1.0.1

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
