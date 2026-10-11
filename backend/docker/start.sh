#!/bin/sh
set -eu

# Blade resolves its compiled path with realpath(). A missing directory makes
# that false, and the /up view then fails with "Please provide a valid cache path."
mkdir -p \
  storage/framework/cache/data \
  storage/framework/sessions \
  storage/framework/views \
  storage/logs \
  bootstrap/cache

php artisan migrate --force
php artisan db:seed --force
exec php artisan serve --host=0.0.0.0 --port=8000
