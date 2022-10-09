"""
loads a json representation of a playlist as it was returned by yt-dlp -J and 
checks if there is any file in the specified folder, whose id (the part in square brackets in the filename)
is not part of the playlist. If so the file is deleted.
"""

import sys
import json
from pprint import pprint
import os
import re

if len(sys.argv) != 3:
    raise ValueError('usage: remove_videos_not_in_playlist <folder> <playlist-json-file>') 

folder = sys.argv[1]
jsonfile = sys.argv[2]

with open(jsonfile) as f:
    d = json.load(f)

entries = d["entries"]
ids = []
for entry in entries:
    try:
        ids.append(entry["id"])
    except:
        # sometimes null or empty entries in playlist (maybe deleted videos)
        # just skip
        pass    

# pprint(d)
print(ids)

files = os.listdir(folder)
for file in files:
    print(file)
    m = re.match(".*\[([a-zA-Z0-9_\-]+)\].*", file)
    if m is not None:
        fileId = m[1]
        print(fileId)
        if not fileId in ids:
            fullpath = os.path.join(folder, file)
            print("Deleting " + fullpath + "...")
            os.remove(fullpath)
