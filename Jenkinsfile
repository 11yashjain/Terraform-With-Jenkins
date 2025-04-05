pipeline {
    agent any

    environment {
        AZURE_CREDENTIALS_ID = 'azure-service-principal-terraform'
        RESOURCE_GROUP = 'rg-jenkins'
        APP_SERVICE_NAME = 'webapijenkins691122'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/11yashjain/WebApiJenkins.git'
            }
        }

        
        stage('Infra Creation') {
            steps {
                dir('terraform_jenkins') {
                    bat 'terraform init'
                    bat 'terraform plan -out=tfplan'
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
        stage('Publish .NET 8 Web API') {
             steps {
                 dir('webapi') {
                     bat 'dotnet publish -c Release -o out'
                }
             }
         }    

        stage('Deploy') {
            steps {
                withCredentials([azureServicePrincipal(credentialsId: env.AZURE_CREDENTIALS_ID)]) {
                   bat '''
    az login --service-principal -u %AZURE_CLIENT_ID% -p %AZURE_CLIENT_SECRET% --tenant %AZURE_TENANT_ID%
    az account set --subscription %AZURE_SUBSCRIPTION_ID%
    powershell -Command "Compress-Archive -Path webapi\\out\\* -DestinationPath webapi\\publish.zip -Force"
    az webapp deploy --resource-group %RESOURCE_GROUP% --name %APP_SERVICE_NAME% --src-path webapi\\publish.zip --type zip
'''

                }
            }
        }
    }

    post {
        success {
            echo '✅ Deployment Successful!'
        }
        failure {
            echo '❌ Deployment Failed!'
        }
    }
}
