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
      # export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"

      # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.openssl.out}/lib
      # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.glib.out}/lib
      # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.nss.out}/lib
      # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.nspr.out}/lib
      # export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.xorg.libxcb.out}/lib

      # ln -sfn ${pkgs.glib.out}

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
