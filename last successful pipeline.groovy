pipeline {
	agent any

    stages{
        stage('Git clone'){
            steps {
                sh '''rm -rf C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/*'''
                sh '''git clone -b master https://github.com/odharmapuri2/kiwi-infra2.git'''
            }
        }
        stage('packaging'){
            steps {
                sh '''cd kiwi-infra2'''
                sh '''mvn -f kiwi-infra2/pom.xml install'''
            }
        }
        stage('copy app to s3'){
            steps {
                withAWS(region:'us-east-1',credentials:'s3creds') {
                    s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/kiwi-infra2/target/vprofile-v2.war', bucket:'testbuck3699/app')
                    s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/kiwi-infra2/target/classes/application.properties', bucket:'testbuck3699/app')
                }
            }
        }
    }
}
