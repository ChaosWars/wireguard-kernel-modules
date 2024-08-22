#!/bin/bash

if [[ ! -d spksrc ]]; then
    echo "spksrc not found"
    exit 1
fi

cd spksrc
TARGET="distrib"

if [[ ! -L "$TARGET" ]]; then
    echo "Linking $TARGET to source"
    ln -s "../source" "$TARGET"
else
    echo "$TARGET already linked"
fi
