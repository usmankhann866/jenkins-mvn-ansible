#!/usr/bin/env sh

echo 'Deploy Finally'
#ansible playbook to create and import database with user permission
ansible-playbook -i ansible/hosts --limit production -t "add_new_user,copy_pub_key,generate_ssh_keys,create_dir,copy_deploy_file,copy_DB" ansible/usersetup.yml
ansible-playbook -i ansible/hosts --limit production --extra-vars "db_name=mockup_db host=localhost username=mockup password=mockup123" -t "create_db,add_user,import_db" ansible/mysqlsetup.yml
#ansible playbook to create user and transfer the neccessary deployment files and deploy it.
ansible-playbook -i ansible/hosts --limit production -t "deploy_jar" ansible/usersetup.yml
# ssh mockup@production
# cd deploy
# set -x
# java -jar /home/mockup/deploy/test-1.0-SNAPSHOT-jar-with-dependencies.jar &
# set +x