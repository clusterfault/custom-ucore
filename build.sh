#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
export PACKAGES_DIR="${SCRIPT_DIR}/packages"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# rpm-ostree install screen

# this would install a package from rpmfusion
# rpm-ostree install vlc

# batch up all the rpm-ostree installs

# get package names from all rpm-ostree-install files
rpm_ostree_packages=$(cat $(find $PACKAGES_DIR -name rpm-ostree-install))

# remove duplicates and unnecessary spaces
rpm_ostree_packages=$(echo "$rpm_ostree_packages" | sort | uniq | xargs)

if [ -n "$rpm_ostree_packages" ]; then
    rpm-ostree install $rpm_ostree_packages
fi

# with all rpm-ostree packages installed 
# go through each package and execute custom install and post install scripts
# one at a time
packages=$(find $PACKAGES_DIR -maxdepth 1 ! -path $PACKAGES_DIR  -type d -exec basename {} \;)

# install packages
for package in $packages; do
    export package

    PKG_PATH="${PACKAGES_DIR}/${package}"
    # run executable files in package directory in alphabetical order
    script_files=$(ls -1 "${PKG_PATH}")

    for file in $script_files; do
        #skip directories
        [ -d "${PKG_PATH}/${file}" ] && continue

        if [ -x "${PKG_PATH}/${file}" ]; then
            echo "Executing ${PKG_PATH}/${file}"
            "${PKG_PATH}/${file}"
        else
            echo "Skipping ${PKG_PATH}/${file}"
        fi
    done
done
