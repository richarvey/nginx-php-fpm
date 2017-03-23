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
