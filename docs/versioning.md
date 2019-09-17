## Versioning
We are now introducing versioning so users can stick to specific versions of software. As we are dealing with three upstream sources (nginx, php and alpine) plus our own scripts this all gets a little complex, but this document will provide a definitive source of tags and versions.

We will use the [semver](http://ricostacruz.com/cheatsheets/semver.html) style notation for versioning:

>This follows the format MAJOR.MINOR.PATCH (eg, 1.2.6)
>
- MAJOR version changes to nginx, php-fpm, alpine or potential breaking feature changes
- MINOR version changes to nginx, php-fpm or scripts that are still backwards-compatible with previous versions
- PATCH version minor changes and bug fixes

### Current versions and tags

The latest tag will always follow the master branch in git. the other versions will have releases attached.

#### PHP 7.3

| Docker Tag | PHP Version | Nginx Version | Alpine Version | Container Scripts | Notes |
|-----|-------|-----|--------|--------|----------|
| 1.6.0 | 7.3.2 |1.14.2 | 3.9 | 0.3.8 ||
| 1.6.1 | 7.3.2 |1.14.2 | 3.9 | 0.3.9 ||
| 1.6.2 | 7.3.3 |1.14.2 | 3.9 | 0.3.10 ||
| 1.6.3 | 7.3.3 |1.14.2 | 3.9 | 0.3.11 ||
| 1.6.4 | 7.3.3 |1.14.2 | 3.9 | 0.3.12 ||
| 1.6.5 | 7.3.3 |1.14.2 | 3.9 | 0.3.12 ||
| 1.6.6 | 7.3.3 |1.14.2 | 3.9 | 0.3.12 ||
| 1.6.7 | 7.3.3 |1.14.2 | 3.9 | 0.3.13 | Broken |
| 1.6.8 | 7.3.4 |1.14.2 | 3.9 | 0.3.12 | Custom scripts rolled back |
| 1.7.0 | 7.3.4 |1.16.0 | 3.9 | 0.3.12 | First move to nginx 1.16.0 |
| 1.7.1 | 7.3.5 |1.16.0 | 3.9 | 0.3.12 | Bump to PHP 7.3.5 |
| 1.7.2 | 7.3.6 |1.16.0 | 3.9 | 0.3.12 | Bump to PHP 7.3.6 |
| 1.7.3 | 7.3.6 |1.16.0 | 3.9 | 0.3.12 | Bump xdebug 2.7.2 |
| 1.7.4 | 7.3.8 |1.16.0 | 3.9 | 0.3.12 | upgrade php to 7.3.8 |
| 1.8.0 | 7.3.9 |1.16.1 | 3.10 | 0.3.12 | Alpine upgrade to 3.10, PHP 7.3.9 and nginx 1.16.1 upgrades |
| 1.8.1 | 7.3.9 |1.16.1 | 3.10 | 0.3.12 | started python upgrade |
| 1.8.2 | 7.3.9 |1.16.1 | 3.10 | 0.3.13 | geoip2, catchall and xdebug.remote merges |

These tags will be created on GitLab and as tags in docker hub.

### Unmaintained tags:
#### PHP 7.2

| Docker Tag | PHP Version | Nginx Version | Alpine Version | Container Scripts |
|-----|-------|-----|--------|--------|
| 1.4.0 | 7.2.0 |1.13.2 | 3.6 | 0.3.5 |
| 1.4.1 | 7.2.0 |1.13.2 | 3.6 | 0.3.6 |
| 1.5.0 | 7.2.4 |1.14.0 | 3.6 | 0.3.6 |
| 1.5.1 | 7.2.6 |1.14.0 | 3.7 | 0.3.6 |
| 1.5.2 | 7.2.6 |1.14.0 | 3.7 | 0.3.7 |
| 1.5.3 | 7.2.7 |1.14.0 | 3.7 | 0.3.7 |
| 1.5.4 | 7.2.7 |1.14.0 | 3.7 | 0.3.8 |
| 1.5.5 | 7.2.10 |1.14.0 | 3.7 | 0.3.8 |
| 1.5.6 | 7.2.9 |1.14.0 | 3.7 | 0.3.8 |
| 1.5.7 | 7.2.10 |1.14.0 | 3.7 | 0.3.8 |

#### PHP 7.1

| Docker Tag | Git Release | Nginx Version | PHP Version | Alpine Version | Container Scripts |
|-----|-------|-----|--------|--------|--------|
| latest | Master Branch |1.13.2 | 7.1.7 | 3.4 | 0.2.9 |
| 1.1.1 | 1.1.1 |1.11.9 | 7.1.1 | 3.4 |  0.2.5 |
| 1.1.2 | 1.1.2 |1.11.10 | 7.1.1 | 3.4 |  0.2.6 |
| 1.1.3 | 1.1.3 |1.11.10 | 7.1.2 | 3.4 |  0.2.6 |
| 1.1.4 | 1.1.4 |1.11.10 | 7.1.2 | 3.4 |  0.2.6 |
| 1.1.5 | 1.1.5 |1.11.10 | 7.1.2 | 3.4 |  0.2.7 |
| 1.1.6 | 1.1.6 |1.11.10 | 7.1.2 | 3.4 |  0.2.8 |
| 1.2.0 | 1.2.0 |1.12.10 | 7.1.3 | 3.4 |  0.2.9 |
| 1.2.1 | 1.2.1 |1.13.1 | 7.1.6 | 3.4 | 0.2.9 | 
| 1.2.2 | 1.2.2 |1.13.2 | 7.1.7 | 3.4 | 0.2.9 | 
| 1.2.3 | 1.2.3 |1.13.3 | 7.1.7 | 3.4 | 0.2.9 | 
| 1.2.4 | 1.2.4 |1.13.4 | 7.1.8 | 3.4 | 0.2.9 | 
| 1.2.5 | 1.2.5 |1.13.4 | 7.1.8 | 3.4 | 0.2.10 | 
| 1.2.6 | 1.2.6 |1.13.4 | 7.1.8 | 3.4 | 0.2.11 | 
| 1.3.0 | 1.3.0 |1.13.4 | 7.1.8 | 3.4 | 0.3.0 | 
| 1.3.1 | 1.3.1 |1.13.4 | 7.1.8 | 3.4 | 0.3.1 | 
| 1.3.2 | 1.3.2 |1.13.4 | 7.1.8 | 3.4 | 0.3.2 | 
| 1.3.3 | 1.3.3 |1.13.4 | 7.1.9 | 3.4 | 0.3.2 | 
| 1.3.4 | 1.3.4 |1.13.4 | 7.1.9 | 3.4 | 0.3.3 | 
| 1.3.5 | 1.3.5 |1.13.5 | 7.1.9 | 3.4 | 0.3.3 | 
| 1.3.6 | 1.3.6 |1.13.5 | 7.1.10 | 3.4 | 0.3.3 | 
| 1.3.7 | 1.3.7 |1.13.6 | 7.1.10 | 3.4 | 0.3.3 | 
| 1.3.8 | 1.3.8 |1.13.6 | 7.1.11 | 3.4 | 0.3.3 | 
| 1.3.9 | 1.3.9 |1.13.7 | 7.1.11 | 3.4 | 0.3.3 | 
| 1.3.10 | 1.3.10 |1.13.7 | 7.1.12 | 3.4 | 0.3.4 | 

### Legacy tags:

- php5
- php7
