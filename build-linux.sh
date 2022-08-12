#!/bin/bash

cd dot_ssh_switch && \
    gcc main.m profile_manager.m \
    `gnustep-config --objc-flags` \
    -lobjc -lgnustep-base -std=c11 \
    -o dot_ssh_switch