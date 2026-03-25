FROM php:8.2-cli-bookworm

# Instalar dependencias del sistema y extensiones PHP para Laravel
RUN apt-get update -y && apt-get install -y --fix-missing \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Obtener Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

EXPOSE 8000

# Al levantar el contenedor, instalamos dependencias y servimos
CMD bash -c "composer install && php artisan serve --host=0.0.0.0 --port=8000"
