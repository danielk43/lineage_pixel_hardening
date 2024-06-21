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
set -eo pipefail;

if [[ -n ${ANDROID_BUILD_TOP} ]]; then
  echo "ANDROID_BUILD_TOP set, must be named 'lineage-20.0'"
  export PROJECT_ROOT=${ANDROID_BUILD_TOP}
else
  echo "ANDROID_BUILD_TOP not set, using PWD for project root. must be named 'grapheneos-14'"
  export PROJECT_ROOT=${PWD}
fi

echo PROJECT_ROOT=${PROJECT_ROOT}
export PATCH_DIR="${GIT_LOCAL}/lineage_pixel_hardening/${PROJECT_ROOT##*/}"

export DOS_WORKSPACE_ROOT=${GIT_LOCAL}"/DivestOS-Build"; #XXX: THIS MUST BE CORRECT TO PATCH
[[ ${PROJECT_ROOT##*/} =~ "lineage" ]] && source "${DOS_WORKSPACE_ROOT}/Scripts/init.sh" # Skip DOS scripts for GOS

#
#START OF CHANGES
#

if [[ ${PROJECT_ROOT,,} =~ "lineage" ]]; then
#  #ROM
#  if enterAndClear "build/make"; then
#    [[ -n "${DOS_DEBLOBBER_REMOVE_FP} = true" ]] && applyPatch "${PATCH_DIR}/android_build/0001-Remove-fp.patch"; #Remove fingerprint module
#    [[ -n ${AVB} ]] && applyPatch "${PATCH_DIR}/android_build/0002-Patch-makefile-for-custom-avb.patch"; #Add support for custom AVB key
#  fi;
#
#  if enterAndClear "frameworks/base"; then
#    [[ -n "${MICROG}" || "${WITH_GMS}" = true ]] && applyPatch "${PATCH_DIR}/android_frameworks_base/0001-Apply-restricted-sig-spoof.patch"; #Support restricted sig spoofing
#    applyPatch "${PATCH_DIR}/android_frameworks_base/0002-Use-alternate-ntp-pool.patch"; #Use non-Android ntp pool
#  fi;
#
#  if enterAndClear "hardware/google/pixel"; then
#    applyPatch "${PATCH_DIR}/android_hardware_google_pixel/0001-Remove-wifi-ext.patch"; #Remove wifi-ext
#  fi;
#
#  if enterAndClear "vendor/lineage"; then
#    applyPatch "${PATCH_DIR}/android_vendor_lineage/0001-Allow-custom-build-types.patch"; #Remove restriction for build type
#    applyPatch "${PATCH_DIR}/android_vendor_lineage/0002-Update-webview-providers.patch"; #Allowlist Bromite webview
#    applyPatch "${PATCH_DIR}/android_vendor_lineage/0003-Replace-default-browser.patch"; #Install Bromite browser
#    [[ ! "${WITH_GMS}" = true ]] && applyPatch "${PATCH_DIR}/android_vendor_lineage/0004-Add-extra-apks.patch"; #Add additional apks
#    [[ -n "${MICROG}" && ! "${WITH_GMS}" = true ]] && applyPatch "${PATCH_DIR}/android_vendor_lineage/0005-Add-microg-apks.patch"; #Add microg apks
#    curl https://raw.githubusercontent.com/GrapheneOS/platform_packages_apps_Dialer/13/java/com/android/voicemail/impl/res/xml/vvm_config.xml -o overlay/common/packages/apps/Dialer/java/com/android/voicemail/impl/res/xml/vvm_config.xml && git commit -am "GrapheneOS VVM"
#  fi;
#
#  #DEVICE
#
#  if enterAndClear "device/google/barbet"; then
#    applyPatch "${PATCH_DIR}/android_device_google_barbet/0001-barbet-Disable-mainline-checking.patch"; #Allow extra apks at build time
#  fi;
#
#  if enterAndClear "device/google/bramble"; then
#    applyPatch "${PATCH_DIR}/android_device_google_bramble/0001-bramble-Disable-mainline-checking.patch"; #Allow extra apks at build time
#  fi;
#
#  if enterAndClear "device/google/coral"; then
#    applyPatch "${PATCH_DIR}/android_device_google_coral/0001-floral-Disable-mainline-checking.patch"; #Allow extra apks at build time
#    applyPatch "${PATCH_DIR}/android_device_google_coral/0002-floral-Remove-modules.patch"; #Debloat
#    applyPatch "${PATCH_DIR}/android_device_google_coral/0003-floral-Remove-default-permissions.patch"; #Remove unused permissions
#    [[ -n ${AVB} ]] && applyPatch "${PATCH_DIR}/android_device_google_coral/0004-floral-Add-custom-avb-key.patch"; #Add support for AVB
#  fi;
#
#  if enterAndClear "device/google/crosshatch"; then
#    applyPatch "${PATCH_DIR}/android_device_google_crosshatch/0001-b1c1-Remove-modules.patch"; #Debloat
#    applyPatch "${PATCH_DIR}/android_device_google_crosshatch/0002-b1c1-Remove-default-permissions.patch"; #Remove unused permissions
#    [[ -n ${AVB} ]] && applyPatch "${PATCH_DIR}/android_device_google_crosshatch/0003-b1c1-Add-custom-avb-key.patch"; #Add support for AVB
#  fi;
#
#  if enterAndClear "device/google/redbull"; then
#    applyPatch "${PATCH_DIR}/android_device_google_redbull/0001-redbull-Remove-modules.patch"; #Debloat
#    applyPatch "${PATCH_DIR}/android_device_google_redbull/0002-redbull-Remove-default-permissions.patch"; #Remove unused permissions
#    [[ -n ${AVB} ]] && applyPatch "${PATCH_DIR}/android_device_google_redbull/0003-redbull-Add-custom-avb-key.patch"; #Add support for AVB
#  fi;
#
#  if enterAndClear "device/google/redfin"; then
#    applyPatch "${PATCH_DIR}/android_device_google_redfin/0001-redfin-Disable-mainline-checking.patch"; #Allow extra apks at build time
#  fi;
#
#  #KERNEL
#
#  if enterAndClear "kernel/google/redbull"; then
#    "${GIT_LOCAL}"/DivestOS-Build/Scripts/"${BUILD_WORKING_DIR}"/CVE_Patchers/android_kernel_google_redbull.sh
#  fi;
#
#  if enterAndClear "kernel/google/msm-4.14"; then
#    "${GIT_LOCAL}"/DivestOS-Build/Scripts/"${BUILD_WORKING_DIR}"/CVE_Patchers/android_kernel_google_msm-4.14.sh
#  fi;
#
#  if enterAndClear "kernel/google/msm-4.9"; then
#    "${GIT_LOCAL}"/DivestOS-Build/Scripts/"${BUILD_WORKING_DIR}"/CVE_Patchers/android_kernel_google_msm-4.9.sh
#  fi;

  #VENDOR

  if enterAndClear "vendor/google/barbet"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_barbet/0001-barbet-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_barbet/0002-barbet-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_barbet/0003-barbet-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/blueline"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_blueline/0001-blueline-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_blueline/0002-blueline-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_blueline/0003-blueline-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/bramble"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_bramble/0001-bramble-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_bramble/0002-bramble-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_bramble/0003-bramble-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/coral"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_coral/0001-coral-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_coral/0002-coral-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_coral/0003-coral-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/crosshatch"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_crosshatch/0001-crosshatch-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_crosshatch/0002-crosshatch-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_crosshatch/0003-crosshatch-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/flame"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_flame/0001-flame-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_flame/0002-flame-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_flame/0003-flame-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/lynx"; then
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_lynx/0001-lynx-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_lynx/0002-lynx-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/panther"; then
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_panther/0001-panther-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_panther/0002-panther-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/raven"; then
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_raven/0001-raven-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_raven/0002-raven-Update-apps.patch"; #Deblob apps
  fi;

  if enterAndClear "vendor/google/redfin"; then
    git am "${PATCH_DIR}/proprietary_vendor_google_redfin/0001-redfin-Add-gesture-input.patch";
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_redfin/0002-redfin-Update-priv-apps.patch"; #Deblob priv-apps
    applyPatch "${PATCH_DIR}/proprietary_vendor_google_redfin/0003-redfin-Update-apps.patch"; #Deblob apps
  fi;
elif [[ ${PROJECT_ROOT,,} =~ "graphene" ]]; then
  #ROM
  # if enterAndClear "frameworks/base"; then
  #   applyPatch "${PATCH_DIR}/platform_frameworks_base/0001-Update-dns-references.patch"; #Use quad9 dns
  #   applyPatch "${PATCH_DIR}/platform_frameworks_base/0002-Use-alternate-ntp-pool.patch"; #Use non-Android ntp pool
  # fi;

  # if enterAndClear "packages/inputmethods/LatinIME"; then
  #   applyPatch "${PATCH_DIR}/platform_packages_inputmethods_LatinIME/0001-Enable-gesture-input.patch"; #Reenable swipe keyboard
  # fi;

  # if enterAndClear "packages/modules/Connectivity"; then
  #   applyPatch "${PATCH_DIR}/platform_packages_modules_Connectivity/0001-Update-dns-references.patch"; #Use quad9 dns
  # fi;

  # if enterAndClear "script"; then
  #   applyPatch "${PATCH_DIR}/script/0001-Alias-signify-cmd-if-applicable.patch"; #Add shim for signing on debian
  # fi;

  # do this outside of DOS for now
  cd frameworks/base
  git am ${PATCH_DIR}/platform_frameworks_base/0001-Update-dns-references.patch
  git am ${PATCH_DIR}/platform_frameworks_base/0002-Use-alternate-ntp-pool.patch
  cd ${PROJECT_ROOT}

  cd packages/inputmethods/LatinIME
  git am ${PATCH_DIR}/platform_packages_inputmethods_LatinIME/0001-Enable-gesture-input.patch
  cd ${PROJECT_ROOT}
  
  cd packages/modules/Connectivity
  git am ${PATCH_DIR}/platform_packages_modules_Connectivity/0001-Update-dns-references.patch
  cd ${PROJECT_ROOT}

  cd script
  git am ${PATCH_DIR}/script/0001-Alias-signify-cmd-if-applicable.patch
  cd ${PROJECT_ROOT}

fi

#
#END OF CHANGES
#

