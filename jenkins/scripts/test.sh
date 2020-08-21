#!/usr/bin/env sh

echo 'Deploy before testing'
cp target/test-1.0-SNAPSHOT-jar-with-dependencies.jar ansible/mockup_db.sql /tmp
#create target user to test.
#ansible-playbook -i ansible/hosts --limit localhost -t "add_new_user,copy_pub_key,generate_ssh_keys,create_dir,copy_deploy_file" ansible/usersetup.yml
ansible-playbook -i ansible/hosts --limit localhost --extra-vars "db_name=mockup_db host=localhost username=mockup password=mockup123" -t "create_db,add_user,import_db" ansible/mysqlsetup.yml
#ansible playbook to create user and transfer the neccessary deployment files and deploy it.
#ansible-playbook -i ansible/hosts --limit localhost -t "deploy_jar" ansible/usersetup.yml
#deploy jar file
java -jar target/test-1.0-SNAPSHOT-jar-with-dependencies.jar &

##FUNCTIONAL Testing
cd testcase/
mvn test "-Dtest=Test.Runner"
cd ..
