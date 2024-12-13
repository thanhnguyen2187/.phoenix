# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz";
    sha256 = "sha256:00wp0s9b5nm5rsbwpc1wzfrkyxxmqjwsc1kcibjdbfkh69arcpsn";
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
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.extraModulePackages = with config.boot.kernelPackages; [
    rtl88x2bu
    # rtl8821au
    rtl88xxau-aircrack
  ];

  networking.hostName = "draco"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Ho_Chi_Minh";

  # Select internationalisation properties.
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
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      bamboo
    ];
  };

  hardware.nvidia = {
    modesetting.enable = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    nvidiaSettings = true;
    # powerManagement.enable = true;
  };
  hardware.opengl = {
    enable = true;
    # driSupport = true;
    # driSupport32Bit = true;
  };
  # hardware.opentabletdriver = {
  #   enable = true;
  #   daemon.enable = true;
  # };
  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    displayManager = {
      # gdm.enable = true;
      # gdm.wayland = false;
      lightdm.enable = true;
    };
    desktopManager = {
      # gnome.enable = true;
      # mate.enable = true;
      # cinnamon.enable = true;
      deepin.enable = true;
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.thanh = {
    isNormalUser = true;
    description = "Thanh Nguyen";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;
  programs.appimage.binfmt = true;

  virtualisation.docker.enable = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  environment.systemPackages = with pkgs; [
     vim
     git
     ibus-engines.bamboo
     steam-run
     home-manager
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

  networking.firewall.allowedTCPPorts = [ 5173 5174 5175 8080 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  system.stateVersion = "24.11";
}
