## Install PHP Modules
To install and configure extra PHP modules in this image, first of all drop into the container:
```
docker exec -t -i nginx /bin/bash
```
Then configure and install your module:
```
/usr/local/bin/docker-php-ext-configure sockets
/usr/local/bin/docker-php-ext-install sockets
```
Now restart php-fpm:
```
supervisorctl restart php-fpm
```

We may include a env var to do this in the future.

## Extensions already installed
The following are already installed and ready to use:

| `docker-php-ext-`name | Description 
|----|----|
| curl | cURL: command line tool and library for transferring data with URLs
| dom | **DOM**-manipulation library 
| gd | **GD**: Image creation and manipulation library 
| intl | **Internationalization** (i18n) function library 
| mysqli | **MySQL Improved**: Procedural-style  library for connecting to and using a MySQL database
| opcache | **OPcache**: Improves PHP performace by storing precompiled script bytecode in shared memory 
| pdo | **PDO**: PHP Database Object; Object-oriented library for connecting to various databases.
| pdo_mysql | **MySQL Driver** for PDO
| pdo_sqlite | **SQLite Driver** for PDO
| soap | **SOAP**: **S**imple **O**bject **A**ccess **P**rotocol library
| xsl | **XSL**: e**X**stensible **S**tyling **L**anguage library
| zip | **ZIP**: Transparently read and write ZIP compressed archives
