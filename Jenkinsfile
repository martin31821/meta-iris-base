// SPDX-License-Identifier: MIT
// Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

// meta-layers to check for identical branches
def meta_layers = [ "https://github.com/iris-GmbH/meta-iris-base.git" ]

pipeline {
    agent any
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
                HOME = '/home/builder'
            }
            steps {
                unstash 'kas'
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'ssh_key', keyFileVariable: 'SSH_PRIVATE_KEY_FILE')]) {
                    sh 'ls -la /home/'
                    sh 'kas shell --update -c "exit" kas-irma6-base.yml'
                }
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
