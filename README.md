# Arbimon II
Bio-Acoustic Analyzer

---
### Quick Setup:

 - python 2.7 - comes with Ubuntu
 
 - All dependencies  in one line
   ```
   sudo add-apt-repository ppa:chris-lea/node.js
   sudo apt-get update
   sudo apt-get install python-pip sox libsox-fmt-mp3 imagemagick nodejs libmysqlclient-dev python-dev gfortran libopenblas-dev liblapack-dev  libpng12-dev libfreetype6-dev libsndfile-dev virtualenv
   ```
   
 - Install all python dependencies, create python virtual enviroment and build
    ```
    sudo npm run-script setup    
    ```
    
 - Run app (the app will be available in localhost:3000)
    ```
    npm start
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
   
   
 - sox - audio conversion
   ```
   sudo apt-get install sox
   sudo apt-get install libsox-fmt-mp3
   ```


 - image magick - image manipulation tool
   ```
   sudo apt-get install imagemagick
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
   
 - nodejs
   ```
   sudo add-apt-repository ppa:chris-lea/node.js
   sudo apt-get update
   sudo apt-get install nodejs
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
   
   
 - matplotlib dependencies
   ```
   sudo apt-get install libpng12-dev libfreetype6-dev
   ```
   
 - scikits.audiolab dependencies
   ```
   sudo apt-get install libsndfile1 libsndfile-dev
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

---

### Build

install backend and dev dependecies 

`npm install`

install frontend dependencies 

`bower install`

build app

`grunt` or `grunt build`

run

`npm start` and the app will be available in localhost:3000

run and watch

`grunt server` everything a file changes the project will rebuild

clean packages and builds (node_modules, bower_components, public/assets)

`grunt clean` 
