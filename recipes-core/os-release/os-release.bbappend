# SPDX-License-Identifier: MIT
# Copyright (C) 2021 iris-GmbH infrared & intelligent sensors

# rerun on each build to make sure the version is updated
do_compile[nostamp] = "1"
do_install[nostamp] = "1"
get_bootloader_version[nostamp] = "1"

# we need the populated sysroot for access to the "uboot.release" file,
# which is provided by the u-boot recipe
DEPENDS += "u-boot"
get_bootloader_version[deptask] = "do_populate_sysroot"

# setting as prefunc will change the variable scope:
# https://stackoverflow.com/a/61039212
do_compile[prefuncs] += "get_bootloader_version"

python get_bootloader_version() {
    with open(d.getVar('STAGING_DIR_HOST', True) + d.getVar('datadir', True) + '/uboot.release','r') as f:
        bootloader_version = f.readline().rstrip()
        d.setVar('BOOTLOADER_VERSION', bootloader_version)
        d.appendVar('OS_RELEASE_FIELDS', ' BOOTLOADER_VERSION')
}

OS_RELEASE_FIELDS += "MACHINE"
