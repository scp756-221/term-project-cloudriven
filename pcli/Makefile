# Makefile for Playlist service (S3)

VER=v1.0

SERVER=`docker inspect s3 --format '{{.NetworkSettings.IPAddress}}'`
PORT=30003

build-pcli:
	docker image build -f Dockerfile -t pcli:$(VER) .

run-mcli:
	docker container run -it --rm --name pcli pcli:$(VER) python3 pcli.py $(SERVER) $(PORT)
