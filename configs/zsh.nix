{ config, pkgs, lib, ... }:
{
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
      "cl" = "clear";
      "cll" = "clear && ll";
      "cla" = "clear && la";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "kubectl"
      ];
    };
  };

}
