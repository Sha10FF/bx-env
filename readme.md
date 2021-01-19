# BXEnv

## Назначение

Сборка предназначена для разработки Битрикс и содержит контейнеры:
- php
- mysql
- nginx
- redis
- memcache
- push&pull сервер

>**Внимание!**  
>Сборка рассчитана исключительно на локальную разработку. Использование в продакшене не безопасно!

## Быстрый старт

1. Клонируйте или скачайте репозиторий
2. Скопируйте содержимое файла `.env.default` в файл `.env`
3. В файле `.env` внесите необходимые изменения
4. Выполните команду `docker-compose up`

## Конфигурирование  
Для настройки используются переменные окружения, указываемые в файле `.env`. Полный список можно найти в файле `.env.default`.  

**BX_PUBLIC_HTML_PATH**  
путь к директории public_html, в которой содержатся директории хостов, монтируется в php и nginx контейнеры и используется для генерации хостов.  

**BX_MODULES_PATH**  
путь к репозиторию modules, требуется для работы с линкованной установкой, монтируется в php и nginx контейнеры  

**BX_LOGS_PATH**  
путь к директории в которой контейнеры должны хранить логи, монтируется в контейнеры, внутри каждый из контейнеров создаст свою папку  

**BX_MYSQL_IMAGE**  
образ для контейнера mysql, по умолчанию используется percona:5.7, но можно использовать mysql, в т.ч. mysql:8  

**BX_MYSQL_ROOT_PASSWORD**  
пароль для root пользователя mysql  

**BX_MYSQL_PORT**  
порт на котором mysql будет доступен извне, по умолчанию 3306  

**BX_XDEBUG_IP**  
устанавливает опцию xdebug.client_host  

**BX_XDEBUG_PORT**  
устанавливает опцию xdebug.client_port  

**BX_DEFAULT_CHARSET**  
кодировка по умолчанию для php  

**BX_HTTP_PORT**  
**BX_HTTPS_PORT**  
порты на которых будет доступен веб сервер

**BX_CONTAINER_UID**  
**BX_CONTAINER_GID**  
пользователь и группа от имени которого будут работать php и nginx

**BX_UPDATE_HOST**  
добавляет указанную строку в extra_hosts директиву docker-compose конфига (затем попадет в /etc/hosts php контейнера)  
формат: "updates.lan:192.168.0.100"  
необходимо, если используете локальный сервер обновлений, скрытый за VPN  
оставьте пустой, если не требуется  

### Настройки push&pull сервера  

**BX_PUSH_SUB_HOST**  
хост для чтения сообщений  

**BX_PUSH_SUB_PORT**  
порт для чтения сообщений  

**BX_PUSH_PUB_HOST**  
хост для публикации сообщений  

**BX_PUSH_PUB_PORT**  
порт для публикации сообщений  

**BX_PUSH_SECURITY_KEY**  
ключ для подключения к push серверу  

### Автоматическоое создание хостов  

**BX_HOST_AUTOCREATE**    
включает или отключает автогенерацию хостов nginx

**BX_DEFAULT_HOST**  
хост по умолчанию, получит аттрибут default_server в конфиге nginx, оставьте пустым, если не требуется  

**BX_DEFAULT_LOCAL_DOMAIN**  
доменная зона по умолчанию, будет добавлена через точку к имени директории хоста, если директория хоста в имени не содержит доменную зону, оставьте пустым если не требуется  

>Каких-либо проверок или значений по умолчанию в системе нет. Если вы не укажете один или несколько параметров или вообще не создадите `.env` файл, docker-compose подставит пустые строки и выведет соответствующее уведомление.

## Автоподключение хостов  
При запуске контейнера nginx читается список директорий в public_html и для каждой создается виртуальный хост.  
Если в директории sites_enabled уже есть конфиг для какого-либо хоста, то он не будет перезаписан.  
Если указана переменная BX_DEFAULT_LOCAL_DOMAIN и имя директории не содержит точку, то для каждого хоста будет автоматически добавлена доменная зона.  
Если указана переменная BX_DEFAULT_HOST, то в конфигурации nginx этот хост будет отмечен хостом по умолчанию.  