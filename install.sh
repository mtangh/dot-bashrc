#!/bin/bash
THIS="${BASH_SOURCE##*/}"
CDIR=$(cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Name
THIS="${THIS:-install.sh}"
NAME="${THIS%.*}"

# Path
PATH=/usr/bin:/usr/sbin:/bin:/sbin; export PATH

# dot-bashrc URL
DOT_BASHRC_URL="${DOT_BASHRC_URL:-https://github.com/mtangh/dot-bashrc.git}"
# dot-bashrc Installation source
DOT_BASHRC_SRC="${DOT_BASHRC_SRC:-}"
# dot-bashrc Working dir
DOT_BASHRC_TMP="${DOT_BASHRC_TMP:-}"
# dot-bashrc project name
DOT_BASHRC_PRJ="${DOT_BASHRC_URL##*/}"
DOT_BASHRC_PRJ="${DOT_BASHRC_PRJ%.*}"

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
[ -n "${DOT_BASHRC_SYSTEM:-}"  ] &&
INSTALL_GLOBAL=1
[ -n "${DOT_BASHRC_SKEL:-}" ] &&
SETUP_SKELETON=1
[ -n "${DOT_BASHRC_DEBUG:-}" ] && {
  ENABLE_DRY_RUN=1
  ENABLE_X_TRACE=1
}

# Stdout
_stdout() {
  local rowlanel="${1:-$THIS}"
  local row_data=""
  cat | while IFS= read row_data
  do
    if [[ "${row_data}" =~ ^${rowlanel}: ]]
    then printf "%s" "${row_data}"
    else printf "${rowlanel}: %s" "${row_data}"
    fi; echo
  done
  return 0
}

# Abort
_abort() {
  local exitcode=1 &>/dev/null
  [[ ${1} =~ ^[0-9]+$ ]] && {
    exitcode="$1"; shift;
  } &>/dev/null
  echo "ERROR: $@" "(${exitcode:-1})" |_stdout 1>&2
  [ ${exitcode:-1} -le 0 ] || exit ${exitcode:-1}
  return 0
}

# Cleanup
_cleanup() {
  if [ $ENABLE_DRY_RUN -eq 0 ]
  then
    [ -z "${DOT_BASHRC_TMP}" ] || {
      rm -rf "${DOT_BASHRC_TMP}" 1>/dev/null 2>&1
    } || :
  else
    echo rm -rf "${DOT_BASHRC_TMP}"
  fi
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
      -e 's@{{[ ]*bashrc_bash_logout_path[ ]*[^\}]*}}@'"${dotinstall}/${bashrclout}"'@g' \
      -e 's@{{[ ]*bashrc_bashrc_name[ ]*[^\}]*}}@'"${bashrcfile}"'@g' \
      -e 's@{{[ ]*bashrc_profile_name[ ]*[^\}]*}}@'"${bashrcprof}"'@g' \
      -e 's@{{[ ]*bashrc_logout_name[ ]*[^\}]*}}@'"${bashrclout}"'@g' \
      1>|"${_dst}" 2>/dev/null && {
    : && {
      echo "Difference between '${_src##*/}' and '${_dst##*/}'."
      diff -u "${_src}" "${_dst}" || :
      echo
    }
  }
  return $?
}

_usage() {
  cat <<_USAGE_
Usage: $DOT_BASHRC_PRJ/$THIS [OPTIONS]

OPTIONS:

-G, --global
  Install in the global scope.
-U, --user
  Install in the user environment.
--skel
  Update the system user template (SKEL).
-D, --debug
  Enable debug output.
-n, --dry-run
  Dry run mode

_USAGE_
  return 0
}

# Parsing command line options
while [ $# -gt 0 ]
do
  case "${1}" in
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
    _usage; exit 0
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

# Redirect to filter
exec 1> >(set +x; _stdout "${DOT_BASHRC_PRJ}/${THIS}" 2>/dev/null)

# Prohibits overwriting by redirect and use of undefined variables.
set -Cu

# Enable trace, verbose
[ $ENABLE_X_TRACE -eq 0 ] || {
  PS4='>(${THIS}:${LINENO:-?})${FUNCNAME:+:$FUNCNAME()}: '
  export PS4
  set -xv
}

# SKEL
if [ $INSTALL_GLOBAL -eq 0 ]
then SETUP_SKELETON=0
fi

# Source dir
[ -z "${DOT_BASHRC_SRC}" -o -d "${DOT_BASHRC_SRC}" ] || {
  _abort 2 "'${DOT_BASHRC_SRC}': no such file or dorectory."
}

# Working dir
[ -z "${DOT_BASHRC_TMP}" -o -d "${DOT_BASHRC_TMP}" ] || {
  _abort 2 "'${DOT_BASHRC_TMP}': no such file or dorectory."
}
[ -n "${DOT_BASHRC_TMP}" -a -d "${DOT_BASHRC_TMP}" ] || {
  DOT_BASHRC_TMP="${TMPDIR:-/tmp}/.${DOT_BASHRC_PRJ}.$$"
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
: && {
  # Set trap
  trap "_cleanup" SIGTERM SIGHUP SIGINT SIGQUIT
  trap "_cleanup" EXIT
} || :

# Run
if [ $BASHRC_INSTALL -eq 0 ]
then

  dotbashrc_git="$(type -P git)"
  dotbashrcplay="$(type -P ansible-playbook)"
  dotbashrcopts=""
  dotbashrc_ret=0

  [ -n "${DOT_BASHRC_URL}" ] || {
    _abort 1 "'DOT_BASHRC_URL' is empty."
  }

  [ -x "${dotbashrc_git}" ] || {
    _abort 1 "Can not find the 'git' command."
  }

  if [ -z "${DOT_BASHRC_SRC}" -o ! -d "${DOT_BASHRC_SRC}" ]
  then

    if [ -d "${CDIR}/files" -a -d "${CDIR}/templates" ]
    then

      [ -d "${CDIR}/.git" ] && {
        ${dotbashrc_git} pull ||
        _abort 1 "Failed command: 'git pull'."
      }

      DOT_BASHRC_SRC="${CDIR}"

    else

      ( cd "${DOT_BASHRC_TMP}" &&
        ${dotbashrc_git} clone "${DOT_BASHRC_URL}"; ) 2>/dev/null ||
      _abort 1 "Failed command: 'git clone'."

      ( cd "${DOT_BASHRC_TMP}/${DOT_BASHRC_PRJ}/"; ) 2>/dev/null ||
      _abort 2 "'dot-bashrc': no such file or directory."

      DOT_BASHRC_SRC=$(
        cd "${DOT_BASHRC_TMP}/${DOT_BASHRC_PRJ}" 2>/dev/null &&
        pwd)

    fi # if [ -d "${CDIR}/${dotbashrcproj}" -a ...

  fi # if [ ! -d "${DOT_BASHRC_SRC}" ]

  cat <<_MSG_
#
# dot-bashrc/install.sh
#
_MSG_

  if [ -x "${dotbashrcplay}" -a -r "${DOT_BASHRC_SRC}/ansible.yml" ]
  then

    dotbashrcopts="-D"

    [ $INSTALL_GLOBAL -eq 0 ] ||
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }-e global=true"
    [ $SETUP_SKELETON -eq 0 ] ||
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }-e skel=true"
    [ $ENABLE_DRY_RUN -eq 0 ] ||
    dotbashrcopts="${dotbashrcopts:+$dotbashrcopts }-C"

    cat <<_MSG_
#
# run - ${dotbashrcplay} ${dotbashrcopts} ansible.yml
#
_MSG_

    ( cd "${DOT_BASHRC_SRC}" &&
      ${dotbashrcplay} ${dotbashrcopts} ./ansible.yml; )
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

    cat <<_MSG_
#
# run - bash ./$THIS $dotbashrcopts
#
_MSG_

    /bin/bash ./$THIS $dotbashrcopts
    dotbashrc_ret=$?

  fi

  exit $dotbashrc_ret

fi # if [ $BASHRC_INSTALL -eq 0 ]

# Installation Tag
dotbashtag="${DOT_BASHRC_PRJ}/${THIS}, $(LANG=C date)"

# Installation source path
dotfilesrc="files/etc/bash.bashrc.d"

# DOT_BASHRC_SRC
if [ -z "${DOT_BASHRC_SRC:-}" ]
then
  DOT_BASHRC_SRC="$(pwd)"
fi

# Change the current directory to install-source
cd "${DOT_BASHRC_SRC}" 2>/dev/null || {
  _abort 2 "'${DOT_BASHRC_SRC:-.}': no such file or dorectory."
}

# Confirm existence of source to be installed
[ -d "${DOT_BASHRC_SRC}/${dotfilesrc}" ] || {
  _abort 2 "'DOT_BASHRC_SRC/${dotfilesrc:-???}': no such file or dorectory."
}

# Installation will start.
cat <<_MSG_
#---------------------------------------
# dot-bashrc/install.sh
#---------------------------------------
_MSG_

# Installation settings
if [ $INSTALL_GLOBAL -ne 0 ]
then
  # System install
  dotinstall="/etc"
  dotbackdir="${dotinstall}/._bashrc-origin"
  dotbasedir="${dotinstall}/bash.bashrc.d"
  bashrcfile="bash.bashrc"
  bashrcprof="bash.profile"
  bashrclout="bash.bash_logout"
  bashrcuser="root"
  bashrc_grp=$(id -gn "$bashrcuser")
else
  # User local install
  set +u
  dotinstall="${XDG_CONFIG_HOME:-${HOME}/.config}"
  dotbackdir="${dotinstall}/._bashrc-origin"
  dotbasedir="${dotinstall}/bash.bashrc.d"
  bashrcfile="bash.bashrc"
  bashrcprof="bash.profile"
  bashrclout="bash.bash_logout"
  bashrcuser=$(id -un)
  bashrc_grp=$(id -gn "$bashrcuser")
  set -u
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
${bashrclout}:bash.bash.logout
_EOF_
  } 2>/dev/null; )

# User home updater
usrhomeupd="${dotbasedir}/bin/update-user-home"

# Print variables
cat <<_MSG_
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
  echo "Mkdir backup-dir."
  mkdir -p "${dotbackdir}" &>/dev/null || :
}
[ "$(echo $(ls -1 ${dotbackdir} 2>/dev/null|wc -l))" != "0" ] || {

  echo "Create a backup."

  ( cd "${dotbackdir}" &&
    pwd &&
    for backupfile in \
      bashrc profile \
      bash.bashrc bash.profile bash.bash_logout bash.bash.logout \
      bash_profile bash_logout \
      bashrc_Apple_Terminal \
      paths manpaths
    do
      backup_src=""
      if [ $INSTALL_GLOBAL -ne 0 ]
      then backup_src="${dotinstall}/${backupfile}"
      else backup_src="${HOME}/.${backupfile}"
      fi
      [ -e "${backup_src}" ] && {
        cp -prf "${backup_src}" "./${backupfile}" 2>/dev/null &&
        echo "${backup_src}: Backed to '${dotbackdir}'."
      } || :
    done; )

  echo "Backed up to '${dotbackdir}'."

}

# Install the file
if [ ! -e "${dotbasedir}" -o -z "$(type -P patch)" ]
then

  echo "Install the 'bash.bashrc.d' to '${dotbasedir}'."

  [ -e "${dotbasedir}" ] && {
    mv -f "${dotbasedir}" \
          "${dotbasedir}.$(date +'%Y%m%d_%H%M%S')"
  }

  mkdir -p "${dotbasedir}" 1>/dev/null 2>&1

  ( cd "${DOT_BASHRC_SRC}/${dotfilesrc}" && {
      tar -c . |tar -C "${dotbasedir}/" -xvf - ||
      exit 1
    }; )

  if [ $? -ne 0 ]
  then
    _abort 1 "Abort: 'tar -c . |tar -C "${dotbasedir}/" -xvf -'."
  fi

else

  echo "Update the 'bash.bashrc.d' to '${dotbasedir}'."

  ( cd "${dotbasedir}" && {
      diff -Nur . "${DOT_BASHRC_SRC}/${dotfilesrc}" |patch -p0 ||
      exit 1
    }; )

  if [ $? -ne 0 ]
  then
    _abort 1 "Abort: 'diff -Nur . "${DOT_BASHRC_SRC}" |patch -p0'."
  fi

fi

# Print message
echo "Install the templates."

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

  done; )

if [ $? -ne 0 ]
then
  _abort 1 "Abort: One or more template files could not be installed."
fi

# Print message
echo "Grant and revoke on 'bash.bashrc.d' files."

# Set installation file permissions
( : && {
    cd "${dotbasedir}" 2>/dev/null &&
    chown -R "${bashrcuser}:${bashrc_grp}" . &&
    find . -type d -print -exec chmod u=rwx,go=rx {} \; &&
    find . -type f -print -exec chmod u=rw,go=r {} \;  &&
    find . -type f -a -name "*.sh*" -print -exec chmod a+x {} \; &&
    find ./bin -type f -print -exec chmod a+x {} \; &&
    echo ||
    exit 1
  }; )

if [ $? -ne 0 ]
then
  _abort 1 "Abort: Permission setting failed."
fi

# Symlinks
if [ $INSTALL_GLOBAL -ne 0 ]
then

  # Print message
  echo "Create symlinks."

  # Symlink processing
  ( cd "${dotinstall}" &&
    for symlnk_ent in ${dotsymlnks}
    do

      symlnk_src=$(echo "${symlnk_ent}"|cut -d: -f1 2>/dev/null)
      symlnk_dst=$(echo "${symlnk_ent}"|cut -d: -f2 2>/dev/null)

      [ -e "${symlnk_src}" ] || continue
      [ -n "${symlnk_dst}" ] || continue

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

    done; )

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
  echo "Start updating SKEL."

  # Update SKEL
  ( cd "${dotbasedir}" 2>/dev/null &&
    [ -x "${usrhomeupd}" ] && {
      "${usrhomeupd}" ${usrhomeopt} --update-skel
      exit $?
    }; )

  if [ $? -eq 0 ]
  then echo "SKEL update completed."
  else _abort 1 "SKEL update failed."
  fi

fi # if [ $SETUP_SKELETON -ne 0 ]

# Sync user-home
if [ $INSTALL_GLOBAL -eq 0 ]
then

  # print
  echo "Start updating dots for USER-HOME."

  # Update user-home
  ( cd "${dotbasedir}" 2>/dev/null &&
    [ -x "${usrhomeupd}" ] && {
      "${usrhomeupd}" ${usrhomeopt} --skel=./skel.d
      exit $?
    }; )

  if [ $? -eq 0 ]
  then echo "USER-HOME dots update completed."
  else _abort 1 "Failed to update dot for USER-HOME."
  fi

fi # if [ $INSTALL_GLOBAL -eq 0 ]

# Finish installation
echo "Done."

# End
exit 0
