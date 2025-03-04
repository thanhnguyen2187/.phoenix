{
  description = "Personal declarative configuration files that shall rise from the ashes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-utils.url = "github:numtide/flake-utils";
    # claude-desktop = {
    #   url = "github:k3d3/claude-desktop-linux-flake";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
  };
  outputs = { home-manager, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.draco = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./configs/draco.nix
        # claude-desktop
      ];
    };
    nixosConfigurations.draco = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/draco-ossis.nix
      ];
    };

    homeConfigurations.vespertilio = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./configs/vespertilio.nix
      ];
    };
    nixosConfigurations.vespertilio = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/vespertilio-ossis.nix
      ];
    };

    nixosConfigurations.gigas = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/gigas-ossis.nix
      ];
    };
    nixosConfigurations.petram = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configs/petram-cor.nix
      ];
    };
  };
}
