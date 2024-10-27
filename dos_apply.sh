#!/bin/bash
#DivestOS: A privacy focused mobile distribution
#Copyright (c) 2015-2024 Divested Computing Group
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
  echo ANDROID_BUILD_TOP=${ANDROID_BUILD_TOP}
  export PROJECT_ROOT=${ANDROID_BUILD_TOP}
else
  echo "ANDROID_BUILD_TOP not set, using PWD for project root"
  export PROJECT_ROOT=${PWD}
fi

echo PROJECT_ROOT=${PROJECT_ROOT}
echo DEVICE=${device}
echo ANDROID_PLATFORM=${android_platform}
echo ANDROID_VERSION_NUMBER=${android_version_number}

export PATCH_DIR="${GIT_LOCAL}/lineage_pixel_hardening/${android_platform}-${android_version_number}"
echo PATCH_DIR=${PATCH_DIR}

export DOS_WORKSPACE_ROOT=${GIT_LOCAL}"/DivestOS-Build"; #XXX: THIS MUST BE CORRECT TO PATCH
grep -q lineageos <<< "${android_platform}" && source "${DOS_WORKSPACE_ROOT}/Scripts/init.sh" # Skip DOS scripts for GOS

#
#START OF CHANGES
#

if grep -q lineageos .repo/manifests/default.xml; then
#  Non-vendor patches moved to DOS fork, ones in this project are unmaintained
#  #ROM
#
#  #DEVICE
#
#  #KERNEL

  #VENDOR

  for vendor_device_dir in vendor/google/*
  do
    if enterAndClear "${vendor_device_dir}"; then
      for patch_path in "${PATCH_DIR}"/proprietary_vendor_google_$(basename $vendor_device_dir)/*.patch
      do
        applyPatch "${patch_path}"
      done
    fi
  done

elif grep -q grapheneos .repo/manifests/default.xml; then
  echo "Patching GrapheneOS"
  #ROM
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

  cd packages/apps/SetupWizard2
  git am ${PATCH_DIR}/platform_packages_apps_SetupWizard2/0001-Update-security-action.patch
  cd ${PROJECT_ROOT}

  [[ ! -f libjni_latinimegoogle.so ]] && curl -LO https://gitlab.com/MindTheGapps/vendor_gapps/-/raw/tau/arm64/proprietary/product/lib64/libjni_latinimegoogle.so
  cd vendor/google_devices/${device}
  cp -fp "${PROJECT_ROOT}"/libjni_latinimegoogle.so proprietary/product/lib64
  chmod 444 proprietary/product/lib64/libjni_latinimegoogle.so
    if [[ ! -d .git ]]
    then
      for patch_path in "${PATCH_DIR}"/proprietary_vendor_google_"${device}"/*.patch
      do
        patch -p1 < "${patch_path}"
        echo "Applied patch: ${patch_path}"
      done
    fi
  cd - >/dev/null
fi

#
#END OF CHANGES
#

