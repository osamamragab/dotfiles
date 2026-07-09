{ pkgs, ... }:
{
    home.packages = [ pkgs.wget ];
    home.sessionVariables.WGETRC = "$XDG_CONFIG_HOME/wget/wgetrc";
    xdg.configFile."wget/wgetrc".text = ''
        hsts-file=~/.cache/wget-hsts
    '';
}
