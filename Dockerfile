FROM composer:2.5 as composer-php

RUN composer global require sharpen/versionna

RUN versionna list

FROM php:8.2-cli-alpine AS phpapp

RUN set -eux ; \
  apk add --no-cache --virtual .composer-rundeps \
  bash \
  coreutils \
  git \
  make \
  openssh-client \
  unzip \
  zip

RUN docker-php-ext-install pdo pdo_mysql pdo_pgsql

WORKDIR /app

COPY --from=composer-php composer-php /app
ENV VERSIONNA_ALLOW_SUPERUSER 1
ENV VERSIONNA_HOME /tmp

ENTRYPOINT [ "php" ]

FROM phpapp AS default
