# ${bashrc_dir}/70golang.sh
# $Id$

[ -n "$(type -P go 2>/dev/null)" ] && {

# path config command
gopathconf="${bashrc_dir}/bin/pathconfig"

# paths
gopaths_dirs=""

# lookup paths file(s)
for gopaths_file in $( {
__pf_rc_loader \
{"${HOME}/.","${XDG_CONFIG_HOME:-${HOME}/.config}/"}gopaths
} 2>/dev/null || :; )
do
  [ -f "${gopaths_file}" ] || continue
  gopaths_dirs="${gopaths_dirs:+${gopaths_dirs} }"
  [ -x "${gopaths_file}" ] &&
  gopaths_dirs="${gopaths_dirs}$(echo $(/bin/bash ${gopaths_file} 2>/dev/null))"
  [ -x "${gopaths_file}" ] ||
  gopaths_dirs="${gopaths_dirs}$(echo $(/bin/cat ${gopaths_file} 2>/dev/null))"
done || :
unset gopaths_file

# Set default if dirs is empty
if [ -z "${gopaths_dirs}" ]
then
  for gopaths_file in {/opt,/usr/local/lib,/usr/lib}/golang
  do
    [ -d "${gopaths_file}" ] && {
      gopaths_dirs="${gopaths_dirs:+${gopaths_dirs} }"
      gopaths_dirs="${gopaths_dirs}${gopaths_file}"
    } || :
  done || :
  unset gopaths_file
fi || :

# export new GOPATH
GOPATH=
eval $($gopathconf GOPATH -s -f -a ${gopaths_dirs})

# Cleanup
unset gopathconf
unset gopaths_dirs

# Aliases
alias go-get="go get"
alias go-env-goos="go env GOOS"
alias go-env-goarch="go env GOARCH"
alias go-env-goroot="go env GOROOT"
alias go-env-gopath="go env GOPATH"
alias go-env-gotooldir="go env GOTOOLDIR"
alias go-run="go run"
alias go-build="go build"
alias go-tool="go tool"
alias go-compile="go tool compile"
alias go-link="go tool link"
alias go-asm="go tool asm"
alias go-cgo="go tool cgo"
alias go-objdump="go tool objdump"
alias go-nm="go tool nm"
alias go-pack="go tool pack"

} &>/dev/null || :

# *eof*
