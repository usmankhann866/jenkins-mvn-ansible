#!/usr/bin/env sh
ps aux | grep test-1.0-SNAPSHOT-jar-with-dependencies.jar | grep java | awk '{print $2}' | xargs kill -9 || true
ansible-playbook -i ansible/hosts --limit localhost  --extra-vars "deploy_user=mockup" -t "remove_user" ansible/usersetup.yml
ansible-playbook -i ansible/hosts --limit localhost --extra-vars "db_name=mockup_db username=mockup" -t "remove_user,remove_db" ansible/mysqlsetup.yml
