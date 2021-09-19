## To Do List

    - [x] Nginx
    - [x] PHP 8.0
    - [x] Composer
    - [x] NPM
    - [x] Laravel 8
    - [x] MariaDB
    - [x] Redis
    - [x] Dockerfile
    - [x] docker-compose
    - [x] Sail (Official docker-compose)

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
- laravel_php80
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

Run the container depends on this image:

```bash
$ sudo docker run --rm -it \
  --name my_lemp \
  -p 80:80 \
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
$ sudo docker exec -it laravel_php80 /bin/bash
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
$ sudo docker exec -it laravel_php80 /bin/bash
$ npm ci     # install version-locked packages
```

### Laravel App Key

To generate your laravel app key, get into container and run command:

```bash
$ sudo docker exec -it laravel_php80 /bin/bash
$ php artisan key:generate
```

### MariaDB Config

If you are using docker-compose, there's NO NEED to initialize your database, the official MariaDB image has handled all of them.

If you are using Dockerfile, you NEED to follow steps below to initialize your database system:

1. Login into MariaDB Workbench
2. Create a Database
3. Register a User
4. Grant the Database Privileges to that User
5. Apply the Settings above

```bash
$ sudo mysql
MariaDB > CREATE DATABASE `laravel`;
MariaDB > CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';
MariaDB > GRANT ALL PRIVILEGES ON `laravel`.* TO 'username'@'localhost';
MariaDB > FLUSH PRIVILEGES;
```

### Volumes

You can find your Mariadb Volume in `/var/lib/docker/volumes/<volume-name>` (this path is for `Linux` user!!)

> Warning: DO NOT mount database volumes in local path, it will cause many issues which may destroy all of your patient !!

### Laravel Official Sail Development Environment

If you prefer official method, you can just use `Sail` which is developed by Laravel itself.

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
