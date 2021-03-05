#!/bin/bash

export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4900
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"
export DATABASE_URL=ecto://events:karayakaylar@localhost/events_app_prod

echo "Building..."

mix deps.get --only prod
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

mix ecto.migrate

mix local.hex --force
mix local.rebar --force
mix release --force --overwrite

echo "Generating release..."


#echo "Stopping old copy of app, if any..."
#_build/prod/rel/practice/bin/practice stop || true

echo "Starting app..."

PROD=t ./start.sh
