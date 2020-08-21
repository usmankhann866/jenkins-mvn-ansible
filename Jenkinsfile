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
            ansiblePlaybook(playbook: 'ansible/java-app-setup.yml', inventory: 'ansible/hosts', limit: 'localhost')
            sh 'cd '
          }
        }

        stage('Functional Testing') {
          steps {
            sh 'mvn test "-Dtestcase/test=Test.Runner"'
            archiveArtifacts 'testcase/target/surefire-reports/*html'
          }
        }

        stage('Stop App in Test Server') {
          steps {
            ansiblePlaybook(playbook: 'ansible/java-app-resset.yml', inventory: 'ansible/hosts', limit: 'localhost')
          }
        }

      }
    }

    stage('Deploy') {
      steps {
        ansiblePlaybook(playbook: 'ansible/java-app-setup.yml', inventory: 'ansible/hosts', limit: 'production')
        input 'Finished using mvn-app?'
        ansiblePlaybook(playbook: 'ansible/java-app-reset.yml', inventory: 'ansible/hosts', limit: 'production')
      }
    }

  }
}