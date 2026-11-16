{
  inputs,
  lib,
  config,
  ...
}: {
  imports = [inputs.flake-file.flakeModules.default];
  systems = config.flake.hosts |> lib.map (h: h.system) |> lib.unique;

  flake-file = {
    description = "Osama's NixOS configuration";
    auto-follow.enable = true;
    formatter = pkgs: pkgs.alejandra;
    inputs = {
      nixpkgs.url = lib.mkDefault "github:NixOS/nixpkgs/nixos-unstable";
      nixpkgs-lib.follows = "nixpkgs";
      flake-file.url = "github:denful/flake-file";
      import-tree.url = "github:denful/import-tree";
      flake-parts.url = "github:hercules-ci/flake-parts";
    };
  };
}
