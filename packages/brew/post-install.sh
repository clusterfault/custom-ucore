#!/usr/bin/bash

set -eoux pipefail

cp /tmp/packages/brew/systemd/units/* /usr/lib/systemd/system/
systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer

cp /tmp/packages/brew/systemd/tmpfiles/* /usr/lib/tmpfiles.d/
cp /tmp/packages/brew/shell/brew* /etc/profile.d/
