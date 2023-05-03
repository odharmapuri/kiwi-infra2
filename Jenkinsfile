pipeline {
	agent any
    /*tools { 
        maven 'MAVEN_HOME' 
        jdk 'JAVA_HOME' 
    }*/
    environment {

    }
    stages{
        stage('Git clone'){
            steps {
                script {
                    def folder = new File( 'C:/ProgramData/Jenkins/.jenkins/workspace/*' )
                    if( folder.exists() ) {
                        sh "rm -rf C:/ProgramData/Jenkins/.jenkins/workspace/*"
                    } else {
                        sh '''git clone -b master https://github.com/odharmapuri2/kiwi-infra2.git''' 
                    }
                
                sh '''rm -rf C:/ProgramData/Jenkins/.jenkins/workspace/*'''
                sh '''git clone -b master https://github.com/odharmapuri2/kiwi-infra2.git'''
            }
        }
        stage('creating s3'){
            steps {
                sh '''terraform init'''
                sh '''terraform apply -target="module.s3" --auto-approve'''
            }
        }
        stage('packaging'){
            steps {
                sh '''cd kiwi-infra2'''
                sh '''mvn -f kiwi-infra2/pom.xml install'''
            }
        }
        stage('mvn test'){
            steps {
                sh '''mvn -f kiwi-infra2/pom.xml test'''
            }
        }
        /*stage('INTEGRATION TEST'){
            steps {
                sh 'mvn verify -DskipUnitTests'
            }
        }
        stage ('CODE ANALYSIS WITH CHECKSTYLE'){
            steps {
                sh 'mvn checkstyle:checkstyle'
            }
        }*/
        stage('CODE ANALYSIS with SONARQUBE') {
		    environment {
                scannerHome = tool 'kiwisonar'
            }
            steps {
                sh '''mvn -f kiwi-infra2/pom.xml verify sonar:sonar'''
            }
        }
        stage('copy app to s3'){
            steps {
                withAWS(region:'us-east-1',credentials:'s3creds') {
                    sh 'echo "Uploading content with AWS creds"'
                    /*s3Upload(file:'C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/kiwi-infra2/target/vprofile-v2.war', bucket:'testbuck3699', path:'/app/kiwi.war')*/
                    s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/kiwi-infra2/target/vprofile-v2.war', bucket:'kiwi-artifact-storage/app')
                    s3Upload(pathStyleAccessEnabled: true, payloadSigningEnabled: true, file:'C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/kiwi-infra2/target/classes/application.properties', bucket:'kiwi-artifact-storage/app')
                }
            }
        }
        stage('building infra'){
            steps {
                sh '''terraform init -upgrade'''
                sh '''terraform apply --auto-approve'''
            }
        }
        /*stage("Publish to Nexus Repository Manager") {
            steps {
                script {
                    pom = readMavenPom file: "pom.xml";
                    filesByGlob = findFiles(glob: "target/*.${pom.packaging}");
                    echo "${filesByGlob[0].name} ${filesByGlob[0].path} ${filesByGlob[0].directory} ${filesByGlob[0].length} ${filesByGlob[0].lastModified}"
                    artifactPath = filesByGlob[0].path;
                    artifactExists = fileExists artifactPath;
                    if(artifactExists) {
                        echo "*** File: ${artifactPath}, group: ${pom.groupId}, packaging: ${pom.packaging}, version ${pom.version} ARTVERSION";
                        nexusArtifactUploader(
                            nexusVersion: NEXUS_VERSION,
                            protocol: NEXUS_PROTOCOL,
                            nexusUrl: NEXUS_URL,
                            groupId: pom.groupId,
                            version: ARTVERSION,
                            repository: NEXUS_REPOSITORY,
                            credentialsId: NEXUS_CREDENTIAL_ID,
                            artifacts: [
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: artifactPath,
                                type: pom.packaging],
                                [artifactId: pom.artifactId,
                                classifier: '',
                                file: "pom.xml",
                                type: "pom"]
                            ]
                        );
                    } 
		            else {
                        error "*** File: ${artifactPath}, could not be found";
                    }
                }
            }
        }*/
    }
}
