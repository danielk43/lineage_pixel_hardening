#!/bin/bash
#DivestOS: A privacy focused mobile distribution
#Copyright (c) 2015-2022 Divested Computing Group
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <https://www.gnu.org/licenses/>.
umask 0022;
set -euo pipefail;

export DOS_WORKSPACE_ROOT=${GIT_LOCAL}"/DivestOS-Build"; #XXX: THIS MUST BE CORRECT TO PATCH
source "${DOS_WORKSPACE_ROOT}/Scripts/init.sh"

#Last verified: 2023-02-12

[[ -z ${ANDROID_BUILD_TOP} ]] && echo "ANDROID_BUILD_TOP not set. build/envsetup.sh must be sourced" && exit 1
export PATCH_DIR="${GIT_LOCAL}/android_patches/$(basename ${ANDROID_BUILD_TOP})"

#
#START OF CHANGES
#

if [[ ${ANDROID_BUILD_TOP,,} =~ "lineage" ]]; then
  #ROM
  if enterAndClear "build/make"; then
    if [ -n "${DOS_DEBLOBBER_REMOVE_FP} = true" ]; then applyPatch "${PATCH_DIR}/android_build/0001-Remove-fp.patch"; fi; #Remove fingerprint module
    applyPatch "${PATCH_DIR}/android_build/0002-Patch-makefile-for-custom-avb.patch"; #Add support for custom AVB key
  fi;

  if enterAndClear "frameworks/base"; then
    if [ -n "${MICROG}" ]; then applyPatch "${PATCH_DIR}/android_frameworks_base/0001-Apply-restricted-sig-spoof.patch"; fi; #Support restricted sig spoofing
    applyPatch "${PATCH_DIR}/android_frameworks_base/0002-Use-alternate-ntp-pool.patch"; #Use non-Android ntp pool
  fi;

  if enterAndClear "hardware/google/pixel"; then
    applyPatch "${PATCH_DIR}/android_hardware_google_pixel/0001-Remove-wifi-ext.patch"; #Remove wifi-ext
  fi;

  if enterAndClear "vendor/lineage"; then
    applyPatch "${PATCH_DIR}/android_vendor_lineage/0001-Allow-custom-build-types.patch"; #Remove restriction for build type
    applyPatch "${PATCH_DIR}/android_vendor_lineage/0002-Update-webview-providers.patch"; #Allowlist Bromite webview
    applyPatch "${PATCH_DIR}/android_vendor_lineage/0003-Replace-default-browser.patch"; #Install Bromite browser
    applyPatch "${PATCH_DIR}/android_vendor_lineage/0004-Add-extra-apks.patch"; #Add additional apks
    if [ -n "${MICROG}" ]; then applyPatch "${PATCH_DIR}/android_vendor_lineage/0005-Add-microg-apks.patch"; fi; #Add microg apks
  fi;

  #DEVICE

  if enterAndClear "device/google/bramble"; then
    applyPatch "${PATCH_DIR}/android_device_google_bramble/0001-bramble-Disable-mainline-checking.patch"; #Allow extra apks at build time
    applyPatch "${PATCH_DIR}/android_device_google_bramble/0002-Move-avb-key-from-device-redbull.patch"; #Add support for AVB at device level
  fi;

  if enterAndClear "device/google/crosshatch"; then
    applyPatch "${PATCH_DIR}/android_device_google_crosshatch/0001-b1c1-Remove-modules.patch"; #Debloat
    applyPatch "${PATCH_DIR}/android_device_google_crosshatch/0002-b1c1-Remove-default-permissions.patch"; #Remove unused permissions
    applyPatch "${PATCH_DIR}/android_device_google_crosshatch/0003-Add-custom-avb-key.patch"; #Add support for AVB
  fi;

  if enterAndClear "device/google/redbull"; then
    applyPatch "${PATCH_DIR}/android_device_google_redbull/0001-redbull-Remove-modules.patch"; #Debloat
    applyPatch "${PATCH_DIR}/android_device_google_redbull/0002-redbull-Remove-default-permissions.patch"; #Remove unused permissions
    applyPatch "${PATCH_DIR}/android_device_google_redbull/0003-Move-avb-key-to-device-bramble.patch"; #Move AVB support to device repo
  fi;

  #KERNEL

  if enterAndClear "kernel/google/redbull"; then
    "${GIT_LOCAL}"/DivestOS-Build/Scripts/"${BUILD_WORKING_DIR}"/CVE_Patchers/android_kernel_google_redbull.sh
  fi;

  if enterAndClear "kernel/google/msm-4.9"; then
    "${GIT_LOCAL}"/DivestOS-Build/Scripts/"${BUILD_WORKING_DIR}"/CVE_Patchers/android_kernel_google_msm-4.9.sh
  fi;

  #VENDOR

  if enterAndClear "vendor/google/bramble"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_bramble/0001-bramble-Add-gesture-input.patch" && echo "Add libjni_latinimegoogle.so";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_bramble/0002-bramble-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_bramble/0003-bramble-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/crosshatch"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_crosshatch/0001-crosshatch-Add-gesture-input.patch" && echo "Add libjni_latinimegoogle.so";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_crosshatch/0002-crosshatch-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_crosshatch/0003-crosshatch-Update-apps.patch"; #Deblob apps
  fi;
elif [[ ${ANDROID_BUILD_TOP,,} =~ "graphene" ]]; then
  echo "Do stuff";
fi

#
#END OF CHANGES
#
