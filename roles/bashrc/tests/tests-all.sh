#!/bin/bash -u
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Ansible playbook
ansible_play="$(type -P ansible-playbook)"
ansible_play="${ansible_play:+$ansible_play -i testcases test.yml}"

# Flags
tests_test_run=0
tests_case_ret=0

exec 1> >({
  cat|while IFS= read row_data
  do echo "$THIS: $row_data"
  done
  } 2>/dev/null)

cd "${CDIR}" &>/dev/null &&
[ -n "${ansible_play}" -a -r "testcases" -a -r "test.yml" ] && {

  echo "syntax-check." && {

    $ansible_play --syntax-check

  } &&
  echo "list-hosts." && {

    $ansible_play --list-hosts

  } &&
  echo "begin tests-run." && {

    for tests_casename in $( {
      cat testcases |
      sed -En 's@^[ ]*([0-9A-Za-z][-_.0-9A-Za-z]*)[ ]*(.+$|$)@\1@gp' |
      sort -u 2>/dev/null; } )
    do
      tests_test_run=$((++tests_test_run))
      printf 'case #%03d [%s].' $tests_test_run "$tests_casename"; echo
      $ansible_play -l "${tests_casename}" ||
      tests_case_ret=$?
    done

  } &&
  echo "end of tests-run."
  [ ${tests_test_run:-0} -ne 0 ] &&
  [ ${tests_case_ret:-1} -eq 0 ];

} &&
echo "OK."

exit $?
