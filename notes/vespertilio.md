# On Vespertilio

I installed NixOS 23.05 on this new machine (Lenovo Thinkpad P53 to be precise),
and rode on a bumpy road to make everything works, and wanted to note the
difficulties down. `vespertilio.nix` (and `vespertilio-ossis.nix`) is an almost
identical copy of `draco.nix` (and `draco-ossis.nix`) because of subtle changes
below that could not be parameterized easily.

## Changed Hash of Home Manager

In `vespertilio-ossis.nix`:

```nix
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
    sha256 = "1lhkqlizabh107mgj9b3fsfzz6cwpcmplkwspqqavwqr9dlmlwc4";
  };
```

In `draco-ossis.nix`:

```nix
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz";
    sha256 = "0dfshsgj93ikfkcihf4c5z876h4dwjds998kvgv7sqbfv0z6a4bc";
  };
```

I expected `sha256` to be the same, but they still differs. Maybe it is related
to how I "upgrade" NixOS and Home Manager's version in the original machine.

## Changed `efiSysMountPoint`

From `/boot/efi` to `/boot`.

## `home-manager` binary does not exist despite the declaration

After running `nixos-rebuild switch`, I expected to have `home-manager` ready,
but it doesn't. I had to use `nix-shell` like this:

```shell
nix-shell -p home-manager
```

This version of `home-manager` doesn't have `--flake` enabled, so I had to run
this:

```shell
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

Before being able to run `home-manager --flake` "like normal".

