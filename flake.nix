{
  description = "Personal declarative configuration files that shall rise from the ashes";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
  };
}
