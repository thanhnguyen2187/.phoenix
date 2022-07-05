# Phoenix

Personal declarative configuration files that shall rise from the ashes. An
Ubuntu/Debian-based distro with `apt` is expected. Other shell scripts that I
want to store also go here.

## Bootstrap

Make sure that this repository is ready within the machine and move to the
cloned folder:

```sh
cd ~
git clone https://github.com/thanhnguyen2187/.phoenix
cd .phoenix/
```

Run the bootstrap file to install `nix`, and `home-manager`:

```sh
./bootstrap.sh
```

Create a link to a config file:

```
./link.sh draco

# equivalent to:
# ln -s ~/.phoenix/configs/draco.nix ~/.config/nixpkgs/home.nix
```

Run `home-manager`:

```
home-manager switch
```

## Config Files

- `draco`: for home/personal usage
- `avem`: for work usage
- `?`

## Notes

`notes/` tells us why does the code within this repository exist as it is.

