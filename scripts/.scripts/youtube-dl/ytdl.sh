#! /bin/bash
# TODO:
# - Make it so passing a single url it can download
# - Make the post processing sripts more efficent (Basically only run on whats needed and not everything)
# - parse abc iviews api and grab all ep from series url only, currently have to pass each ep url
#   https://iview.abc.net.au/api/shows/
# - Pre-process abc-iview titles so I can get them into a format I prefer

#set -x

# Kill script on SIGKILL
# ctrl+c will stop script
trap 'trap - INT; kill -s HUP -- -$$' INT

# Enable globstar
shopt -s globstar

# Global Variables
VERBOSE=0 # Currently does nothing
VERSION="1.0.0"
# 0 = run whole script
# 1 = no post processing
# 2 = only post processing
POSTPROCESS=0 

# Functions
function check-exists() {
    if [[ -z $(command -v "$1") ]]; then
        echo "Missing dependency: $i"
        exit 1
    fi
}

function die() {
    echo "$1" >&2
    exit 1
}

function convert-to-mkv() {
    title="${file%.*}"
    echo "[mkvmerge] Muxing $title to mkv"
    mkvmerge -o "$title.mkv" "$title.mp4"
    rm "$title.mp4"
    wait
}

function merge-covers() {
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

function replace-placeholder-text() {
    # Replace Audio and Video placeholders with Format
    audio="$(mediainfo "--Output=Audio;%Format%" "$file")"
    video="$(mediainfo "--Output=Video;%Format%" "$file")"
    mv "$file" "${file//Video Audio/$video $audio}"
    wait
}

# Dependency checks
# Check if we have a version of bash new enough to use the features we want
if [[ "${BASH_VERSINFO[0]}" -lt 4 ]]; then 
    echo "Sorry, you need at least bash-4.0 to run this script." >&2 
    exit 1
fi

# Check if we have required dependencies
check-exists youtube-dl
check-exists ffmpeg
check-exists mkvmerge
check-exists mediainfo

# Help Text
# https://stackoverflow.com/a/51911626
__helptext="
Usage: $(basename $0) [-v|--verbose] [ -l|--links links.txt ] [ -s|--site youtube ]

Options:
-l, --links <links>          Pass a list of links to use.
-s, --site <site>            Pass what site you are downloading from, values include:
                                - iview (only tested against abc iview)
                                - iview-series (only tested against abv iview)
                                - twitch (For quick and dirty rips)
                                - twitch-archive (For a proper channel archive which is semi-sorted)
                                - youtube (For quick and dirty rips)
                                - youtube-archive (For a proper channel archive which is semi-sorted)
                             NOTE: If the flag isn't used it'll assume the generic.conf which is a 
                             config with the smallest amount of options enabled.
--no-postprocess             Disables post processing, this includes converting to MKV, embedding covers
                             and replacing the AUDIO and VIDEO placeholder text
--only-postprocess           Only run the post processing steps and not the download steps
-v, --verbose                Verbose output.
-h, --help                   Prints this help.
--version                    Prints version.
"

# Parse user flags
# https://stackoverflow.com/a/28466267
# https://stackoverflow.com/a/46793269
optspec=":l:s:v:h:-:" 
while getopts "$optspec" OPTCHAR; do
    case "${OPTCHAR}" in
        -)
            case "${OPTARG}" in
                help)
                    echo "$__helptext" >&2
                    exit 2
                    ;;
                links)
                    opt=${OPTARG}
                    val="${!OPTIND}"
                    # check value. If negative, assume user forgot value
                    if [[ "$val" == -* ]]; then
                        die "ERROR: --$opt value must not have dash at beginning"
                    fi
                    readarray -t LINKS < ${OPTARG}
                    shift
                    ;;
                site)
                    opt=${OPTARG}
                    val="${!OPTIND}"
                    # check value. If negative, assume user forgot value
                    if [[ "$val" == -* ]]; then
                        die "ERROR: --$opt value must not have dash at beginning"
                    fi
                    SITE="${val}"
                    shift
                    ;;
                no-postprocess)
                    POSTPROCESS=1
                    ;;
                only-postprocess)
                    POSTPROCESS=2
                    ;;
                verbose)
                    VERBOSE=1
                    ;;
                version)
                    echo "$VERSION" >&2
                    exit 2
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac
            ;;
        h|-\?|--help)
            echo "$__helptext" >&2
            exit 2
            ;;
        l)
            readarray -t LINKS < ${OPTARG}
            ;;
        s)
            SITE=${OPTARG}
            ;;
        v)
            VERBOSE=1
            ;;
        *) 
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "ERROR: Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done

# Actual Script
# Download the files
if [[ "$POSTPROCESS" != 2 ]]; then
    case "$SITE" in
        "iview")
            for i in "${LINKS[@]}"; do
                youtube-dl --config-location $HOME/.scripts/youtube-dl/iview.conf "$i"
                echo "[script] Finished downloading series $i"
                wait
            done
            ;;
        "iview-series")
            for i in "${LINKS[@]}"; do
                # The way they name thier episodes are weird, will need to do some pre processing to get into my preferred format.
                # youtube-dl --config-location $HOME/.scripts/youtube-dl/iview.conf --output '%(series)s/Season 0%(season_number)s/%(series)s - S0%(season_number)sE%(episode_number)s [WEB-DL-%(height)sp Video Audio].%(ext)s' "$i"
                youtube-dl --config-location $HOME/.scripts/youtube-dl/iview.conf --output '%(series)s/Season 0%(season_number)s/%(title)s [WEB-DL-%(height)sp Video Audio].%(ext)s' "$i"
                echo "[script] Finished downloading series $i"
                wait
            done
            ;;
        "twitch")
            for i in "${LINKS[@]}"; do
                youtube-dl --config-location $HOME/.scripts/youtube-dl/twitch.conf "$i"
                echo "[script] Finished downloading channel $i"
                wait
            done
            ;;           
        "twitch-archive")
            # Check if we passed any links to $LINKS, if not then use our default list.
            if [[ -z ${LINKS[@]} ]]; then
                readarray -t LINKS < $HOME/.scripts/youtube-dl/twitch-channels.txt
            fi

            for i in "${LINKS[@]}"; do    
                # Note: youtube-dl has a bug where you cant rip user channels as it says they are offline
                # Work around until it gets fixed is append /all onto user channels
                # https://github.com/ytdl-org/youtube-dl/issues/22979
                youtube-dl --config-location $HOME/.scripts/youtube-dl/twitch.conf "$i"/videos/all
                echo "[script] Finished downloading channel $i"
                wait
            done
            ;;
        "youtube")
            for i in "${LINKS[@]}"; do
                youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube.conf "$i"
                echo "[script] Finished downloading channel $i"
                wait
            done
            ;;
        "youtube-archive")
            # Check if we passed any links to $LINKS, if not then use our default list.
            if [[ -z ${LINKS[@]} ]]; then
                readarray -t LINKS < $HOME/.scripts/youtube-dl/yotube-channels.txt
            fi

            for i in "${LINKS[@]}"; do
                # view=1 to view all playlists otherwise you might not catch all playlists
                # goodgameabctv is a good example of this coming in useful
                youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube.conf --output '%(uploader)s/%(playlist)s/%(title)s [ID %(id)s] [WEB-DL-%(height)sp Video Audio].%(ext)s' --playlist-reverse --match-filter "playlist_title != 'Trending'" --match-filter "playlist_title != 'Liked videos'" --match-filter "playlist_title != 'Favorites'" "$i/playlists?view=1"
                youtube-dl --config-location $HOME/.scripts/youtube-dl/youtube.conf "$i"
                echo "[script] Finished downloading channel $i"
                wait
            done
            ;;
        *)
            for i in "${LINKS[@]}"; do
                youtube-dl --config-location $HOME/.scripts/youtube-dl/generic.conf "$i"
                echo "[script] Finished downloading $i"
                wait
            done
            ;;
    esac
fi

# Post Processing
if [[ "$POSTPROCESS" != 1 ]]; then
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
fi
