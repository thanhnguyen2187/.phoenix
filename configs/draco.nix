{ config, pkgs, ... }:
let
  # TODO: find a way to make the config more declarative
  # nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update
  # pkgsUnstable = import <nixpkgs-unstable> {};
  # nixGL = import <nixgl> {};
in
{
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  # nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    xclip
    (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    neofetch
    zsh-powerlevel10k
    mitschemeX11
    ripgrep
    hugo
    go-task
    texlive.combined.scheme-full
    nodejs
    # nodejs_16
    yarn
    gitui
    # swiProlog
    # vscode
    # graphviz
    # pkgsUnstable.deno
    go
    # elixir
    # sumneko-lua-language-server
    # elixir_ls
    # inotify-tools
    jq
    # kubectl
    # janet
    # pkgsUnstable.jpm
    # babashka
    # clojure
    jdk
    tmuxp
    spotify
    google-chrome
    chromedriver
    peek
    gerbil

    # tree-sitter

    # cargo
    # rustc
    rustup
    # TODO: find a way to make this feel... less hacky
    # rust-analyzer
    # rustfmt
    # clippy
    # llvmPackages.bintools # to make `lld` works
    # (clang.override {ignoreCollisions = true;})

    llvm
    lld
    gcc
    # llvmPackages.libcxxClang
    # clang
    pkgconfig
    # dotnetPackages.Boogie_2_4_1
    # boogie
    dotnet-sdk

    calibre
    sqlitebrowser

    jetbrains.pycharm-community
    jetbrains.pycharm-professional
    jetbrains.idea-community
    jetbrains.webstorm
    jetbrains.goland

    python3Full
    python310Packages.python-lsp-server
    # pipenv

    gnumake
    docker-compose

    openssl
    glib
    nss
    nspr
    xorg.libxcb

    patchelf
    # solc
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
    terminal = "screen-256color";
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      nord
    ];
    resizeAmount = 2;
    extraConfig = ''
      bind -r C-h previous-window
      bind -r C-l next-window
    '';
  };

  programs.firefox = {
    enable = true;
    profiles = {
      thanh = {
        id = 0;
        isDefault = true;
        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
        userChrome = ''
          /* Hide horizontal tabs at the top of the window */
          #tabbrowser-tabs {
            visibility: collapse !important;
          }
        '';
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
}
