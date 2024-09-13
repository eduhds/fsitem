#!/bin/bash

set -e

project=$(basename $(pwd))

rm -rf linux/AppDir 2> /dev/null || true
rm *.AppImage 2> /dev/null || true
rm -rf build .xmake 2> /dev/null || true

mkdir -p linux/AppDir

docker build -t $project/linuxdeploy-deb .

docker run --rm -v $(pwd):/builder $project/linuxdeploy-deb bash -l -c "
    GNUSTEP_FLAGS=\$(gnustep-config --objc-flags) xmake && linuxdeploy \
    --appdir linux/AppDir \
    --executable build/linux/x86_64/release/switch-config \
    --icon-file linux/switch-config.png \
    --desktop-file linux/switch-config.desktop \
    --output appimage"
