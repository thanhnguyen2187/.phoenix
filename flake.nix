{
  description = "My Home Manager configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { home-manager, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations.thanh = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./configs/draco.nix
      ];
    };
    nixosConfigurations.thanh = nixpkgs.lib.nixosSystem {
      # inherit pkgs system;
      system = "x86_64-linux";
      modules = [
        ./configs/draco-ossis.nix
      ];
    };
  };
}
