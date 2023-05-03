pipeline {
	agent any
	/*tools {
        maven "maven3"
    }
    environment {
        NEXUS_VERSION = "nexus3"
        NEXUS_PROTOCOL = "http"
        NEXUS_URL = "172.31.40.209:8081"
        NEXUS_REPOSITORY = "vprofile-release"
	    NEXUS_REPO_ID    = "vprofile-release"
        NEXUS_CREDENTIAL_ID = "nexuslogin"
        ARTVERSION = "${env.BUILD_ID}"
    }*/
    stages{
        stage('Git clone'){
            steps {
                sh '''rm -rf C:/ProgramData/Jenkins/.jenkins/workspace/kiwi/*'''
                sh '''git clone -b master https://github.com/odharmapuri2/kiwi-infra2.git'''
            }
        }
        /*stage('bulding infra'){
            steps {
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
            }
        }*/
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
