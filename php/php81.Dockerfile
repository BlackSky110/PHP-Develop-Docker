FROM php:8.1.14-fpm-alpine3.17 as php81
LABEL author="0x49"
LABEL email="1458513@qq.com"

ENV COMPOSER_HOME /root/composer
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk upgrade \
    && apk add --no-cache tzdata git \
    icu-dev gettext-dev libxml2-dev libzip libzip-dev \
    libmcrypt-dev libjpeg-turbo-dev libpng-dev freetype-dev autoconf g++ make \
    openssl openssl-dev \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    && docker-php-ext-install -j$(nproc)  bcmath exif gettext intl pcntl shmop soap sockets sysvmsg sysvsem sysvshm zip pdo_mysql mysqli \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install swoole \
    && docker-php-ext-enable swoole \
    && pecl install xlswriter \
    && docker-php-ext-enable xlswriter \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
EXPOSE 9000
CMD [ "php-fpm","-R" ]