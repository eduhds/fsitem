# fsitem

CLI tool for manage multiple folders with diferent ssh keys in .ssh folder.

## For MacOS open and build with XCode

## For Linux use GNUStep

```bash
sudo apt install gnustep gnustep-devel

. /usr/share/GNUstep/Makefiles/GNUstep.sh

cd ./fsitem

gcc main.m profile_manager.m `gnustep-config --objc-flags` -lobjc -lgnustep-base -std=c11 -o fsitem
```

## Usage

Move fsitem to home.

```bash
cd ~

# Create a profile or change to it if already exists
./fsitem <profile_name>

# List all profiles
./fsitem list
```

After create a new profile, use `ssh-keygen` to generate new keys.
