#!/bin/bash

VERSION=$1

cd /tmp
curl -LJ "https://download.jetbrains.com/toolbox/jetbrains-toolbox-${VERSION}.tar.gz" \
    -o jetbrains-toolbox.tar.gz
tar -xvzf jetbrains-toolbox.tar.gz
cd jetbrains-toolbox-${VERSION}/
./jetbrains-toolbox


