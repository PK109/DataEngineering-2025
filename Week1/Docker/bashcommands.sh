# building custom image on dockerfile

 docker build -t image:pandas .

# creating network in docker
docker network create postgres

# running postgres from command
docker run -it \
  -e POSTGRES_USER="root" \
  -e POSTGRES_PASSWORD="root" \
  -e POSTGRES_DB="ny_taxi" \
  -v /$(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
  -p 5432:5432 \
  --network=postgres \
  --name pg-database \
  postgres:13

# running PGadmin from command
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL=admin@admin.com \
  -e PGADMIN_DEFAULT_PASSWORD=admin \
  -p 8080:80 \
  --network=postgres \
  --name pg-admin \
  dpage/pgadmin4

# running ingest script on host
python upload-data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --database_name=ny_taxi \
    --table_name=yellow_taxi_data \
    --file_url=https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2024-01.parquet

#running ingest script on container with 
docker run -it \
  --network=docker_default \
    taxi_ingest:v001 \
        --user=root \
        --password=root \
        --host=pgdatabase \
        --port=5432 \
        --database_name=ny_taxi \
        --table_name=green_taxi_data \
        --file_url=https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2019-10.parquet

#running ingest script on container with zones

docker run -it \
  --network=docker_default \
    zones_ingest:v001 \
        --user=root \
        --password=root \
        --host=pgdatabase \
        --port=5432 \
        --database_name=ny_taxi \
        --table_name=zones_data \
        --file_url=https://d37ci6vzurychx.cloudfront.net/misc/taxi_zone_lookup.csv
