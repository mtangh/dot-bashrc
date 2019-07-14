#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>/dev/null; pwd)

# Name
THIS="${THIS:-install.sh}"
BASE="${THIS%%.*}"

# Path
PATH=/usr/bin:/bin; export PATH

# dot-bashrc URL
DOT_BASHRC_URL="${DOT_BASHRC_URL:-https://github.com/mtangh/dot-bashrc.git}"
# dot-bashrc Installation source
DOT_BASHRC_SRC=""
# dot-bashrc Working dir
DOT_BASHRCWDIR=""

# Flags
BASHRC_INSTALL=0
SYSTEM_INSTALL=0
SETUP_SKELETON=0
DRYRUNMODEFLAG=0

# Set flags from environment variables
[ -n "$DOT_BASHRC_SYSTEM" ] &&
SYSTEM_INSTALL=1
[ -n "$DOT_BASHRC_SKEL" ] &&
SETUP_SKELETON=1
[ -n "$DOT_BASHRC_DEBUG" ] &&
DRYRUNMODEFLAG=1

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
      DOT_BASHRCWDIR="${1##*--workdir=}"
    }
    ;;
  --system*|-S)
    SYSTEM_INSTALL=1
    SETUP_SKELETON=0
    ;;
  --user*|-u)
    SYSTEM_INSTALL=0
    SETUP_SKELETON=0
    ;;
  --skel*)
    SYSTEM_INSTALL=0
    SETUP_SKELETON=1
    ;;
  --dry-run*|--debug*|-d)
    DRYRUNMODEFLAG=1
    ;;
  *)
    ;;
  esac
  shift
done

# Working dir
[ -n "${DOT_BASHRCWDIR}" ] ||
DOT_BASHRCWDIR="${TMPDIR:-/tmp}/.dot-bashrc.$(mktemp -u XXXXXXXX)"

# Working dir
[ -n "${DOT_BASHRCWDIR}" ] ||
DOT_BASHRC_SRC="${DOT_BASHRCWDIR}/dot-bashrc/roles/bashrc"

# Prohibits overwriting by redirect and use of undefined variables.
set -Cu

<<<<<<< Updated upstream
# Filter func
dot_bashrc_template_filter() {
  sed -e 's@{{[ ]*ansible_managed[ ]*[^\}]*}}@'"${bashrctagname}"'@g' \
      -e 's@{{[ ]*bashrc(_|_skel_)install_path[ ]*[^\}]*}}@'"${bashrcinstall}"'@g' \
      -e 's@{{[ ]*bashrc(_|_skel_)bashrcdir_path[ ]*[^\}]*}}@'"${bashbashrcdir}"'@g' \
      -e 's@{{[ ]*bashrc(_|_skel_)bashrc_name[ ]*[^\}]*}}@'"${bashrc_rcfile}"'@g' \
      -e 's@{{[ ]*bashrc(_|_skel_)profile_name[ ]*[^\}]*}}@'"${bashrcprofile}"'@g' \
      -e 's@{{[ ]*bashrc(_|_skel_)bashrc_path[ ]*[^\}]*}}@'"${pathof_bashrc}"'@g' \
      -e 's@{{[ ]*bashrc(_|_skel_)profile_path[ ]*[^\}]*}}@'"${pathofprofile}"'@g'
  return $?
}

dot_bashrc_abort() {
  dot_bashrc_abort=$1; shift
  echo "${THIS}: $@ ($baah_abort)" 1>$2
  exit $dot_bashrc_abort
}

# Verify the permissions for global installation availability.
[ $SYSTEM_INSTALL -ne 0 ] &&
[ "$(id -u 2>/dev/null)" != "0" ] && {
  dot_bashrc_abort 8 "Need SUDO"
=======
# "/bin/bash" ?
[ -x "/bin/bash" ] || {
  echo "${THIS}: '/bin/bash' not installed." 1>&2
  exit 127
}

# Verify the permissions for global installation availability.
[ $GLOBAL_INSTALL -ne 0 ] &&
[ "$(id -u 2>/dev/null)" != "0" ] && {
  echo "${THIS}: Need SUDO." 1>&2
  exit 8
>>>>>>> Stashed changes
}

# Create a working directory if does not exist.
[ -d "${DOT_BASHRCWDIR}" ] || {
  mkdir -p "${DOT_BASHRCWDIR}"
}

# Run
if [ $BASHRC_INSTALL -eq 0 ]
then

  dotbashrc_git="$(type -P git)"
  dotbashrcplay="$(type -P ansible-playbook)"

  [ -n "$DOT_BASHRC_URL" ] || {
    dot_bashrc_abort 11 "'DOT_BASHRC_URL' is empty."
  }

  [ -n "$dotbashrc_git" ] || {
    dot_bashrc_abort 12 "Can not find the 'git'."
  }

<<<<<<< Updated upstream
  [ -d "$DOT_BASHRCWDIR" ] || {
    mkdir -p "$DOT_BASHRCWDIR" 1>/dev/null 2>&1
  }

  [ $DRYRUNMODEFLAG -eq 0 ] && {
    cleanup="test -d ${DOT_BASHRCWDIR} && rm -rf ${DOT_BASHRCWDIR}"
    trap $cleanup 1>/dev/null 2>&1 SIGTERM SIGHUP SIGINT SIGQUIT
    trap $cleanup 1>/dev/null 2>&1 EXIT
=======
  [ -d "$dotbashrcwdir" ] || {
    mkdir -p "$dotbashrcwdir" 1>/dev/null 2>&1
  }

  [ $DRYRUNMODEFLAG -eq 0 ] && {
    cleanup="test -d ${dotbashrcwdir} && rm -rf ${dotbashrcwdir}"
    trap "$cleanup 1>/dev/null 2>&1" SIGTERM SIGHUP SIGINT SIGQUIT
    trap "$cleanup 1>/dev/null 2>&1" EXIT
>>>>>>> Stashed changes
    unset cleanup
  }

  if [ -e "${dotbashrc_git}" ]
  then

<<<<<<< Updated upstream
    ( cd "${DOT_BASHRCWDIR}" 2>/dev/null &&
=======
    ( cd "${dotbashrcwdir}" 2>/dev/null &&
>>>>>>> Stashed changes
      ${dotbashrc_git} clone "$DOT_BASHRC_URL" )

  else
    dot_bashrc_abort 15 "'git' command not found."
  fi

<<<<<<< Updated upstream
  cd "${DOT_BASHRCWDIR}/dot-bashrc/" 2>/dev/null || {
    dot_bashrc_abort 18 "'dot-bashrc': no such file or directory."
  }

  [ ! -x "${dotbashrcplay}" -a ! -e "./install.sh" ] && {
    dot_bashrc_abort 20 "Abort."
  }

  cat <<_EOF_
#
# dot-bashrc/install.sh
#
_EOF_
=======
  cd "${dotbashrcwdir}/dot-bashrc/" 2>/dev/null || {
    echo "${THIS}: 'dot-bashrc': no such file or directory." 1>&2
    exit 18
  }

  cat <<_MSG_
#
# dot-bashrc/install.sh
#
_MSG_
>>>>>>> Stashed changes

  if [ -x "${dotbashrcplay}" ]
  then

    ansibleoption=""

    if [ $SYSTEM_INSTALL -ne 0 ]
    then
      ansibleoption="${ansibleoption:+$ansibleoption }-e system=true"
    elif [ $SETUP_SKELETON -eq 0 ]
    then
      ansibleoption="${ansibleoption:+$ansibleoption }-e system=false"
    else
      ansibleoption="${ansibleoption:+$ansibleoption }-e skel=true"
    fi

    [ $DRYRUNMODEFLAG -ne 0 ] &&
    ansibleoption="${anaibleoption} -D"

<<<<<<< Updated upstream
    cat <<_EOF_
#
# run - ${dotbashrcplay} ${ansibleoption} ansible.yml
#
_EOF_
=======
    cat <<_MSG_
#
# run - ${dotbashrcplay} ${ansibleoption} ansible.yml
#
_MSG_
>>>>>>> Stashed changes

    ${dotbashrcplay} ${ansibleoption} ansible.yml
    exit $?

  else

    installoption=""
    installoption="${installoption:+$installoption }--install"
    installoption="${installoption:+$installoption }--source=${DOT_BASHRC_SRC}"
    installoption="${installoption:+$installoption }--workdir=${DOT_BASHRCWDIR}"

    [ $SYSTEM_INSTALL -ne 0 ] &&
    installoption="${installoption:+$installoption }--system"
    [ $SETUP_SKELETON -ne 0 ] &&
    installoption="${installoption:+$installoption }--skel"

    [ $DRYRUNMODEFLAG -ne 0 ] &&
    installoption="${installoption:+$installoption }--dry-run"

<<<<<<< Updated upstream
    cat <<_EOF_
#
# run - bash ./install.sh $installoption
#
_EOF_
=======
    cat <<_MSG_
#
# run - bash ./install.sh $installoption
#
_MSG_
>>>>>>> Stashed changes

    bash ./install.sh $installoption
    exit $?

  fi

fi # if [ $BASHRC_INSTALL -eq 0 ]

# Installation will start.
cat <<_MSG_
#---------------------------------------
# dot-bashrc/install.sh
#---------------------------------------
_MSG_

# Installation Tag
bashrctagname="dot-bashrc/$THIS, $(date)"

# Installation source path
bashbashrcsrc="files/etc/bash.bashrc.d"

<<<<<<< Updated upstream
[ -n "${DOT_BASHRC_SRC}" ] || {
  dot_bashrc_abort 31 "'DOT_BASHRC_SRC' not set."
=======
# Change the current directory to install-source
cd "${DOT_BASHRC_SRC}" 2>/dev/null || {
  echo "${THIS}: '${DOT_BASHRC_SRC}' no such file or dorectory." 1>&2
  exit 31
>>>>>>> Stashed changes
}

# Confirm existence of source to be installed
[ -d "${DOT_BASHRC_SRC}/${bashbashrcsrc}" ] || {
  dot_bashrc_abort 32 "'DOT_BASHRC_SRC/${bashbashrcsrc:-???}' no such file or dorectory."
}

# Change the current directory to install-source
cd "${DOT_BASHRC_SRC}" 2>/dev/null || {
  dot_bashrc_abort 33 "'${DOT_BASHRC_SRC}' no such file or dorectory."
}

# Installation settings
if [ $SYSTEM_INSTALL -ne 0 ]
then
  # System install
  bashrcinstall=/etc
  bashbashrcdir="${bashrcinstall}/bash.bashrc.d"
  bashrc_rcfile="bash.bashrc"
  bashrcprofile="bash.profile"
  bash_rc_owner="root"
  bash_rc_group=$(id -gn "$bash_rc_owner")
else
  # User local install
  bashrcinstall="$HOME/.config"
  bashbashrcdir="${bashrcinstall}/bash.bashrc.d"
  bashrc_rcfile="bash.bashrc"
  bashrcprofile="bash.profile"
  bash_rc_owner=$(id -un)
  bash_rc_group=$(id -gn "$bash_rc_owner")
fi

# Change to the installation setting for dry-run mode
[ $DRYRUNMODEFLAG -ne 0 ] && {
  bashrcinstall="${DOT_BASHRCWDIR}${bashrcinstall}"
  bashbashrcdir="${DOT_BASHRCWDIR}${bashbashrcdir}"
}

<<<<<<< Updated upstream
# bash.bashrc, bash.profile
pathof_bashrc="${bashbashrcdir}/${bashrc_rcfile}"
pathofprofile="${bashrcinstall}/${bashrcprofile}"
=======
# Template files
bashtmplfiles=$(
  : && {
    cd "${DOT_BASHRC_SRC}/templates" &&
    find etc -type f -a -name "*.j2" |sort
  } 2>/dev/null; )

# Symlinks ("from:to" format)
bashrcsymlnks=$(
  : && {
    cat <<_EOF_
${bashrcprofile}:profile
${bashrc_rcfile}:bashrc
_EOF_
  } 2>/dev/null; )
>>>>>>> Stashed changes

# Print variables
cat <<_MSG_
#
#* bashrcinstall="$bashrcinstall"
#* bashbashrcdir="$bashbashrcdir"
#* bashrcprofile="$bashrcprofile"
#* bashrc_rcfile="$bashrc_rcfile"
#* bash_rc_owner="$bash_rc_owner"
#* bash_rc_group="$bash_rc_group"
#
_MSG_

# Backup the original file
[ -d "${bashrcinstall}/._bashrc-origin" ] || {

<<<<<<< Updated upstream
  cat <<_EOF_
#
# Create a backup.
_EOF_
=======
cat <<_MSG_

# Create a backup.
_MSG_
>>>>>>> Stashed changes

  mkdir -p "${bashrcinstall}/._bashrc-origin" 2>/dev/null || :

  ( cd "${bashrcinstall}/._bashrc-origin" &&
    pwd &&
    for file in \
      bashrc profile \
      bash.bashrc bash.profile \
      bash_profile bash_logout
    do
      [ -e "${bashrcinstall}/${file}" ] &&
      cp -prfv ${bashrcinstall}/${file} ./
      [ -e "${bashrcinstall}/.${file}" ] &&
      cp -prfv ${bashrcinstall}/.${file} ./
    done; )

  echo

} 2>/dev/null

# Print message
<<<<<<< Updated upstream
cat <<_EOF_
#
# Install the 'bash.bashrc.d' to '${bashbashrcdir}'.
_EOF_
=======
cat <<_MSG_

# Install the 'bash.bashrc.d' to '${bashbashrcdir}'.
_MSG_
>>>>>>> Stashed changes

# Install the file
if [ ! -e "${bashbashrcdir}" -o -z "$(type -P patch)" ]
then

  [ -e "${bashbashrcdir}" ] && {
    mv -f "${bashbashrcdir}" \
          "${bashbashrcdir}.$(date +'%Y%m%d_%H%M%S')"
  }

  mkdir -p "${bashbashrcdir}"

  ( cd "${bashbashrcsrc}" &&
    tar -c . |tar -C "${bashbashrcdir}/" -xvf - ) || {
    dot_bashrc_abort 41 "Abort."
  }

else

  ( cd "${bashbashrcdir}" &&
    diff -Nur . "${bashbashrcsrc}" |patch -p0 ) || {
    dot_bashrc_abort 42 "Abort."
  }

fi # if [ ! -e "${bashbashrcdir}" -o -z "$(type -P patch)" ]

# Print message
<<<<<<< Updated upstream
cat <<_EOF_
#
# Grant and revoke on 'bash.bashrc.d' files.
_EOF_
=======
cat <<_MSG_

# Install the templates.
_MSG_

# Process the template file
( cd "${bashrcinstall}" &&
  for bashrctmplent in ${bashtmplfiles}
  do

    bashrctmplsrc="${DOT_BASHRC_SRC}/templates/"$(echo "${bashrctmplent}")".j2"
    bashrctmpldst="${bashrctmplent##*etc/}"
    bashrctmpldst="${bashrctmpldst%.j2*}"

    [ -e "${bashrctmplsrc}" ] || continue
    [ -n "${bashrctmpldst}" ] || continue

    case "${bashrctmpldst}" in
    */*)
      [ -z "${bashrctmpldst%/*}" -o -d "${bashrctmpldst%/*}" ] || {
        mkdir -p "${bashrctmpldst%/*}"; }
      ;;
    *)
      ;;
    esac

    cat <<_MSG_
# Templates '${bashrctmplsrc}' to '${bashrctmpldst}'.
_MSG_

    cat "${bashrctmplsrc}" |
    sed -e 's@{{[ ]*ansible_managed[ ]*}}@'"${bashrctagname}"'@g' \
        -e 's@{{[ ]*bash_bashrc_dir[ ]*[^\}]*}}@'"${bashbashrcdir}"'@g' \
        -e 's@{{[ ]*bash_bashrc_profile[ ]*[^\}]*}}@'"${bashrcinstall}/${bashrcprofile}"'@g' \
        -e 's@{{[ ]*bash_bashrc_rcfile[ ]*[^\}]*}}@'"${bashrcinstall}/${bashrc_rcfile}"'@g' \
             1>"${bashrctmpldst}" 2>/dev/null && {
      echo
      diff -u "${bashrctmplsrc}" "${bashrctmpldst}"
      echo
    }

  done 2>/dev/null; )

# Print message
cat <<_MSG_

# Grant and revoke on 'bash.bashrc.d' files.
_MSG_
>>>>>>> Stashed changes

# Set installation file permissions
( cd "${bashbashrcdir}" &&
  chown -R "${bash_rc_owner}:${bash_rc_group}" . &&
  find . -type d -print -exec chmod u=rwx,go=rx {} \; &&
  find . -type f -print -exec chmod u=rw,go=r {} \; &&
  find . -type f -a -name "*.sh" -print -exec chmod a+x {} \; &&
  find ./bin -type f -print -exec chmod a+x {} \; &&
  echo ) || {
  dot_bashrc_abort 43 "Abort."
}

<<<<<<< Updated upstream
# bash rc-files setup
if [ $SYSTEM_INSTALL -ne 0 ]
then

  # Template files
  bashtmplfiles=$(
    : && {
      cat <<_EOF_
bash.bashrc:${bashrcinstall}/${bashrc_rcfile}
bash.profile:${bashrcinstall}/${bashrcprofile}
vim/vimrc:${bashbashrcdir}/vim/vimrc
_EOF_
    } 2>/dev/null; )

  # Symlinks ("from:to" format)
  bashrcsymlnks=$(
    : && {
      cat <<_EOF_
${bashrcprofile}:profile
${bashrc_rcfile}:bashrc
_EOF_
    } 2>/dev/null; )

  # Print message
  cat <<_EOF_
#
# Install the templates.
_EOF_

  # Process the template file
  for bashrctmplent in ${bashtmplfiles}
  do

    : && {
      bashrctmplsrc="templates/etc/"$(echo "${bashrctmplent}"|cut -d: -f1)".j2"
      bashrctmpldst=$(echo "${bashrctmplent}"|cut -d: -f2)
    } 2>/dev/null

    [ -e "${bashrctmplsrc}" ] || continue
    [ -n "${bashrctmpldst}" ] || continue

    [ -z "${bashrctmpldst%/*}" -o -d "${bashrctmpldst%/*}" ] || {
      mkdir -p "${bashrctmpldst%/*}"
    }

    echo "# Templates '${bashrctmplsrc}' to '${bashrctmpldst}'."
=======
# Print message
cat <<_MSG_

# Create symlinks.
_MSG_
>>>>>>> Stashed changes

    cat "${bashrctmplsrc}" |
    dot_bashrc_template_filter 1>|"${bashrctmpldst}" && {
      echo
      diff -u "${bashrctmplsrc}" "${bashrctmpldst}"
      echo
    }

  done 2>/dev/null || :

  # Print message
  cat <<_EOF_
#
# Create symlinks.
_EOF_

  # Sumlink processing
  ( cd "${bashrcinstall}" &&
    for bashsymlnkent in ${bashrcsymlnks}
    do

      : && {
        bashsymlnksrc=$(echo "${bashsymlnkent}"|cut -d: -f1)
        bashsymlnkdst=$(echo "${bashsymlnkent}"|cut -d: -f2)
      } 2>/dev/null

      [ -e "${bashsymlnksrc}" ] || continue
      [ -n "${bashsymlnkdst}" ] || continue

      [ "${bashsymlnksrc}" = "${bashsymlnkdst}" ] && continue

      case "${bashsymlnkdst}" in
      */*)
        [ -n "${bashsymlnkdst%/*}" ] &&
        [ ! -e "${bashsymlnkdst%/*}" ] && {
          mkdir -p "${bashsymlnkdst%/*}"
        }
        ;;
      *)
        ;;
      esac

      echo "# Symlink '${bashsymlnksrc}' to '${bashsymlnkdst}'."

      ln -sf "${bashsymlnksrc}" "${bashsymlnkdst}"

    done 2>/dev/null; )

fi # if [ $SYSTEM_INSTALL -ne 0 ]

# bash rc-files setup from skeleton
if [ $SETUP_SKELETON -ne 0 ]
then

  # Print message
  cat <<_EOF_
#
# Install the templates for user.
_EOF_

  # Process the template file for user
  [ -d "templates/skel" ] &&
  for bashrctmplsrc in $(
  find templates/skel -name "*.j2"|sort)
  do

<<<<<<< Updated upstream
    : && {
    
      bashrctmpldst=$(
        head -n 1 "${bashrctmplsrc}" |
        sed -ne 's@^.*\($HOME/[^ ][^ ]*\)[ ]*@\1@gp'; )

      eval 'bashrctmpldst="${bashrctmpldst}"'
=======
    bashsymlnksrc="${bashsymlnkent%:*}"
    bashsymlnkdst="${bashsymlnkent##*:}"
>>>>>>> Stashed changes

    } 2>/dev/null

    [ -e "${bashrctmplsrc}" ] || continue
    [ -n "${bashrctmpldst}" ] || continue

<<<<<<< Updated upstream
    echo "# Templates '${bashrctmplsrc}' to '${bashrctmpldst}'."

    cat "${bashrctmplsrc}" |
    dot_bashrc_template_filter 1>|"${bashrctmpldst}" && {
      echo
      diff -u "${bashrctmplsrc}" "${bashrctmpldst}"
      echo
    }
=======
    case "${bashsymlnkdst}" in
    */*)
      [ -z "${bashsymlnkdst%/*}" -o -d "${bashsymlnkdst%/*}" ] && {
        mkdir -p "${bashsymlnkdst%/*}"; }
      ;;
    *)
      ;;
    esac

    cat <<_MSG_
# Symlink '${bashsymlnksrc}' to '${bashsymlnkdst}'.
_MSG_
>>>>>>> Stashed changes

  done 2>/dev/null || :

<<<<<<< Updated upstream
fi # if [ $SETUP_SKELETON -ne 0 ]

# Finish installation
cat <<_EOF_
#
# Done.
_EOF_
=======
  done 2>/dev/null; )

#
if [ $GLOBAL_INSTALL -eq 0 ]
then

  # Finish installation
  cat <<_MSG_

# Update USER-HOME.
_MSG_

  [ -x "${bashbashrcdir}/bin/update-user-home" ] && {
    "${bashbashrcdir}/bin/update-user-home"
  }

fi

# Finish installation
cat <<_MSG_

Done.
_MSG_
>>>>>>> Stashed changes

# End
exit 0
