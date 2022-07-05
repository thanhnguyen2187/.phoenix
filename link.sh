#!/bin/sh

NAME=$1

ln -s $(pwd)/configs/${NAME}.nix ~/.config/nixpkgs/home.nix
