#!/bin/bash
# INFO.sh
source /pkgscripts/include/pkg_util.sh

package="${PACKAGE_NAME}"
version="${PACKAGE_VERSION}"
os_min_ver="7.0-40000"
displayname="Kernel Modules for Wireguard"
description="Kernel modules needed by the wireguard kernel module"
arch="$(pkg_get_spk_platform)"
maintainer="Not Synology Inc."
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
