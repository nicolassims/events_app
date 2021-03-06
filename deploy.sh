#!/bin/bash

export MIX_ENV=prod
export PORT=4900
export SECRET_KEY_BASE=insecure
export DATABASE_URL=ecto://events:bad@localhost/events_app_prod

mix deps.get --only prod
mix compile

CFGD=$(readlink -f ~/.config/events_app)

if [ ! -d "$CFGD" ]; then
	mkdir -p "$CFGD"
fi

if [ ! -e "$CFGD/base" ]; then
	mix phx.gen.secret > "$CFGD/base"
fi

if [ ! -e "$CFGD/db_pass" ]; then
	pwgen 12 1 > "$CFGD/db_pass"
fi

SECRET_KEY_BASE=$(cat "$CFGD/base")
export SECRET_KEY_BASE

DP_PASS=$(cat "$CFGD/db_pass")
export DATABASE_URL=ecto://events:$DB_PASS@localhost/events_app_prod

mix ecto.migrate

npm install --prefix ./assets
npm run deploy --prefix ./assets
mix phx.digest

mix release
