#!/usr/bin/bash

set -eoux pipefail

cp ${PACKAGES_DIR}/${package}/shell/zz-nvim-default-editor.sh /etc/profile.d/
cp ${PACKAGES_DIR}/${package}/shell/alias-vim-to-nvim.sh /etc/profile.d/
