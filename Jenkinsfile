
pipeline
{
    agent { dockerfile true }

    stages
    {
        stage('terraform init')
        {
            steps
            {
		sh 'terraform init'
            }
        }
        stage('terraform apply')
        {
            steps
            {
		sh 'terraform apply -auto-approve'
            }
        }
        stage('terraform destroy')
        {
            steps
            {
		sh 'terraform destroy -auto-approve'
            }
        }
    }
}
