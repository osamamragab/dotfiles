{ pkgs, config, ... }:
{
    home = {
        packages = [ pkgs.wget ];
        sessionVariables.WGETRC =
            if config.xdg.enable then
                "${config.xdg.configHome}/wget/wgetrc"
            else
                "${config.home.homeDirectory}/.wgetrc";
        file.${config.home.sessionVariables.WGETRC}.text = ''
            hsts-file=~/.cache/wget-hsts
        '';
    };
}
