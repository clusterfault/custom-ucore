#!/usr/bin/bash

set -eoux pipefail

cp ${PACKAGES_DIR}/${package}/systemd/units/* /usr/lib/systemd/system/
systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer

cp ${PACKAGES_DIR}/${package}/systemd/tmpfiles/* /usr/lib/tmpfiles.d/
cp ${PACKAGES_DIR}/${package}/shell/brew* /etc/profile.d/
