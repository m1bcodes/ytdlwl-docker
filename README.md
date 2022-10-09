# ytdlwl-docker
Docker version of the ytdlwl project

## Create docker image
clone this repository
```
git clone https://github.com/m1bcodes/ytdlwl-docker.git
```
Create Docker image:
```
docker build --tag ytdlwl ytdlwl-docker
```

## Run docker image
Create a folder ```/srv/ytdlwl``` which will hold the downloaded files. Change owner accordingly.

### For an interactive session:
```
docker run -v /srv/ytdlwl:/app/downloads --mount "source=ytdlwl-cookies,target=/app/cookies" -it ytdlwl sh
```
For test purposes: start the download by calling ```sh update_wl.sh```.

### installing the cookies
Running the docker image will create the volume cookies ```/var/lib/docker/volumes/ytdlwl-cookies```.
Place the cookies as described in the ytdlwl repository in the cookies folder.

### running the docker image for real
```
docker run -d --name ytdlwl -v /srv/ytdlwl:/app/downloads --mount "source=ytdlwl-cookies,target=/app/cookies" ytdlwl 
```
To auto-start the container, e.g. after a reboot of the server, call
```
docker update --restart unless-stopped ytdlwl
```
