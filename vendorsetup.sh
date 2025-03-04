#!/bin/bash

export OF_DISABLE_OTA_MENU=1
export FOX_AB_DEVICE=1
export FOX_VIRTUAL_AB_DEVICE=1
export OF_DEFAULT_KEYMASTER_VERSION=4.1
export OF_NO_TREBLE_COMPATIBILITY_CHECK=1

export FOX_USE_BASH_SHELL=1
export FOX_USE_NANO_EDITOR=1
export FOX_USE_TAR_BINARY=1
export FOX_USE_SED_BINARY=1
export FOX_USE_XZ_UTILS=1
export FOX_ASH_IS_BASH=1
export OF_ENABLE_LPTOOLS=1
export FOX_DELETE_AROMAFM=1
export FOX_ENABLE_APP_MANAGER=1
export OF_SUPPORT_VBMETA_AVB2_PATCHING=1

export FOX_USE_DATA_RECOVERY_FOR_SETTINGS=1

export OF_LOOP_DEVICE_ERRORS_TO_LOG=1

export OF_USE_LZ4_COMPRESSION=true

export OF_USE_MAGISKBOOT="1"
export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES="1"
export OF_DONT_PATCH_ENCRYPTED_DEVICE="1"

export OF_SCREEN_H=2436 
export OF_STATUS_H=95
export OF_STATUS_INDENT_LEFT=48
export OF_STATUS_INDENT_RIGHT=48
export OF_ALLOW_DISABLE_NAVBAR=0
export OF_CLOCK_POS=1

# maintainer 
export OF_MAINTAINER_AVATAR="$(gettop)/device/tecno/LH8n/maintainer_avatar.png"
cp "${OF_MAINTAINER_AVATAR}" "$(gettop)/bootable/recovery/gui/theme/portrait_hdpi/images/Default/About/maintainer.png"
export OF_MAINTAINER="Nazephyrus"
export FOX_VARIANT="A12+"

# Important build settings
export ALLOW_MISSING_DEPENDENCIES=true
export LC_ALL="C"

# flashlight
export OF_FLASHLIGHT_ENABLE=0

# haptic patch
TFILE=$PWD/out/hapticspath.patched
[ ! -d "out" ]&& mkdir -p out
RET=0
REVERSE=0

cd bootable/recovery
git apply --reverse --check ../../device/tecno/LI9/patches/0001-Change-haptics-activation-file-path.patch || REVERSE=$?
cd ../../

if [ -f "$TFILE" ];then
    echo "haptics path patched already, skipping"
elif [ $REVERSE -eq 0 ]; then
	echo "$TFILE is not found but git is able to reverse haptics path patch, assuming it's already patched, skipping"
else
    cd bootable/recovery
    git apply ../../device/tecno/LI9/patches/0001-Change-haptics-activation-file-path.patch || RET=$?
    cd ../../
    if [ $RET -ne 0 ];then
	echo "ERROR: minuitwrp/events.cpp could not be patched! Vibration in TWRP will not work."
    else
	echo "OK: minuitwrp/events.cpp patched"
	touch $TFILE
    fi
fi
