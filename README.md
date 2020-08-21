# Jenkins - GitHub Deployment (small maven project)

This repo demonstrates how to deploy a maven based project from GitHub using Jenkins Pipeline and ansible.
In this project, maven based application is built, tested and deployed.
See the Jenkinsfile for the exact Pipeline.

Prerequisite
------------
1. Ubuntu server, at least version(java 1.8, mysql 5.6), python-mysqldb(mysql python connector).
2. Jenkins, maven, ansible should be installed.
2. Provision Managent is handled by ansible including the deployment.

Requirements
------------
1. Create a Multibranch Pipeline (or use Blue Ocean) within Jenkins that references this repository.
2. Pipeline will then instructs Jenkins to proceed through build, test and deploy phase.


How it Works
------------
The Jenkins pipeline has 3 stages: Build, Test and Deploy.

* Build Stage:
  * Maven command is run to build the project.

* Test Stage:
  * To test the built project, the test deployment is carried out locally where API testing is done.
  * First, it runs the test.sh script from jenkins/scripts/test.sh. This scripts file has necessary bash command to deploy the build project for test purpose. Scripts also uses ansible to create the mysql user and database. Before the completion of test phase, ansible removes the mysql user and db.
  * After API tests is completed, it will terminate the test deployment.
  * Email will also be sent with build log and results. (P.S. To send email, first do a email setup in jenkins, either use your own or google mail server to send an email)
  * Then, Jenkins pipeline will artifact the API Test results in Artifacts for future use.
  * Finally results of APT test cases are displayed in the Test.
 
* Deploy Stage:
  * To deploy the tested project, the Deploy stage is carried out. In this case, deployment is carried locally.
  * First, it runs the deploy.sh script from jenkins/scripts/deploy.sh. This scripts also uses ansible to create the mysql user and database using mysql role(ansible/roles/mysql). It also creates a different user with respective home directory to deploy the maven app using user-management role(ansible/roles/user-management. Before the completion of test phase, ansible removes the mysql(user, database) and linux(user and its home directory).
  * Finally an interactive input is also added, "Finished using the mockup maven app? (Click "Proceed" to continue)". Proceeding will terminate the deployed app. 


Ansible Roles and its task
========
Ansible helps in automated deployment. 
Two Roles are used i.e mysql and user-management which is found under ansible/roles/.
* mysql role have a tasks to add_user, create_db, delete_user, import_db, mysql_status, remove_db.
* user-management role have a task to create add_new_user, copy_pub_key, create_dir, generate_ssh_keys, remove_user.

Role Variables
--------------
* mysql role
  * ansible/roles/mysql/vars/main.yml has the variable and it contains the mysql root password, which in this case is not used, but
  whoever user runs the ansible-playbook, that users home directory most contain mysql root username and password in .my.cnf hidden file
  so that ansible-playbook can have access to complete the required tasks.
 
* user-management role
  * ansible/roles/user-management/vars/main.yml contains the deployment user password. Deployment in this case is done locally but if you want to deploy remotely then set-up ssh between the current server and remote production server with passwordless sudo access because all the user-management tasks requires a sudo privelege.

**P.S.** It is better to use ansible-vault to hide the passwords but for the simplicity of this task, I have directly used the password from the variables. Also, in some cases using variables are passed using "--extra-vars" in ansible-playbook.  

Author Information
------------------

Sushan Kunwar\
Sytem Engineer/Devops Engineer
