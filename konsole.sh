#!/bin/bash

cd "$(dirname "$(realpath "$0")")"

if [ -x ./konsole/build/src/konsole ]; then
    ./konsole/build/src/konsole "$@"
elif [ -x "/mnt/develop/my/cpp/konsole/build/src/konsole" ]; then
    /mnt/develop/my/cpp/konsole/build/src/konsole "$@"
else
    echo "No konsole found."
    exit 1
fi
