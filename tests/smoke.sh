#!/bin/sh
set -eu

docker run --rm --network none --env OPcache="${OPcache:-}" --entrypoint sh "$1" -ec '
    test "$(php -r "echo PHP_VERSION;")" = "8.2.35"
    grep -q "^3\.24\." /etc/alpine-release
    php -r '\''foreach (["curl", "dom", "ftp", "gd", "intl", "mysqli", "PDO", "pdo_mysql", "pdo_sqlite", "pgsql", "pdo_pgsql", "exif", "soap", "xsl", "zip", "redis", "mongodb", "xdebug", "Zend OPcache"] as $extension) {
        if (!extension_loaded($extension)) {
            fwrite(STDERR, "Missing extension: $extension\n");
            exit(1);
        }
    }'\''
    php-fpm -t --fpm-config /usr/local/etc/php-fpm.d/www.conf
    nginx -t
    composer --version
    certbot --version
    printf "<?php echo PHP_VERSION, PHP_EOL;" > /var/www/html/smoke.php
    /start.sh &
    service_pid=$!
    trap '\''kill "$service_pid"; wait "$service_pid" || true'\'' EXIT
    for attempt in $(seq 1 30); do
        if curl --fail --silent --dump-header /tmp/smoke-headers http://127.0.0.1/smoke.php > /tmp/smoke-response; then
            test "$(cat /tmp/smoke-response)" = "8.2.35"
            test "$(stat -c %U:%G /var/www/html/smoke.php)" = "nginx:nginx"
            php -r '\''exit(extension_loaded("Zend OPcache") === (getenv("OPcache") === "") ? 0 : 1);'\''
            if grep -qi "^X-Powered-By:" /tmp/smoke-headers; then exit 1; fi
            curl --fail --silent --output /dev/null http://127.0.0.1/logo.png
            test "$(curl --silent --output /dev/null --write-out "%{http_code}" http://127.0.0.1/missing.php)" = "404"
            echo "PHP-FPM / Nginx: OK"
            exit 0
        fi
        sleep 1
    done
    echo "PHP-FPM / Nginx: timeout" >&2
    exit 1
'
