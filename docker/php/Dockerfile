FROM php:7.4-fpm-alpine

ARG ENABLE_XDEBUG

RUN apk add --update \
    build-base \
    autoconf \
    rabbitmq-c-dev \
    make \
    curl

RUN pecl install amqp && docker-php-ext-enable amqp

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    ln -s $(composer config --global home) /root/composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

ADD php.ini /etc/php/conf.d/
ADD php.ini /etc/php/cli/conf.d/
ADD php-fpm.conf /etc/php/php-fpm.d/

RUN if [ "${ENABLE_XDEBUG}" == "on" ]; then \
        yes | pecl install xdebug \
        && docker-php-ext-enable xdebug \
        && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_autostart=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
        && echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/xdebug.ini; \
    fi

WORKDIR /var/www/web

EXPOSE 9000

CMD ["php-fpm", "-F"]
