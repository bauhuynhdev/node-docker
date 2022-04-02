# Includes
```text
- Nginx: 1.20.2
- Node: 14.x
- NPM: 6.14.16
- Yarn: 1.22.18
- Supervisor: 4.2.4
```
# Open ports
```text
- 80
- 443
- 9000
```
# Volumes
```text
- /app
- /etc/supervisord.conf
- /etc/supervisord.d/nginx.ini
- /etc/supervisord.d/app.ini
- /etc/nginx/nginx.conf
- /etc/nginx/conf.d/default.conf
```
# Virtual host
```apacheconf
server {
    listen 80;
    listen [::]:80;
    server_name 127.0.0.1;
    root /app;

    charset utf-8;

    error_page 404 /;

    location / {
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header Host $http_host;
        proxy_pass http://127.0.0.1:3000;
    }
}
```
# Run short
```shell
docker run -d --name [name] -v ${PWD}:/app -v ${PWD}/default.conf:/etc/nginx/conf.d/default.conf -v ${PWD}/app.ini:/etc/supervisord.d/app.ini -p 8888:80 bauhuynhdev/php-node
```