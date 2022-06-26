# Phoenix

Personal declarative configuration files that shall rise from the ashes. An
Ubuntu/Debian-based distro with `apt` is expected. Some other shell scripts that
I want to store also go here.

## Bootstrap

Make sure that this repository is ready within the machine and move to the
cloned folder:

```sh
cd ~
git clone https://github.com/thanhnguyen2187/.phoenix
cd ~/.phoenix
```

Run the bootstrap file to install `nix`, and `home-manager`:

```sh
./bootstrap.sh
```

Switch to the correct branch to get the right configuration:

```sh
git checkout home
# git checkout work
```

## Branches

- `master`: for documentation writing
- `home`: for home usage
- `work`: for work usage
- `?`

TODO: use cool branch names like `dominus`, `draco`, and `avem`

## Notes

`notes/` tells us why does the code within this repository exist as it is.

