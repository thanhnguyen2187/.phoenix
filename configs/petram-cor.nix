# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./petram-medulla.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "petram";
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.networkmanager.settings.device = {
    match-device = "driver:iwlwifi";
    # wifi = {
    #   scan-rand-mac-address = "no";
    # };
  };

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
  ];

  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_17;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "yes";
      PasswordAuthentication = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHkxJii3iM+x0Om3ngt41s7VFKubfNaNwyzYuD5afOY thanh@draco''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIpwjQHb5v/b9fSdyaP0LrAMD8FScR/NbHPQuFcKX5w thanh@vespertilio''
  ];

  services.logind = {
    lidSwitch = "ignore";           # Do nothing when lid is closed
    lidSwitchExternalPower = "ignore";  # Same behavior when plugged in
    lidSwitchDocked = "ignore";         # Same behavior when docked
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };

  services.glance = {
    enable = true;
    settings = {
      server = {
        host = "0.0.0.0";  # Change to "0.0.0.0" if you want to access from other machines
      };
      pages = [
        {
          name = "Dashboard";
          columns = [
            {
              size = "small";
              widgets = [
                {
                  type = "markets";
                  symbol-link-template = "https://www.tradingview.com/symbols/{SYMBOL}/news";
                  markets = [
                    {
                      symbol = "BTC-USD";
                      name = "Bitcoin";
                    }
                    {
                      symbol = "ETH-USD";
                      name = "Ethereum";
                    }
                  ];
                }
              ];
            }
            {
              size = "full";
              widgets = [
                {
                  type = "group";
                  widgets = [
                    {
                      type = "hacker-news";
                    }
                    {
                      type = "reddit";
                      subreddit = "programming";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "webdev";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "rust";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "quant";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "algotrading";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "clojure";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "lisp";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "python";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "golang";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "javascript";
                      show-thumbnails = true;
                    }
                    {
                      type = "reddit";
                      subreddit = "sveltejs";
                      show-thumbnails = true;
                    }
                  ];
                }
              ];
            }
          ];
        }
      ];
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    22
    5432 # Postgres
    8384 # Syncthing
    8080 # Glance
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  services.fstrim.enable = lib.mkDefault true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}

