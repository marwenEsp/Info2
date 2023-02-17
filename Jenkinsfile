pipeline {
    agent any
    stages {
        stage('Clone') {
            steps {
                git branch: 'hedi',
                url: 'https://github.com/devOps-project-groupe2/backend.git',
                credentialsId: 'github_creds'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn  clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
        stage('Sonar') {
            steps {
               sh 'mvn sonar:sonar -Dsonar.projectKey=devOps-project -Dsonar.login=2f0a6cb8549fbf8a3c4c41649b751fc41c194764'
            }
        }
        stage('Package') {
            steps {
                sh 'mvn package'
            }
        }
        stage('Deploy') {
            steps {
                        nexusArtifactUploader(
                            nexusVersion: 'nexus3',
                            protocol: 'http',
                            nexusUrl: 'localhost:8081/nexus',
                            groupId: 'com.esprit.examen',
                            version: '1.0',
                            repository: 'devOps-project-releases',
                            credentialsId: 'nexus_creds',
                            artifacts: [
                                [artifactId: 'tpAchatProject',
                                 classifier: '',
                                 file: 'target/tpAchatProject-1.0.jar',
                                 type: 'jar']
                            ]
                         )
            }
        }
        stage('docker-build') {
            steps {
                sh 'curl -u admin:admin -O http://localhost:8081/nexus/repository/devOps-project-releases/com/esprit/examen/tpAchatProject/1.0/tpAchatProject-1.0.jar'
                script {
                            docker.withRegistry('https://index.docker.io/v1', 'dockerhub_creds') {
                            def image = docker.build('hedikamoun1911/devops-project', '-f Dockerfile --build-arg JAR_FILE=tpAchatProject-1.0.jar .')
                            }
                }

            }
        }
               stage('docker-push') {
                 steps {
                     withCredentials([usernamePassword(credentialsId: 'dockerhub_creds', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                       sh "docker login -u $DOCKER_USERNAME -p $DOCKER_PASSWORD"
                       sh "docker tag hedikamoun1911/devops-project hedikamoun1911/devops-project:v1"
                       sh "docker push hedikamoun1911/devops-project:v1"
                      }
                 }
               }

            stage('docker-pull') {
                  steps {
                    script {
                      def imageName = "hedikamoun1911/devops-project:v1"
                      docker.withRegistry("https://registry.hub.docker.com", "dockerhub_creds") {
                        docker.image(imageName).pull()
                      }
                    }
                  }
                }

        stage('Docker-compose-run') {
          steps {
            // Copy the docker-compose.yml file to the workspace
            // sh 'cp ~/mydockerfiles/docker-compose.yaml .'

            // Replace the image tag in the docker-compose.yml file with the current Git commit hash
            // sh "sed -i 's/my_app:.*/my_app:${GIT_COMMIT}/' docker-compose.yml"

            // Start the Docker Compose stack
            sh 'docker compose up -d'
          }
        }

    }
}