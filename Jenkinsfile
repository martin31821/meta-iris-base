// SPDX-License-Identifier: MIT
// Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

// meta-layers to check for identical branches
def meta_layers = [ "meta-iris-base" ]

def loop_meta_layers(meta_layers) {
   for (int i = 0; i < meta_layers.size(); i++) {
       sh """
           cd ${meta_layers[i]}
           git checkout ${BRANCH_NAME} || true
           cd ..
       """
   }
}

pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    stages {
        stage('Preparation Stage') {
            steps {
                // Clean workspace
                cleanWs disableDeferredWipeout: true, deleteDirs: true
                sh 'printenv'
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: false]], userRemoteConfigs: [[url: 'https://github.com/iris-GmbH/iris-kas.git']]])
                // checkout branch with the same name, if exists
                sh "git checkout ${BRANCH_NAME} || true"
                stash includes: '**/*', name: 'kas'
                // get auth token for ECR
                sh "aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 693612562064.dkr.ecr.eu-central-1.amazonaws.com"
            }
        }
        stage('Clone Meta Layers') {
            agent {
                docker {
                    image '693612562064.dkr.ecr.eu-central-1.amazonaws.com/kas:latest'
                }
            }
            environment {
                // set HOME, so KAS has a location where it can store the .ssh directory
                HOME = '/tmp'
            }
            steps {
                unstash 'kas'
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'ssh_key', keyFileVariable: 'SSH_PRIVATE_KEY_FILE')]) {
                    // clone all meta layers using kas
                    sh 'kas shell --update -c "exit" kas-irma6-base.yml'
                }
                // checkout any identical named branches in the meta-layers
                loop_meta_layers(meta_layers)
            }
        }
    }

    post {
        // Clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}
