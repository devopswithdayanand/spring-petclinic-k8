pipeline {
    agent any
    parameters {
        string(name: 'phase1', defaultValue: 'clean test', description: 'mvn phase')
        string(name: 'phase2', defaultValue: 'package', description: 'mvn phase')
        string(name: 'version', defaultValue: '3.4.0-SNAPSHOT', description: 'snap version')
    }
    environment {
        ARTIFACT_ID = "spring-petclinic"
        SNAP_VERSION = "${params.version}"
        IMAGE_TAG = "$SNAP_VERSION"
        IMAGE_NAME = "devopswithdayanand/neeraj"
    }

    stages {
        stage('Git Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Testing') {
            steps {
                sh "mvn ${params.phase1}"
            }
        }
        stage('Sonar Scan') {
            steps {
                withSonarQubeEnv(installationName:'sonarqube', credentialsId: 'sonar-cred') {
                    sh "mvn sonar:sonar"
                }
            }
        }
        stage('Package') {
            steps {
                sh "mvn ${params.phase2}"
                archiveArtifacts artifacts: "target/*.jar", fingerprint: true
            }
        }
        stage('Nexus Upload') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: "$ARTIFACT_ID", 
                                                   classifier: '', file: 'target/spring-petclinic-3.4.0-SNAPSHOT.jar', type: 'jar']], 
                                                    credentialsId: 'neuxs-cred', groupId: 'org.springframework.samples', 
                                                    nexusUrl: '172.31.39.210:8081', nexusVersion: 'nexus3', protocol: 'http', 
                                                    repository: 'spring', version: '3.4.0-SNAPSHOT'
            }
        }
        stage('Docker image build') {
            steps {
                sh "docker build -t $IMAGE_NAME:$IMAGE_TAG ."
            }
        }

        stage('Docker image push') {
            steps {
                sh "docker push $IMAGE_NAME:$IMAGE_TAG"
            }
        }
    }
    post {
        success {
            mail bcc: '', 
                 body: """Hi Team,

            Job Name: ${env.JOB_NAME}
            Build Number: ${env.BUILD_NUMBER}
            Status: SUCCESS
            Branch: ${env.GIT_BRANCH}
            Commit: ${env.GIT_COMMIT}
            
            Logs: ${env.BUILD_URL}console
            Artifacts: ${env.BUILD_URL}artifact/
            
            Regards,
            Jenkins
            """, 
             cc: '', from: '', replyTo: '', 
             subject: "[Jenkins] ${env.JOB_NAME} #${env.BUILD_NUMBER} - Success", 
             to: 'devopswithdayanand@gmail.com'
        }
        failure {
            mail bcc: '', 
                 body: """Hi Team,

                Job Name: ${env.JOB_NAME}
                Build Number: ${env.BUILD_NUMBER}
                Status: FAILED
                Branch: ${env.GIT_BRANCH}
                Commit: ${env.GIT_COMMIT}
                
                Logs: ${env.BUILD_URL}console
                Artifacts: ${env.BUILD_URL}artifact/
                
                Regards,
                Jenkins
                """, 
                 cc: '', from: '', replyTo: '', 
                 subject: "[Jenkins] ${env.JOB_NAME} #${env.BUILD_NUMBER} - Failed", 
                 to: 'devopswithdayanand@gmail.com'
        }
    }
}
