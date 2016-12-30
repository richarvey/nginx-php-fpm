FROM nginx:mainline

MAINTAINER Anh K. Huynh <kyanh@theslinux.org>

ENV php_conf /etc/php5/fpm/php.ini
ENV fpm_conf /etc/php5/fpm/php-fpm.conf
ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update \
  && echo Y \
  | apt-get install \
      openssh-client \
      wget \
      supervisor \
      curl \
      git \
      php5-fpm \
      php5-mysql \
      php5-mcrypt \
      php5-gd \
      php5-cli \
      php5-intl \
      php5-memcache \
      php5-pgsql \
      php5-xsl \
      php5-curl \
      php5-json \
      python \
      python-dev \
      python-pip \
      ca-certificates \
  && curl -sS https://getcomposer.org/installer \
     | php -- --install-dir=/usr/bin --filename=composer \
  && mkdir -p /etc/nginx /var/www/app /run/nginx /var/log/supervisor


ADD conf/supervisord.conf /etc/supervisord.conf

# Copy our nginx config
RUN rm -Rf /etc/nginx/nginx.conf
ADD conf/nginx.conf /etc/nginx/nginx.conf

# nginx site conf
RUN \
  mkdir -pv /etc/nginx/sites-available/ \
    /etc/nginx/sites-enabled/
    /etc/nginx/ssl/ \
    /var/www/html/
  && rm -Rf /var/www/*
  && mkdir -pv /var/www/html/

ADD conf/nginx-site.conf /etc/nginx/sites-available/default.conf
ADD conf/nginx-site-ssl.conf /etc/nginx/sites-available/default-ssl.conf
RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# tweak php-fpm config
RUN sed -i \
    -e "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g" \
    -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 100M/g" \
    -e "s/post_max_size\s*=\s*8M/post_max_size = 100M/g" \
    -e "s/variables_order = \"GPCS\"/variables_order = \"EGPCS\"/g" \
    ${php_conf} \
  && sed -i \
    -e "s/;daemonize\s*=\s*yes/daemonize = no/g" \
    -e "s/;catch_workers_output\s*=\s*yes/catch_workers_output = yes/g" \
    -e "s/pm.max_children = 4/pm.max_children = 4/g" \
    -e "s/pm.start_servers = 2/pm.start_servers = 3/g" \
    -e "s/pm.min_spare_servers = 1/pm.min_spare_servers = 2/g" \
    -e "s/pm.max_spare_servers = 3/pm.max_spare_servers = 4/g" \
    -e "s/pm.max_requests = 500/pm.max_requests = 200/g" \
    -e "s/user = nobody/user = nginx/g" \
    -e "s/group = nobody/group = nginx/g" \
    -e "s/;listen.mode = 0660/listen.mode = 0666/g" \
    -e "s/;listen.owner = nobody/listen.owner = nginx/g" \
    -e "s/;listen.group = nobody/listen.group = nginx/g" \
    -e "s/listen = 127.0.0.1:9000/listen = \/var\/run\/php-fpm.sock/g" \
    -e "s/^;clear_env = no$/clear_env = no/" \
    ${fpm_conf}
  && cp -fv ${php_conf} /etc/php5/cli/php.ini \
  && find /etc/php5/fpm/conf.d/ -name "*.ini" \
      -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# Add Scripts
ADD scripts/start.sh  /start.sh
ADD scripts/pull      /usr/bin/pull
ADD scripts/push      /usr/bin/push

RUN chmod 755 /usr/bin/pull /usr/bin/push /start.sh

# copy in code
ADD src/    /var/www/html/
ADD errors/ /var/www/errors/

VOLUME /var/www/html

EXPOSE 443 80

CMD ["/start.sh"]
