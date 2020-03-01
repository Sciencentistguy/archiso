#!/bin/bash

sudo umount -R work 2>/dev/null
sudo rm -rf work
sudo ./_build.sh -v
