#!/bin/bash -u
THIS="${BASH_SOURCE##*/}"
NAME="${THIS%.*}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" 2>/dev/null; pwd)

# Background
for clbg in {40..47} {100..107} 49
do
  # Foreground
  for clfg in {30..37} {90..97} 39
  do
    # Formatting
    for attr in 0 1 2 4 5 7
    do
      # Print the result
      [ "${attr}" = "7" ] && sepr="" || sepr=" | "
      printf "\e[${attr};${clbg};${clfg}m %-12s \e[0m%s" "^[${attr};${clbg};${clfg}m" "${sepr}"
    done
    echo # Newline
  done
done

exit 0
