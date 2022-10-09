#!/bin/bash

OUTPUT_PATH=./downloads

echo downloading playlist...
yt-dlp -J --cookies ./cookies/cookies.txt https://www.youtube.com/playlist?list=WL > ${OUTPUT_PATH}/playlist.json

echo purging...
python3 remove_videos_not_in_playlist.py ${OUTPUT_PATH} ${OUTPUT_PATH}/playlist.json

echo downloading files...
yt-dlp --embed-thumbnail --embed-metadata --embed-chapters --restrict-filenames -f "best[height=720]" --cookies ~/ytdlwl/cookies/cookies.txt --paths $OUTPUT_PATH https://www.youtube.com/playlist?list=WL 

echo adjusting file dates...
python3 set_file_date.py ${OUTPUT_PATH} ${OUTPUT_PATH}/playlist.json
