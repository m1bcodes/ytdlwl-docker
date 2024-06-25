#!/bin/bash

echo "****************************************"
echo "*** Starting $(date)"
echo "****************************************"

PLAYLIST_FILE=/var/tmp/playlist.json
VIDEO_PATH=/var/Videos/Youtube_WL
VIDEO_PATH_HD=/var/Videos/Youtube_WL_HD
COOKIES_FILE=/run/secrets/yt-cookies
LOCAL_COOKIES=/var/tmp/cookies.txt
URL=https://www.youtube.com/playlist?list=WL

echo copying cookies...
cp $COOKIES_FILE $LOCAL_COOKIES

echo downloading playlist...
yt-dlp -J --cookies ${LOCAL_COOKIES} $URL > ${PLAYLIST_FILE}

mkdir -p ${VIDEO_PATH_HD}
mkdir -p ${VIDEO_PATH_HD}

echo purging...
rm ${VIDEO_PATH}/*.part
rm ${VIDEO_PATH}/*.jpg
rm ${VIDEO_PATH_HD}/*.part
rm ${VIDEO_PATH_HD}/*.jpg

python3 remove_videos_not_in_playlist.py ${VIDEO_PATH} ${PLAYLIST_FILE}
python3 remove_videos_not_in_playlist.py ${VIDEO_PATH_HD} ${PLAYLIST_FILE}

echo downloading files...
yt-dlp --download-archive ${VIDEO_PATH}/archive.txt --embed-thumbnail --embed-metadata --embed-chapters --restrict-filenames -f "bv*[height<=720]+ba/b[height<=720]/wv*+ba/w" --cookies ${LOCAL_COOKIES} --paths $VIDEO_PATH $URL 
yt-dlp --download-archive ${VIDEO_PATH_HD}/archive.txt --embed-thumbnail --embed-metadata --embed-chapters --restrict-filenames -f "bv*[height<=1080]+ba/b[height<=1080]/wv*+ba/w" --cookies ${LOCAL_COOKIES} --paths $VIDEO_PATH_HD $URL 

echo adjusting file dates...
python3 set_file_date.py ${VIDEO_PATH} ${PLAYLIST_FILE}
python3 set_file_date.py ${VIDEO_PATH_HD} ${PLAYLIST_FILE}

echo syncronizing with remote devices
rsync -avz --delete -e "ssh -i /run/secrets/ssh-key-prv -o UserKnownHostsFile=/run/secrets/ssh-known-hosts" /var/Videos/Youtube_WL root@rpi4:"/storage/videos"
rsync -avz --delete -e "ssh -i /run/secrets/ssh-key-prv -o UserKnownHostsFile=/run/secrets/ssh-known-hosts" /var/Videos/Youtube_WL_HD root@rpi4:"/storage/videos"

echo "****************************************"
echo "*** Completed $(date)"
echo "****************************************"
