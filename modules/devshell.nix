{
  perSystem = {pkgs, ...}: {
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        nix
        nixos-rebuild
        home-manager
        sops
        nixd
        alejandra
      ];
    };
  };
}
