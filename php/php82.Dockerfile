FROM php:8.2.1-fpm-alpine3.16 as php82
LABEL author="0x49"
LABEL email="1458513@qq.com"
ENV COMPOSER_HOME /root/composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk upgrade \
    && set -eux \
    && apk add --no-cache \
        tzdata \
        c-client \
        ca-certificates \
        freetds \
        freetype \
        gettext \
        gmp \
        icu-libs \
        imagemagick \
        imap \
        libexecinfo \
        libffi \
        libgmpxx \
        libintl \
        libjpeg-turbo \
        libpng \
        libpq \
        librdkafka \
        libssh2 \
        libstdc++ \
        libtool \
        libxpm \
        libxslt \
        libzip \
        make \
        rabbitmq-c \
        tidyhtml \
        unixodbc \
        vips \
        yaml \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        bzip2-dev \
        cmake \
        curl-dev \
        freetds-dev \
        freetype-dev \
        g++ \
        gcc \
        gettext-dev \
        git \
        gmp-dev \
        icu-dev \
        imagemagick-dev \
        imap-dev \
        krb5-dev \
        libc-dev \
        libexecinfo-dev \
        libjpeg-turbo-dev \
        libpng-dev \
        librdkafka-dev \
        libssh2-dev \
        libwebp-dev \
        libxml2-dev \
        libxpm-dev \
        libxslt-dev \
        libzip-dev \
        openssl-dev \
        pcre-dev \
        pkgconf \
        postgresql-dev \
        rabbitmq-c-dev \
        tidyhtml-dev \
        unixodbc-dev \
        vips-dev \
        yaml-dev \
        zlib-dev \
    && ln -s /usr/lib /usr/local/lib64 \
    && if [ -f /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini ]; then \
        echo "ffi.enable = 1" >> /usr/local/etc/php/conf.d/docker-php-ext-ffi.ini; \
    fi \
    && docker-php-ext-install -j$(nproc) sockets bcmath exif gettext intl pcntl shmop soap sysvmsg sysvsem sysvshm zip pdo_mysql mysqli \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) opcache \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && pecl install swoole \
    && docker-php-ext-enable swoole \
    && pecl install xlswriter \
    && docker-php-ext-enable xlswriter \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
EXPOSE 9000
CMD [ "php-fpm","-R" ]