{ config, pkgs, ... }:
let
  unstablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable";
    sha256 = "sha256:1nhn3hhnszq1j1nm7r6l3a698drsqzpzagyb059fvw6y8aawzkn6";
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
    neofetch
    zsh-powerlevel10k
    ripgrep
    go-task
    nodejs_20
    nodejs_20.pkgs.pnpm
    gitui
    go
    jq
    unstablePkgs.chromium
    unstablePkgs.chromedriver
    # peek
    # rustup
    # calibre
    # sqlitebrowser
    # jetbrains.pycharm-community
    jetbrains.pycharm-professional
    # jetbrains.idea-community
    jetbrains.webstorm
    jetbrains.goland
    jetbrains.clion
    # jetbrains.datagrip
    python3Full
    # gnumake
    # docker-compose
    # vivaldi
    # skypeforlinux
    zotero
    # sqlite
    warpd
    # wally-cli
    typst
    # codeium
    # csvkit
    # sqld
    deno
    # jdk21
    # unstablePkgs.awscli2
    # opam
    # gcc
    # google-chrome
    # bruno
    # anki-bin
    floorp
    kaf
    peek
    usbutils
    obsidian
    ncspot
    xmake
    gcc
    cling
    syncthing
    graphviz
    activitywatch
    keepassxc
    mitscheme
    mitmproxy
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

  #programs.firefox = {
  #  enable = true;
  #  profiles = {
  #    thanh = {
  #      id = 0;
  #      isDefault = true;
  #      settings = {
  #        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
  #      };
  #      userChrome = ''
  #        /* Hide horizontal tabs at the top of the window */
  #        #tabbrowser-tabs {
  #          visibility: collapse !important;
  #        }
  #      '';
  #    };
  #  };
  #};

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
