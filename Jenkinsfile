//login to Agent-1 here wwe are using agent ec2 so login to that manually through super putty 
//do sudo visudo or sudo cd /etc/sudoers file 
// add jenkins ALL=(ALL) NOPASSWD: ALL   after %wheel 
// this is adding becasue it will not run as root it will run as jenkins user so adding like this 
//do aws configure command not in root user do it in normal user in agent-1 where ever agent u do all this
//then only pipeline will execute

pipeline {
    agent {
        node {
            label 'Agent-1'
        }
    }
    
    options {
        ansiColor('xterm')
        timeout(time:1, unit:'HOURS')
        disableConcurrentBuilds()
    }
    parameters {
        choice (name: 'action', choices: ['Apply', 'Destroy'])
    }
    stages {
        stage('Install Terraform') {
            when {
                expression {
                    return sh (
                        script : 'commanf -v terraform >/dev/null 2&1',
                        returnStatus: true
                        echo "Terraform is already installed."
                    ) ! = 0
                    
                }
            }
            steps {
                sh '''
                echo "Terraform is not installed. Installing..."

                sudo yum install -y yum-utils

                sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

                sudo yum install -y terraform

                echo "Terraform Installed Successfully"

                terraform version
                '''
            }
        }
        stage('VPC') {
            steps {
                sh """
                    cd 01-vpc/
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """
            } 
        }
        stage('SG') {
            steps {
                sh """
                    cd 02-sg/
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """
            } 
        }
        stage('VPN') {
            steps {
                sh """
                    cd 03-VPN/
                    terraform init -reconfigure
                    terraform apply -auto-approve
                """
            } 
        }
//all stages are running in sequential process so App alb doesnt have dependency n databases s we used parallel stages
        stage('Databases And APP ALB') {
            parallel {
                stage('Databases') {
                    steps {
                        sh """
                            cd 04-databases/
                            terraform init -reconfigure
                            terraform apply -auto-approve
                        """
                    } 
                }
                stage('Application Load Balancer') {
                    steps {
                        sh """
                            cd 05-app-alb/
                            terraform init -reconfigure
                            terraform apply -auto-approve
                        """
                    } 
                }
            }
        }
                    
        
        // stage('Destroy Stage') {
        //     when {
        //         expression {
        //             params.action == 'Destroy'
        //         }
        //     }
        //     input {
        //         message "Do You Want to Continue ?"
        //         ok "proceed"
        //     }
        //     steps {
        //     sh """
        //         cd "${Module_No}"
        //         terraform destroy -auto-approve
        //     """
        //     }
        // }
    }
    post {
        always {
            echo "Terraform modules"
        }
        success {
            echo "Terraform infra Deployment Successfull"
        }
        failure {
            echo "Terraform infra Deployment Failed"
        }
    }
}