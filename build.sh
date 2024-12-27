#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
PACKAGES_DIR="${SCRIPT_DIR}/packages"


# 1. Install all the required dnf repo packages using rpm-ostree 
#
#

## batch up all the rpm-ostree installs
### get package names from all rpm-ostree-pkgs files
rpm_ostree_packages=$(cat $(find $PACKAGES_DIR -name rpm-ostree-pkgs))

### remove duplicates and unnecessary spaces
rpm_ostree_packages=$(echo "$rpm_ostree_packages" | sort | uniq | xargs)

### run rpm-ostree install on the package list
if [ -n "$rpm_ostree_packages" ]; then
    rpm-ostree install $rpm_ostree_packages
fi

# 2. For each package copy files to image and run scripts 
#
#

## get list of all packages
packages=$(find $PACKAGES_DIR -maxdepth 1 ! -path $PACKAGES_DIR  -type d -exec basename {} \;)

for package in $packages; do

## 2a. Copy files to approriate location inside the image, for each package 
    
    rsync -rvK "${PACKAGES_DIR}/${package}/files/" /

## 2b. Run install scripts, for each package 
#
    PKG_SCRIPTS_PATH="${PACKAGES_DIR}/${package}/install-scripts"

    # skip if install-scripts dir does not exist
    [ -d "${PKG_SCRIPTS_PATH}" ] || continue 
    # run executable files in package directory in alphabetical order
    script_files=$(ls -1 "${PKG_SCRIPTS_PATH}")

    for file in $script_files; do
        #skip directories
        [ -d "${PKG_SCRIPTS_PATH}/${file}" ] && continue

        if [ -x "${PKG_SCRIPTS_PATH}/${file}" ]; then
            echo "Executing ${PKG_SCRIPTS_PATH}/${file}"
            "${PKG_SCRIPTS_PATH}/${file}"
        else
            echo "Skipping ${PKG_SCRIPTS_PATH}/${file}"
        fi
    done
done
