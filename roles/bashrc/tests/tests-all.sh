#!/bin/bash -u
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Ansible playbook
ansible_play="$(type -P ansible-playbook)"
ansible_play="${ansible_play:+$ansible_play -i testcases test.yml}"
ansible_opts="${TESTS_PLAY_OPTIONS:-}"

# List of test-case
testcaselist="$@"

# Flags
testcase_run=0
testcase_ret=0

# Redirect to filter
exec 1> >(set +x && {
  cat | while IFS= read row_data
  do echo "$THIS: $row_data"; done
  } 2>/dev/null; )

# The tests
cd "${CDIR}" &>/dev/null &&
[ -n "${ansible_play}" -a -r "testcases" -a -r "test.yml" ] && {

  [ -n "${testcaselist}" ] || {
    testcaselist=$( {
       cat ./testcases |
       sed -En 's@^[ ]*([0-9A-Za-z][-_.0-9A-Za-z]*)[ ]*(.+$|$)@\1@gp' |
       sort -u
       } 2>/dev/null; )
  }

  echo "Syntax check." && {

    $ansible_play --syntax-check || testcase_ret=$?
    echo

  } &&
  [ ${testcase_ret:-1} -eq 0 ] &&
  echo "Begin of the tests." && {

    echo
    echo "The tests to run are as follows:"
    echo "${testcaselist}"
    echo

    for tests_casename in ${testcaselist}
    do
      testcase_run=$((++testcase_run))
      printf 'CASE #%03d [%s].' $testcase_run "$tests_casename"; echo
      $ansible_play ${ansible_opts} -l "${tests_casename}" || testcase_ret=$?
      echo
    done

  } &&
  echo "End of the tests." &&
  [ ${testcase_run:-0} -ne 0 ] &&
  [ ${testcase_ret:-1} -eq 0 ]

} &&
echo "OK."

# End
exit ${testcase_ret:-1}
