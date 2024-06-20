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
### rebuild for docker-compose
To rebuild the stack after editing and to avoid re-use of cached components:
```
docker-compose up --force-recreate --build -d
```

# setup synchronization to remote systems
This section describes the steps required to synchronize the downloaded 
videos with remote (raspberry pi) systems. They can run libreelec for 
instance.

## create key file
Execute these steps on the machine, where docker-compose is run.
The remote machine is called `rpi4` in this case.
```
ssh-keygen -o -a 100 -t ed25519
```
Allow the key file to be created in `~/.ssh`.

## copy key to remote machine
The public key is copied to the remote machine.
```
ssh-copy-id -i ~/.ssh/id_ed25519.pub root@rpi4
```
## add all remote machines to a known_hosts file
In order to avoid confirmation by ssh to accept the remote machine, since no fingerprint is known, we create a `known_hosts` file, were the fingerprints of all machines are stored, which shall be syncronization targets.
Type the folling command for each remote machine:
```
ssh-keyscan -H rpi4 >> ./known_hosts
```
The `known_hosts` file will be transferred as secret to the container.

## install network tools on libreelec
Install the network tools addon (on libreelec) from the libreelec addon 
repository. The network tools can be found under _program addons_.
This is necessary to have rsync available under libreelec.

## rsync command
The rsync command to be executed from the ytdlwl container is added to 
update_wl.sh:
```
rsync -avz --delete -e "ssh -i /run/secrets/ssh-key-prv -o UserKnownHostsFile=/run/secrets/ssh-known-hosts" /var/Videos/Youtube_WL root@rpi4:"/storage/videos"
```
 - The ssh key (we need the private one) is per docker-compose copied to 
 /run/secrets/ssh-key-prv`
 - --delete to remove extra files on the destination folder.
