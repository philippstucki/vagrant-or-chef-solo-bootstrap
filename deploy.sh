#!/bin/bash

# Usage: ./deploy.sh [host]


# update community cookbooks to the latest
pushd . > /dev/null
if [ ! -e "cookbooks" ]
then
    git clone git://github.com/opscode/cookbooks.git cookbooks
fi

cd cookbooks && git fetch origin && git reset --hard origin/HEAD
popd > /dev/null

host="${1:-aaron@192.168.2.105}"

# The host key might change when we instantiate a new VM, so
# we remove (-R) the old host key from known_hosts
ssh-keygen -R "${host#*@}" 2> /dev/null

tar cj . | ssh -o 'StrictHostKeyChecking no' "$host" '
sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh'
