## Introduction
This is a Dockerfile to build a container image for nginx and php-fpm, with the ability to pull website code from git. The container can also use environment variables to configure your web application using the templating detailed in the special features section.
### Git repository
The source files for this project can be found here: [https://github.com/ngineered/nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm)

If you have any improvements please submit a pull request.
### Docker hub repository
The Docker hub build can be found here: [https://registry.hub.docker.com/u/richarvey/nginx-php-fpm/](https://registry.hub.docker.com/u/richarvey/nginx-php-fpm/)
## Versions

| Tag    | nginx  | PHP               | Ubuntu  |
|--------|--------|-------------------|---------|
| latest | 1.9.12 | 5.5.9-1ubuntu4.14 | 14.04.4 |
| beta56 | 1.9.11 | 5.6               | 16.04   |
| beta70 | 1.9.11 | 7.0               | 16.04   |

## Building from source
To build from source you need to clone the git repo and run docker build:
```
git clone https://github.com/ngineered/nginx-php-fpm.git
docker build -t richarvey/nginx-php-fpm:latest .
```
## Pulling from Docker Hub
Pull the image from docker hub rather than downloading the git repo. This prevents you having to build the image on every docker host:
```
docker pull richarvey/nginx-php-fpm:latest
```
## Running
To simply run the container:
```
sudo docker run --name nginx -p 8080:80 -d richarvey/nginx-php-fpm
```
You can then browse to ```http://<DOCKER_HOST>:8080``` to view the default install files.
### Volumes
If you want to link to your web site directory on the docker host to the container run:
```
sudo docker run --name nginx -p 8080:80 -v /your_code_directory:/usr/share/nginx/html -d richarvey/nginx-php-fpm
```
### Dynamically Pulling code from git
One of the nice features of this container is its ability to pull code from a git repository with a couple of environmental variables passed at run time.

**Note:** You need to have your SSH key that you use with git to enable the deployment. I recommend using a special deploy key per project to minimise the risk.

To run the container and pull code simply specify the GIT_REPO URL including *git@* and then make sure you have a folder on the docker host with your id_rsa key stored in it:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git'  -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```
To pull a repository and specify a branch add the GIT_BRANCH environment variable:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'GIT_BRANCH=stage' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```
### Linking
Linking to containers also exposes the linked container environment variables which is useful for templating and configuring web apps.

Run MySQL container with some extra details:
```
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
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 --link some-mysql:mysql -d richarvey/nginx-php-fpm
```
### Enabling SSL or Special Nginx Configs
As with all docker containers its possible to link resources from the host OS to the guest. This makes it really easy to link in custom nginx default config files or extra virtual hosts and SSL enabled sites. For SSL sites first create a directory somewhere such as */opt/deployname/ssl/*. In this directory drop you SSL cert and Key in. Next create a directory for your custom hosts such as  */opt/deployname/sites-enabled*. In here load your custom default.conf file which references your SSL cert and keys at the location, for example:  */etc/nginx/ssl/xxxx.key*

Then start your container and connect these volumes like so:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -v /opt/ngddeploy/:/root/.ssh -v /opt/deployname/ssl:/etc/nginx/ssl -v /opt/deployname/sites-enabled:/etc/nginx/sites-enabled -p 8080:80 --link some-mysql:mysql -d richarvey/nginx-php-fpm
```
## Special Features

### Push code to Git
To push code changes back to git simply run:
```
sudo docker exec -t -i <CONATINER_NAME> /usr/bin/push
```
### Pull code from Git (Refresh)
In order to refresh the code in a container and pull newer code form git simply run:
```
sudo docker exec -t -i <CONTAINER_NAME> /usr/bin/pull
```
### Install Extra Modules
If you wish to install extras at boot time, such as extra php modules you can specify this by adding the DEBS flag, to add multiple packages you need to space separate the values:
```
sudo docker run --name nginx -e 'DEBS=php5-mongo php-json" -p 8080:80 -d richarvey/nginx-php-fpm
```
### Templating
This container will automatically configure your web application if you template your code. For example if you are linking to MySQL like above, and you have a config.php file where you need to set the MySQL details include $$_MYSQL_ENV_MYSQL_DATABASE_$$ style template tags.

Example:
```
<?php
database_name = $$_MYSQL_ENV_MYSQL_DATABASE_$$;
database_host = $$_MYSQL_PORT_3306_TCP_ADDR_$$;
...
?>
```
### Using environment variables
If you want to link to an external MySQL DB and not using linking you can pass variables directly to the container that will be automatically configured by the container.

Example:
```
sudo docker run -e 'GIT_REPO=git@git.ngd.io:ngineered/ngineered-website.git' -e 'GIT_BRANCH=stage' -e 'MYSQL_HOST=host.x.y.z' -e 'MYSQL_USER=username' -e 'MYSQL_PASS=password' -v /opt/ngddeploy/:/root/.ssh -p 8080:80 -d richarvey/nginx-php-fpm
```

This will expose the following variables that can be used to template your code.
```
MYSQL_HOST=host.x.y.z
MYSQL_USER=username
MYSQL_PASS=password
```
To use these variables in a template you'd do the following in your file:
```
<?php
database_host = $$_MYSQL_HOST_$$;
database_user = $$_MYSQL_USER_$$;
database_pass = $$_MYSQL_PASS_$$
...
?>
```
### Enable Templating
In order to speed up boot time templating is now diabled by default, if you wish to enable it simply include the flag below:
```
-e TEMPLATE_NGINX_HTML=1
```
### Template anything
Yes ***ANYTHING***, any variable exposed by a linked container or the **-e** flag lets you template your configuration files. This means you can add redis, mariaDB, memcache or anything you want to your application very easily.

## Logging and Errors

### Logging
All logs should now print out in stdout/stderr and are available via the docker logs command:
```
docker logs <CONTAINER_NAME>
```
### Displaying Errors
If you want to display PHP errors on screen (in the browser) for debugging purposes use this feature:
```
-e ERRORS=1
```
