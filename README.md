This README file contains information on the contents of the
meta-iris-base layer collection.

Please see the corresponding sections below for details.

Patches
=======

Please submit any patches against the meta-iris-base layer collection via
GitHub pull requests or as patch files via email to the maintainers.

Maintainers: 
- Jasper Orschulko <Jasper [dot] Orschulko [at] iris-sensing.com>
- Erik Schumacher <Erik [dot] Schumacher [at] iris-sensing.com>

Table of Contents
=================

1. Current layers
2. Usage
3. Misc

Current layers
==============

Currently, this layer collection contains the following layers:
- **meta-iris-base-common** contains common code for HW release 1 and 2
- **meta-iris-base-hw1** contains code specific to HW release 1
- **meta-iris-base-hw2** contains code specific to HW release 1

Usage
=====

Check out our KAS setup at [https://github.com/iris-GmbH/iris-kas]

Misc
====

This repository contains the multiple layers, which in turn contain the
configurations, recipes and modifications for building the iris custom Linux
distribution (the irma-six-base image), minus our proprietary platform
application.

The maintainers of this repository focus on supporting the current Yocto LTS 
release. However, feel free to add support for other releases via pull requests.
In the future we plan to include all currently supported Yocto releases
in a CI workflow.
