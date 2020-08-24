**THIS REPOSITORY HAS BEEN MOVED AND IS NO LONGER MAINTAINED**

Pleas checkout the new location at https://gitlab.com/naturalis/bii/linnaeus/ansible-linnaeus, you can update your local checkout code by using this command:

```
git remote set-url origin git@gitlab.com:naturalis/bii/linnaeus/ansible-linnaeus.git
```

# linnaeus_ng_control
Ansible Playbooks for controlling Linnaeus NG servers

 
## requirements

Ansible should be installed on your _control machine_, which is usually your
local machine or a central controller machine.  Remote servers require OpenSSH,
Python and should be accessible with your ssh key.

Follow the instructions from the 
[ansible documentation](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-the-control-machine) on installing.

After succesfully installing ansible. Clone this git repository and use the
playbooks to control all or some linnaeus installations.

## usage
Run:

```
ansible-playbook -u [your user name] -i inventory playbooks/[playbook.yml]
```

Available Playbooks:

* update_production.yml [check the detailed docker playbook documentation](https://github.com/naturalis/linnaeus_ng_control/tree/master/linnaeus.ansible/roles/naturalis-linnaeus_docker-control)
* update_test.yml

Make sure you can connect to all servers and have sudo rights. Link to ssh key
is stored in ansible.cfg.

You can also be override your user in the hosts file.


## hosts

The `hosts` file contains the names, ip numbers and ssh users, these are grouped by labels. The playbook
refers to the labeled hosts defined in the hosts file. The `update_production.yml` playbook contains:

```
- hosts: production
  become: true
  roles:
    - naturalis-linnaeus_docker-control
```

So this playbook runs the `naturalis-linnaeus_docker-control` ansible tasks script on the machines listed 
under `linnaeus-docker-test` in the hosts file.

To see what a certain playbook does on which machines you can call the command with `--list-hosts` parameter.
For instance:

```
$ ansible-playbook -i hosts playbooks/update_production.yml --list-hosts

playbook: update_production.yml

  play #1 (linnaeus-docker-test): linnaeus-docker-test	TAGS: []
    pattern: [u'linnaeus-docker-test']
    hosts (3):
      various-003-linnaeustest
      various-002-linnaeustest
      various-001-linnaeustest
```

But you can also limit the playbook to just one of these hosts. By using the _--limit_ or _-l_ parameter:

```
$ ansible-playbook -l various-003-linnaeustest -i hosts playbooks/update_production.yml --become --list-hosts 

playbook: update_production.yml

  play #1 (linnaeus-docker-test): linnaeus-docker-test	TAGS: []
    pattern: [u'linnaeus-docker-test']
    hosts (1):
      various-003-linnaeustest
```

If you run the last command without `--list-hosts` you run the playbook on this machine only. This
will look something like this:


![Animation of ansible playbook running](http://g.recordit.co/1M3195aKQi.gif)



## typical usage recipes

Some common scenarios when dealing with linnaeus installations.

### Updating all linnaeus servers after releasing a new version

This will be most common whenever a new stable release is released.

```
ansible-playbook -u [your username] -i inventory --become playbooks/update_production.yml
```

A playbook can fail on some machines. You should always try again and if the problem persists, check 
the error or increase verbosity '-v', '-vv' or even '-vvv' and then try and fix the issue.

### Updating a single linnaeus server after releasing a new version

This will be done if you just want to test if a certain machine works.

```ansible-playbook -u [your username] -l [exact host name] -i inventory playbooks/update_production.yml```

### Installing a specific version of a linnaeus installation on a certain server

* create a new branch of linnaeus containing your special version
* push it to the linnaeus repository
* log on to the server you want to run a different version on
* change `/opt/docker-linnaeusng/.env', set a different GIT_BRANCH (same to the one you just created)
* logout

```ansible-playbook -u [your username] -l [exact host name] -i inventory playbooks/update_production.yml```

### Completely reinstall a certain linnaeus installation

First time setups will contain linnaeus installations that do not work or just contain empty versions
of linnaeus. With these steps you can setup a new machine in minutes.

* `scp` a recent mysql dump of a linnaeus installation to the server
* log on to the server you want to reinstall
* become root (_sudo su_)
* `rm /data/linnaeus/4_new_project_and_user.sql`
* `echo "USE linnaeus_ng" > /data/linnaeus/4_linnaeusdb.sql`
* `cat /path/to/your/recent/dump.sql >> /data/linnaeus/4_linnaeusdb.sql`
* `rm -rf /data/linnaeus/www`
* logout

```ansible-playbook -u [your username] -l [exact host name] -i inventory playbooks/update_production.yml```

This will rebuild the docker configuration as well as reinstall linnaeus and load the database.

### Only running one group of tasks on one machine using _-t_

```ansible-playbook -u [your username] -l [exact host name] -t code -i inventory playbooks/update_production.yml```

If you only want to run the task tagged 'code' on one host.



### Assorted oneliners

You can also use ansible one-liners without the playbooks. Useful for one off updates.

```
 ansible test -u joep.vermaat -i inventory -m shell -b -a 'cd /opt/docker-linnaeusng;git fetch origin development:development;git checkout development
```


Fetch and checkout the new development branch on the test machines.

```
ansible test-001 -u joep.vermaat -i inventory -m shell -b -a 'cd /opt/docker-linnaeusng;docker-compose down;docker-compose up -d'
```

Shutdown and start the docker-compose environment.

```
 ansible test -u joep.vermaat -i inventory -m shell -b -a 'cd /opt/docker-linnaeusng;docker-compose exec -T linnaeus git pull origin development
```

Fetch and checkout the development branch of the code.


```
ansible test -u joep.vermaat -i inventory -m shell -b -a '/bin/bash -c "cd /opt/docker-linnaeusng;docker-compose exec -T linnaeus tools/scripts/gulp.sh"'
```

Run the frontend compiler scripts.
