pipeline {
    agent any
    parameters {
        string(name: 'phase1', defaultValue: 'clean test', description: 'mvn phase')
        string(name: 'phase2', defaultValue: 'package', description: 'mvn phase')
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
                withSonarQubeEnv(credentialsId: 'sonar-cred') {
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
