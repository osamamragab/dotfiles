{ pkgs, config, ... }:
{
    programs.password-store = {
        enable = true;
        package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
        settings = {
            PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";
            PASSWORD_STORE_GPG_OPTS = "--no-throw-keyids";
        };
    };
}
