#!/bin/bash

if [[ -d spksrc ]]; then
    cd spksrc
    git pull
    cd ..
else
    git clone https://github.com/SynoCommunity/spksrc
fi
