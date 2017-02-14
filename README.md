[![Travis](https://img.shields.io/docker/pulls/richarvey/nginx-php-fpm.svg?style=flat-square)]()
[![Travis](https://img.shields.io/docker/stars/richarvey/nginx-php-fpm.svg?style=flat-square)]()
[![Travis](https://img.shields.io/travis/ngineered/nginx-php-fpm.svg?style=flat-square)]()

## Overview
This is a Dockerfile/image to build a container for nginx and php-fpm, with the ability to pull website code from git when the container is created, as well as allowing the container to push and pull changes to the code to and from git. The container also has the ability to update templated files with variables passed to docker in order to update your code and settings. There is support for lets encrypt SSL configurations, custom nginx configs, core nginx/PHP variable overrides for running preferences, X-Forwarded-For headers and UID mapping for local volume support.

If you have improvements or suggestions please open an issue or pull request on the GitHub project page.

### Versions
| Tag | Nginx | PHP | Alpine |
|-----|-------|-----|--------|
| latest | 1.11.9 | 7.1.1 | 3.4 |
| php71  | 1.11.9 | 7.1.1 | 3.4 |

### Links
- [https://github.com/ngineered/nginx-php-fpm](https://github.com/ngineered/nginx-php-fpm)
- [https://registry.hub.docker.com/u/richarvey/nginx-php-fpm/](https://registry.hub.docker.com/u/richarvey/nginx-php-fpm/)

## Running
To pull from docker hub:
```
docker pull richarvey/nginx-php-fpm:latest
```
### Starting
To simply run the container:
```
sudo docker run -d richarvey/nginx-php-fpm
```
You can then browse to ```http://<DOCKER_HOST>``` to view the default install files. To find your ```DOCKER_HOST``` use the ```docker inspect``` to get the IP address (normally 172.17.0.2)

To pull code from git when running:
```
docker run -d -e 'GIT_EMAIL=email_address' -e 'GIT_NAME=full_name' -e 'GIT_USERNAME=git_username' -e 'GIT_REPO=github.com/project' -e 'GIT_PERSONAL_TOKEN=<long_token_string_here>' richarvey/nginx-php-fpm:latest
```

For more detailed examples and explanations please refer to the documentation.

## Available Configuration Parameters
The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

 - **GIT_REPO** : URL to the repository containing your source code. If you are using a personal token, this is the https URL without https://, e.g github.com/project/ for ssh prepend with git@ e.g git@github.com:project.git
 - **GIT_BRANCH** : Select a specific branch (optional)
 - **GIT_EMAIL** : Set your email for code pushing (required for git to work)
 - **GIT_NAME** : Set your name for code pushing (required for git to work)
 - **GIT_USE_SSH** : Set this to 1 if you want to use git over SSH (instead of HTTP), useful if you want to use Bitbucket instead of GitHub
 - **SSH_KEY** : Private SSH deploy key for your repository base64 encoded (requires write permissions for pushing)
 - **GIT_PERSONAL_TOKEN** : Personal access token for your git account (required for HTTPS git access)
 - **GIT_USERNAME** : Git username for use with personal tokens. (required for HTTPS git access)
 - **WEBROOT** : Change the default webroot directory from `/var/www/html` to your own setting
 - **ERRORS** : Set to 1 to display PHP Errors in the browser
 - **HIDE_NGINX_HEADERS** : Disable by setting to 0, default behaviour is to hide nginx + php version in headers
 - **PHP_MEM_LIMIT** : Set higher PHP memory limit, default is 128 Mb
 - **PHP_POST_MAX_SIZE** : Set a larger post_max_size, default is 100 Mb
 - **PHP_UPLOAD_MAX_FILESIZE** : Set a larger upload_max_filesize, default is 100 Mb
 - **DOMAIN** : Set domain name for Lets Encrypt scripts
 - **REAL_IP_HEADER** : set to 1 to enable real ip support in the logs
 - **REAL_IP_FROM** : set to your CIDR block for real ip in logs
 - **RUN_SCRIPTS** : Set to 1 to execute scripts
 - **PGID** : Set to GroupId you want to use for nginx (helps permissions when using local volume)
 - **PUID** : Set to UserID you want to use for nginx (helps permissions when using local volume)

## Documentation

- [Building from source](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/building.md)
- [Git Auth](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/git_auth.md)
 - [Personal Access token](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/git_auth.md#personal-access-token)
 - [SSH Keys](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/git_auth.md#ssh-keys)
- [Git Commands](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/git_commands.md)
 - [Push](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/git_commands.md#push-code-to-git)
 - [Pull](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/git_commands.md#pull-code-from-git-refresh)
- [Repository layout / webroot](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/repo_layout.md)
 - [webroot](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/repo_layout.md#src--webroot)
- [User / Group Identifiers](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/UID_GID_Mapping.md)
- [Custom Nginx Config files](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/nginx_configs.md)
 - [REAL IP / X-Forwarded-For Headers](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/nginx_configs.md#real-ip--x-forwarded-for-headers)
- [Scripting and Templating](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/scripting_templating.md)
 - [Environment Variables](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/scripting_templating.md#using-environment-variables--templating)
- [Lets Encrypt Support](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/lets_encrypt.md)
 - [Setup](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/lets_encrypt.md#setup)
 - [Renewal](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/lets_encrypt.md#renewal)
- [PHP Modules](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/php_modules.md)
- [Logging and Errors](https://github.com/ngineered/nginx-php-fpm/blob/master/docs/logs.md)
