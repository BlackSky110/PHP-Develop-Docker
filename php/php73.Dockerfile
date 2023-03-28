FROM surnet/alpine-wkhtmltopdf:3.17.0-0.12.6-full as wkhtmltopdf
FROM php:7.3.33-fpm-alpine3.15 as php73
LABEL author="0x49"
LABEL email="1458513@qq.com"
ENV COMPOSER_HOME /root/composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk upgrade \
    && apk add --no-cache tzdata git \
    icu-dev gettext-dev libxml2-dev libzip libzip-dev \
    libmcrypt-dev libjpeg-turbo-dev libpng-dev freetype-dev autoconf g++ make \
    openssl openssl-dev \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation \
    && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && apk del tzdata \
    && docker-php-ext-install -j$(nproc) bcmath exif gettext intl pcntl shmop soap sockets sysvmsg sysvsem sysvshm zip pdo_mysql mysqli \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) opcache \
    ##&& pecl install mongodb \
    && pecl install redis \
#    && docker-php-ext-enable xdebug \
   #&& docker-php-ext-enable mongodb \
    && docker-php-ext-enable redis \
    && pecl install -o -f https://pecl.php.net/get/swoole-4.8.11.tgz \
    && docker-php-ext-enable swoole \
    && pecl install xlswriter \
    && docker-php-ext-enable xlswriter \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && apk del --update make g++ \
    && rm -rf /var/cache/apk/* && rm -rf /tmp/* 
COPY --from=wkhtmltopdf /bin/wkhtmltopdf /bin/wkhtmltopdf
COPY --from=wkhtmltopdf /bin/wkhtmltoimage /bin/wkhtmltoimage
COPY --from=wkhtmltopdf /bin/libwkhtmltox* /bin/
COPY ./font/STFANGSO.TTF /usr/share/fonts/STFANGSO.TTF
COPY ./font/simfang.ttf /usr/share/fonts/simfang.ttf
COPY ./font/simhei.ttf /usr/share/fonts/simhei.ttf
COPY ./font/simsun.ttc /usr/share/fonts/simsun.ttc
EXPOSE 9000
CMD [ "php-fpm","-R" ]
