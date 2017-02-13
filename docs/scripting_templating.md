## Scripting
There is often an occasion where you need to run a script on code to do a transformation once code lands in the container. For this reason we have developed scripting support. By including a scripts folder in your git repository and passing the __RUN_SCRIPTS=1__ flag to your command line the container will execute your scripts. Please see the [repo layout guidelines](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/repo_layout.md) for more details on how to organise this.

## Using environment variables / templating
To set the variables pass them in as environment variables on the docker command line.
Example:
```
sudo docker run -d -e 'YOUR_VAR=VALUE' richarvey/nginx-php-fpm
```
You can then use PHP to get the environment variable into your code:
```
string getenv ( string $YOUR_VAR )
```
Another example would be:
```
<?php
echo $_ENV["APP_ENV"];
?>
```
