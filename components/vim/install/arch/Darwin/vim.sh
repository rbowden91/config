#!/usr/bin/env bash

# xcode cli tools need to be installed, as does brew

# brew install python3 needs this to exist
sudo mkdir -p /usr/local/Frameworks
sudo chown rbowden /usr/local/Frameworks

# couldn't find clang-tidy, *-dev, openjdk-8-jre
brew install ack python2 python3 nodejs ruby cmake ctags codequery golang mono

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
rm get-pip.py
PIPPATH=$(find /usr/local/Cellar/python/*/Frameworks/Python.framework/Versions/* -name bin)
PIPPATH="$PIPPATH/pip"

sudo ln -s $PIPPATH /usr/local/bin/pip3
