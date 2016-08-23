# ${bashrcdir}/completion.d/darwin/90homebrew.sh

brew_path=$(type -P brew 2>/dev/null)
brew_home=$([ -n "${brew_path%/*}" ] &&
            cd -P "${brew_path%/*}/../" 2>/dev/null; pwd)

if [ -n "${brew_home}" ] &&
   [ -d "${brew_home}/etc/bash_completion.d" ]
then
   for completion_sh in $(/bin/ls -1 ${brew_home}/etc/bash_completion.d/* 2>/dev/null)
   do
     . "$completion_sh" 2>/dev/null
   done 
   unset completion_sh
fi

unset brew_path brew_home

