{ inputs, lib, config, pkgs, ... }:
let 
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
    sha256 = "sha256:1vvrrk14vrhb6drj3fy8snly0sf24x3402ykb9q5j1gy99vvqqq6";
  };
  cryptaa-server-repo = builtins.getFlake "git+https://github.com/thanhnguyen2187/cryptaa.git?rev=ccc6e8254542f65f96194eb7983eaf5a7d9ef272";
  cryptaa-server = cryptaa-server-repo.packages.x86_64-linux.cryptaa-server;
in
{
  imports = [
    ./gigas-medulla.nix
    (import "${home-manager}/nixos")
  ];

  users.users.thanh = {
    isNormalUser = true;
    home = "/home/thanh";
    extraGroups = ["wheel" "networkmanager" "docker"];
    initialHashedPassword = "\$6\$z/ChQ.YXpIVOFXwM\$yKnJCsFYtBbne7fIbqi.s7A7W.SvejLwBFo.GjLvTJAtXy7XtTHiNubdoU16eDqQNUhQbJvc.Onhry4b7f9LJ.";
  };

  boot.cleanTmpDir = true;
  zramSwap.enable = false;
  networking.hostName = "gigas";
  networking.domain = "";
  networking.firewall.allowedTCPPorts = [ 80 443 31746 ];
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHkxJii3iM+x0Om3ngt41s7VFKubfNaNwyzYuD5afOY thanh@draco''
    ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOIpwjQHb5v/b9fSdyaP0LrAMD8FScR/NbHPQuFcKX5w thanh@vespertilio''
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    qbittorrent-nox
    filebrowser
    yarr
    nodejs
    python3
  ];

  systemd.services.cryptaa-server = {
    description = "Cryptaa Server Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      WorkingDirectory = "/root/Sources/cryptaa";
      Environment = "PATH=/run/current-system/sw/bin";
      ExecStart = lib.strings.concatStringsSep " " [
        "${pkgs.nodejs}/bin/npx"
        "triplit dev"
        "--schemaPath src/data/schema-triplit.ts"
        "--dbPort 5432"
        "--storage memory"
      ];
      Restart = "on-failure";
    };
  };

  systemd.services.cryptaa-server-demo = {
    description = "Cryptaa Server Demo Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      WorkingDirectory = "/root/Sources/cryptaa";
      Environment =[
        "PATH=/run/current-system/sw/bin"
        "TRIPLIT_JWT_SECRET=super-secret"
        "TRIPLIT_PROJECT_ID=cryptaa-server"
      ];
      ExecStart = lib.strings.concatStringsSep " " [
        "${pkgs.nodejs}/bin/npx"
        "triplit dev"
        "--schemaPath src/data/schema-triplit.ts"
        "--dbPort 5431"
        "--storage memory"
      ];
      Restart = "on-failure";
    };
  };

  systemd.services.qbittorrent-nox = {
    description = "qBittorrent-NOX Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      ExecStart = lib.strings.concatStringsSep " " [
        # stdbuf is needed since qbittorrent-nox buffers its logs.
        "${pkgs.coreutils}/bin/stdbuf -oL -eL"
        "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=%h/.config"
      ];
      Restart = "on-failure";
    };
  };

  systemd.services.filebrowser = {
    description = "Filebrowser Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      WorkingDirectory = "%h/Public";
      # We need this since the binary also requires `getent`.
      Environment = "PATH=/run/current-system/sw/bin";
      ExecStart = lib.strings.concatStringsSep " " [
        "${pkgs.filebrowser}/bin/filebrowser"
        "--address 0.0.0.0"
        "--port 8081"
        "--username filebrowser"
      ];
      Restart = "on-failure";
    };
  };

  systemd.services.yarr = {
    description = "Yarr Daemon";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Environment = "HOME=/root";
      ExecStart = lib.strings.concatStringsSep " " [
        "${pkgs.yarr}/bin/yarr"
      ];
      Restart = "on-failure";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts."torrents.nguyenhuythanh.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8080
    '';
    virtualHosts."files.nguyenhuythanh.com".extraConfig = ''
      reverse_proxy 127.0.0.1:8081
    '';
    virtualHosts."feeds.nguyenhuythanh.com".extraConfig = ''
      reverse_proxy 127.0.0.1:7070
      basicauth /* {
          yarr $2a$14$OzGWTTtQzGtBwyJDVozKf.nEeQlQenemwZ8zv2W5oiAPLC8jRykSG
      }
    '';
    virtualHosts."notes-server.nguyenhuythanh.com".extraConfig = ''
      reverse_proxy 127.0.0.1:5432
    '';
    virtualHosts."cryptaa-server-demo.nguyenhuythanh.com".extraConfig = ''
      reverse_proxy 127.0.0.1:5431
    '';
    virtualHosts."webdav.nguyenhuythanh.com".extraConfig = ''
      reverse_proxy 127.0.0.1:6065
    '';
  };

  home-manager.users.root = {
    home.stateVersion = "24.05";
    home.file.".config/qBittorrent/config/qBittorrent.conf" = {
      text = builtins.readFile ./qBittorrent.conf;
      force = true;
    };
    home.file."Public/.exists".text = "";
    home.file.".config/yarr/.exists".text = "";
    # Incredibly hacky way to do this.
    # home.file."Sources/cryptaa".source = builtins.fetchGit "https://github.com/thanhnguyen2187/cryptaa";
  };
  system.stateVersion = "24.05";
}

