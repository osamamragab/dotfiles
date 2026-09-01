{
  flake.aspects.shell = {
    homeManager =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        home = {
          shellAliases = {
            e = "\${EDITOR:-vi}";
            q = "exit";
            mkd = "mkdir -pv";
            cp = "cp -iv";
            ln = "ln -iv";
            mv = "mv -iv";
            rm = "rm -Iv";
            ls = "ls -hF --color=auto --group-directories-first";
            ll = "ls -lA";
            grep = "grep --color=auto";
            gr = "grep -Hnr";
            urls = "grep -aohE '(((http|https|gopher|gemini|ftp|ftps|git)://|www\\.)[a-zA-Z0-9.]*[:;a-zA-Z0-9./+@$&%?$\#=_~-]*)|((magnet:\\?xt=urn:btih:)[a-zA-Z0-9]*)'";
            ip = "ip -color=auto";
            diff = "diff --color=auto";
          };
        };
      };
  };
}
