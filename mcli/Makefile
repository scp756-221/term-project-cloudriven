# Makefile for  Music service (S2) and Playlist service (S3)

VER=v1.0

# SERVER=`docker inspect s2 --format '{{.NetworkSettings.IPAddress}}'`
# PORT=30001

SERVER=`docker inspect s3 --format '{{.NetworkSettings.IPAddress}}'`
PORT=30003

build-mcli:
	docker image build -f Dockerfile -t mcli:$(VER) .

run-mcli:
	docker container run -it --rm --name mcli mcli:$(VER) python3 mcli.py $(SERVER) $(PORT)
