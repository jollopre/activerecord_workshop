#!/bin/sh
set -eo pipefail

if [ $APP_ENV = "development" ]; then
  bundle exec rake db:migrate
  bundle exec rake db:seed
elif [ $APP_ENV = "test" ]; then
  bundle exec rake db:migrate
else
  echo "nothing todo for APP_ENV: $APP_ENV"
fi

exec $@
