# syntax=docker/dockerfile:1
FROM python:3.9
WORKDIR /app

RUN apt-get update && apt-get upgrade && apt-get install -y ffmpeg
RUN git clone https://github.com/m1bcodes/ytdlwl-docker.git
RUN python3 -m pip install --upgrade yt-dlp
COPY . .
#COPY ytdlwl-docker/* .
#COPY ytdlwl-docker/*.py .
CMD sh update_wl.sh
