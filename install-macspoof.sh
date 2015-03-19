#!/bin/bash
set -e
#set -x

export DEBIAN_FRONTEND=noninteractive

apt-get --no-install-recommends -y install build-essential clang libconfig9 libconfig-dev

wget -O macspoof-master.tar.gz https://github.com/eatnumber1/macspoof/archive/master.tar.gz
tar -xzf macspoof-master.tar.gz
cd macspoof-master
make -j$(nproc) install
cd ..
rm -r macspoof-master macspoof-master.tar.gz

apt-get -y purge build-essential clang libconfig-dev
apt-get -y autoremove

rm "$0"
