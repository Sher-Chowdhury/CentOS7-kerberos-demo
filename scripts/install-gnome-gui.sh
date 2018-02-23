#!/usr/bin/env bash

set -ex

echo '##########################################################################'
echo '##### About to run install-gnome-gui.sh script ##################'
echo '##########################################################################'

# https://codingbee.net/tutorials/vagrant/vagrant-enabling-a-centos-vms-gui-mode
yum groupinstall -y 'gnome desktop'
yum install -y 'xorg*'


# systemctl isolate graphical.target
# systemctl start graphical.target
# systemctl set-default graphical.target   # to make this persistant