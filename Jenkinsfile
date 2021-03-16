pipeline {
    agent {
        kubernetes {
            yaml """
kind: Pod
metadata:
  name: kaniko
spec:
  containers:
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    imagePullPolicy: Always
    command:
    - cat
    tty: true
    volumeMounts:
      - name: docker-config
        mountPath: /kaniko/.docker
  volumes:
    - name: docker-config
      configMap:
        name: docker-config
"""
        }
    }
    environment {
        APP = "arbimon-job"
        PHASE = branchToConfig(BRANCH_NAME)
        ECR = "887044485231.dkr.ecr.eu-west-1.amazonaws.com"
    }

    stages {

        stage("Build") {
            when {
                 expression { BRANCH_NAME ==~ /(dev)/ }
            }
            steps {
                slackSend (channel: "#${slackChannel}", color: '#FF9800', message: "*Arbimon Job*: Build started <${env.BUILD_URL}|#${env.BUILD_NUMBER}> commit ${env.GIT_COMMIT[0..6]} branch ${env.BRANCH_NAME}")
                catchError {
                container(name: 'kaniko') {
                sh '''
                /kaniko/executor --cache=true --cache-repo=${ECR}/cache/${APP} --dockerfile `pwd`/Dockerfile --context `pwd` --destination=${ECR}/${APP}/${PHASE}:latest --destination=${ECR}/${APP}/${PHASE}:${GIT_COMMIT} --destination=${ECR}/${APP}/${PHASE}:v$BUILD_NUMBER
                '''
                }
                }
            }

           post {
               success {
                   slackSend (channel: "#${slackChannel}", color: '#3380C7', message: "*Arbimon Job*: Image built on <${env.BUILD_URL}|#${env.BUILD_NUMBER}> branch ${env.BRANCH_NAME}")
                   echo 'Compile Stage Successful'
               }
               failure {
                   slackSend (channel: "#${slackChannel}", color: '#F44336', message: "*Arbimon Job*: Image build failed <${env.BUILD_URL}|#${env.BUILD_NUMBER}> branch ${env.BRANCH_NAME}")
                   echo 'Compile Stage Failed'
                   sh "exit 1"
               }
           }
        }

        stage ('Invoke jobqueue Pipeline') {
            steps {
                build job: "arbimon-jobqueue/${jobqueueJob}", wait: false
            }
        }
    }
}


def branchToConfig(branch) {
    script {
        result = "NULL"
        if (branch == 'dev') {
            result = "staging"
        slackChannel = "alerts-deployment"
        jobqueueJob = "dev"
        withCredentials([file(credentialsId: 'arbimon-job_staging_aws.local.json', variable: 'PRIVATE_ENV')]) {
        sh "cp $PRIVATE_ENV config/aws.local.json"
        }
        withCredentials([file(credentialsId: 'arbimon-job_staging_config.env', variable: 'PRIVATE_ENV')]) {
        sh "cp $PRIVATE_ENV config/config_env"
        }
        withCredentials([file(credentialsId: 'arbimon-job_staging_db.local.json', variable: 'PRIVATE_ENV')]) {
        sh "cp $PRIVATE_ENV config/db.local.json"
        }
        withCredentials([file(credentialsId: 'arbimon-job_staging_path.local.json', variable: 'PRIVATE_ENV')]) {
        sh "cp $PRIVATE_ENV config/path.local.json"
        }
        }
        echo "BRANCH:${branch} -> CONFIGURATION:${result}"
    }
    return result
}