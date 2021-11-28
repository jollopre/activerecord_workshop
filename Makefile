.PHONY: build clean down install logs shell sql up

build:
	docker-compose build --no-cache
clean:
	docker-compose down --rmi all --volumes
down:
	docker-compose down --remove-orphans
install:
	docker-compose exec app bundle install
logs:
	docker-compose logs
shell:
	docker-compose exec app sh
sql:
	docker compose exec db mysql -u wadus -pS3cret_password workshop
up:
	docker-compose up -d
