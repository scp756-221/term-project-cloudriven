# Makefile for  Music service (S2) and Playlist service (S3)

VER=v1.0

#SERVER1=`docker inspect s2 --format '{{.NetworkSettings.IPAddress}}'`
#PORT1=30001

SERVER2=`docker inspect s3 --format '{{.NetworkSettings.IPAddress}}'`
PORT2=30003

build-mcli:
	docker image build -f Dockerfile -t mcli:$(VER) .

run-mcli:
	docker container run -it --rm --name mcli mcli:$(VER) python3 mcli.py $(SERVER2) $(PORT2)
