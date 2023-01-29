### 介绍
    容器集成
    php 7.3,8.1,8.2
    redis 7,
    elasticsearch 7.17
    openresty 1.21
    kibana 7.17
    
### 修改.env
> WWWROOT_PATH web所有项目目录

### 修改docker 镜像源
>    http://hub-mirror.c.163.com https://docker.mirrors.ustc.edu.cn

### windows
- (推荐)请将项目拷贝到子系统内加速读取速度  可浏览 \\\wsl$
  
#### 迁移windows wsl目录
- wsl -l -v --all \\\查看所有子系统及版本
- wsl --export 子系统名 迁移目录\docker-desktop.tar
- wsl --unregister 子系统名 \\\注销原系统
- wsl --import 子系统 迁移目录\docker-desktop-data 迁移目录\docker-desktop-data.tar --version 2

### 设置elastic账号密码
> docker exec -it elasticsearch /bin/bash
- elasticsearch-setup-passwords auto   \\\自动生成密码(生成的密码一定要记住)
- elasticsearch-setup-passwords interactive \\\手动设置各个账号密码

> 修改kibana/config/kibana.yml 文件 elasticsearch.password密码

### 使用
- 代码文件夹(域名需要使用到文件夹名,注意命名规范)放置在${WWWROOT_PATH}映射目录内
- openresty/config/vhost/default.conf laravel开发环境,如不需要去除配置中"include /usr/local/openresty/nginx/conf/rewrite/laravel.conf;"
- 修改hosts 127.0.0.1 [代码文件夹名].develop.com