# dot_ssh_switch

CLI tool for manage multiple folders with diferent ssh keys in .ssh folder.

## For MacOS open and build with XCode

## For Linux use GNUStep

```bash
sudo apt install gnustep gnustep-devel

. /usr/share/GNUstep/Makefiles/GNUstep.sh

cd ./dot_ssh_switch

gcc main.m profile_manager.m `gnustep-config --objc-flags` -lobjc -lgnustep-base -std=c11 -o dot_ssh_switch
```
