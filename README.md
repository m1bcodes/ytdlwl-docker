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

### For an interactive session:
```
docker run --mount "source=ytdlwl-downloads,target=/app/downloads" --mount "source=ytdlwl-cookies,target=/app/cookies" -it ytdlwl sh
```
For test purposes: start the download by calling ```sh update_wl.sh```.

### installing the cookies
Running the docker image will create to volumes: cookies and downloads, they can be found here:
```
/var/lib/docker/volumes/ytdlwl-cookies
/var/lib/docker/volumes/ytdlwl-downloads
```
Place the cookies as described in the ytdlwl repository in the cookies folder.

### running the docker image for real
```
docker run --name ytdlwl --mount "source=ytdlwl-downloads,target=/app/downloads" --mount "source=ytdlwl-cookies,target=/app/cookies"
```
To auto-start the container, e.g. after a reboot of the server, call
```
docker update --restart unless-stopped ytdlwl
```
