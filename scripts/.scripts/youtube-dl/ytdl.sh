#! /bin/bash

# Kill script on SIGKILL
# ctrl+c will stop script
trap 'trap - INT; kill -s HUP -- -$$' INT

if [[ -z $1 ]]; then
    YTCHANNELS=$(<$HOME/.scripts/youtube-dl/youtube-channels.txt)
else
    YTCHANNELS=$(<$1)
fi

# TODO:
# - Pass flags so only certain portions of this script can be run
# - Make it so passing a single url it can download
# - Make it less youtube specific and more general purpose while also being true to its original purpose
# - Make the post processing sripts more efficent (Basically only run on whats needed and not everything)
# Note: I may need to convert this to a python script at some point for these TODO's to become reality
# and at some point the bash script will become unwieldy

function post-process-playlists {
    # Merge covers into mkv (@ 2 Folders deep)
    for file in */*/*.jpg; do 
        title="${file%.*}"
        echo "[ffmpeg] Embedding cover into $title.mkv"
        ffmpeg -loglevel warning  -i "$title.mkv" -c copy -attach "$title.jpg" -metadata:s:t filename=cover_land.jpg -metadata:s:t mimetype=image/jpeg -metadata:s:t title=Thumbnail "$title.temp.mkv"
        rm "$title.mkv" "$title.jpg"
        mv "$title.temp.mkv" "$title.mkv"
        wait
    done
    
    # Replace Audio and Video placeholders with Format (@ 2 Folder Deep)
    for file in */*/*.mkv; do
        audio="$(mediainfo "--Output=Audio;%Format%" "$file")"
	video="$(mediainfo "--Output=Video;%Format%" "$file")"
        mv "$file" "${file//Video Audio/$video $audio}"
        wait
    done
}

function post-process-channel {
    # Merge covers into mkv (@ 1 Folders deep)
    for file in */*.jpg; do 
        title="${file%.*}"
        echo "[ffmpeg] Embedding cover into $title.mkv"
        ffmpeg -loglevel warning -i "$title.mkv" -c copy -attach "$title.jpg" -metadata:s:t filename=cover_land.jpg -metadata:s:t mimetype=image/jpeg -metadata:s:t title=Thumbnail "$title.temp.mkv"
        rm "$title.mkv" "$title.jpg"
        mv "$title.temp.mkv" "$title.mkv"
        wait
    done

    # Replace Audio and Video placeholders with Format (@ 1 Folder Deep)
    for file in */*.mkv; do
        audio="$(mediainfo "--Output=Audio;%Format%" "$file")"
        video="$(mediainfo "--Output=Video;%Format%" "$file")"
        mv "$file" "${file//Video Audio/$video $audio}"
        wait
    done
}

for i in $YTCHANNELS; do
    # view=1 to view all playlists otherwise you might not catch all playlists
    # goodgameabctv is a good example of this coming in useful
    youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube-channels-playlists.conf "$i/playlists?view=1"
    youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube-channels.conf "$i"
    echo "[script] Finished downloading channel $i"
    wait
done

post-process-playlists
post-process-channel
