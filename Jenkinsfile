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
      steps {
        ansiblePlaybook(playbook: 'ansible/java-app-setup.yml', inventory: 'ansible/hosts', limit: 'localhost', become: true, becomeUser: 'sushan')
        sh 'mvn test "-Dtestcase/test=Test.Runner"'
        archiveArtifacts 'testcase/target/surefire-reports/*html'
        ansiblePlaybook(playbook: 'ansible/java-app-reset.yml', inventory: 'ansible/hosts', limit: 'localhost', become: true, becomeUser: 'sushan', sudo: true, sudoUser: 'sushan')
      }
    }

    stage('Deploy') {
      steps {
        ansiblePlaybook(playbook: 'ansible/java-app-setup.yml', inventory: 'ansible/hosts', limit: 'production', become: true, becomeUser: 'sushan', sudoUser: 'sushan', sudo: true)
        input 'Finished using mvn-app?'
        ansiblePlaybook(playbook: 'ansible/java-app-reset.yml', inventory: 'ansible/hosts', limit: 'production', become: true, becomeUser: 'sushan', sudo: true, sudoUser: 'sushan')
      }
    }

  }
}