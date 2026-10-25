## Building from source

You need Docker with Buildx and GNU Make. From the repository root:

```sh
make help
make check
```

`make check` builds `nginx-php-fpm:local` and runs two test suites, both with
the external network disabled:

- `make test` checks the PHP and Alpine versions, PHP extensions, the Nginx and
  PHP-FPM configs, Composer, Certbot, a PHP request over HTTP, a static file and
  a 404. It runs twice: with OPcache and with `OPcache=1` (disabled).
- `make test-compat` runs 16 isolated scenarios covering the documented
  environment variables: PHP settings, Xdebug, PUID/PGID, Git, Composer,
  headers, a custom Nginx config, startup scripts, HTTPS and Lua/NDK.

Set the image name with `make check IMAGE=nginx-php-fpm:latest` and the buildx
builder with `BUILDER=<name>`.

The host architecture is built by default. For another one:

```sh
make check PLATFORM=linux/arm64 IMAGE=nginx-php-fpm:arm64
```

Building ARM64 on AMD64 needs QEMU/binfmt; the tests run the image, so they
need emulation too.
