#! /bin/bash

# Kill script on SIGKILL
# ctrl+c will stop script
trap 'trap - INT; kill -s HUP -- -$$' INT

# Enable globstar
shopt -s globstar

if [[ -z $1 ]]; then
    LINKS=$(<$HOME/.scripts/youtube-dl/youtube-channels.txt)
else
    LINKS=$(<$1)
fi

# TODO:
# - Pass flags so only certain portions of this script can be run
# - Make it so passing a single url it can download
# - Make it less youtube specific and more general purpose while also being true to its original purpose
# - Make the post processing sripts more efficent (Basically only run on whats needed and not everything)
# Note: I may need to convert this to a python script at some point for these TODO's to become reality
# and at some point the bash script will become unwieldy

function convert-to-mkv {
    title="${file%.*}"
    echo "[mkvmerge] Muxing $title to mkv"
    mkvmerge -o "$title.mkv" "$title.mp4"
    rm "$title.mp4"
    wait
}

function merge-covers {
    # Merge covers into mkv
    title="${file%.*}"
    if [[ -e "$title.mkv" ]]; then
        echo "[ffmpeg] Embedding cover into $title.mkv"
        ffmpeg -loglevel warning  -i "$title.mkv" -c copy -attach "$title.jpg" -metadata:s:t filename=cover_land.jpg -metadata:s:t mimetype=image/jpeg -metadata:s:t title=Thumbnail "$title.temp.mkv"
        rm "$title.mkv" "$title.jpg"
        mv "$title.temp.mkv" "$title.mkv"
    fi
    wait
}

function replace-placeholder-text {
    # Replace Audio and Video placeholders with Format
    audio="$(mediainfo "--Output=Audio;%Format%" "$file")"
    video="$(mediainfo "--Output=Video;%Format%" "$file")"
    mv "$file" "${file//Video Audio/$video $audio}"
    wait
}

for i in $LINKS; do
    # view=1 to view all playlists otherwise you might not catch all playlists
    # goodgameabctv is a good example of this coming in useful
    # FYI, I am keeping the generic config options  in the config file 
    # and then passing the unique options on the commandline
    youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube.conf --output '%(uploader)s/%(playlist)s/%(title)s [ID %(id)s] [WEB-DL-%(height)sp Video Audio].%(ext)s' --playlist-reverse --match-filter "playlist_title != 'Trending'" --match-filter "playlist_title != 'Liked videos'" --match-filter "playlist_title != 'Favorites'" "$i/playlists?view=1"
    youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube.conf "$i"
    echo "[script] Finished downloading channel $i"
    wait
done

for file in **/*.mp4; do
    convert-to-mkv
    wait
done

for file in **/*.jpg; do
    merge-covers
    wait
done

for file in **/*.mkv; do
    replace-placeholder-text
    wait
done
