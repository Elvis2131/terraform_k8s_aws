pipeline{
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('access_key')
        AWS_SECRET_ACCESS_KEY = credentials('secret_key')
    }

    stages{
        stage("Terraform Init"){
            steps{
                    sh "terraform init"
            }
        }
    }
}