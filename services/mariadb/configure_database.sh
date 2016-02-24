#!/usr/bin/env bash

# Place database configuration file in a location where mysqld can find it.
echo "Configure database settings"
ln -svf "${PWD}/files/mysqlconf/my.smg.cnf" /usr/local/etc/my.cnf.d/my.smg.cnf

# Have launchd start mariadb at login.
echo "Start mariadb at login."
ln -sfv /usr/local/opt/mariadb/*.plist ~/Library/LaunchAgents

# Then to load mariadb now:
# launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.mariadb.plist
# launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mariadb.plist
