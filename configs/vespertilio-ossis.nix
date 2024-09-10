{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
    sha256 = "sha256:1vvrrk14vrhb6drj3fy8snly0sf24x3402ykb9q5j1gy99vvqqq6";
  };
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "vespertilio"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Ho_Chi_Minh";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      bamboo
    ];
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    # videoDrivers = ["nvidia"];
    displayManager = {
      gdm.enable = true;
    };
    desktopManager = {
      gnome.enable = true;
    };
  };

  services.dnsmasq.enable = true;

  hardware.opengl.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    # package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thanh = {
    isNormalUser = true;
    description = "Thanh Nguyen";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  virtualisation.docker.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  # $ nix search wget
  environment.systemPackages = with pkgs; [
     vim
     git
     ibus-engines.bamboo
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      fuse
      glibc
    ];
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  networking.firewall.allowedTCPPorts = [ 5173 5174 5175 8080 ];

  system.stateVersion = "24.05";
}
