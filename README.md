# FsItem

CLI tool for manage file system items (files and directories).

## For MacOS open and build with XCode

## For Linux use GNUStep

```bash
sudo apt install gnustep gnustep-devel

. /usr/share/GNUstep/Makefiles/GNUstep.sh

mkdir -p AppDir/usr/bin && gcc fsitem/*.m `gnustep-config --objc-flags` \
    -lobjc -lgnustep-base -std=c11 -O3 \
    -o AppDir/usr/bin/fsitem

appimage-builder --recipe AppImageBuilder.yml

sudo mv FsItem-0.0.1-x86_64.AppImage /usr/bin/fsitem

sudo chmod +x /usr/bin/fsitem
```

## Usage

Move fsitem to home.

```bash

# See Options
./fsitem

```
