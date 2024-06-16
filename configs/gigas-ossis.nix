{ inputs, lib, config, pkgs, ... }:
let 
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
    sha256 = "0jcwajzk7kvwb7crns5pw720hqp2y93fxd8ha533rygbqkgxxha9";
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
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCLtGjzMI2tgDgemd4UVFROrEvc9fR3ogxhrALbs/ehYuZi5wr0cCflKc8I8MYxrSdAk9pekYxBCBmqqrHWi6cmklcdUQVGbu/iXf6ZxfiyK93DmzIEnbOlbtw3y8atYd48mQzFTesC3k602DV77lWBWq09BxxozLL90I5A2uijWoE5R/nauuMqOyEncjXlVUynB9XFYjI+SHRXVOBLQPLfA/e17s2IR0md9iu7Hv7vurWyBJotYwvCuI9KV8Uc5p4D2ZrZ6HsS3JKF3+rXq10WDohm+NFl5hvPI8dRPO2yC2b8EB0RCGC8TuRtm6aa/H0/cJpk3WJT9KnwZeboGII1WWVk/QANBJbEhzJYybW7sbseVjWSb625xZ/CjmaGzqmOkRlOl4v733BIdKJbg1BHOKxpRdi80NbZ5VwkhqLs3IT2z8BlMrVW5bCxnpo/O0WTGEtmg0OmR6IhS4qtqgbdP4vSw9e+kqQSi3JYgMIMT1dM6Rov/O88vl+y0chS1gc= thanh@nixos''
    ''ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzKHwhyaPJpzSw+/gR6zMDEcZQF1SZfjrrr+6YzHyiIfAxczX1ovADtY2Nx0hRO+e/qjxv1tl0TV0BNFo7g5A+NO1/wYAAMcdj7h3j1cRDPwE6ljkvHHt5WWpnP57Bkx+nGAsvx2tHX//6IMRSPYKb1DTmHecjq/nRwpqC1MpF+9r4HbqEq5W53Clvq5kKPnNWIfnX90Dzgy4eTb6L50jwAs1MuttN9dahhtuEtmLlp3EsSuUsX/xHCLweNipMvr5lpS5tYaNHE/mNl3/QeHkMAznS48YC8UVR/7scdyPawvU2G6/lAqNv7i/k9m1q6InHrgeUSKpSjDOZZXdvtcoN33wR9ywzC0BCgBJ9qSXW949ig5+A5Ys3zHFTKTRI1zkzd64w1cCQbrq+dXZ5OZLXzV498CRD9wNx1f4g5hPj8yUJDNDVsABClsEe/rbeiBq3WXL4E/NXEYKp+GskxWSCPAFQ9qTKTz1n3PwIDPczxgMIa/ppZ+hRbd96tH9IoP8= thanh@nixos'' 
  ];

  environment.systemPackages = with pkgs; [
    vim
    git
    qbittorrent-nox
    filebrowser
    yarr
    nodejs
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
  };

  home-manager.users.root = {
    home.stateVersion = "23.11";
    home.file.".config/qBittorrent/config/qBittorrent.conf" = {
      text = builtins.readFile ./qBittorrent.conf;
      force = true;
    };
    home.file."Public/.exists".text = "";
    home.file.".config/yarr/.exists".text = "";
    # Incredibly hacky way to do this.
    # home.file."Sources/cryptaa".source = builtins.fetchGit "https://github.com/thanhnguyen2187/cryptaa";
  };
  system.stateVersion = "23.11";
}

