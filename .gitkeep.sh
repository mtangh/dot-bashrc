#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>/dev/null; pwd)

THIS="${THIS:-gitkeep.sh}"
BASE="${BASE}"

basedirs=""
_rebuild=0
_verbose=0
_dry_run=0

usage() {
  local exitstat="${1:-1}"
  cat <<_USAGE_
Usage: $THIS [OPTION] [dir...]

OPTION:
-R,--rebuild
  Remove gitkeep.
-d,--dry-run
  Enable dry-run mode.
-v,--verbose
  Verbose print.

_USAGE_
  exit $exitstat
}

while [ $# -gt 0 ]
do
  case "$1" in
  -R|--rebuild) _rebuild=1 ;;
  -d|--dry-run) _dry_run=1 ;;
  -v|--verbose) _verbose=1 ;;
  -h|--help)    usage 0 ;;
  -*)           usage 1 ;;
  *)
    if [ -d "${1}" ]
    then
      # Base dir
      basedirs="${basedirs}${1}\n"
    else
      echo "${BASE}: no such directory '${1}'." 1>&2
      exit 1
    fi
    ;;
  esac
  shift
done

# No unbound vars
set -u

# Set default '.' (if empty)
basedirs="${basedirs:-.\n}"

# Work
base_dir=""
keep_dir=""

# Rebuild
[ $_rebuild -ne 0 ] && {

  findcmd=$(
    [ $_dry_run -eq 0 ] && echo "rm -f"
    [ $_dry_run -eq 0 ] || echo "echo")

  # Remove gitkeep
  printf "%b" "${basedirs}" |sort -u |
  while read base_dir
  do
    find "${base_dir}" \
      -name ".gitkeep" -a type f \
      -exec $findcmd {} \; ;
  done 2>/dev/null
  echo

} # [ $_rebuild -ne 0 ]

# Finding dirs
printf "%b" "${basedirs}" |sort -u |
while read base_dir
do

  echo "${BASE}: Finding '$base_dir'."

  find "$base_dir" -type d |sort -u |
  while read keep_dir
  do

    [ $_verbose -ne 0 ] &&
      echo "${BASE}: #1 Check dir '${keep_dir}'"

    echo "${keep_dir}" |
    egrep '^(/.+|\.+|(.*/){0,1}\.(git|svn|cvs)(/.*){0,1})$' 1>&2 &&
      continue

    [ $_verbose -ne 0 ] &&
      echo "${BASE}: #2 Dir '${keep_dir}' have a child ?"

    echo $(ls -1A "${keep_dir}" |wc -l) |
    egrep -v '^0$' 1>&2 &&
      continue

    [ $_verbose -ne 0 ] &&
      echo "${BASE}: #3 Dir '${keep_dir}' is have not child."

    [ -e "${keep_dir}/.gitkeep" ] &&
      continue

    [ $_verbose -ne 0 ] &&
      echo "${BASE}: #4 Dir '${keep_dir}' is gitkeeping."

    [ $_dry_run -eq 0 ] &&
      touch "${keep_dir}"/.gitkeep

    echo "${BASE}: + '${keep_dir}'"

  done

done 2>/dev/null

# End
exit 0
