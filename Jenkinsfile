// SPDX-License-Identifier: MIT
// Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

// meta-layers to check for identical branches
def meta_layers = [ "meta-iris-base" ]

// Target multiconfigs for the Jenkins pipeline
def targets = [ "sc573-gen6", "imx8mp-evk" ]

// Target images for the Jenkins pipeline
def images = [ "irma6-base" ]

// Make layers parsable as environment variable
def meta_layers_string = meta_layers.join(' ')

// Make targets parsable as environment variable
def targets_string = targets.join(' ')

// Make images parsable as environment variable
def images_string = images.join(' ')

// Generate parallel & dynamic compile steps
def parallelImageStagesMap = targets.collectEntries {
    ["${it}" : generateImageStages(it, images_string, meta_layers_string)]  
}

def generateImageStages(target, images_string, meta_layers_string) {
    return {
        stage("Build ${target} Image") {
            awsCodeBuild buildSpecFile: 'buildspecs/build_firmware_images_develop.yml',
                credentialsType: 'keys',
                downloadArtifacts: 'false',
                region: 'eu-central-1',
                sourceControlType: 'jenkins',
                sourceTypeOverride: 'S3',
                sourceLocationOverride: "${S3_TEMP_LOCATION}/${JOB_NAME}/${GIT_COMMIT}/${GIT_COMMIT}-build-firmware-images-develop.zip}",
                projectName: 'iris-devops-kas-build-codebuild',
                envVariables: "[ { MULTI_CONF, $target }, { IMAGES, $images_string }, { BRANCH_NAME, $BRANCH_NAME }, { GIT_COMMIT, $GIT_COMMIT }, { LAYERS, $meta_layers_string }, { HOME, /home/builder } ]"
        }
    }
}

pipeline {
    agent any
    options {
        disableConcurrentBuilds()
    }
    environment {
        // S3 for permanent artifacts
        S3_LOCATION = 'iris-devops-artifacts-693612562064'
        // S3 with auto-expiration enabled
        S3_TEMP_LOCATION = 'iris-devops-tempartifacts-693612562064'
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
                sh 'touch kas.tar'
                sh 'tar cf kas.tar --exclude=kas.tar .'
                stash includes: 'kas.tar,buildspecs/**/*', name: 'kas'
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
