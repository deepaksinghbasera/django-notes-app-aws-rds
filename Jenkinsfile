pipeline{
    agent {label "agent"}
    
    stages{
        stage("code clone"){
            steps{
                echo "cloning repo"
                git url: "https://github.com/deepaksinghbasera/django-notes-app.git", branch:"main"
            }
        }
        stage("build docker image"){
            steps{
                echo "building docker image"
                sh "docker compose build"
            }
        }
        stage("push to docker hub"){
            steps{
                echo "pushing image to docker hub"
                withCredentials([usernamePassword('credentialsId':"dockerhubCred",
                passwordVariable:"dockerHubPass",usernameVariable:"dockerHubUser")]){
                sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPass}"
                sh "docker image tag django_app:latest deepak77ronaldo/django-notes-app:latest"
                sh "docker push deepak77ronaldo/django-notes-app:latest"
                }
            }
        }
        stage("deploy"){
            steps{
                echo "final stage deploy"
                sh "docker compose up -d"
            }
        }
    }
}
