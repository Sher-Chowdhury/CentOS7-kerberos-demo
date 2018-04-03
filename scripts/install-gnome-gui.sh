#!/usr/bin/env bash
set -ex

echo '##########################################################################'
echo '##### About to run install-gnome-gui.sh script ##################'
echo '##########################################################################'

# https://codingbee.net/tutorials/vagrant/vagrant-enabling-a-centos-vms-gui-mode
yum groupinstall -y 'gnome desktop'
yum install -y 'xorg*'

# https://unix.stackexchange.com/questions/181009/gnome-license-not-accepted-issue-when-system-has-been-rebooted
yum remove -y initial-setup initial-setup-gui

systemctl isolate graphical.target
systemctl set-default graphical.target   # to make this persistant

exit 0