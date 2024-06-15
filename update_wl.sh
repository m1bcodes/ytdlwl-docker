#!/bin/bash

echo "****************************************"
echo "*** Starting $(date)"
echo "****************************************"

PLAYLIST_FILE=/var/tmp/playlist.json
VIDEO_PATH=/var/Videos/Youtube_WL
VIDEO_PATH_HD=/var/Videos/Youtube_WL_HD
COOKIES_FILE=/run/secrets/yt-cookies

echo downloading playlist...
yt-dlp -J --cookies ${COOKIES_FILE} https://www.youtube.com/playlist?list=WL > ${PLAYLIST_FILE}

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
yt-dlp --download-archive ${VIDEO_PATH}/archive.txt --embed-thumbnail --embed-metadata --embed-chapters --restrict-filenames -f "best[height=720]" --cookies ${COOKIES_FILE} --paths $VIDEO_PATH https://www.youtube.com/playlist?list=WL 
yt-dlp --download-archive ${VIDEO_PATH_HD}/archive.txt --embed-thumbnail --embed-metadata --embed-chapters --restrict-filenames -f "bv*[height<=1080]+ba/b[height<=1080]/wv*+ba/w" --cookies ${COOKIES_FILE} --paths $VIDEO_PATH_HD https://www.youtube.com/playlist?list=WL 

echo adjusting file dates...
python3 set_file_date.py ${VIDEO_PATH} ${PLAYLIST_FILE}
python3 set_file_date.py ${VIDEO_PATH_HD} ${PLAYLIST_FILE}

echo "****************************************"
echo "*** Completed $(date)"
echo "****************************************"
