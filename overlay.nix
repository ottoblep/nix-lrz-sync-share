final: prev:
let
  inherit (final) callPackage;
in
{
  nix-lrz-sync-share = {
    lrz-sync-share = callPackage ./lrz-sync-share { };
  };
}
