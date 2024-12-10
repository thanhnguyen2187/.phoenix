# Phoenix

Personal declarative configuration files that shall rise from the ashes.

## Getting Started

Make sure that NixOS is installed on the machine.

To apply NixOS operating system configuration:

```shell
sudo nixos-rebuild switch --flake .#<name> --impure
```

First command when `home-manager` is not available in `$PATH`:

```shell
nix \
    --extra-experimental-features "nix-command flakes" \
    run home-manager/release-24.11 -- \
    --extra-experimental-features "nix-command flakes" \
    switch --flake .#draco
```

To apply Home Manager configuration:

```shell
home-manager switch --flake .#<name>
```

## Configuration Sets

- `draco`: for home PC

```shell
sudo nixos-rebuild switch --flake .#draco --impure
home-manager switch --flake .#draco
```

- `vespertilio`: for P53

```shell
sudo nixos-rebuild switch --flake .#vespertilio --impure
home-manager switch --flake .#vespertilio
```

- `gigas`: for VPS

```shell
nixos-rebuild switch \
    --flake .#gigas \
    --impure \
    --fast \
    --target-host root@<ip> \
;
```

## Notes

`notes/` tells us why does the code within this repository exist as it is.

## TODO

- [ ] Investigate why `--impure` is needed

