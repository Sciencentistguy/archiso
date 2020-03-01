#!/bin/bash

sudo umount -f work/efiboot
sudo umount -f work/x86_64/airootfs/tmp
sudo rm -rf work
sudo ./_build.sh -v -L ARCH -V custom
