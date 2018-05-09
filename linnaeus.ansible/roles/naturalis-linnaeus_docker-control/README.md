Role Name
=========

This role is based on [naturalis-linnaeus_ng-control](https://github.com/naturalis/linnaeus_ng_control/tree/master/linnaeus.ansible/roles/naturalis-linnaeus_ng-control) written by Maarten and Atze. It handles similar
tasks but on dockerized installs.

Requirements
------------

To run this playbook docker and docker-composer must be installed on the host machine. The 
installation is typically located in `/opt/docker-linnaeusng` which should contain clone of
https://github.com/naturalis/docker-linnaeusng


Role Variables
--------------

There are no role variables defined atm. This may in future be used to make the ansible playbook more 
versatile and flexible.


Example Playbook
----------------

Running the playbook on the test docker hosts.

    - hosts: linnaeus-docker-test
      roles:
        - naturalis-linnaeus_docker-control
Tasks
-----

This playbook runs the following tasks in order, see [main.yml](https://github.com/naturalis/linnaeus_ng_control/blob/master/linnaeus.ansible/roles/naturalis-linnaeus_docker-control/tasks/main.yml).


First show some information about the host machine

* Show the disk remaining space
* Display the OS version

The handle the preliminaries (tag: preliminaries)

* Install essential python en mysql packages for ansible and python
* Install MySQL pip package
* Install Docker py
* Check '/data/linnaeus' directory
* Add the initdb directory in /data/linnaeus
* Copy the content of a default linnaeus install into initdb
* Create and copy mysqlconf directory if it does not exist
* Check if the git directory exists
* Install the dockerized linnaeus install by pulling 'naturalis/linnaeus' and (re)creating the docker compose setup
* Wait for docker-composer to complete (it will also pull linnaeus from github)

Handle code stuff (tag: code)

* Pull the most recent version of the git branch specified in .env
* Run composer install for the needed third party php libraries
* Run npm, bower and gulp for installing all third party javascript and css, and creating a bundle

Handle database stuff (tag: database)

* Create tools and backup directories if the do not exist
* Compare the database model and create a migration if there are differences
* Check if the migration mysql file exists
* Backup the complete database, if there is a migration
* Importing the update.sql containing essential trait types and translations
* Set the common settings if they are missing
* Import the database migration
* Check for errors

Docker stability (tag: docker)

* Ensure if the docker image is running



License
-------

BSD

Author Information
------------------

Written by joep.vermaat@naturalis.nl, based on work by maarten.schermer@naturalis.nl
