## User / Group Identifiers
Sometimes when using data volumes (`-v` flags) permissions issues can arise between the host OS and the container. We avoid this issue by allowing you to specify the user `PUID` and optionally the group `PGID`. Ensure the data volume directory on the host is owned by the same user you specify and it will "just work" ™.

An example of mapping the UID and GID to the container is as follows:
```
docker run -d -e "PUID=`id -u $USER`" -e "PGID=`id -g $USER`" -v local_dir:/var/www/html richarvey/nginx-php-fpm:latest
```
This will pull your local UID/GID and map it into the container so you can edit on your host machine and the code will still run in the container.
