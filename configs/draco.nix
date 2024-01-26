{ config, pkgs, ... }:
let
in
{
  home.username = "thanh";
  home.homeDirectory = "/home/thanh";
  home.stateVersion = "23.11";

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
    nodejs
    yarn
    gitui
    go
    jq
    tmuxp
    spotify
    google-chrome
    chromedriver
    peek
    rustup
    calibre
    sqlitebrowser
    jetbrains.pycharm-community
    jetbrains.pycharm-professional
    jetbrains.idea-community
    jetbrains.webstorm
    jetbrains.goland
    jetbrains.datagrip
    python3Full
    gnumake
    docker-compose
    vivaldi
    skypeforlinux
    zotero
    sqlite
    warpd
    wally-cli
    (texliveSmall.withPackages (ps: with ps; [
      fullpage
    ]))
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

  services.flameshot = {
    enable = true;
  };

  home.file.".ideavimrc".text = builtins.readFile ./vim/.ideavimrc;
}
