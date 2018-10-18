#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>|/dev/null; pwd)

# Name
THIS="${THIS:-install.sh}"
BASE="${THIS%%.*}"

# Path
PARH=/usr/bin:/bin; export PATH

# dot-bashrc URL
DOT_BASHRC_URL="${DOT_BASHRC_URL:-https://github.com/mtangh/dot-bashrc.git}"
DOT_BASHRC_SRC=""

# Flags
BASHRC_INSTALL=0
GLOBAL_INSTALL=0
DRYRUNMODEFLAG=0

# Set flags from environment variables
[ -n "$DOT_BASHRC_GLOBAL" ] &&
GLOBAL_INSTALL=1
[ -n "$DOT_BASHRC_DEBUG" ] &&
DRYRUNMODEFLAG=1

# Working dir
dotbashrcwdir="${TMPDIR:-/tmp}/.dot-bashrc.$(mktemp -u XXXXXXXX)"

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
      dotbashrcwdir="${1##*--workdir=}"
    }
    ;;
  --global*|-g)
    GLOBAL_INSTALL=1
    ;;
  --local*|-l)
    GLOBAL_INSTALL=0
    ;;
  --dry-run*|--debug*|-d)
    DRYRUNMODEFLAG=1
    ;;
  *)
    ;;
  esac
  shift
done

# Prohibits overwriting by redirect and use of undefined variables.
set -Cu

# Verify the permissions for global installation availability.
[ $GLOBAL_INSTALL -ne 0 ] &&
[ "$(id -u 2>|/dev/null)" != "0" ] && {
  echo "${THIS}: Need SUDO" 1>&2
  exit 8
}

# Create a working directory if does not exist.
[ -d "${dotbashrcwdir}" ] || {
  mkdir -p "${dotbashrcwdir}"
}

# Run
if [ $BASHRC_INSTALL -eq 0 ]
then

  dotbashrc_git="$(type -P git)"
  dotbashrcplay="$(type -P ansible-playbook)"

  [ -n "$DOT_BASHRC_URL" ] || {
    echo "${THIS}: 'DOT_BASHRC_URL' is empty." 1>&2
    exit 11
  }

  [ -n "$dotbashrc_git" ] || {
    echo "${THIS}: Can not find the 'git'." 1>&2
    exit 12
  }

  [ -d "$dotbashrcwdir" ] || {
    mkdir -p "$dotbashrcwdir" 1>|/dev/null 2>&1
  }

  [ $DRYRUNMODEFLAG -eq 0 ] && {
    cleanup="test -d ${dotbashrcwdir} && rm -rf ${dotbashrcwdir}"
    trap $cleanup 1>|/dev/null 2>&1' SIGTERM SIGHUP SIGINT SIGQUIT
    trap $cleanup 1>|/dev/null 2>&1' EXIT
    unset cleanup
  }

  if [ -e "${dotbashrc_git}" ]
  then

    ( cd "${dotbashrcwdir}" 2>|/dev/null &&
      ${dotbashrc_git} clone "$DOT_BASHRC_URL" )

  else
    echo "${THIS}: 'git' command not found." 1>&2
    exit 15
  fi

  cd "${dotbashrcwdir}/dot-bashrc/" 2>|/dev/null || {
    echo "${THIS}: 'dot-bashrc': no such file or directory." 1>&2
    exit 18
  }

  echo "#"
  echo "# dot-bashrc/install.sh"
  echo "#"

  if [ -x "${dotbashrcplay}" ]
  then

    ansibleoption=""

    [ $GLOBAL_INSTALL -ne 0 ] &&
    ansibleoption="${ansibleoption} -e system=true"
    [ $GLOBAL_INSTALL -ne 0 ] ||
    ansibleoption="${ansibleoption} -e system=false"
    [ $DRYRUNMODEFLAG -ne 0 ] &&
    ansibleoption="${anaibleoption} -D"

    echo "#"
    echo "# run - ${dotbashrcplay} ${ansibleoption} ansible.yml"
    echo "#"

    ${dotbashrcplay} ${ansibleoption} ansible.yml

  elif [ -e "./install.sh" ]
  then

    installoption=""
    installoption="${installoption} --install"
    installoption="${installoption} --source=${dotbashrcwdir}/dot-bashrc/roles/bashrc"
    installoption="${installoption} --workdir=${dotbashrcwdir}"

    [ $GLOBAL_INSTALL -ne 0 ] &&
    installoption="${installoption} --global"
    [ $DRYRUNMODEFLAG -ne 0 ] &&
    installoption="${installoption} --dry-run"

    echo "#"
    echo "# run - bash ./install.sh $installoption"
    echo "#"

    bash ./install.sh $installoption

  else
    echo "${THIS}: Abort(20)" 1>&2
    exit 20
  fi

fi # if [ $BASHRC_INSTALL -eq 0 ]

# Installation will start.
cat <<_EOF_
#---------------------------------------
# dot-bashrc/install.sh
#---------------------------------------
_EOF_

# Installation Tag
bashrctagname="dot-bashrc/$THIS, $(date)"
# Installation source path
bashbashrcsrc="files/etc/bash.bashrc.d"

# Change the current directory to install-source
cd "${DOT_BASHRC_SRC}" 2>|/dev/null || {
  echo "${THIS}: '${DOT_BASHRC_SRC}' no such file or dorectory." 1>&2
  exit 31
}

# Confirm existence of source to be installed
[ -n "${DOT_BASHRC_SRC}" \
  -a -d "${DOT_BASHRC_SRC}/${bashbashrcsrc}" ] || {
  echo "${THIS}: 'DOT_BASHRC_SRC/${bashbashrcsrc:-???}' no such file or dorectory." 1>&2
  exit 32
}

# Installation settings
if [ $GLOBAL_INSTALL -ne 0 ]
then
  # System install
  bashrcinstall=/etc
  bashbashrcdir="${bashrcinstall}/bash.bashrc.d"
  bashrcprofile="bash.profile"
  bashrc_rcfile="bash.bashrc"
  bash_rc_owner="root"
  bash_rc_group=$(id -gn "$bash_rc_owner")
else
  # User local install
  bashrcinstall="$HOME/.config"
  bashbashrcdir="${bashrcinstall}/bash.bashrc.d"
  bashrcprofile="bash.profile"
  bashrc_rcfile="bash.bashrc"
  bash_rc_owner=$(id -un)
  bash_rc_group=$(id -gn "$bash_rc_owner")
fi

# Change to the installation setting for dry-run mode
[ $DRYRUNMODEFLAG -ne 0 ] && {
  bashrcinstall="${dotbashrcwdir}${bashrcinstall}"
  bashbashrcdir="${dotbashrcwdir}${bashbashrcdir}"
}

# Template files
bashtmplfiles=$(
  : && {
    cat <<_EOF_
bash.profile:${bashrcinstall}/${bashrcprofile}
bash.bashrc:${bashrcinstall}/${bashrc_rcfile}
vim/vimrc:${bashbashrcdir}/vim/vimrc
_EOF_
  } 2>|/dev/null; )

# Symlinks ("from:to" format)
bashrcsymlnks=$(
  [ $GLOBAL_INSTALL -ne 0 ] && {
    cat <<_EOF_
${bashrcprofile}:profile
${bashrc_rcfile}:bashrc
_EOF_
  } || {
    cat <<_EOF_
${bashrcinstall}/${bashrcprofile}:.bash_profile
${bashrcinstall}/${bashrc_rcfile}:.bashrc
${bashbashrcdir}/inputrc.d/default:.inputrc
${bashbashrcdir}/vim/vimrc:.vimrc
_EOF_
  } 2>|/dev/null; )

# Print variables
cat <<_EOF_
#
#* bashrcinstall="$bashrcinstall"
#* bashbashrcdir="$bashbashrcdir"
#* bashrcprofile="$bashrcprofile"
#* bashrc_rcfile="$bashrc_rcfile"
#* bash_rc_owner="$bash_rc_owner"
#* bash_rc_group="$bash_rc_group"
#
_EOF_

# Backup the original file
[ -d "${bashrcinstall}/._bashrc-origin" ] || {

  echo
  echo "# Create a backup."

  mkdir -p "${bashrcinstall}/._bashrc-origin"

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

} 2>|/dev/null

# Print message
echo
echo "# Install the 'bash.bashrc.d' to '${bashbashrcdir}'."

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
    echo "${THIS}: Abort(41)" 1>&2
    exit 41
  }

else

  ( cd "${bashbashrcdir}" &&
    diff -Nur . "${bashbashrcsrc}" |patch -p0 ) || {
    echo "${THIS}: Abort(42)" 1>&2
    exit 42
  }

fi # if [ ! -e "${bashbashrcdir}" -o -z "$(type -P patch)" ]

# Print message
echo
echo "# Grant and revoke on 'bash.bashrc.d' files."

# Set installation file permissions
( cd "${bashbashrcdir}" &&
  chown -R "${bash_rc_owner}:${bash_rc_group}" . &&
  find . -type d -print -exec chmod u=rwx,go=rx {} \; &&
  find . -type f -print -exec chmod u=rw,go=r {} \; &&
  find . -type f -a -name "*.sh" -print -exec chmod a+x {} \; &&
  find ./bin -type f -print -exec chmod a+x {} \; &&
  echo ) || {
  echo "${THIS}: Abort(42)" 1>&2
  exit 44
}

# Print message
echo
echo "# Install the templates."

# Process the template file
for bashrctmplent in ${bashtmplfiles}
do

  : && {
    bashrctmplsrc="templates/etc/"$(echo "${bashrctmplent}"|cut -d: -f1)".j2"
    bashrctmpldst=$(echo "${bashrctmplent}"|cut -d: -f2)
  } 2>|/dev/null

  [ -e "${bashrctmplsrc}" ] || continue
  [ -n "${bashrctmpldst}" ] || continue

  [ -z "${bashrctmpldst%/*}" -o -d "${bashrctmpldst%/*}" ] || {
    mkdir -p "${bashrctmpldst%/*}"
  }

  echo "# Templates '${bashrctmplsrc}' to '${bashrctmpldst}'."

  sed -e 's@{{[ ]*ansible_managed[ ]*}}@'"${bashrctagname}"'@g' \
      -e 's@{{ bash_bashrc_dir[ ]*[^\}]*}}@'"${bashbashrcdir}"'@g' \
           <"${bashrctmplsrc}" >"${bashrctmpldst}" && {
    echo
    diff -u "${bashrctmplsrc}" "${bashrctmpldst}"
    echo
  }

done

# Print message
echo
echo "# Create symlinks."

# Sumlink processing
( cd "${bashrcinstall}" &&
  for bashsymlnkent in ${bashrcsymlnks}
  do

    : && {
      bashsymlnksrc=$(echo "${bashsymlnkent}"|cut -d: -f1)
      bashsymlnkdst=$(echo "${bashsymlnkent}"|cut -d: -f2)
    } 2>|/dev/null

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

  done 2>|/dev/null; )

# Finish installation
echo
echo "Done."

# End
exit 0
