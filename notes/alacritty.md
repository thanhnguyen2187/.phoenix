# Alacritty

Some notes about the usage of Alacritty.

Somewhere within this repository, there is this definition:

```nix
programs.alacritty = {
  enable = true;
  settings = {
    font = {
      size = 12;
      normal = {
        family = "JetBrains Mono Nerd Font";
        style = "Regular";
      };
    };
  };
};
```

But I also use this script to install Alacritty and then set it as the default
terminal:

```sh
sudo apt install alacritty
sudo update-alternatives --config x-terminal-emulator
```

The reason is Alacritty installation within `home-manager` is going to have this
error:

```
Error: Error creating GL context; Received multiple errors. Errors: `[OsError("Could not create EGL display object"), OsError("`glXQueryExtensionsString` found no glX extensions")]`
```

I guess it is something `glut`, `mesa` (OpenGL) related, but installing it did
not help. In the end, I do `apt install`, `update-alternatives`, along with
the configuration generation within `home-manager`. `Windows + T` works, even if
opening Alacritty directly does not.

