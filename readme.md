# Phoenix

Personal declarative configuration files that shall rise from the ashes.

## Getting Started

Make sure that NixOS is installed on the machine.

To apply NixOS operating system configuration:

```shell
sudo nixos-rebuild switch --flake .#thanh --impure
```

To apply Home Manager configuration:

```shell
home-manager switch --flake .#thanh
```

## Notes

`notes/` tells us why does the code within this repository exist as it is.

## TODO

- [ ] Investigate why `--impure` is needed

