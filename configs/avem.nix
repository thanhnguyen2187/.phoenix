{ config, pkgs, ... }:
{
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";

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
    ripgrep
    hugo
    go-task
    nodejs
    yarn
    google-cloud-sdk
    cloud-sql-proxy
    gitui
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
