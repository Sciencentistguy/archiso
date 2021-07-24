#!/bin/sh
# Dotfiles is a submodule
git submodule update --init

sudo mkarchiso -v -w /tmp/archiso_work -o out/ .
