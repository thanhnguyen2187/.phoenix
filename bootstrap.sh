#!/bin/bash

# install `nix`
sh <(curl -L https://nixos.org/nix/install) --daemon

echo "Pause the script and restart the current shell session"
read -p line

# install `home-manager`
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install

