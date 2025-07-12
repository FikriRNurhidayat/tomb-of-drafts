MAKEFLAGS += --silent

ifneq (,$(wildcard ./.env))
    include .env
    export
endif

DATABASE_URL=postgres://${DATABASE_USER}:${DATABASE_PASSWORD}@${DATABASE_HOST}:${DATABASE_PORT}/${DATABASE_NAME}?sslmode=${DATABASE_SSLMODE}

.PHONY: migratedb
migratedb:
	migrate --path=db/migrations/ \
			--database ${DATABASE_URL} up

.PHONY: rollbackdb
rollbackdb:
	echo "y" | migrate --path=db/migrations/ \
			--database ${DATABASE_URL} down

migration:
	$(eval timestamp := $(shell date +%s))
	touch db/migrations/$(timestamp)_${name}.up.sql
	touch db/migrations/$(timestamp)_${name}.down.sql
