#!/bin/sh
set -eu

if [ "${COMPAT_IN_CONTAINER:-}" != 1 ]; then
    for scenario in extensions settings xdebug uid git-branch git-tag git-commit composer-production composer-development composer-skip composer-failure headers custom-config startup-script https lua; do
        echo "Compatibility: $scenario"
        docker run --rm --network none -i --env COMPAT_IN_CONTAINER=1 \
            --entrypoint sh "${1:?Usage: sh tests/compat.sh IMAGE}" -s -- "$scenario" < "$0"
    done
    exit 0
fi

service_pid=
stop_service() {
    if [ -n "$service_pid" ]; then
        kill "$service_pid" 2>/dev/null || true
        wait "$service_pid" || true
        service_pid=
    fi
}
trap stop_service EXIT

start_service() {
    /start.sh >> /tmp/start.log 2>&1 &
    service_pid=$!
    for attempt in $(seq 1 30); do
        if curl --fail --silent http://127.0.0.1/index.php > /tmp/response; then
            return
        fi
        if ! kill -0 "$service_pid" 2>/dev/null; then
            cat /tmp/start.log
            return 1
        fi
        sleep 1
    done
    cat /tmp/start.log
    return 1
}

printf '<?php echo "fixture-ok";' > /var/www/html/index.php
export COMPOSER_DISABLE_NETWORK=1 COMPOSER_ALLOW_SUPERUSER=1

case "$1" in
    extensions)
        php <<'PHP'
<?php
function check($condition, $message) {
    if (!$condition) {
        file_put_contents('php://stderr', $message . PHP_EOL);
        exit(1);
    }
}
foreach (['redis' => '5.3.7', 'mongodb' => '1.21.12', 'xdebug' => '3.2.1'] as $extension => $version) {
    check(phpversion($extension) === $version, $extension . ' version mismatch');
}
$unicode = 'Привет 世界';
check(extension_loaded('ftp') && function_exists('ftp_ssl_connect'), 'FTP/TLS support missing');
check(iconv('UTF-16LE', 'UTF-8', iconv('UTF-8', 'UTF-16LE', $unicode)) === $unicode, 'iconv Unicode conversion failed');
$image = imagecreatetruecolor(2, 2);
check(imagejpeg($image, '/tmp/fixture.jpg'), 'GD JPEG encoding failed');
$decoded = imagecreatefromjpeg('/tmp/fixture.jpg');
check($decoded !== false && imagesx($decoded) === 2, 'GD JPEG decoding failed');
$db = new PDO('sqlite::memory:');
check($db->query('SELECT 42')->fetchColumn() === 42, 'PDO SQLite failed');
$original = ['text' => 'Привет 世界', 'number' => 42];
$decoded = MongoDB\BSON\toPHP(MongoDB\BSON\fromPHP($original), ['root' => 'array']);
check($decoded === $original, 'MongoDB BSON roundtrip failed');
PHP
        ;;
    settings)
        export WEBROOT=/var/www/html/public PHP_CATCHALL=1
        export PHP_MEM_LIMIT=192 PHP_POST_MAX_SIZE=24 PHP_UPLOAD_MAX_FILESIZE=12
        export ERRORS=1 PHP_ERRORS_STDERR=1 REAL_IP_HEADER=1 REAL_IP_FROM=127.0.0.1/32
        export COMPAT_ENV=passed
        mkdir -p "$WEBROOT"
        cat > "$WEBROOT/index.php" <<'PHP'
<?php
echo json_encode([
    ini_get('memory_limit'), ini_get('post_max_size'), ini_get('upload_max_filesize'),
    ini_get('display_errors'), ini_get('log_errors'), ini_get('error_log'),
    getenv('COMPAT_ENV'), $_SERVER['REMOTE_ADDR'],
]);
PHP
        start_service
        curl --fail --silent -H 'X-Forwarded-For: 198.51.100.7' \
            http://127.0.0.1/missing-route > /tmp/response
        php -r '$actual=json_decode(file_get_contents("/tmp/response"), true);
            $expected=["192M","24M","12M","1","1","/dev/stderr","passed","198.51.100.7"];
            if ($actual !== $expected) {var_export($actual); exit(1);}'
        ;;
    xdebug)
        export ENABLE_XDEBUG=1
        start_service
        php -r 'exit(extension_loaded("xdebug") && ini_get("xdebug.mode") === "debug" ? 0 : 1);' \
            > /tmp/php.log 2>&1
        if grep -iE 'already loaded|Cannot load Xdebug' /tmp/start.log /tmp/php.log; then
            exit 1
        fi
        ;;
    uid)
        export PUID=12345 PGID=12346
        chown -R 12345:12346 /var/www/html
        cat > /var/www/html/index.php <<'PHP'
<?php echo file_put_contents(__DIR__ . '/created.txt', 'written') === 7 ? 'fixture-ok' : 'failed';
PHP
        chown 12345:12346 /var/www/html/index.php
        start_service
        test "$(cat /tmp/response)" = fixture-ok
        test "$(stat -c %u:%g /var/www/html/created.txt)" = 12345:12346
        ;;
    git-*)
        mkdir /tmp/source
        git init -q /tmp/source
        git -C /tmp/source config user.name Fixture
        git -C /tmp/source config user.email fixture@example.invalid
        printf '<?php echo "first";' > /tmp/source/index.php
        git -C /tmp/source add index.php
        git -C /tmp/source commit -qm first
        first_commit=$(git -C /tmp/source rev-parse HEAD)
        git -C /tmp/source tag stable
        git -C /tmp/source checkout -qb testing
        printf '<?php echo "second";' > /tmp/source/index.php
        git -C /tmp/source commit -qam second
        export GIT_REPO=/tmp/source
        expected=first
        case "$1" in
            git-branch) export GIT_BRANCH=testing; expected=second ;;
            git-tag) export GIT_TAG=stable ;;
            git-commit) export GIT_COMMIT="$first_commit" ;;
        esac
        start_service
        test "$(cat /tmp/response)" = "$expected"
        stop_service
        printf '<?php echo "preserved";' > /var/www/html/index.php
        start_service
        test "$(cat /tmp/response)" = preserved
        ;;
    composer-*)
        cat > /var/www/html/composer.json <<'JSON'
{
  "name": "fixture/application",
  "repositories": [
    {"packagist.org": false},
    {"type": "package", "package": {"name": "fixture/runtime", "version": "1.0.0", "type": "metapackage"}},
    {"type": "package", "package": {"name": "fixture/development", "version": "1.0.0", "type": "metapackage"}}
  ],
  "require": {"fixture/runtime": "1.0.0"},
  "require-dev": {"fixture/development": "1.0.0"}
}
JSON
        case "$1" in
            composer-failure|composer-skip)
                php -r '$path="/var/www/html/composer.json";
                    $data=json_decode(file_get_contents($path), true);
                    $data["require"]["ext-compat-missing"]="*";
                    file_put_contents($path, json_encode($data));'
                ;;
        esac
        composer update --no-install --ignore-platform-reqs --no-interaction \
            --working-dir=/var/www/html > /tmp/composer.log 2>&1 || { cat /tmp/composer.log; exit 1; }
        case "$1" in
            composer-failure)
                /start.sh > /tmp/start.log 2>&1 &
                service_pid=$!
                for attempt in $(seq 1 30); do
                    if ! kill -0 "$service_pid" 2>/dev/null; then
                        break
                    fi
                    sleep 1
                done
                if kill -0 "$service_pid" 2>/dev/null; then
                    cat /tmp/start.log
                    exit 1
                fi
                if wait "$service_pid"; then
                    cat /tmp/start.log
                    exit 1
                fi
                service_pid=
                grep -q ext-compat-missing /tmp/start.log
                test ! -f /tmp/supervisord.pid
                echo "Compatibility: composer-failure OK"
                exit 0
                ;;
            composer-skip) export SKIP_COMPOSER=1 ;;
            composer-development) export APPLICATION_ENV=development ;;
        esac
        start_service
        test "$(cat /tmp/response)" = fixture-ok
        if [ "$1" = composer-skip ]; then
            test ! -d /var/www/html/vendor
        else
            php -r '$data=json_decode(file_get_contents("/var/www/html/vendor/composer/installed.json"), true);
                $names=array_column($data["packages"], "name");
                $dev=getenv("APPLICATION_ENV") === "development";
                exit(in_array("fixture/runtime", $names, true) &&
                    in_array("fixture/development", $names, true) === $dev ? 0 : 1);'
        fi
        ;;
    headers)
        export HIDE_NGINX_HEADERS=0
        start_service
        curl --fail --silent --dump-header /tmp/headers \
            http://127.0.0.1/index.php > /tmp/response
        grep -iEq '^Server: nginx/[0-9]' /tmp/headers
        grep -iEq '^X-Powered-By: PHP/[0-9]' /tmp/headers
        ;;
    custom-config)
        mkdir -p /var/www/html/conf/nginx
        sed '/server_name _;/a\        add_header X-Compatibility fixture;' \
            /etc/nginx/sites-available/default.conf > /var/www/html/conf/nginx/nginx-site.conf
        start_service
        curl --fail --silent --dump-header /tmp/headers \
            http://127.0.0.1/index.php > /tmp/response
        grep -iEq '^X-Compatibility: fixture' /tmp/headers
        test "$(cat /tmp/response)" = fixture-ok
        ;;
    startup-script)
        export RUN_SCRIPTS=1 SCRIPTS_DIR=/tmp/startup-files SKIP_CHOWN=1
        mkdir "$SCRIPTS_DIR"
        printf '#!/bin/sh\nprintf executed > /tmp/startup-marker\n' > "$SCRIPTS_DIR/01-marker"
        chown 23456:23457 /var/www/html/index.php
        start_service
        test "$(cat /tmp/startup-marker)" = executed
        test "$(stat -c %u:%g /var/www/html/index.php)" = 23456:23457
        test "$(cat /tmp/response)" = fixture-ok
        ;;
    https)
        mkdir -p /etc/letsencrypt/live/fixture
        cat > /tmp/openssl.cnf <<'CONF'
[req]
distinguished_name = dn
req_extensions = certificate
[dn]
[certificate]
subjectAltName = DNS:localhost
basicConstraints = critical,CA:TRUE
keyUsage = digitalSignature,keyEncipherment,keyCertSign
extendedKeyUsage = serverAuth
CONF
        php <<'PHP'
<?php
$options = ['config' => '/tmp/openssl.cnf', 'private_key_bits' => 2048,
    'digest_alg' => 'sha256', 'x509_extensions' => 'certificate'];
$key = openssl_pkey_new($options);
$request = openssl_csr_new(['commonName' => 'localhost'], $key, $options);
$certificate = openssl_csr_sign($request, null, $key, 1, $options);
if (!openssl_pkey_export_to_file($key, '/etc/letsencrypt/live/fixture/privkey.pem', null, $options)
    || !openssl_x509_export_to_file($certificate, '/etc/letsencrypt/live/fixture/fullchain.pem')) {
    exit(1);
}
PHP
        sed -i 's/##DOMAIN##/fixture/g' /etc/nginx/sites-available/default-ssl.conf
        ln -s /etc/nginx/sites-available/default-ssl.conf /etc/nginx/sites-enabled/default-ssl.conf
        start_service
        curl --fail --silent --cacert /etc/letsencrypt/live/fixture/fullchain.pem \
            --resolve localhost:443:127.0.0.1 https://localhost/index.php > /tmp/response
        test "$(cat /tmp/response)" = fixture-ok
        ;;
    lua)
        sed -i '1i\load_module /usr/lib/nginx/modules/ndk_http_module.so;\nload_module /usr/lib/nginx/modules/ngx_http_lua_module.so;' /etc/nginx/nginx.conf
        cat > /etc/nginx/sites-enabled/lua.conf <<'CONF'
server {
    listen 8081;
    location /lua {
        content_by_lua_block { ngx.say("lua-ok") }
    }
}
CONF
        start_service
        test "$(curl --fail --silent http://127.0.0.1:8081/lua)" = lua-ok
        ;;
    *) exit 1 ;;
esac
echo "Compatibility: $1 OK"
