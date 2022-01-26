pipeline{
    agent any
    environment{
        AWS_ACCESS_KEY_ID = credentials('TF_VAR_access_key')
        AWS_SECRET_ACCESS_KEY = credentials('TF_VAR_access_key')
    }
    
    stages{
        stage("Terraform Init"){
            steps{
                    sh "terraform init"
            }
        }
    }
}