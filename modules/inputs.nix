{
  inputs,
  lib,
  ...
}: {
  imports = [inputs.flake-file.flakeModules.default];

  flake.inputs = inputs;

  flake-file = {
    description = "Osama's NixOS configuration";
    auto-follow.enable = true;
    formatter = pkgs: pkgs.alejandra;
    outputs = "dendritic";
    inputs = {
      nixpkgs.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-unstable";
      den.url = "github:denful/den/v0.20.0";
      flake-file.url = "github:denful/flake-file";
      import-tree.url = "github:denful/import-tree";
      flake-parts.url = "github:hercules-ci/flake-parts";
      home-manager.url = "github:nix-community/home-manager";
    };
  };
}
