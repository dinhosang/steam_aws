#!/bin/bash


# NOTE: with help from - https://www.digitalocean.com/community/tutorials/how-to-enable-remote-desktop-protocol-using-xrdp-on-ubuntu-22-04


##
#  XRDP - PREPARE
##


echo "START: xfce4 install"

sudo apt-get install xfce4 xfce4-goodies -y

echo "FINISH: xfce4 install"


##
#  XRDP - INSTALL
##


echo "START: xrdp install"

sudo apt-get install xrdp -y

echo "FINISH: xrdp install"


##
#  XRDP - SETUP xfce4 SESSION
##


echo "START: setup xfce4 .session"

echo "xfce4-session" | tee .xsession

echo "FINISH: setup xfce4 .session"


##
#  XRDP - RESTART SERVICE
##


echo "START: restart rdp service"

sudo systemctl restart xrdp

echo "FINISH: restart rdp service"
