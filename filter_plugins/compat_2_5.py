#!/usr/bin/env python

import os
import re

class FilterModule(object):

  def filters(self):
    return {
      "exists": self.path_exists,
      "is_dir": self.path_is_dir,
      "is_file": self.path_is_file,
      "is_link": self.path_is_link,
      "is_abs": self.path_is_abs,
      "is_mount": self.path_is_mount,
      "samefile": self.path_samefile,
      "match": self.pattern_match,
    }

  def path_exists( self, path ):
    try:
      return path is not None and os.path.exists(path)
    except:
      return False

  def path_is_dir( self, path ):
    try:
      return path is not None and os.path.isdir(path)
    except:
      return False

  def path_is_file( self, path ):
    try:
      return path is not None and os.path.isfile(path)
    except:
      return False

  def path_is_link( self, path ):
    try:
      return path is not None and os.path.islink(path)
    except:
      return False

  def path_is_abs( self, path ):
    try:
      return path is not None and os.path.isabs(path)
    except:
      return False

  def path_is_mount( self, path ):
    try:
      return path is not None and os.path.ismount(path)
    except:
      return False

  def path_samefile( self, path1, path2 ):
    try:
      return \
        path1 is not None and \
        path2 is not None and \
        os.path.samefile(path1,path2)
    except:
      return False

  def pattern_match( self, input, pattern ):
    try:
      return \
        input is not None and \
        pattern is not None and \
        re.match(pattern,input)
    except:
      return False

