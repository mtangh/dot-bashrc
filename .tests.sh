#!/bin/bash -Cu
THIS="${BASH_SOURCE##*/}"
CDIR=$([ -n "${BASH_SOURCE%/*}" ] && cd "${BASH_SOURCE%/*}" &>/dev/null; pwd)

# Status of all tests
tests_stat=0
# Ran tests
tests_cseq=0
# Tests Dir
tests_tdir=${TESTS_DIR_PATH:-${CDIR}/.tests.d}

# Run tests
for tests_sh in "${tests_tdir}"/*.sh
do

  tests_cseq=$((++tests_cseq))
  tests_name="${tests_sh##*/}"
  tests_name="${tests_name%.sh*}"
  tests_mark="${THIS%.*}/${tests_name}"
  tests_rval=0

  x_trace_fd=""
  xtrace_out="${tests_sh%.sh*}_xtrace.log"

  echo "${tests_mark}: Start the test."

  exec {x_trace_fd}>"${xtrace_out}" || :
  BASH_XTRACEFD=${x_trace_fd} \
  tests_name="${tests_name}" tests_wdir="${CDIR}" \
  bash -x "${tests_sh}"; tests_rval=$?
  exec {x_trace_fd}>&- || :

  if [ $tests_rval -eq 0 ]
  then
    echo "${tests_mark}: OK."
  else
    tests_stat=${tests_rval}
    echo "${tests_mark}: {{{ This test failed. XTRACE is as follows:"
    cat "${xtrace_out}" 2>/dev/null
    echo "${tests_mark}: }}} End of XTRACE."
    echo "${tests_mark}: Exit with (${tests_rval:-1})."
  fi

done &&
[ ${tests_cseq:-0} -gt 0 ] &&
[ ${tests_stat:-1} -eq 0 ]
tests_stat=$?

# End
exit ${tests_stat:-1}
