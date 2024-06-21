{ config, pkgs, ... }:
let
  unstablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable";
    sha256 = "sha256:0cww7hyrdh5mylk2rb0v9i7iic0gy5qnn9sa7bz3rmnwwgjwys56";
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
    # mitschemeX11
    # ripgrep
    # hugo
    # go-task
    nodejs_20
    nodejs_20.pkgs.pnpm
    # yarn
    gitui
    go
    # jq
    # tmuxp
    # spotify
    # unstablePkgs.chromium
    # unstablePkgs.chromedriver
    # peek
    # rustup
    # calibre
    # sqlitebrowser
    # jetbrains.pycharm-community
    # jetbrains.pycharm-professional
    # jetbrains.idea-community
    unstablePkgs.jetbrains.webstorm
    unstablePkgs.jetbrains.goland
    # jetbrains.datagrip
    # python3Full
    # gnumake
    # docker-compose
    # vivaldi
    # skypeforlinux
    # zotero
    # sqlite
    warpd
    # wally-cli
    # typst
    # codeium
    # csvkit
    # sqld
    # deno
    # jdk21
    # unstablePkgs.awscli2
    # opam
    # gcc
    # google-chrome
    # bruno
    # anki-bin
    floorp
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

  home.file.".ideavimrc".text = builtins.readFile ./vim/.ideavimrc;
}
