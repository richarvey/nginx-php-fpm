Very little configuration here -- we've added some post-run commands to the dockerfile, and overwritten some config for Drupal development.

Most configuraton is handled by the fork source at https://github.com/richarvey/nginx-php-fpm

To build locally from the Dockerfile run:
`docker build . -f Dockerfile`

You should now have a built docker image, and you can get its info like this:

`docker image ls`

that should give you something like this:
```
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
<none>       <none>    018305e0e124   10 minutes ago   1.05GB
```

To run a container built from the image built from the Dockerfile, run:

`docker run -td <The IMAGE ID, aka 018305e0e124 above>`

The ID of the container will be returned and run in the background. If you need to get it later, you can run:

`docker container ls`

You can use bash on the image to test out commands for the dockerfile by using:

`docker exec -it <The CONTAINER ID> /bin/bash`
