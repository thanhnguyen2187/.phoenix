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
      # OPENSSL_DIR=${pkgs.openssl.dev}
      export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
      export LD_LIBRARY_PATH=${pkgs.openssl.out}/lib
      export DOTNET_ROOT=${pkgs.dotnet-sdk}
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
