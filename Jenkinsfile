pipeline {
    agent any

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/devopswithdayanand/spring-petclinic-k8.git'
            }
        }
        
        stage('Test') {
            steps {
                sh 'mvn clean test'
            }
        }
        
        stage('Package') {
            steps {
                sh 'mvn clean package -DSkiptests'
            }
        }
    }
}
