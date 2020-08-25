# Jenkins - GitHub Continuous Integration and Deployment Project (small maven project using ansible)

This repo demonstrates how to deploy a maven based project from GitHub using Jenkins Pipeline and ansible (with asnsible-playbook and ansible-vault).
In this project, java based application is built, tested and deployed. 
See the Jenkinsfile for the exact Pipeline.
Basic Jenkins and ansible knowledge is required to understand this whole devops CI/CD flow.

# Environment Setup
1) Two VM's is required. One can use Virtualbox or VMware. I have used VMware workstation to create two VM's.
2) Server One will use Jenkins as a Continuous Integration Tool server in which we will also install ansible to carry out the automation work.
3) Server TWO will be the production server and it will have the same environment as staging server. This is important, we want to have the identical environment setup in staging and deployment server. Check point 5) and 6) to see the identical environment.
4) Server ONE can be considered as our testing/staging server and here we do our building and testing. Therefore locally in server One we will build and test our app using ansible and we will deploy it on server TWO which will be our production server. We could use totally a different VMS for staging server and differentiate it from the VM's in which Jenkins and ansible is installed. But for the simplicity, Jenkins and Ansible is installed in the staging server.
5) OS: Ubuntu 16.04. Works on 18.04 as well.
6) Packages: apache2, mysql, python-mysqldb(mysql db connector from Python), maven(build java app). 

Identical Server Setup
--------
1. jdk 1.8 (default jdk on ubuntu 16.04) 
2. apache2, mysql 5.7, python-mysqldb(mysql python connector). 
3. 

P.S. Ansible can handle these package installation. In future, I will create a git repo on how to install packages using ansible. 

Setup process for Ansible
-----
1) Two roles are created for deploying the app and killing the app.
2) Both servers will have identical setup because we are deploying first in staging server and if all the build, testing is okay in staging server then we will proceed to the deployment.
3)

Setup process for Jenkins
--------
1) Install Jenkins and add required plugins like (blueocean, github, pipeline, ansible).
2) Configure Jenkins global tool and add ansible and maven as a global tool. 
2) Setup sudo passwordless user access in both staging and production server and make passwordless ssh connection between those two passwordless user, this is needed for ansible-playbook. 
3) In Jenkins server, create a node in local server which has access to passwordless user. Then from Jenkinsfile (pipeline) we will tell it to execute the whole Job from the newly created node. This has to be done because I did not want to give the sudo privilege to Jenkins user and run ansible-playbook. 

Ansible Roles and its task
========
Ansible helps in automated deployment. 
Two Roles are used i.e java-app and java-kill-app which is found under ansible/roles/.
* java role have a tasks to add_new_user, add_user, copy_deploy_file, copy_pub_key, create_db, create_dir, deploy_jar, generate_ssh_keys, import_db, mysql_status
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

# How it Works
1. Create a Multibranch Pipeline (or use Blue Ocean) within Jenkins that references this repository.
2. Pipeline will then instructs Jenkins to proceed through build, test and deploy phase using Jenkinsfile.

Jenkins pipeline has 3 stages: Build, Test and Deploy.

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
  * Finally an interactive input is also added, "Finished using the mockup maven app? (Click "Proceed" to continue)". Proceeding will terminate the deployed app. This is what we could have done in testing phase and proceed to the deployment but since it's a demo project, I have terminated the deployed app as well.



Author Information
------------------
Sushan Kunwar
Sytem Engineer/Devops Engineer
