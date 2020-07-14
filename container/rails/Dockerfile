FROM ruby:2.6.6-alpine3.12

RUN apk upgrade --no-cache && \
    apk add --update --no-cache \
      nodejs \
      tzdata \
      build-base \
      linux-headers \
      postgresql-dev

ENV DOCKERIZE_VERSION v0.6.1
RUN apk add --no-cache openssl \
    && wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR /app

COPY Gemfile* /app/
RUN bundle install

COPY . /app/
