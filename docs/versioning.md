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

| Docker Tag | GitHub Release | Nginx Version | PHP Version | Alpine Version | Container Scripts |
|-----|-------|-----|--------|--------|--------|
| latest | Master Branch |1.11.10 | 7.1.2 | 3.4 | 0.2.6 |
| 1.1.1 | 1.1.1 |1.11.9 | 7.1.1 | 3.4 |  0.2.5 |
| 1.1.2 | 1.1.2 |1.11.10 | 7.1.1 | 3.4 |  0.2.6 |
| 1.1.3 | 1.1.3 |1.11.10 | 7.1.2 | 3.4 |  0.2.6 |
| 1.1.4 | 1.1.4 |1.11.10 | 7.1.2 | 3.4 |  0.2.6 |
| 1.1.5 | 1.1.5 |1.11.10 | 7.1.2 | 3.4 |  0.2.7 |
| 1.1.6 | 1.1.6 |1.11.10 | 7.1.2 | 3.4 |  0.2.8 |
| 1.2.0 | 1.2.0 |1.12.10 | 7.1.3 | 3.4 |  0.2.9 |
| 1.2.1 | 1.2.1 |1.13.1 | 7.1.6 | 3.4 | 0.2.9 | 

These tags will be created as releases on GitHub and as tags in docker hub.

### Unmaintained tags:

- php5
- php7
