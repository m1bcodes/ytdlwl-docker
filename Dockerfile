# syntax=docker/dockerfile:1
FROM python:3.9
WORKDIR /app

RUN apt-get update && apt-get upgrade && apt-get install -y ffmpeg
RUN apt-get -y install cron
RUN git clone https://github.com/m1bcodes/ytdlwl-docker.git
RUN python3 -m pip install --upgrade yt-dlp
COPY . .

COPY ytdlwl-cron /etc/cron.d/ytdlwl-cron
# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/ytdlwl-cron
# Apply cron job
RUN crontab /etc/cron.d/ytdlwl-cron
# Create the log file to be able to run tail
RUN touch downloads/update_wl.log
# Run the command on container startup
CMD cron && tail -f downloads/update_wl.log
# CMD sh update_wl.sh
