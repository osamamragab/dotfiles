{ config, ... }:
{
    home = {
        shell = {
            enableZshIntegration = config.programs.zsh.enable;
            enableBashIntegration = config.programs.bash.enable;
            enableFishIntegration = config.programs.fish.enable;
            enableNushellIntegration = config.programs.nushell.enable;
        };
        shellAliases = {
            e="\${EDITOR:-vi}";
            q="exit";
            mkd="mkdir -pv";
            cp="cp -iv";
            ln="ln -iv";
            mv="mv -iv";
            rm="rm -Iv";
            ls="ls -hF --color=auto --group-directories-first";
            ll="ls -lA";
            grep="grep --color=auto";
            gr="grep -Hnr";
            ip="ip -color=auto";
            bc="bc -ql";
            diff="diff --color=auto";
            info="info --vi-keys";
            rsync="rsync -vrPlu";
            ffmpeg="ffmpeg -hide_banner";
            urls="grep -aohE '(((http|https|gopher|gemini|ftp|ftps|git)://|www\\.)[a-zA-Z0-9.]*[:;a-zA-Z0-9./+@$&%?$\#=_~-]*)|((magnet:\\?xt=urn:btih:)[a-zA-Z0-9]*)'";
            drag="dragon-drop -a -x";
            adb=''env HOME="$ANDROID_USER_HOME" adb'';
            mitmproxy=''mitmproxy --set confdir="$XDG_CONFIG_HOME/mitmproxy"'';
            mitmweb=''mitmweb --set confdir="$XDG_CONFIG_HOME/mitmproxy"'';
            emacs="emacsclient -nca emacs";
        };
    };
}
