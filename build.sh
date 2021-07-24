#!/bin/sh
# Dotfiles is a submodule
git submodule update --init

cargo --root ./airootfs/ install starship

sudo mkarchiso -v -w /tmp/archiso_work -o out/ .
