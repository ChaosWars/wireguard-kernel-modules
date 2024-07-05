#!/bin/bash

set -eu

IS_ROOT=$(id -u)

if [[ $IS_ROOT -ne 0 ]]; then
    echo "Script must be run as root"
    exit 1
fi

if [[ -z $DSMVERSION ]]; then
    echo "DSMVERSION is not set"
    exit 1
fi

if [[ -z $KERNEL_VERSION ]]; then
    echo "KERNEL_VERSION is not set"
    exit 1
fi

if [[ -z $ARCHITECTURE ]]; then
    echo "ARCHITECTURE is not set"
    exit 1
fi

if [[ -z $PACKAGE_NAME ]]; then
    echo "PACKAGE_NAME is not set"
    exit 1
fi

if [[ -z $WORKSPACE ]]; then
    echo "WORKSPACE is not set"
    exit 1
fi

export SOURCE_DIR="$WORKSPACE/source"
export TEMPLATES_DIR="$WORKSPACE/templates"

source "$PKGSCRIPTSPATH/include/platform.$ARCHITECTURE"

export BUILD_ENV="$TOOLKITPATH/build_env/ds.$ARCHITECTURE-$DSMVERSION"
export BUILD_ENV_SOURCE="$BUILD_ENV/source"
export TOOLKIT_SOURCE_DIR="$TOOLKITPATH/source/$PACKAGE_NAME"

if [[ -d "$TOOLKIT_SOURCE_DIR" ]]; then
    echo "Removing $TOOLKIT_SOURCE_DIR"
    rm -rf "$TOOLKIT_SOURCE_DIR"
fi

echo "Creating $TOOLKIT_SOURCE_DIR"
mkdir -p "$TOOLKIT_SOURCE_DIR"

if [[ -d "$BUILD_ENV_SOURCE" ]]; then
    echo "Removing $BUILD_ENV_SOURCE"
    rm -rf "$BUILD_ENV_SOURCE"

    echo "Creating $BUILD_ENV_SOURCE"
    mkdir -p "$BUILD_ENV_SOURCE"
fi

SCRIPTS_DIR="$TOOLKIT_SOURCE_DIR/scripts"

if [[ -d "$SCRIPTS_DIR" ]]; then
    echo "Removing $SCRIPTS_DIR"
    rm -rf "$SCRIPTS_DIR"
fi

echo "Creating $SCRIPTS_DIR"
mkdir -p "$SCRIPTS_DIR"

KERNEL_MODULES="iptable_raw xt_comment xt_connmark"

echo "Initializing service templates"
sed -e "s/KERNEL_MODULES/$KERNEL_MODULES/g" -e "s/PACKAGE_NAME/$PACKAGE_NAME/g" ${TEMPLATES_DIR}/scripts/start-stop-status > $SCRIPTS_DIR/start-stop-status
chmod +x $SCRIPTS_DIR/start-stop-status

cd $SOURCE_DIR

echo "Copying source files to $TOOLKIT_SOURCE_DIR"
cp -av conf $TOOLKIT_SOURCE_DIR
cp -av SynoBuildConf $TOOLKIT_SOURCE_DIR
cp -av ${TEMPLATES_DIR}/scripts/{postinst,postuninst,postupgrade,preinst,preuninst,preupgrade} $SCRIPTS_DIR
cp -av INFO.sh $TOOLKIT_SOURCE_DIR
cp -av Makefile $TOOLKIT_SOURCE_DIR
cp -av PACKAGE_ICON*.PNG $TOOLKIT_SOURCE_DIR
cp -av LICENSE $TOOLKIT_SOURCE_DIR

cd $TOOLKITPATH
${SOURCE_DIR}/getKernelSource.sh

set +e

BUILD_ENV_DEV="$BUILD_ENV/dev"
mount -o bind /dev $BUILD_ENV_DEV

$PKGSCRIPTSDIR/PkgCreate.py \
    -p $ARCHITECTURE \
    -v $DSMVERSION \
    --build-opt=-J \
    --min-sdk $DSMVERSION \
    -c "${PACKAGE_NAME}"

# Save package builder exit code. This allows us to print the logfiles and give
# a non-zero exit code on errors.
pkg_status=$?

set -e
umount $BUILD_ENV_DEV

if [[ $pkg_status -ne 0 ]]; then
    echo "Failed to build package"
    exit 1
fi

TARGET_DIR="$WORKSPACE/target"

if [[ -d $TARGET_DIR ]]; then
    echo "Removing $TARGET_DIR"
    rm -rf $TARGET_DIR
fi

echo "Creating $TARGET_DIR"
mkdir -p $TARGET_DIR
chown -R $SUDO_UID:$SUDO_GID $TARGET_DIR

PACKAGES_DIR="$BUILD_ENV/image/packages"

if [[ -d $PACKAGES_DIR ]]; then
    echo "Copying packages to $TARGET_DIR"
    cp -av $PACKAGES_DIR/*.spk $TARGET_DIR
else
    echo "PACKAGES_DIR not found: $PACKAGES_DIR"
    exit 1
fi

chown $SUDO_UID:$SUDO_GID $TARGET_DIR/*.spk
exit $pkg_status
