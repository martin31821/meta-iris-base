// SPDX-License-Identifier: MIT
// Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

// meta-layers to check for identical branches
def meta_layers = [ "meta-iris-base" ]

// Target multiconfigs for the Jenkins pipeline
def targets = [ "sc573-gen6", "imx8mp-evk" ]

// Target images for the Jenkins pipeline
def images = [ "irma6-base" ]

// Make targets parsable as environment variable
def targets_string = targets.join(' ')

// Make images parsable as environment variable
def images_string = images.join(' ')

// Generate parallel & dynamic compile steps
def parallelImageStagesMap = targets.collectEntries {
    ["${it}" : generateImageStages(it, images_string)]  
}

def gitCheckoutMetaLayers(meta_layers) {
   for (int i = 0; i < meta_layers.size(); i++) {
       sh """
           cd ${meta_layers[i]}
           git checkout ${BRANCH_NAME} || true
           cd ..
       """
   }
}

def generateImageStages(target, images_string) {
    return {
        stage("Build ${target} Image") {
            awsCodeBuild buildSpecFile: 'buildspecs/build_firmware_images_develop.yml',
                credentialsType: 'keys',
                downloadArtifacts: 'false',
                region: 'eu-central-1',
                sourceControlType: 'jenkins',
                projectName: 'iris-devops-kas-build-codebuild',
                envVariables: "[ { MULTI_CONF, $target }, { IMAGES, $images_string }, { BRANCH_NAME, $BRANCH_NAME }, { GIT_COMMIT, $GIT_COMMIT }, { HOME, /home/builder } ]"
        }
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
                cleanWs disableDeferredWipeout: true, deleteDirs: true
                unstash 'kas'
                withCredentials(bindings: [sshUserPrivateKey(credentialsId: 'ssh_key', keyFileVariable: 'SSH_PRIVATE_KEY_FILE')]) {
                    // clone all meta layers using kas
                    sh 'kas shell --update -c "exit" kas-irma6-base.yml'
                }
                // checkout any identical named branches in the meta-layers
                gitCheckoutMetaLayers(meta_layers)
                sh 'touch kas.tar'
                sh 'tar --exclude=kas.tar cf kas.tar .'
                stash includes: 'kas.tar', name: 'kas'
            }
        }

        stage('Build Firmware') {
            steps {
                cleanWs disableDeferredWipeout: true, deleteDirs: true
                unstash 'kas'
                script {
                    parallel parallelImageStagesMap
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
