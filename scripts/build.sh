#!/bin/bash

clear

mkdir -p bin
rm bin/* 2> /dev/null

gcc -c -o bin/termbox2.o src/libs/termbox2.c


if [ "$(uname)" = "Darwin" ]; then
  gcc src/*.m bin/*.o -framework Foundation \
      -o bin/switch-config 
else
  gcc src/*.m bin/*.o `gnustep-config --objc-flags` \
      -lobjc -lgnustep-base -std=c11 \
      -o bin/switch-config
fi

