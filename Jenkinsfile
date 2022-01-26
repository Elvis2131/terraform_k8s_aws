pipeline{
    agent any
    stages{
        stage("Terraform Init"){
            steps{
                withCredentials([string(credentialsId: 'TF_VAR_access_key', variable: 'TF_VAR_access_key'), string(credentialsId: 'TF_VAR_secret_key', variable: 'TF_VAR_secret_key')]) {
                    sh "terraform init"
                }

            }
        }
    }
}