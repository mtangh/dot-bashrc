#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>/dev/null; pwd)

basedirs=""
_rebuild=0
_verbose=0
_dry_run=0

usage() {
  cat <<_USAGE_
Usage: $THIS [--rebuild] [-d|--dry-run] [dir...]

_USAGE_
  exit 1
}

while [ $# -gt 0 ]
do
  case "$1" in
  --rebuild)
    _rebuild=1
    ;;
  --dry-run|-d)
    _dry_run=1
    ;;
  --verbose|-v)
    _verbose=1
    ;;
  --help)
    usage
    ;;
  -*)
    ;;
  *)
    if [ ! -d "${1}" ]
    then
      echo "${THIS%.*}: no such directory '${1}'." 1>&2
      exit 1
    fi 
    if [ -z "$basedirs" ]
    then
      basedirs="${1}"
    else
      basedirs="${basedirs}\n${1}"
    fi
    ;;
  esac
  shift
done

basedirs="${basedirs:-.}"

[ $_rebuild -ne 0 ] && {
  if [ $_dry_run -eq 0 ]
  then
    findcmd="rm -f"
  else
    findcmd="echo"
  fi
  # Remove gitkeep
  find ${basedirs} \
       -name ".gitkeep" -a type f \
       -exec $findcmd {} \; 2>/dev/null
  echo
}

exec 2>/dev/null

echo -e ${basedirs} |
while read base_dir
do
  echo "${THIS%.*}: Finding '$base_dir'"
  find "$base_dir" -type d |
  while read dir
  do
    [ $_verbose -ne 0 ] &&
      echo "${THIS%.*}: #1 Check dir '$dir'"
    echo "${dir}" |
    grep -E '^(/.+|\.+|(.*/){0,1}\.(git|svn|cvs)(/.*){0,1})$' 1>&2 &&
      continue
    [ $_verbose -ne 0 ] &&
      echo "${THIS%.*}: #2 Dir '$dir' have a child ?"
    echo $(ls -1A "${dir}" |wc -l) |grep -vE '^0$' 1>&2 &&
      continue
    [ $_verbose -ne 0 ] &&
      echo "${THIS%.*}: #2 Dir '$dir' is have not child."
    [ -e "${dir}/.gitkeep" ] &&
      continue
    [ $_verbose -ne 0 ] &&
      echo "${THIS%.*}: #3 Dir '$dir' is gitkeeping."
    [ $_dry_run -eq 0 ] &&
      touch "${dir}"/.gitkeep
    echo "${THIS%.*}: + '$dir'"
  done
done

exit 0
