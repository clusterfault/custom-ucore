#!/bin/bash

set -ouex pipefail

RELEASE="$(rpm -E %fedora)"


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
rpm_ostree_packages=$(cat $(find /tmp/packages -name rpm-ostree-install))

# remove duplicates
rpm_ostree_packages=$(echo "$rpm_ostree_packages" | sort | uniq)

rpm-ostree install $rpm_ostree_packages

# with all rpm-ostree packages installed 
# go through each package and execute custom install and post install scripts
# one at a time
packages=$(find /tmp/packages -maxdepth 1 ! -path /tmp/packages  -type d -exec basename {} \;)

# install packages
for package in $packages; do
    # Script to install the package
    if [ -f /tmp/packages/${package}/install.sh ]; then
        /tmp/packages/${package}/install.sh
    fi

    # Script to run post-install tasks
    if [ -f /tmp/packages/${package}/post-install.sh ]; then
        /tmp/packages/${package}/post-install.sh
    fi
done
