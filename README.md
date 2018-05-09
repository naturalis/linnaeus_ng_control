# linnaeus_ng_control
Ansible Playbooks for controlling Linnaeus NG servers

## usage:
Run:

```ansible-playbook -u my_user -i hosts -become _playbook.yml_```

Available Playbooks:

* lng_update_all.yml
* lng_update_dev.yml
* lng_update_test.yml
* lng_update_production.yml
* lng_update_docker.yml

Make sure _my_user_ can connect to all servers and has sudo rights. Link to ssh key is stored in ansible.cfg.

_my_user_ can also be configured in the hosts file.

## hosts

The `hosts` file contains the names, ip numbers and remove ssh users these are grouped by labels. The playbook
refers to the actual hosts defined in the hosts file. The lng_update_docker.yml playbook contains:

```
- hosts: linnaeus-docker-test
  roles:
    - naturalis-linnaeus_docker-control
```

So this playbook runs the `naturalis-linnaeus_dockter-control` ansible tasks script on the machines listed under `linnaeus-docker-test` in the hosts file.

To see what a certain playbook runs on which machines you can call the command with '--list-hosts' parameter.
For instance:

```
$ ansible-playbook -i hosts lng_update_docker.yml --list-hosts

playbook: lng_update_docker.yml

  play #1 (linnaeus-docker-test): linnaeus-docker-test	TAGS: []
    pattern: [u'linnaeus-docker-test']
    hosts (3):
      various-003-linnaeustest
      various-002-linnaeustest
      various-001-linnaeustest
```

You can also limit the playbook to just one of these hosts. By using the limit parameter:

```
$ ansible-playbook -l various-003-linnaeustest -i hosts lng_update_docker.yml --become --list-hosts 

playbook: lng_update_docker.yml

  play #1 (linnaeus-docker-test): linnaeus-docker-test	TAGS: []
    pattern: [u'linnaeus-docker-test']
    hosts (1):
      various-003-linnaeustest
```

If you run the last command without '--list-hosts' you run the playbook on this machine only. This
will look something like this:


![Animation of ansible playbook running](http://g.recordit.co/1M3195aKQi.gif)



 
## requirements
Ansible should be installed on the local system. Remote servers require OpenSSH and Python.

## running ansible on one host only



## recipes
