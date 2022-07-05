#!/bin/sh

# install `nix`
sh <(curl -L https://nixos.org/nix/install) --daemon

# install `home-manager`
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
nix-shell '<home-manager>' -A install

