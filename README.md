# linnaeus_ng_control
Ansible Playbooks for controlling Linnaeus NG servers

## usage:
Run:

ansible-playbook -u my_user -i hosts -become playbook.yml

Available Playbooks:
* lng_update_all.yml
* lng_update_dev.yml
* lng_update_test.yml
* lng_update_production.yml

Make sure my_user can connect to all servers and has sudo rights. Link to ssh key is stored in ansible.cfg.

## requirements
Ansible should be installed on the local system. Remote servers require OpenSSH and Python.