#!/bin/bash


##
#   ENABLE 32-bit ARCHITECTURE
##


echo "START: Enable 32-bit Arch"

sudo dpkg --add-architecture i386

echo "FINISH: Enable 32-bit Arch"


##
#   ADD multiverse REPOSITORY
##


echo "START: enable multiverse repo"

sudo add-apt-repository multiverse

echo "FINISH: enable multiverse repo"


##
#   APT - UPDATE
##


echo "START: apt update"

sudo apt-get update -y

echo "FINISH: apt update"


##
#   APT - UPGRADE
##


echo "START: apt upgrade"

sudo apt-get upgrade -y

echo "FINISH: apt upgrade"
