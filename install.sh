#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>/dev/null; pwd)

# Name
THIS="${THIS:-install.sh}"
BASE="${THIS%.*}"

# Path
PATH=/usr/bin:/bin; export PATH

# dot-bashrc URL
DOT_BASHRC_URL="${DOT_BASHRC_URL:-https://github.com/mtangh/dot-bashrc.git}"
# dot-bashrc Installation source
DOT_BASHRC_SRC="${DOT_BASHRC_SRC:-}"
# dot-bashrc Working dir
DOT_BASHRC_TMP=""

# Flags
BASHRC_INSTALL=0
INSTALL_GLOBAL=0
SETUP_SKELETON=0
ENABLE_DRY_RUN=0
ENABLE_X_TRACE=0

# Debug
case "${DEBUG:-NO}" in
0|[Nn][Oo]|[Oo][Ff][Ff])
  ;;
*)
  ENABLE_DRY_RUN=1
  ENABLE_X_TRACE=1
  ;;
esac || :

# Set flags from environment variables
[ -n "$DOT_BASHRC_SYSTEM" ] &&
INSTALL_GLOBAL=1
[ -n "$DOT_BASHRC_SKEL" ] &&
SETUP_SKELETON=1
[ -n "$DOT_BASHRC_DEBUG" ] && {
  ENABLE_DRY_RUN=1
  ENABLE_X_TRACE=1
}

# Echo
_echo() {
  local row_data="" 1>/dev/null 2>&1
  if [ -n "$@" ]
  then printf "$THIS: %s" "$@"; echo
  else
    cat |
    while read row_data
    do printf "$THIS: %s" "$row_data"; echo
    done
  fi 2>/dev/null
  return 0
}

# Abort
_abort() {
  local exitcode=1 1>/dev/null 2>&1
  case "$1" in
  [0-9]|[1-9][0-9]|[1-9][0-9][0-9])
    exitcode="$1"; shift ;;
  *)
    ;;
  esac 1>/dev/null 2>&1
  _echo "ERROR: $@ (${exitcode:-1})" 1>&2
  exit ${exitcode:-1}
}

# Cleanup
_cleanup() {
  [ -z "${DOT_BASHRC_TMP}" ] || {
    rm -rf "${DOT_BASHRC_TMP}" 1>/dev/null 2>&1
  } || :
  return 0
}

# Process template file
_process_template_file() {
  local _src="$1"; shift
  local _dst="$1"; shift
  [ -n "${_src}" ] || return 1
  [ -n "${_dst}" ] || return 1
  [ -r "${_src}" ] || return 2
  cat "${_src}" |
  sed -e 's@{{[ ]*ansible_managed[ ]*}}@'"${dotbashtag}"'@g' \
      -e 's@{{[ ]*bashrc_install_path[ ]*[^\}]*}}@'"${dotinstall}"'@g' \
      -e 's@{{[ ]*bashrc_bashrcdir_path[ ]*[^\}]*}}@'"${dotbasedir}"'@g' \
      -e 's@{{[ ]*bashrc_bashrcdir_name[ ]*[^\}]*}}@'"${dotbasedir##*/}"'@g' \
      -e 's@{{[ ]*bashrc_bash_rc_file_path[ ]*[^\}]*}}@'"${dotinstall}/${bashrcfile}"'@g' \
      -e 's@{{[ ]*bashrc_bash_profile_path[ ]*[^\}]*}}@'"${dotinstall}/${bashrcprof}"'@g' \
      -e 's@{{[ ]*bashrc_bashrc_name[ ]*[^\}]*}}@'"${bashrcfile}"'@g' \
      -e 's@{{[ ]*bashrc_profile_name[ ]*[^\}]*}}@'"${bashrcprof}"'@g' \
      1>|"${_dst}" 2>/dev/null && {
    : && {
      echo "Difference between ${_src##*/} and ${_dst##*/}."
      diff -u "${_src}" "${_dst}" || :
      echo
    } |_echo
  }
  return $?
}

# Parsing command line options
while [ $# -gt 0 ]
do
  case "$1" in
  --install)
    BASHRC_INSTALL=1
    ;;
  --source=*)
    [ -n "${1##*--source=}" ] && {
      DOT_BASHRC_SRC="${1##*--source=}"
    }
    ;;
  --workdir=*)
    [ -n "${1##*--workdir=}" ] && {
      DOT_BASHRC_TMP="${1##*--workdir=}"
    }
    ;;
  -G*|--global*|--system*)
    INSTALL_GLOBAL=1
    ;;
  -U*|--user*|--local*)
    INSTALL_GLOBAL=0
    ;;
  -skel|--skel|--with-skel)
    SETUP_SKELETON=1
    ;;
  -without-skel|--without-skel)
    SETUP_SKELETON=0
    ;;
  -D*|-debug*|--debug*)
    ENABLE_X_TRACE=1
    ;;
  -n*|-dry-run*|--dry-run*)
    ENABLE_DRY_RUN=1
    ;;
  -h|--help)
    ;;
  -*)
    _abort 22 "Illegal option '${1}'."
    ;;
  *)
    _abort 22 "Illegal argument '${1}'."
    ;;
  esac
  shift
done

# SKEL
if [ -$INSTALL_GLOBAL -eq 0 ]
then SETUP_SKELETON=0
fi

# Working dir
[ -n "${DOT_BASHRC_TMP}" -a -d "${DOT_BASHRC_TMP}" ] || {
  DOT_BASHRC_TMP="${TMPDIR:-/tmp}/.dot-bashrc.$$"
}

# Source dir
[ -n "${DOT_BASHRC_SRC}" -a -d "${DOT_BASHRC_SRC}" ] || {
  DOT_BASHRC_SRC="${DOT_BASHRC_TMP}/dot-bashrc/roles/bashrc"
}

# Prohibits overwriting by redirect and use of undefined variables.
set -Cu

# Enable trace, verbose
[ $ENABLE_X_TRACE -eq 0 ] || {
  PS4='>(${BASH_SOURCE:-$THIS}:${LINENO:-0})${FUNCNAME:+:$FUNCNAME()}: '
  export PS4
  set -xv
}

# "/bin/bash" ?
[ -x "/bin/bash" ] || {
  _abort 1 "'/bin/bash' not installed."
}

# Verify the permissions for global installation availability.
if [ $INSTALL_GLOBAL -ne 0 ]
then
  [ "$(id -u 2>/dev/null)" = "0" ] || {
    _abort 13 "Need SUDO."
  }
fi

# Create a working directory if does not exist.
[ -d "${DOT_BASHRC_TMP}" ] || {
  mkdir -p "${DOT_BASHRC_TMP}" &&
  chmod 0700 "${DOT_BASHRC_TMP}" 1>/dev/null 2>&1
}

# Trap
[ $ENABLE_DRY_RUN -eq 0 ] && {
  # Set trap
  trap "_cleanup" SIGTERM SIGHUP SIGINT SIGQUIT
  trap "_cleanup" EXIT
}

# Run
if [ $BASHRC_INSTALL -eq 0 ]
then

  dotbashrcopts=""
  dotbashrc_git="$(type -P git)"
  dotbashrcplay="$(type -P ansible-playbook)"
  dotbashrc_ret=0

  [ -n "${DOT_BASHRC_URL}" ] || {
    _abort 1 "'DOT_BASHRC_URL' is empty."
  }

  [ -n "${dotbashrc_git}" ] || {
    _abort 1 "Can not find the 'git'."
  }

  ( cd "${DOT_BASHRC_TMP}" 2>/dev/null &&
    ${dotbashrc_git} clone "$DOT_BASHRC_URL" ) || {
    _abort 1 "failed 'git clone'."
  }

  cd "${DOT_BASHRC_TMP}/dot-bashrc/" 2>/dev/null || {
    _abort 2 "'dot-bashrc': no such file or directory."
  }

  cat <<_MSG_ |_echo
#
# dot-bashrc/install.sh
#
_MSG_

  if [ -x "${dotbashrcplay}" -a -r "./ansible.yml" ]
  then

    dotbashrcopts=""

    [ $INSTALL_GLOBAL -eq 0 ] ||
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }-e bashrc_install_global=true"
    [ $SETUP_SKELETON -eq 0 ] ||
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }-e bashrc_install_skel=true"
    [ $ENABLE_DRY_RUN -eq 0 ] ||
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }-D"

    cat <<_MSG_ |_echo
#
# run - ${dotbashrcplay} ${dotbashrcopts} ansible.yml
#
_MSG_

    ${dotbashrcplay} ${dotbashrcopts} ./ansible.yml
    dotbashrc_ret=$?

  else

    dotbashrcopts=""
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }--install"
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }--source=${DOT_BASHRC_SRC}"
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }--workdir=${DOT_BASHRC_TMP}"

    [ $INSTALL_GLOBAL -ne 0 ] &&
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }--global"
    [ $SETUP_SKELETON -ne 0 ] &&
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }--with-skel"
    [ $ENABLE_DRY_RUN -ne 0 ] &&
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }--dry-run"

    cat <<_MSG_ |_echo
#
# run - bash ./$THIS $installoption
#
_MSG_

    bash ./$THIS $dotbashrcopts
    dotbashrc_ret=$?

  fi

  exit $dotbashrc_ret

fi # if [ $BASHRC_INSTALL -eq 0 ]

# Installation will start.
cat <<_MSG_ |_echo
#---------------------------------------
# dot-bashrc/install.sh
#---------------------------------------
_MSG_

# Installation Tag
dotbashtag="dot-bashrc/$THIS, $(date)"

# Installation source path
dotfilesrc="files/etc/bash.bashrc.d"

# Confirm existence of source to be installed
[ -d "${DOT_BASHRC_SRC}/${dotfilesrc}" ] || {
  _abort 2 "'DOT_BASHRC_SRC/${dotfilesrc:-???}' no such file or dorectory."
}

# Change the current directory to install-source
cd "${DOT_BASHRC_SRC}" 2>/dev/null || {
  _abort 2 "'${DOT_BASHRC_SRC}' no such file or dorectory."
}

# Installation settings
if [ $INSTALL_GLOBAL -ne 0 ]
then
  # System install
  dotinstall=/etc
  dotbackdir="${dotinstall}/._bashrc-origin"
  dotbasedir="${dotinstall}/bash.bashrc.d"
  bashrcfile="bash.bashrc"
  bashrcprof="bash.profile"
  bashrcuser="root"
  bashrc_grp=$(id -gn "$bashrcuser")
else
  # User local install
  dotinstall="$HOME/.config"
  dotbackdir="${dotinstall}/._bashrc-origin"
  dotbasedir="${dotinstall}/bash.bashrc.d"
  bashrcfile="bash.bashrc"
  bashrcprof="bash.profile"
  bashrcuser=$(id -un)
  bashrc_grp=$(id -gn "$bashrcuser")
fi

# Change to the installation setting for dry-run mode
[ $ENABLE_DRY_RUN -ne 0 ] && {
  dotinstall="${DOT_BASHRC_TMP}${dotinstall}"
  dotbasedir="${DOT_BASHRC_TMP}${dotbasedir}"
}

# Template files
tmpltfiles=$(
  : && {
    cd "${DOT_BASHRC_SRC}/templates" &&
    find etc -type f -a -name "*.j2" |sort
  } 2>/dev/null; )

# Symlinks ("from:to" format)
dotsymlnks=$(
  : && {
    cat <<_EOF_
${bashrcprof}:profile
${bashrcfile}:bashrc
_EOF_
  } 2>/dev/null; )

# User home updater
usrhomeupd="${dotbasedir}/bin/update-user-home"

# Print variables
cat <<_MSG_ |_echo
**
* dotinstall="$dotinstall"
* dotbasedir="$dotbasedir"
* bashrcfile="$bashrcfile"
* bashrcprof="$bashrcprof"
* bashrcuser="$bashrcuser"
* bashrc_grp="$bashrc_grp"
**
_MSG_

# Backup the original file
[ -d "${dotbackdir}" ] || {

  echo
  echo "Create a backup."

  mkdir -p "${dotbackdir}" 2>/dev/null || :

  ( cd "${dotbackdir}" &&
    pwd &&
    for file in \
      bashrc profile \
      bash.bashrc bash.profile \
      bash_profile bash_logout
    do
      if [ $GLOBAL_INSTALL -ne 0 ]
      then
        [ -e "${dotinstall}/${file}" ] && {
          cp -prf ${dotinstall}/${file} ./ 2>/dev/null &&
          echo "${dotinstall}/${file}: Backed to '${dotbackdir}'."
        }
      else
        [ -e "${HOME}/.${file}" ] && {
          cp -prfv ${dotinstall}/.${file} ./ 2>/dev/null &&
          echo "${dotinstall}/.${file}: Backed to '${dotbackdir}'."
        }
      fi
    done; )

  echo

} 2>/dev/null |
_echo

# Print message
_echo "Install the 'bash.bashrc.d' to '${dotbasedir}'."

# Install the file
if [ ! -e "${dotbasedir}" -o -z "$(type -P patch)" ]
then

  [ -e "${dotbasedir}" ] && {
    mv -f "${dotbasedir}" \
          "${dotbasedir}.$(date +'%Y%m%d_%H%M%S')"
  }

  mkdir -p "${dotbasedir}" 1/dev/null 2>&1

  ( cd "${DOT_BASHRC_SRC}" &&
    tar -c . |tar -C "${dotbasedir}/" -xvf - |_echo; )

  if [ $? -ne 0 ]
  then
    _abort 1 "Abort: 'tar -c . |tar -C "${dotbasedir}/" -xvf -'."
  fi

else

  ( cd "${dotbasedir}" &&
    diff -Nur . "${DOT_BASHRC_SRC}" |patch -p0 |_echo; )

  if [ $? -ne 0 ]
  then
    _abort 1 "Abort: 'diff -Nur . "${DOT_BASHRC_SRC}" |patch -p0'."
  fi

fi

# Print message
_echo "Install the templates."

# Process the template file
( cd "${dotinstall}/" &&
  for dbrtmplent in $(
    [ -d "${DOT_BASHRC_SRC}/templates/etc" ] &&
    cd "${DOT_BASHRC_SRC}/templates" 2>/dev/null &&
    find etc -type f -a -name "*.j2" |sort; )
  do

    dbrtmplsrc="${DOT_BASHRC_SRC}/templates/${dbrtmplent}"
    dbrtmpl_to="${dbrtmplent##*etc/}"
    dbrtmpl_to="${dbrtmpl_to%.j2*}"

    [ -e "${dbrtmplsrc}" ] || continue
    [ -n "${dbrtmpl_to}" ] || continue

    case "${dbrtmpl_to}" in
    */*)
      [ -z "${dbrtmpl_to%/*}" -o -d "${dbrtmpl_to%/*}" ] || {
        mkdir -p "${dbrtmpl_to%/*}" 2>/dev/null || :
      }
      ;;
    *)
      ;;
    esac

    _message="Process templates '${dbrtmplsrc}' to '${dbrtmpl_to}'"

    _process_template_file "${dbrtmplsrc}" "${dbrtmpl_to}"

    if [ $? -eq 0 ]
    then echo "${_message}: OK."
    else echo "${_message}: NG."; exit 1
    fi

  done |_echo; )

if [ $? -ne 0 ]
then
  _abort 1 "Abort: One or more template files could not be installed."
fi

# Print message
_echo "Grant and revoke on 'bash.bashrc.d' files."

# Set installation file permissions
( : && {
    cd "${dotbasedir}" 2>/dev/null &&
    chown -R "${bashrcuser}:${bashrc_grp}" . 2>/dev/null &&
    find . -type d -print -exec chmod u=rwx,go=rx {} \; 2>/dev/null &&
    find . -type f -print -exec chmod u=rw,go=r {} \; 2>/dev/null &&
    find . -type f -a -name "*.sh*" -print -exec chmod a+x {} \; 2>/dev/null &&
    find ./bin -type f -print -exec chmod a+x {} \; 2>/dev/null &&
    echo ||
    exit 1
  } |_echo; )

if [ $? -ne 0 ]
then
  _abort 1 "Abort: Permission setting failed."
fi

# Symlinks
if [ $INSTALL_GLOBAL -ne 0 ]
then

  # Print message
  _echo "Create symlinks."

  # Symlink processing
  ( cd "${dotinstall}" &&
    for symlnk_ent in ${dotsymlnks}
    do

      symlnk_src=$(echo "${symlnk_ent}"|cut -d: -f1 2>/dev/null)
      symlnk_dst=$(echo "${symlnk_ent}"|cut -d: -f2 2>/dev/null)

      [ -e "${symlnk_src}" ] || continue
      [ -n "${symlnk_dat}" ] || continue

      [ "${symlnk_src}" != "${symlnk_dst}" ] || continue

      case "${symlnk_dst}" in
      */*)
        [ -z "${symlnk_dst%/*}" -o -e "${symlnk_dst%/*}" ] || {
          mkdir -p "${symlnk_dst%/*}"
        }
        ;;
      *)
        ;;
      esac

      _message="Symlink '${symlnk_src}' to '${symlnk_dst}'"

      ln -sf "${symlnk_src}" "${symlnk_dst}" 2>/dev/null

      if [ $? -eq 0 ]
      then echo "${_message}: OK."
      else echo "${_message}: NG."; exit 1
      fi

    done |_echo; )

  if [ $? -ne 0 ]
  then
    _abort 1 "Abort: Symlink creation failed."
  fi

fi

# The options for update-user-home
usrhomeopt=""
[ $ENABLE_DRY_RUN -ne 0 ] &&
usrhomeopt="${usrhomeopt:+$usrhomeopt }--dry-run"
[ $ENABLE_X_TRACE -ne 0 ] &&
usrhomeopt="${usrhomeopt:+$usrhomeopt }--debug"

# bash rc-files setup from skeleton
if [ $SETUP_SKELETON -ne 0 ]
then

  # print
  _echo "Update USER-HOME Template."

  # Update SKEL
  ( cd "${dotbasedir}" 2>/dev/null &&
    [ -x "${usrhomeupd}" ] && {
      "${usrhomeupd}" ${usrhomeopt} --update-skel
      exit $?
    } |_echo; )

fi # if [ $SETUP_SKELETON -ne 0 ]

# Sync user-home
if [ $INSTALL_GLOBAL -eq 0 ]
then

  # print
  _echo "Update USER-HOME."

  # Update user-home
  ( cd "${dotbasedir}" 2>/dev/null &&
    [ -x "${usrhomeupd}" ] && {
      "${usrhomeupd}" ${usrhomeopt} --skel=./skel.d
      exit $?
    } |_echo; )

fi # if [ $INSTALL_GLOBAL -eq 0 ]

# Finish installation
_echo "Done."

# End
exit 0
