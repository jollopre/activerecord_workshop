.PHONY: build clean down install logs shell sql up

build:
	docker compose build --no-cache
clean:
	docker compose down --rmi all --volumes
down:
	docker compose down --remove-orphans
install:
	docker compose exec app bundle install
logs:
	docker compose logs
shell: start_dependencies
	docker compose run --rm app sh
sql:
	docker compose exec db mysql -u root -ps3cret_password
start_dependencies:
	docker compose run --rm start_dependencies
test: start_dependencies
	docker compose run -e DB_NAME=workshop-test -e APP_ENV=test --rm app sh
up: start_dependencies
	docker compose up -d
