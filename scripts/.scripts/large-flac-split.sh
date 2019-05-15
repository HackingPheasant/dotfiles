#! /bin/bash
# Split one flac file into tracks using cuetools.
# Requires: cuetools shntool flac
set -eu

function usage {
  echo "Usage: ${0##*/} [-d DEST] FILE.cue FILE.flac"
  echo "  -d DEST     destination (defaults to working directory)"
  echo
  echo "Requires cuetools, shntool and flac."
}


[[ -z $@ ]] && usage && exit 0


# get the options
while getopts ":d:" opt
do
  case $opt in
    d)  DESTDIR="${OPTARG}" ;;
    ?)  echo "Illegal option: $OPTARG" ;;
  esac
done
shift $(( OPTIND-1 ))


# validate args
err=0
if [[ $# -ne 2 || "${1: -4:4}" != .cue || "${2: -5:5}" != .flac ]]
then
  usage && err=$(( err+1 ))
else
  [[ ! -e "$1" ]] && echo "No such file: $1" >&2 && err=$(( err+2 ))
  [[ ! -e "$2" ]] && echo "No such file: $2" >&2 && err=$(( err+3 ))
fi
(( $err )) && exit $err


# split the flac file
CUESHEET="$1"
FLACFILE="$2"
DESTDIR="${DESTDIR:-.}"

mkdir -p "${DESTDIR}"
shnsplit -d "${DESTDIR}" -f "${CUESHEET}" -o flac -t "$$_%n %t" "${FLACFILE}"
cuetag.sh "${CUESHEET}" "${DESTDIR}"/$$_*.flac

for pid in "${DESTDIR}"/$$_*.flac
do
  nopid=$(echo "${pid}" | sed "s,/${$}_,/,")
  mv -i "${pid}" "${nopid}"
done


# vim:ts=2:sts=2:sw=2
