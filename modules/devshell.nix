{
  perSystem = { pkgs, ... }: {
    formatter = pkgs.alejandra;
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
        git
        nixos-rebuild
        home-manager
        nixd
      ];
    };
  };
}
