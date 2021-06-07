SRC_URI += "file://fragment.cfg"
SRC_URI += "file://arp.cfg"
SRC_URI += "file://ntpd.cfg"
SRC_URI += "file://0001-added-multiple-remote-hosts-in-syslog-init-script.patch;patchdir=${WORKDIR}"

FILESEXTRAPATHS_prepend := "${THISDIR}/busybox:"

#do_patch_syslog () {
#    patch ${WORKDIR}/syslog ${WORKDIR}/0001-added-multiple-remote-hosts-in-syslog-init-script.patch
#}

#addtask do_patch_syslog after do_unpack before do_install
