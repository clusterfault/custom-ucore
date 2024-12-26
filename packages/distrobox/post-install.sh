#!/usr/bin/bash

set -eoux pipefail

cp ${PACKAGES_DIR}/${package}/systemd/* /usr/lib/systemd/user/
