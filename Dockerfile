FROM ruby:3.0.2-alpine3.14 as base
ENV APP /app
WORKDIR $APP
COPY Gemfile $APP
RUN apk --update add --no-cache --virtual build_deps build-base mariadb-dev
RUN bundle install -j 10 --quiet
CMD ["tail", "-f", "/dev/null"]
