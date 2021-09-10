## To do list

- development environment:

    - [x] Nginx
    - [x] PHP
    - [x] Composer
    - [x] Laravel
    - [x] MariaDB
    - [x] Redis
    - [x] Dockerfile
    - [x] docker-compose

## Usage

### 1. docker-compose

Run the LEMP-Stack docker services for development:

```bash
$ sudo docker-compose up --build -d laravel_nginx
```

The command above will run these services defined in `docker-compose.yml` file:

- laravel_nginx
- laravel_php
- laravel_mariadb
- laravel_redis

### 2. Dockerfile

Build the whole LEMP-Stack in single docker image:

```bash
$ sudo docker build \
  -f Dockerfile \
  -t my_lemp:latest \
  --build-arg TZ=<your-timezone> \
  --build-arg USER=<your-current-user> \
  --build-arg MYSQL_ROOT_PASSWORD=<your-mysql-root-password> \
  ./
```

Run the image in a container:

```bash
$ sudo docker run --rm -it \
  --name my_lemp \
  -p 80:80 \
  -v "$PWD/php-fpm.pool.conf:/etc/php/8.0/fpm/pool.d/www.conf" \
  -v "$PWD/nginx.conf:/etc/nginx/sites-available/default" \
  my_lemp:latest
```

Or just run the script to build image and run it in container:

```bash
$ bash ./run.sh
```
