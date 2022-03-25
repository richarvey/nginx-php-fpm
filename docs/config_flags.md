## Available Configuration Parameters
The following flags are a list of all the currently supported options that can be changed by passing in the variables to docker with the -e flag.

### Git

| Name               | Description                                                                                                                                                                                                                |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| GIT_REPO           | URL to the repository containing your source code. If you are using a personal token, this is the https URL without `https://` (e.g `github.com/project/`). For ssh prepend with `git@` (e.g `git@github.com/project.git`) |
| GIT_BRANCH         | Select a specific branch (optional)                                                                                                                                                                                        |
| GIT_TAG            | Specify a specific git tag (optional)                                                                                                                                                                                      |
| GIT_COMMIT         | Specify a specific git commit (optional)                                                                                                                                                                                   |
| GIT_EMAIL          | Set your email for code pushing (required for git to work)                                                                                                                                                                 |
| GIT_NAME           | Set your name for code pushing (required for git to work)                                                                                                                                                                  |
| GIT_USE_SSH        | Set this to 1 if you want to use git over SSH (instead of HTTP), useful if you want to use Bitbucket instead of GitHub                                                                                                     |
| SSH_KEY            | Private SSH deploy key for your repository base64 encoded (requires write permissions for pushing)                                                                                                                         |
| GIT_PERSONAL_TOKEN | Personal access token for your git account (required for HTTPS git access)                                                                                                                                                 |
| GIT_USERNAME       | Git username for use with personal tokens. (required for HTTPS git access)                                                                                                                                                 |

### Others

| Name                    | Description                                                                                                    |
|-------------------------|----------------------------------------------------------------------------------------------------------------|
| OPcache		  | Set to 1 to disable opcache (enabled by default)                                                               |
| WEBROOT                 | Change the default webroot directory from `/var/www/html` to your own setting                                  |
| ERRORS                  | Set to 1 to display PHP Errors in the browser                                                                  |
| HIDE_NGINX_HEADERS      | Disable by setting to 0, default behaviour is to hide nginx + php version in headers                           |
| PHP_CATCHALL            | Enable a 404 catch all to `index.php` -- changes `=404` on `try_files` to `/index.php?$args`                   |
| PHP_MEM_LIMIT           | Set higher PHP memory limit, default is 128 Mb                                                                 |
| PHP_POST_MAX_SIZE       | Set a larger post_max_size, default is 100 Mb                                                                  |
| PHP_UPLOAD_MAX_FILESIZE | Set a larger upload_max_filesize, default is 100 Mb                                                            |
| PHP_ERRORS_STDERR       | Send php logs to docker logs                                                                                   |
| DOMAIN                  | Set domain name for Lets Encrypt scripts                                                                       |
| REAL_IP_HEADER          | set to 1 to enable real ip support in the logs                                                                 |
| REAL_IP_FROM            | set to your CIDR block for real ip in logs                                                                     |
| RUN_SCRIPTS             | Set to 1 to execute scripts                                                                                    |
| SCRIPTS_DIR             | Change default scripts dir from `/var/www/html/scripts` to your own setting                                    |
| PGID                    | Set to GroupId you want to use for nginx (helps permissions when using local volume)                           |
| PUID                    | Set to UserID you want to use for nginx (helps permissions when using local volume)                            |
| REMOVE_FILES            | Use REMOVE_FILES=0 to prevent the script from clearing out /var/www/html (useful for working with local files) |
| APPLICATION_ENV         | Set this to development to prevent composer deleting local development dependencies                            |
| SKIP_CHOWN              | Set to 1 to avoid running chown -Rf on /var/www/html                                                           |
| SKIP_CHMOD              | Set to 1 to avoid running chmod -Rf 750 on `SCRIPTS_DIR`                                                       |
| SKIP_COMPOSER           | Set to 1 to avoid installing composer                                                                          |
