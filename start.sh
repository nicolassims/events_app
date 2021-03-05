#!/bin/bash

export SECRET_KEY_BASE=W68eso5YQOlbtvSNUR50N/HDWj6IaEhAwMR3LtzuBEQAefwYVbX84bvoTA7XtiGi
export MIX_ENV=prod
export PORT=4900
export DATABASE_URL=ecto://events:karayakaylar@localhost/events_app_prod

echo "Stopping old copy of app, if any..."

_build/prod/rel/events_app/bin/events_app stop || true

echo "Starting app..."

_build/prod/rel/events_app/bin/events_app start
