#!/bin/bash

if [[ -z $KERNEL_VERSION ]]; then
    echo "KERNEL_VERSION is not set"
    exit 1
fi

if [[ -z $TOOLKIT_SOURCE_DIR ]]; then
    echo "TOOLKIT_SOURCE_DIR is not set"
    exit 1
fi

if [[ -z $TOOLKITPATH ]]; then
    echo "TOOLKITPATH is not set"
    exit 1
fi

if [[ ! -f ${TOOLKIT_SOURCE_DIR}/iptable_raw.c && ! -f ${TOOLKIT_SOURCE_DIR}/xt_comment.c && ! -f ${TOOLKIT_SOURCE_DIR}/xt_connmark.c ]]; then
    KERNEL_TAR_FILE="${TOOLKITPATH}/${KERNEL_VERSION}.tar.xz"
    KERNEL_URI="https://cdn.kernel.org/pub/linux/kernel/v4.x/${KERNEL_TAR_FILE}"

    if [[ ! -f "$KERNEL_TAR_FILE" ]]; then
        echo "Downloading $KERNEL_TAR_FILE"
        wget -q -O $KERNEL_TAR_FILE $KERNEL_URI
    fi

    chmod +x $KERNEL_TAR_FILE

    echo "Copying kernel modules source to build environment"
    tar -xf ${KERNEL_TAR_FILE} -C ${TOOLKIT_SOURCE_DIR} --strip-components=4 ${KERNEL_VERSION}/net/ipv4/netfilter/iptable_raw.c
    tar -xf ${KERNEL_TAR_FILE} -C ${TOOLKIT_SOURCE_DIR} --strip-components=3 ${KERNEL_VERSION}/net/netfilter/xt_comment.c
    tar -xf ${KERNEL_TAR_FILE} -C ${TOOLKIT_SOURCE_DIR} --strip-components=3 ${KERNEL_VERSION}/net/netfilter/xt_connmark.c
fi
