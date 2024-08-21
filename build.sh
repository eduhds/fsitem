#!/bin/bash

clear

mkdir -p bin
rm bin/*

gcc -c -o bin/termbox2.o src/libs/termbox2.c


if [ "$(uname)" = "Darwin" ]; then
  gcc src/*.m bin/*.o -framework Foundation \
      -o bin/app 
else
  gcc src/*.m bin/*.o `gnustep-config --objc-flags` \
      -lobjc -lgnustep-base -std=c11 \
      -o bin/app
fi

