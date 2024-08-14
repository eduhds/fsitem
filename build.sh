#!/bin/bash

mkdir -p bin
rm bin/*

gcc -c -o bin/termbox2.o fsitem/libs/termbox2.c

gcc fsitem/*.m bin/*.o `gnustep-config --objc-flags` \
    -lobjc -lgnustep-base -std=c11 \
    -o bin/app
