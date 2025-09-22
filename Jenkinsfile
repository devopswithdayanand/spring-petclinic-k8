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
        IMAGE_NAME = "devopswithdayanand/spring-pet-project-m2:$SNAP_VERSION"
    }

    stages {
        stage('notify') {
            steps {
                mail bcc: '', 
                 body: """Hi Team,

            Job Name: ${env.JOB_NAME}
            
            Regards,
            Jenkins
            """, 
             cc: '', from: '', replyTo: '', 
             subject: "[Jenkins] ${env.JOB_NAME} is started", 
             to: 'sewin21172@anysilo.com'
            }
        }
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
                withSonarQubeEnv(installationName: 'sonarqube', credentialsId: 'sonar-cred') {
                    sh 'mvn sonar:sonar'
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
                nexusArtifactUploader artifacts: [[artifactId: 'spring-petclinic', 
                    classifier: '', file: 'target/spring-petclinic-3.4.0-SNAPSHOT.jar', 
                    type: 'jar']], credentialsId: 'Nexus_cred', groupId: 'org.springframework.samples', 
                    nexusUrl: '172.31.39.206:8081', nexusVersion: 'nexus3', 
                    protocol: 'http', repository: 'spring-petclinic', version: "$SNAP_VERSION"
            }
        }

        stage('Docker Image Build') {
            steps {
                sh "docker build -t $IMAGE_NAME ."
            }
        }
        
        stage('Docker Image Push') {
            steps {
                sh "docker push $IMAGE_NAME"
            }
        }
        
        stage('deply to eks') {
            steps {
                sh "aws eks --region ap-northeast-1 update-kubeconfig --name demo-cluster"
                sh "helm upgrade --install petclinic ./petclinic-helm"
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
             to: 'sewin21172@anysilo.com'
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
                 to: 'sewin21172@anysilo.com'
        }
    }
}
