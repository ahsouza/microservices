#!/bin/bash
docker build -t anibalhsouza/laravel-5.8 .
#docker run -d --name crecies -v $(pwd):/var/www -p 8000:8000 crecies/laravel-5.8
docker run -d --name crecies -p 8000:8000 anibalhsouza/laravel-5.8
#docker exec -it crecies bash server.sh
docker exec -it crecies bash server.sh