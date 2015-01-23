Digital Paper deploy
==================
The base vagrant setup is derived for the applications Agilefreaks creates. Uses Digital Ocean, Newrelic, Ruby, Nginx, Mongo.

Requirement
-----------
- [vagrant](https://www.vagrantup.com/)
- [virtual box](https://www.virtualbox.org/)

Run
---
Ensure your key is added to the ssh agent

```sh
ssh-add ~/.ssh/id_rsa
```

Edit the `Vagrantfile` line `37` and add your repo, for example

```
repo_path: 'git@github.com:someusername/somerepo.git'
```

Start your machine (have patience this might take a wile)
```sh
  $ vagrant up web
```  

It will create a default user `deploy` as per capistrano requerments

Navigate to `http://locahost:3000`

Destroy
--------
```sh
  $ vagrant destory web
```

Bonus
-----
There is a nginx websockets class in case you need one.

Notes
-----
This repo contains submodules so be sure to:

```sh
  $ git clone --recursive git@github.com:samchao/digital-paper-vagrant.git
```
