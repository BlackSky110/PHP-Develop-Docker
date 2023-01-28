FROM openresty/openresty:1.21.4.1-0-alpine
LABEL author="0x49"
LABEL email="1458513@qq.com"
VOLUME [ "./config/","./logs/" ]
ENV TZ=Asia/Shanghai
RUN apk --no-cache add tzdata zeromq && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    && apk del tzdata
EXPOSE 80 443