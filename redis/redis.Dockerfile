FROM redis:7.0.7-alpine3.17
ENV TZ=Asia/Shanghai
RUN apk --no-cache add tzdata zeromq && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone
EXPOSE 6379