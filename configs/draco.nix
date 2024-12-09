{ config, pkgs, ... }:
let
  unstablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable";
    sha256 = "sha256:0b39jqms70gi7hy611nlgy9vdcfkfwk505c9dxjmjyl6pbbdn5pn";
  })
  { config = config.nixpkgs.config; system = "x86_64-linux"; };
  home-manager-unstable.url = "github:nix-community/home-manager";
in
{
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    xclip
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    sqlite
    neofetch
    zsh-powerlevel10k
    ripgrep
    go-task
    nodejs_22
    gitui
    go
    jq
    floorp
    openssl
    # skypeforlinux
    unstablePkgs.chromium
    unstablePkgs.chromedriver
    # peek
    # rustup
    # calibre
    # jetbrains.pycharm-community
    jetbrains.pycharm-professional
    # jetbrains.idea-community
    jetbrains.webstorm
    jetbrains.goland
    # jetbrains.clion
    # jetbrains.datagrip
    python3Full
    zotero_7
    # sqlite
    warpd
    # wally-cli
    typst
    deno
    # firefox
    peek
    obsidian
    gcc
    syncthing
    graphviz
    keepassxc
    mitscheme
    hugo
    pdftk
    sshuttle
    # opentabletdriver
    libsForQt5.xp-pen-deco-01-v2-driver
    websocat
  ];
  imports = [
    ./vim.nix
    ./zsh.nix
  ];

  programs.fzf = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    # use `gpakosz/.tmux`
    extraConfig = ''
      ${builtins.readFile ./tmux/.tmux.conf}
      ${builtins.readFile ./tmux/.tmux.conf.local}
    '';
  };

  programs.firefox = {
    enable = true;
    profiles = {
      thanh = {
        id = 0;
        isDefault = true;
        # settings = {
        #   "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        # };
        # userChrome = ''
        #   /* Hide horizontal tabs at the top of the window */
        #   #tabbrowser-tabs {
        #     visibility: collapse !important;
        #   }
        # '';
      };
    };
  };

  programs.git = {
    enable = true;
  };

  programs.gh = {
    enable = true;
  };

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

  programs.opam = {
    enable = true;
  };

  services.flameshot = {
    enable = true;
  };

  services.activitywatch = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray";
      package = pkgs.syncthingtray-minimal;
    };
  };

  home.file.".ideavimrc".text = builtins.readFile ./vim/.ideavimrc;
}
