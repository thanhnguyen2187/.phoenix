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
      # export OPENSSL_DIR=${pkgs.openssl.dev}

      export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${pkgs.openssl.dev}/lib/pkgconfig
      export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.postgresql.lib}/lib

      # export DOTNET_ROOT=${pkgs.dotnet-sdk}
      export PATH=$PATH:${builtins.toString ./shell}
      # fix Firefox wrong timezone
      export TZ="Asia/Ho_Chi_Minh";
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
