{ config, pkgs, ... }:
let
  pkgsUnstable = import <nixpkgs-unstable> {};
in
{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
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
    texlive.combined.scheme-small
    nodejs
    yarn
    google-cloud-sdk
    cloud-sql-proxy
    gitui
    swiProlog
    vscode
    pkgsUnstable.deno
  ];
  imports = [
    ./vim.nix
  ];

  programs.fzf = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    initExtra = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      FILE=~/.p10k.zsh && \
          test -f $FILE && \
          source $FILE
    '';
    shellAliases = {
      ".." = "cd ..";
      "cl" = "clear";
      "ll" = "ls -l";
      "cll" = "clear && ls -l";
    };
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

  programs.go = {
    enable = true;
  };
}
