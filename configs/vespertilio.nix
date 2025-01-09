{ config, pkgs, ... }:
let
  unstablePkgs = import (builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/nixpkgs-unstable";
    sha256 = "sha256:15s3z0wg5lpyfl0cjjb6p5c0kr2yn79a4bz0zs6smaznc34a4p7x";
  })
  { config = config.nixpkgs.config; system = "x86_64-linux"; };
in
{
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";
  home.stateVersion = "24.11";

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
    ripgrep
    hugo
    go-task
    nodejs_20
    nodejs_20.pkgs.pnpm
    # yarn
    gitui
    go
    jq
    # tmuxp
    # spotify
    # unstablePkgs.chromium
    # unstablePkgs.chromedriver
    # peek
    rustup
    # calibre
    # sqlitebrowser
    # jetbrains.pycharm-community
    # jetbrains.pycharm-professional
    # jetbrains.idea-community
    jetbrains.webstorm
    jetbrains.goland
    jetbrains.rust-rover
    # jetbrains.datagrip
    # python3Full
    # gnumake
    # docker-compose
    # vivaldi
    # skypeforlinux
    sqlite
    warpd
    # wally-cli
    typst
    deluge
    floorp
    vlc
    unstablePkgs.chromium
    obsidian
    zotero_7
    syncthing
    keepassxc
    pdftk
    hugo
    gnumake
    sshuttle
    websocat
    libsForQt5.xp-pen-deco-01-v2-driver
    # zed-editor
    gcc
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

  programs.direnv = {
    enable = true;
    enableZshIntegration = true; # see note on other shells below
    nix-direnv.enable = true;
  };

  services.syncthing = {
    enable = true;
    tray = {
      enable = true;
      command = "syncthingtray";
      package = pkgs.syncthingtray-minimal;
    };
  };

  systemd.user.services.warpd = {
    Unit = {
      Description = "Modal keyboard-driven pointer control";
      PartOf = [ "graphical-session.target" ];
      After = [
        "graphical-session.target"
        "graphical-session-pre.target"
        "window-manager.target"
      ];
    };

    Service = {
      ExecStart = "${pkgs.warpd}/bin/warpd";
      
      # Restart on failure
      Restart = "on-failure";
      RestartSec = 3;
      
      # Kill the process on session logout
      KillMode = "process";

      Type = "simple";
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  home.file.".ideavimrc".text = builtins.readFile ./vim/.ideavimrc;
}
