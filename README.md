dot-bashrc [![Build Status](https://travis-ci.org/mtangh/dot-bashrc.svg?branch=master)](https://travis-ci.org/mtangh/dot-bashrc)
==========

Requirements
------------

This is a bash dot file.
A system with bash installed.
The bash version will not be confirmed. It may not work with very old bash versions.


Role Variables
--------------

bashrc_install_global: true|false
bashrc_install_skel: true|false


Dependencies
------------

There are no other roles to depend on.


Example Playbook
----------------

The method of using a roll is as follows:

```
    - hosts: servers
      roles:
      - role: dot-bashrc
        vars:
          bashrc_install_global: true
          bashrc_install_skel: true
```

```
    - hosts: servers
      roles:
      - role: dot-bashrc
        vars:
          bashrc_install_global: false
          bashrc_install_skel: true
```

License
-------

BSD


Author Information
------------------

MT

