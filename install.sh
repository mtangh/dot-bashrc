#!/bin/bash
THIS="${0##*/}"
CDIR=$([ -n "${0%/*}" ] && cd "${0%/*}" 2>/dev/null; pwd)

THIS="${THIS:-install.sh}"
BASE="${THIS%%.*}"

DOT_BASHRC_URL="${DOT_BASHRC_URL:-https://github.com/mtangh/dot-bashrc.git}"
DOT_BASHRC_SRC=""

BASHRC_INSTALL=0
GLOBAL_INSTALL=0
DRYRUNMODEFLAG=0

[ -n "$DOT_BASHRC_GLOBAL" ] &&
GLOBAL_INSTALL=1
[ -n "$DOT_BASHRC_DEBUG" ] &&
DRYRUNMODEFLAG=1

dotbashrcwdir="/tmp/.dot-bashrc.$(mktemp -u XXXXXXXX)"

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

set -u

[ -d "${dotbashrcwdir}" ] || {
  mkdir -p "${dotbashrcwdir}"
}

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
    mkdir -p "$dotbashrcwdir" 1>/dev/null 2>&1
  }

  [ $DRYRUNMODEFLAG -eq 0 ] && {
    trap 'test -d '"$dotbashrcwdir"' && rm -rf '"${dotbashrcwdir}/"' 1>/dev/null 2>&1' SIGTERM SIGHUP SIGINT SIGQUIT
    trap 'test -d '"$dotbashrcwdir"' && rm -rf '"${dotbashrcwdir}/"' 1>/dev/null 2>&1' EXIT
  }

  if [ -e "${dotbashrc_git}" ]
  then

    ( cd "$dotbashrcwdir" 2>/dev/null &&
      $dotbashrc_git clone "$DOT_BASHRC_URL" )

  else
    echo "${THIS}: 'git' command not found." 1>&2
    exit 15
  fi

  cd "${dotbashrcwdir}/dot-bashrc/" 2>/dev/null || {
    echo "${THIS}: 'dot-bashrc': no such file or directory." 1>&2
    exit 18
  }

  echo "#"
  echo "# dot-bashrc/install.sh"
  echo "#"

  if [ -x "$dotbashrcplay" ]
  then

    ansibleoption=""

    [ $GLOBAL_INSTALL -ne 0 ] &&
    ansibleoption="${ansibleoption} -e system=true"
    [ $DRYRUNMODEFLAG -ne 0 ] &&
    ansibleoption="${anaibleoption} -D"

    echo "#"
    echo "# run - $dotbashrcplay $ansibleoption ansible.yml"
    echo "#"

    $dotbashrcplay $ansibleoption ansible.yml

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

else

  bashrctagname="dot-bashrc/$THIS, $(date)"
  bashbashrcsrc="files/etc/bash.bashrc.d"

  cd "${DOT_BASHRC_SRC}" 2>/dev/null || {
    echo "${THIS}: '${DOT_BASHRC_SRC}' no such file or dorectory." 1>&2
    exit 31
  }

  [ -n "${DOT_BASHRC_SRC}" \
    -a -d "${DOT_BASHRC_SRC}/${bashbashrcsrc}" ] || {
    echo "${THIS}: 'DOT_BASHRC_SRC/${bashbashrcsrc:-???}' no such file or dorectory." 1>&2
    exit 32
  }

  bashrcinstall="$HOME"
  bashbashrcdir="${bashrcinstall}/.bash.bashrc.d"
  bashrcprofile=".bash_profile"
  bashrc_rcfile=".bashrc"
  bash_rc_owner=$(id -un)
  bash_rc_group=$(id -gn "$bash_rc_owner")

  [ $GLOBAL_INSTALL -ne 0 ] && {
    bashrcinstall=/etc
    bashbashrcdir="${bashrcinstall}/bash.bashrc.d"
    bashrcprofile="bash.profile"
    bashrc_rcfile="bash.bashrc"
    bash_rc_owner="root"
    bash_rc_group=$(id -gn "$bash_rc_owner")
  }

  [ $DRYRUNMODEFLAG -ne 0 ] && {
    bashrcinstall="${dotbashrcwdir}${bashrcinstall}"
    bashbashrcdir="${dotbashrcwdir}${bashbashrcdir}"
  }

  bashtmplfiles=$(
    : && {
      cat <<_EOF_
bash.profile:${bashrcinstall}/${bashrcprofile}
bash.bashrc:${bashrcinstall}/${bashrc_rcfile}
vim/vimrc:${bashbashrcdir}/vim/vimrc
_EOF_
    } 2>/dev/null )

  bashrcsymlnks=$(
    [ $GLOBAL_INSTALL -ne 0 ] && {
      cat <<_EOF_
${bashrcprofile}:profile
${bashrc_rcfile}:bashrc
_EOF_
    } || {
      cat <<_EOF_
${bashbashrcdir##*/}/vim/vimrc:.vimrc
_EOF_
    } 2>/dev/null )

  cat <<_EOF_
#-----------------------
# sot-bashrc/install.sh
#-----------------------
#
#* bashrcinstall="$bashrcinstall"
#* bashbashrcdir="$bashbashrcdir"
#* bashrcprofile="$bashrcprofile"
#* bashrc_rcfile="$bashrc_rcfile"
#* bash_rc_owner="$bash_rc_owner"
#* bash_rc_group="$bash_rc_group"
#
_EOF_

  [ -d "${bashbashrcdir}" ] || {
    mkdir -p "${bashbashrcdir}"
  }

  [ -d "${bashrcinstall}/._bashrc-origin" ] || {

    echo
    echo "# Create a backup."

    mkdir -p "${bashrcinstall}/._bashrc-origin"

    ( cd "${bashrcinstall}/._bashrc-origin" &&
      for file in \
        bashrc profile \
        bash.bashrc bash.profile \
        bash_profile bash_logout
      do
        [ -e "../${file}" ] && cp -prfv ../${file} ./
        [ -e "../.${file}" ] && cp -prfv ../.${file} ./
      done )

    echo

  } 2>/dev/null

  echo
  echo "# Install the 'bash.bashrc.d' to '${bashbashrcdir}'."

  ( cd "${bashbashrcsrc}" &&
    tar -c . |tar -C "${bashbashrcdir}/" -xvf - ) || {
    echo "${THIS}: Abort(41)" 1>&2
    exit 41
  }

  echo
  echo "# Grant and revoke on 'bash.bashrc.d' files."

  ( cd "${bashbashrcdir}" &&
    chown -R "${bash_rc_owner}:${bash_rc_group}" . &&
    find . -type d -print -exec chmod u=rwx,go=rx {} \; &&
    find . -type f -print -exec chmod u=rw,go=r {} \; &&
    find . -type f -a -name "*.sh" -print -exec chmod a+x {} \; &&
    find ./bin -type f -print -exec chmod a+x {} \; &&
    echo ) || {
    echo "${THIS}: Abort(42)" 1>&2
    exit 42
  }

  echo
  echo "# Install the templates."

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

    sed -e 's@{{[ ]*ansible_managed[ ]*}}@'"${bashrctagname}"'@g' \
        -e 's@{{ bash_bashrc_dir[ ]*[^\}]*}}@'"${bashbashrcdir}"'@g' \
           <"${bashrctmplsrc}" >"${bashrctmpldst}" && {
      echo
      diff -u "${bashrctmplsrc}" "${bashrctmpldst}"
      echo
    }

  done

  echo
  echo "# Create symlinks."

  ( cd "${bashrcinstall}" &&
    for bashsymlnkent in ${basrcsymlnks}
    do

      : && {
        bashsymlnksrc=$(echo "${bashsymlnkent}"|cut -d: -f1)
        bashsymlnkdst=$(echo "${bashsymlnkent}"|cut -d: -f2)
      } 2>/dev/null

      [ -e "${bashsymlnksrc}" ] || continue
      [ -n "${bashsymlnkdst}" ] || continue

      [ "${bashsymlnksrc}" = "${bashsymlnkdst}" ] && continue

      [ -z "${bashsymlnkdst%/*}" -o -d "${bashsymlnkdst%/*}" ] || {
        mkdir -p "${bashsymlnkdst%/*}"
      }

      echo "# Symlink '${bashsymlnksrc}' to '${bashsymlnkdst}'."

      ln -sf "${bashsymlnksrc}" "${bashsymlnkdst}"

    done 2>/dev/null )

  echo
  echo "Done."

fi

exit $?
