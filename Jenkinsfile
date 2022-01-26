pipeline{
    agent any
    environment{
        // AWS Variables
        AWS_ACCESS_KEY_ID = credentials('access_key')
        AWS_SECRET_ACCESS_KEY = credentials('secret_key')

        // Terraform Variables
        TF_VAR_access_key = credentials('access_key')
        TF_VAR_secret_key = credentials('secret_key')
    }

    stages{
        stage("Terraform Init"){
            steps{
                    sh "terraform init"
            }
        }

        stage("Terraform Plan"){
            steps{
                    sh "terraform plan -lock-false"
            }
        }
    }
}