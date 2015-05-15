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

### Less properties
Change the `KLI_PROPERTIES` env var in the `docker-compose.yml`
Available keys: `TIMESTAMP,RECORD,AirTC_Avg,SW_in_Avg,WS_ms_S_WVT,WindDir_D1_WVT,WindDir_SD1_WVT,WS_Gust_Max,RH_Avg,BP_kPa_Avg,Rain_Tot,BiralVisInst_Avg,WeatherCode00_Tot,WeatherCode04_Tot,WeatherCode30_Tot,WeatherCode40_Tot,WeatherCode50_Tot,WeatherCode60_Tot,WeatherCode70_Tot,TIMESTAMP_UTC`
