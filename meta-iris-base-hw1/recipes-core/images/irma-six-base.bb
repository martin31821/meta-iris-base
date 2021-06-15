# SPDX-License-Identifier: MIT
# Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

require recipes-core/images/irma-six-base.inc

PN_append = "-hw1"

inherit irma-6-firmware-zip
