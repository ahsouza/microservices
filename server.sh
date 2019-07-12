#!/bin/bash
#composer create-project --prefer-dist laravel/laravel app
cp .env.example .env
composer update --no-plugins --no-scripts
php artisan key:generate
php artisan config:cache
php artisan serve --host=0.0.0.0