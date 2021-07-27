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
                checkout([$class: 'GitSCM', branches: [[name: '*/develop,*/${BRANCH_NAME}']], extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: false]], userRemoteConfigs: [[url: 'https://github.com/iris-GmbH/iris-kas.git']]])
            }
        }
    }
}