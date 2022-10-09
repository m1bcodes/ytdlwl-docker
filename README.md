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
For an interactive session:
```
docker run --name ytdlwl-cont --mount "source=ytdlwl-downloads,target=/app/downloads" --mount "source=ytdlwl-cookies,target=/app/cookies" -it ytdlwl sh
```
Start the download by calling ```sh update_wl.sh```.
Running the docker image will create to volumes: cookies and downloads, they can be found here:
```
/var/lib/docker/volumes/ytdlwl-cookies
/var/lib/docker/volumes/ytdlwl-downloads
```
Place the cookies as described in the ytdlwl repository in the cookies folder.

