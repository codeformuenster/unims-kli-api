# Machine-readable Environmental Data from kli.uni-muenster.de

This API returns machine-readable and JSON encoded data from [kli.uni-muenster.de](http://kli.uni-muenster.de).

It knows the following endpoints
 - `/` - `data of the last 24 hours`
 - `/latest` - `latest record`

## How to run?
- Install Docker
- `docker run -d -p "8081:8080" ubergesundheit/unims-kli-api`
- Point your browser to [localhost:8081](http://localhost:8081)

## OR (docker-compose):
- Install Docker and docker-compose
- `docker-compose up`
- Point your browser to [localhost:8081](http://localhost:8081)
