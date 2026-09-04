{ inputs, lib, ... }: {
  systems = [ "x86_64-linux" ];
  imports = [ inputs.flake-file.flakeModules.default ];

  flake-file = {
    description = "Osama's NixOS configuration";
    auto-follow.enable = true;
    formatter = pkgs: pkgs.nixfmt;
    inputs = {
      nixpkgs.url = lib.mkDefault "github:NixOS/nixpkgs/nixpkgs-unstable";
      nixpkgs-lib.follows = "nixpkgs";
      flake-file.url = "github:denful/flake-file";
      import-tree.url = "github:denful/import-tree";
      flake-parts.url = "github:hercules-ci/flake-parts";
    };
  };
}
