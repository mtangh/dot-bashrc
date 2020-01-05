#!/usr/bin/env python

import os
import re

class FilterModule(object):

  def filters(self):
    return {
      "tests_task_valid": self.tests_task_valid,
      "tests_task_eq_setup": self.tests_task_eq_setup,
      "tests_task_eq_teardown": self.tests_task_eq_teardown,
    }

  def tests_task_valid( self, input ):
    try:
      return input is not None and \
        (self.is_tests_task_setup(input) or self.is_tests_task_teardown(input))
    except:
      return False

  def tests_task_eq_setup( self, input ):
    try:
      return input is not None and \
        re.match('^setup$',(str(input).strip()).lower())
    except:
      return False

  def tests_task_eq_teardown( self, input ):
    try:
      return input is not None and \
        re.match('^teardown$',(str(input).strip()).lower())
    except:
      return False

