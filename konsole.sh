#!/bin/bash

cd "$(dirname "$(realpath "$0")")"

[ "$1" = "--use-existing" ] && (qdbus | grep -q "org.kde.konsole$") && exit 0

if [ -x ./konsole/build/src/konsole ]; then
    ./konsole/build/src/konsole --workdir ~ "$@"
elif [ -x "/mnt/develop/my/cpp/konsole/build/src/konsole" ]; then
    /mnt/develop/my/cpp/konsole/build/src/konsole --workdir ~ "$@"
else
    echo "No konsole found."
    exit 1
fi
