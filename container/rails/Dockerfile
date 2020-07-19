# builder-base stage
FROM ruby:2.6.6-alpine3.12 AS builder-base

RUN apk update --no-cache --quiet && \
    apk upgrade --no-cache --quiet && \
    apk add --no-cache --quiet \
        nodejs \
        tzdata \
        build-base \
        linux-headers \
        postgresql-dev

# development stage
FROM builder-base AS development

ARG APP_ROOT="/app"

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

WORKDIR $APP_ROOT

ENV RAILS_ENV=development
ENV RAILS_LOG_TO_STDOUT=true

COPY Gemfile Gemfile.lock $APP_ROOT/
RUN bundle install -j$(getconf _NPROCESSORS_ONLN) --without production

COPY . $APP_ROOT/

# builder stage
FROM builder-base AS builder

ARG APP_ROOT="/app"

WORKDIR $APP_ROOT

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG=$APP_ROOT/.bundle

COPY Gemfile Gemfile.lock $APP_ROOT/
RUN bundle install -j$(getconf _NPROCESSORS_ONLN) --deployment --without test development

COPY . $APP_ROOT/

RUN bundle exec rails assets:precompile

# main image
FROM ruby:2.6.6-alpine3.12

ARG APP_ROOT="/app"

RUN apk update --no-cache --quiet && \
    apk upgrade --no-cache --quiet && \
    apk add --no-cache --quiet \
        nodejs \
        tzdata \
        postgresql-client

WORKDIR $APP_ROOT

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG=$APP_ROOT/.bundle
ENV RAILS_LOG_TO_STDOUT=true

COPY --from=builder $APP_ROOT $APP_ROOT

CMD ["bundle", "exec", "rails", "s"]
