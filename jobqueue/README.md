# Arbimon Job Queue

Node.js application for running background jobs (wrapper around the job code defined in [rfcx/arbimon-jobs](https://github.com/rfcx/arbimon-jobs).

---

### System dependencies:

 - nodejs
   ```
   sudo add-apt-repository ppa:chris-lea/node.js
   sudo apt-get update
   sudo apt-get install nodejs
   ```
 - node global dependencies(`sudo npm install -g <package>`):
  - grunt-cli
  
---

### Build

install backend and dev dependecies 

`npm install`

build app

`grunt` or `grunt build`

run

`npm start` and the app will be available in localhost:3007

run and watch

`grunt server` everything a file changes the project will rebuild

clean packages (node_modules)

`grunt clean` 

### Launching on production

1. SSH into the Bastion tunnel server
```sh
ssh ec2-user@54.159.71.198 -i ~/.ssh/arbimon2-bastion.pem
```
2. From inside the Bastion server, SSH into dev/prod server
```sh
ssh-job-dev
```
```sh
ssh-job
```
Both these connections are defined in the .bashrc file and rely on the same .ssh/arbimon2-app.pem key.
3. Switch user to `arbimon2`
```sh
sudo su arbimon2
```
4. Change to app directory
```sh
cd /var/lib/arbimon2/jobqueue/
```
5. Start app
```
./start_queue-debug.sh
```


## Docker Image

Build a docker image from this package:

```sh
docker build -t rfcx-arbimon-jobqueue -f build/Dockerfile .
```  

