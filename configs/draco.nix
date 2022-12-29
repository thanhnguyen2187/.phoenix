{ config, pkgs, ... }:
let
  # TODO: find a way to make the config more declarative
  # nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # nix-channel --add https://github.com/guibou/nixGL/archive/main.tar.gz nixgl && nix-channel --update
  pkgsUnstable = import <nixpkgs-unstable> {};
  # nixGL = import <nixgl> {};
in
{
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfree = true;
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
    swiProlog
    vscode
    graphviz
    pkgsUnstable.deno
    go_1_18
    elixir
    sumneko-lua-language-server
    elixir_ls
    inotify-tools
    jq
    kubectl
    janet
    pkgsUnstable.jpm
    babashka
    clojure
    jdk
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
}
