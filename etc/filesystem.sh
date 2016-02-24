#!/usr/bin/env bash

# Run this script in the host system to do basic filesystem checks.
# Grants Vagrant sudo permission to /etc/exports.
# See https://www.vagrantup.com/docs/synced-folders/nfs.html.

SHARE_FS='../../opt'
SUDO_DROP='/private/etc/sudoers.d'

# Initialize the host and guest shared filesystem.
if [ ! -d "${SHARE_FS}" ]; then
    mkdir -v "${SHARE_FS}"
fi

# Stop Vagrant from asking for sudo.
if [ ! -d "${SUDO_DROP}" ]; then
    mkdir -pv "${SUDO_DROP}"
fi

sudo cp -vi vagrant_exports.txt "${SUDO_DROP}/vagrant_exports"
