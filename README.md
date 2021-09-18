## To do list

- Development Environment:

    - [x] Nginx
    - [x] PHP
    - [x] Composer
    - [x] NPM
    - [x] Laravel
    - [x] MariaDB
    - [x] Redis
    - [x] Dockerfile
    - [x] docker-compose
    - [x] Sail(Official docker-compose)

## Usage

### Environment Variables

Setting your `.env` file in `./env`:

```bash
$ cd /path/to/laravel-nginx-mysql-docker
$ cp .env.example .env
$ vim .env
```

Setting your `.env` file in `./src/.env`:

```bash
$ cd /path/to/laravel-nginx-mysql-docker/src
$ cp .env.example .env
$ vim .env
```

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

> Warning: if you use Dockerfile, it will take about 25 minutes to build the image !!

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
  -v "$PWD/src:/var/www/html" \
  -v "laravel_mariadb:/var/lib/mysql" \
  my_lemp:latest
```

Or just run the script to build image and run the container:

```bash
$ bash ./run.sh
```

### Dependencies management:

#### Composer

Install and update composer packages:

```bash
$ sudo docker-compose run --rm laravel_composer composer install
$ sudo docker-compose run --rm laravel_composer composer update
```

Or, you can get into container and run:

```bash
$ sudo docker exec -it laravel_php /bin/bash
$ composer install
$ composer update
```

#### NPM

Install npm packages:

```bash
$ sudo docker-compose run --rm laravel_nodejs npm ci     # install version-locked packages
```

Also, you can get into container and run:

```bash
$ sudo docker exec -it laravel_php /bin/bash
$ npm ci     # install version-locked packages
```

### Laravel App Key

To generate your laravel app key, get into container and run command:

```bash
$ sudo docker exec -it laravel_php /bin/bash
$ php artisan key:generate
```

### Volumes

If you are using `Dockerfile`, you can find your `mariadb-volume` in `/var/lib/docker/volumes/<volume-name>` (this path is for `Linux` user!!)

If you are using `docker-compose`, just find your `mariadb-volume` in `./my_database`

### Laravel Official Sail Development Environment

If you prefer official method, you can use `Sail` which is developed by Laravel itself.

Here's a snippet source codes from official which can work pretty nice on my computer:

```bash
$ sudo docker run
  --rm \
  -w /opt \
  -v "$PWD:/opt" \
  laravelsail/php80-composer:latest \
  bash -c "laravel new <your-project-name> \
  && cd <your-project-name> \
  && php ./artisan sail:install --with=mariadb,redis"
```

It will download a laravel project in your current directory, and just get started with commands below for developemnt:

```bash
$ cd <your-project-name>
$ sudo ./vendor/bin/sail up
```

It may took a time for building docker images, and just navigate to `http://localhost` to access your application.
