#!/bin/bash

clear

mkdir -p bin
rm bin/*

gcc -c -o bin/termbox2.o src/libs/termbox2.c

gcc src/*.m bin/*.o `gnustep-config --objc-flags` \
    -lobjc -lgnustep-base -std=c11 \
    -o bin/app
