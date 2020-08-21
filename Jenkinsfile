pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh 'mvn clean install'
        sh 'cp ./target/test-1.0-SNAPSHOT-jar-with-dependencies.jar /tmp'
      }
    }

    stage('Test') {
      parallel {
        stage('Test') {
          steps {
            ansiblePlaybook(playbook: 'ansible/roles/java-app-setup.yml', inventory: 'ansible/hosts', limit: 'localhost')
          }
        }

        stage('Kill Current Test') {
          steps {
            ansiblePlaybook(playbook: 'ansible/roles/java-app-reset.yml', inventory: 'ansible/hosts', limit: 'localhost')
          }
        }

      }
    }

    stage('Deploy') {
      steps {
        ansiblePlaybook(playbook: 'ansible/roles/java-app-setup.yml', inventory: 'ansible/hosts', limit: 'production')
        input 'Finished using mvn-app?'
        ansiblePlaybook(playbook: 'ansible/roles/java-app-reset.yml', inventory: 'ansible/hosts', limit: 'production')
      }
    }

  }
}