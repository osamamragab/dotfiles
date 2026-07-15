{
    pkgs,
    lib,
    config,
    ...
}:
{
    home.packages = [
        pkgs.bluetui
    ];

    xdg.configFile."bluetui/config.toml" =
        let
            tomlFormat = pkgs.formats.toml { };
        in
        lib.mkIf (builtins.elem pkgs.bluetui config.home.packages) {
            source = tomlFormat.generate "config.toml" {
                width = "auto";
                layout = "SpaceAround";
                esc_quit = false;
                toggle_scanning = "s";
                adapter = {
                    toggle_pairing = "p";
                    toggle_power = "o";
                    toggle_discovery = "d";
                };
                paired_device = {
                    unpair = "u";
                    toggle_trust = "t";
                    toggle_favorite = "f";
                    rename = "e";
                };
            };
        };
}
