// SPDX-License-Identifier: MIT
// Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

pipeline {
    agent any
    options {
        disableConcurrentBuilds()
        parallelsAlwaysFailFast()
    }
    environment {
        // S3 bucket for temporary artifacts
        S3_TEMP_BUCKET = 'iris-devops-tempartifacts-693612562064'
        SDK_IMAGE = 'irma6-maintenance'
    }
    stages {
        stage('Preparation Stage') {
            steps {
                // clean workspace
                cleanWs disableDeferredWipeout: true, deleteDirs: true
                sh 'printenv'
                // checkout iris-kas repo
                checkout([$class: 'GitSCM',
                    branches: [[name: '*/feature/jaor/add_Jenkinsfile']],
                    extensions: [[$class: 'CloneOption',
                    noTags: false,
                    reference: '',
                    shallow: false]],
                    userRemoteConfigs: [[url: 'https://github.com/iris-GmbH/iris-kas.git']]])
            }
        }
        
        stage('Build Firmware') {
            matrix {
                axes {
                    axis {
                        name 'MULTI_CONF'
                        values 'sc573-gen6', 'imx8mp-evk'
                    }
                    axis {
                        name 'IMAGES'
                        values 'irma6-deploy irma6-maintenance irma6-dev'
                    }
                }
                stages {
                    stage("Build Firmware Artifacts") {
                        steps {
                            awsCodeBuild buildSpecFile: 'buildspecs/build_firmware_images_develop.yml',
                                projectName: 'iris-devops-kas-large-amd-codebuild',
                                credentialsType: 'keys',
                                downloadArtifacts: 'false',
                                region: 'eu-central-1',
                                sourceControlType: 'jenkins',
                                sourceTypeOverride: 'S3',
                                sourceLocationOverride: "${S3_TEMP_BUCKET}/${JOB_NAME}/${GIT_COMMIT}/iris-kas-sources.zip",
                                envVariables: "[ { MULTI_CONF, $MULTI_CONF }, { IMAGES, $IMAGES }, { BRANCH_NAME, $BRANCH_NAME }, { SDK_IMAGE, $SDK_IMAGE }, { HOME, /home/builder } ]"
                        }
                    }
                }
            }
        }
    }

    post {
        // clean after build
        always {
            cleanWs(cleanWhenNotBuilt: false,
                    deleteDirs: true,
                    disableDeferredWipeout: true,
                    notFailBuild: true)
        }
    }
}




