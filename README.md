## To do list

- development environment:

    - [x] Nginx
    - [x] PHP
    - [x] Laravel
    - [x] MariaDB
    - [x] Redis

## Usage

Run the LNMP-Stack docker services for development:

```bash
$ sudo docker-compose up -d --build laravel_nginx
```

The command above will run these services defined in `docker-compose.yml` file:

- laravel_nginx
- laravel_php
- laravel_mariadb
- laravel_redis
