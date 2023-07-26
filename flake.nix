{
  description = "Nix package for LRZ Sync+Share";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/release-23.05";

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.systems.flakeExposed;
    in
    rec {
      overlays.default = import ./overlay.nix;

      packages = forAllSystems
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
              overlays = builtins.attrValues overlays;
            };
          in
          pkgs.nix-lrz-sync-share
          // { default = pkgs.nix-lrz-sync-share.lrz-sync-share; }
        );
    };
}
