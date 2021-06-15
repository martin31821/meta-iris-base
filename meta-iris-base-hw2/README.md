This README file contains information on the contents of the
meta-iris-base-hw2 layer.

Please see the corresponding sections below for details.

Dependencies
============
 - core
 - openembedded-layer
 - meta-iris-base-common

Patches
=======

Please submit any patches against the meta-iris-base-hw2 layer via GitHub
pull requests or as patch files via email to the maintainers.

Maintainers: 
- Jasper Orschulko <Jasper [dot] Orschulko [at] iris-sensing.com>
- Erik Schumacher <Erik [dot] Schumacher [at] iris-sensing.com>

Table of Contents
=================

1. Adding the meta-iris-base-hw2 layer to your build
2. Misc


Adding the meta-iris-base-hw2 layer to your build
=================================================

Run 'bitbake-layers add-layer meta-iris-base-hw2'
Or, check out our KAS setup at [https://github.com/iris-GmbH/iris-kas]

Misc
====

This repository contains the hardware release 1 specific 
recipes and modifications for building the iris custom Linux
distribution (the irma-six-base image), minus our proprietary platform
application.


The maintainers of this layer focus on supporting the current Yocto LTS 
release. However, feel free to add support for other releases via pull requests.
In the future we plan to include all currently supported Yocto releases
in a CI workflow.
