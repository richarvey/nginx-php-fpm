## Introduction
This is a Dockerfile to build a container image for nginx and php-fpm, with the ability to pull website code from git. The container can also use environment variables to configure your web application using the templating detailed in the [special features](#special-features) section.
## Version
- Mainline Version: **1.7.9**
- Stable Version: **1.6.2**
- *Latest = Mainline Version*
## Installation
Pull the image from the docker index rather than downloading the git repo. This prevents you having to build the image on every docker host.
```bash
docker pull richarvey/nginx-pfp-fpm:latest
```
To pull the Stable Version:
```bash
docker pull richarvey/nginx-pfp-fpm:stable
```
## Running
To simply run the container:
```bash
sudo docker run --name nginx -p 8080:80 -d richarvey/nginx-php-fpm
```
You can then browse to http://<docker_host>:8080 to view the default install files.
### Volumes
If you want to link to your web site directory on the docker host to the container run:
```bash
sudo docker run --name nginx -p 8080:80 -v /your_code_directory:/usr/share/nginx/html -d richarvey/nginx-php-fpm
```
### Pulling code from git
One of the nice features of this container is its ability to pull code from a git repository with a couple of environmental variables passed at run time.
**Note:** You need to have your SSH key that you use with git to enable the deployment. I recommend using a special deploy key per project to minimise the risk.
To run the container and pull code simply specify the GIT_REPO URL including *git@* and then make sure you have a folder on the docker host with your id_rsa key stored in it:
```bash
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git'  -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```
To pull a repository and specify a branch add the GIT_BRANCH environment variable:
```bash
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'GIT_BRANCH=stage' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```
### Linking
Linking to containers also exposes the linked container environment variables which is useful for [templating](#templating) and configuring web apps:
Run MySQL container with some extra details:
```bash
sudo docker run --name some-mysql -e MYSQL_ROOT_PASSWORD=yayMySQL -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wordpress_user -e MYSQL_PASSWORD=wordpress_password -d mysql
```
This exposes the following environment variables to the container when linked:
```
MYSQL_ENV_MYSQL_DATABASE=wordpress
MYSQL_ENV_MYSQL_ROOT_PASSWORD=yayMySQL
MYSQL_PORT_3306_TCP_PORT=3306
MYSQL_PORT_3306_TCP=tcp://172.17.0.236:3306
MYSQL_ENV_MYSQL_USER=wordpress_user
MYSQL_ENV_MYSQL_PASSWORD=wordpress_password
MYSQL_ENV_MYSQL_VERSION=5.6.22
MYSQL_NAME=/sick_mccarthy/mysql
MYSQL_PORT_3306_TCP_PROTO=tcp
MYSQL_PORT_3306_TCP_ADDR=172.17.0.236
MYSQL_ENV_MYSQL_MAJOR=5.6
MYSQL_PORT=tcp://172.17.0.236:3306
```
To link the container launch like this:
```bash
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 --link some-mysql:mysql -d richarvey/nginx-php-fpm
```
## Special Features
### Templating
This container will automatically configure your web application if you template your code. For example if you are linking to MySQL like above, and you have a config.php file where you need to set the MySQL details include $$_MYSQL_ENV_MYSQL_DATABASE_$$ style template tags. Example:
```php
<?php
database_name = $$_MYSQL_ENV_MYSQL_DATABASE_$$;
database_host = $$_MYSQL_PORT_3306_TCP_ADDR_$$;
...
?>
```
### Using environment variables
If you want to link to an external MySQL DB and not using linking you can pass variables directly to the container that will be automatically configured by the container.
Example:
```bash
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'GIT_BRANCH=stage' -e 'MYSQL_HOST=host.x.y.z' -e 'MYSQL_USER=username' -e 'MYSQL_PASS=password' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```
This will expose the following variables that can be used to template your code.
```
MYSQL_HOST=host.x.y.z
MYSQL_USER=username
MYSQL_PASS=password
```
To use these variables in a template you'd do the following in your file:
```php
<?php
database_host = $$_MYSQL_HOST_$$;
database_user = $$_MYSQL_USER_$$;
database_pass = $$_MYSQL_PASS_$$
...
?>
```
### Template anything
Yes ***ANYTHING***, any variable exposed by a linked container or the **-e** flag lets you template your config files. This means you can add redis, mariaDB, memcache or anything you want to your application very easily.
