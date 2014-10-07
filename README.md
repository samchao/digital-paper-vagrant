Agilefreaks deploy
==================
The base vagrant setup for the applications Agilefreaks creates. Uses Digital Ocean, Newrelic, Ruby, Nginx, Mongo.

Requirement
-----------
- Your favorite provider. For digitalocean provider: 
```sh
  $ vagrant plugin install vagrant-digitalocean)
```
- vagrant-triggers
```sh
  $ vagrant plugin install vagrant-triggers
```
- DIGITAL_OCEAN_TOKEN
```sh
  $ export  DIGITAL_OCEAN_TOKEN = '<your token>'
```
- DIGITAL_SSH_KEY_NAME
- DIGITAL_SSH_KEY_NAME
- NEWRELIC_LICENSE_KEY
- set facter with your settings

Recommended setup
-----------
- Create an admin machine add it to the dns and run the vagrant scripts from there

Run
---
```sh
  $ vagrant up --provider=digital_ocean
```  
  or
```sh
  $ vagrant up <vm_name> --provider=digital_ocean
```
It will create a defailt user `deploy` as per capistrano requerments

Destroy
--------
```sh
  $ vagrant destory --force
```
  or
```sh
  $ vagrant destroy <vm_name> --force
```

If you're trying to wipe out the whole setup do it like this so that triggers
do not fail when not being able to remove the only remaining LB machine.

```sh
  $ VAGRANT_NO_TRIGGERS="" vagrant destroy
```

Bonus
-----
There is a nginx websockets class in case you need one.

Notes
-----
Depending on your provider you might need to update the mongo class from the `init.pp` file to use the proper `eth`.

This repo contains submodules so be sure to:
```sh
  $ git clone --recursive git://github.com/foo/bar.gi
```
