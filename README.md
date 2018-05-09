# linnaeus_ng_control
Ansible Playbooks for controlling Linnaeus NG servers

 
## requirements

Ansible should be installed on your _control machine_, which is usually your local machine or a central
controller machine.  Remote servers require OpenSSH, Python and should be accessible with your ssh key.

Follow the instructions from the [ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-machine) on installing.

After succesfully installing ansible. Clone this git repository and use the playbooks to control all or
some linnaeus installations.

## usage
Run:

```
cd linnaeus.ansible
ansible-playbook -u my_user -i hosts --become [playbook.yml]
```

Available Playbooks:

* lng_update_all.yml
* lng_update_dev.yml
* lng_update_test.yml
* lng_update_production.yml
* lng_update_docker.yml

Make sure _my_user_ can connect to all servers and has sudo rights. Link to ssh key is stored in ansible.cfg.

_my_user_ can also be configured in the hosts file. Also do not forget the --become for this is needed for
many of the sudo operations in the playbook.

## hosts

The `hosts` file contains the names, ip numbers and remove ssh users these are grouped by labels. The playbook
refers to the actual hosts defined in the hosts file. The lng_update_docker.yml playbook contains:

```
- hosts: linnaeus-docker-test
  roles:
    - naturalis-linnaeus_docker-control
```

So this playbook runs the `naturalis-linnaeus_dockter-control` ansible tasks script on the machines listed under `linnaeus-docker-test` in the hosts file.

To see what a certain playbook runs on which machines you can call the command with `--list-hosts` parameter.
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

If you run the last command without `--list-hosts` you run the playbook on this machine only. This
will look something like this:


![Animation of ansible playbook running](http://g.recordit.co/1M3195aKQi.gif)



## typical usage recipes

Here are some common scenarios when dealing with linnaeus installations.

### Updating all linnaeus servers after releasing a new version

This will be most common whenever a new stable release is released.

```ansible-playbook -u [your username] -i hosts --become lng_update_docker.yml```

A playbook can fail on certain machines. You should always try again and if the problem persists, check 
the error or increase verbosity '-v', '-vv' or even '-vvv'.

### Updating a single linnaeus server after releasing a new version

This will be done if you just want to test if a certain machine works.

```ansible-playbook -u [your username] -l [exact host name] -i hosts --become lng_update_docker.yml```

### Installing a specific version of a linnaeus installation on a certain server

* create a new branch of linnaeus containing your special version
* push it to the linnaeus repository
* log on to the server you want to run a different version on
* change `/opt/docker-linnaeusng/.env', set a different GIT_BRANCH (same to the one you just set)
* logout

```ansible-playbook -u [your username] -l [exact host name] -i hosts --become lng_update_docker.yml```

### Completely reinstall a certain linnaeus installation

First time setups will contain linnaeus installations that do not work or just contain empty versions
of linnaeus. With these steps you can setup a new machine in minutes.

* `scp` a recent mysql dump of a linnaeus installation to the server
* log on to the server you want to reinstall
* become root
* `rm /data/linnaeus/4_new_project_and_user.sql`
* `echo "USE linnaeus_ng" > /data/linnaeus/4_linnaeusdb.sql`
* `cat /path/to/your/recent/dump.sql >> /data/linnaeus/4_linnaeusdb.sql`
* `rm -rf /data/linnaeus/www`
* logout

```ansible-playbook -u [your username] -l [exact host name] -i hosts --become lng_update_docker.yml```

This will rebuild the docker configuration as well is reinstall linnaeus and install the database.

### Only running one task on one machine

```ansible-playbook -u [your username] -l [exact host name] -t gulp -i hosts --become lng_update_docker.yml```

If you only want to run the task tagged 'code' on one host.


