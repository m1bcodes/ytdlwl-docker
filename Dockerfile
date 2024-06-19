# syntax=docker/dockerfile:1
FROM python:latest
WORKDIR /app

RUN echo "hello there"

RUN apt-get update 
RUN apt-get install -y ffmpeg cron rsync

# RUN git clone https://github.com/m1bcodes/ytdlwl-docker.git

RUN python3 -m pip install --upgrade yt-dlp
COPY . .

COPY ytdlwl-cron /etc/cron.d/ytdlwl-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/ytdlwl-cron

# Apply cron job
RUN crontab /etc/cron.d/ytdlwl-cron

# Create the log file to be able to run tail
RUN touch /var/log/cron.log

RUN chmod a+x update_wl.sh

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log

# ...or: run the update immediately
# CMD sh update_wl.sh

RUN echo "end 23"
