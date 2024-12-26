#!/usr/bin/bash

set -eoux pipefail

cp /tmp/packages/neovim/shell/zz-nvim-default-editor.sh /etc/profile.d/
cp /tmp/packages/neovim/shell/alias-vim-to-nvim.sh /etc/profile.d/
