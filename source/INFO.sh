#!/bin/bash
# INFO.sh
source /pkgscripts/include/pkg_util.sh

arch="$(pkg_get_spk_platform)"
description="Kernel modules needed by the wireguard kernel module"
displayname="Kernel Modules for Wireguard"
maintainer="Lawrence Lee"
os_min_ver="7.0-40000"
package="${PACKAGE_NAME}"
version="${PACKAGE_VERSION}"
[ "$(caller)" != "0 NULL" ] && return 0
pkg_dump_info
