## To do list

- development environment:

    - [x] Nginx
    - [x] PHP
    - [x] Laravel
    - [x] MariaDB
    - [x] Redis
    - [ ] Dockerfile (almost done)
    - [x] docker-compose

## Usage

### 1. docker-compose

Run the LEMP-Stack docker services for development:

```bash
$ sudo docker-compose up -d --build laravel_nginx
```

The command above will run these services defined in `docker-compose.yml` file:

- laravel_nginx
- laravel_php
- laravel_mariadb
- laravel_redis

### 2. Dockerfile

Build the whole LEMP-Stack in single docker container:

```bash
$ sudo docker build -f Dockerfile -t my_lemp:latest --build-arg MYSQL_ROOT_PASSWORD=<your-mysql-root-password> ./
```

Run the container:

```bash
$ sudo docker run --rm -it -p 80:80 my_lemp:latest
```
