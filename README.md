# ytdlwl-docker
Docker version of the ytdlwl project

# Create docker image
clone this repository
```
git clone https://github.com/m1bcodes/ytdlwl-docker.git
cd ytdlwl-docker

```

Create Docker image:
```
docker build --tag ytdlwl ytdlwl-docker
```

For an interactive session:
```
docker run --name ytdlwl-cont --mount "source=ytdlwl-downloads,target=/app/downloads" --mount "source=ytdlwl-cookies,target=/app/cookies" -it ytdlwl sh
```
Start the download by calling ```sh update_wl.sh```.

