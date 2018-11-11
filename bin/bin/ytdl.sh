#! /bin/bash

youtube-dl --config-location ~/bin/youtube-channels-playlists.conf && youtube-dl --config-location ~/bin/youtube-channels.conf

# Merge covers into mkv (@ 2 Folders deep)
for file in */*/*.jpg; do 
    title="${file%.*}"
    echo "[ffmpeg] Embedding cover into $title.mkv"
    ffmpeg -loglevel warning  -i "$title.mkv" -c copy -attach "$title.jpg" -metadata:s:t filename=cover_land.jpg -metadata:s:t mimetype=image/jpeg -metadata:s:t title=Thumbnail "$title.temp.mkv"
    rm "$title.mkv" "$title.jpg"
    mv "$title.temp.mkv" "$title.mkv"
done

# Merge covers into mkv (@ 1 Folders deep)
for file in */*.jpg; do 
    title="${file%.*}"
    echo "[ffmpeg] Embedding cover into $title.mkv"
    ffmpeg -loglevel warning -i "$title.mkv" -c copy -attach "$title.jpg" -metadata:s:t filename=cover_land.jpg -metadata:s:t mimetype=image/jpeg -metadata:s:t title=Thumbnail "$title.temp.mkv"
    rm "$title.mkv" "$title.jpg"
    mv "$title.temp.mkv" "$title.mkv"
done

# Replace Audio and Video placeholders with Format
# (@ 2 Folder Deep)
for file in */*/*.mkv; do
    audio="$(mediainfo "--Output=Audio;%Format%" "$file")"
    mv "$file" "${file//Audio/$audio}"
done

for file in */*/*.mkv; do
    video="$(mediainfo "--Output=Video;%Format%" "$file")"
    mv "$file" "${file//Video/$video}"
done

# Replace Audio and Video placeholders with Format
# (@ 1 Folder Deep)
for file in */*.mkv; do
    audio="$(mediainfo "--Output=Audio;%Format%" "$file")"
    mv "$file" "${file//Audio/$audio}"
done

for file in */*.mkv; do
    video="$(mediainfo "--Output=Video;%Format%" "$file")"
    mv "$file" "${file//Video/$video}"
done
