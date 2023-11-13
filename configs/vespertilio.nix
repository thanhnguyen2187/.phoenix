{ config, pkgs, ... }:
let
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
    yarn
    gitui
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
    jetbrains.datagrip

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
    cmake
    vivaldi
    skypeforlinux
    # postgresql
    zotero
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
