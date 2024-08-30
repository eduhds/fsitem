#!/bin/bash

rm -rf linux/AppDir 2> /dev/null
rm *.AppImage 2> /dev/null

mkdir -p linux/AppDir
mkdir -p linux/AppDir/usr
mkdir -p linux/AppDir/usr/bin

linuxdeploy --appimage-extract-and-run --appdir linux/AppDir \
    --executable build/linux/x86_64/release/switch-config \
    --icon-file linux/switch-config.png \
    --desktop-file linux/switch-config.desktop \
    --output appimage
