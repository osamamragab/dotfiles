{
    pkgs,
    config,
    ...
}:
{
    programs.lf = {
        enable = true;
        package = pkgs.lf;
        settings = {
            shell = "sh";
            shellopts = "-eu";
            ifs = "\n";
            icons = true;
            period = 1;
            scrolloff = 10;
            cursorpreviewfmt = "\033[7;2m";
            autoquit = true;
            cleaner = "${config.programs.lf.package}/bin/lfcleaner";
            previewer = "${config.programs.lf.package}/bin/lfpreviewer";
        };
        keybindings = {
            H = "set hidden!";
            enter = "shell";
            esc = "!true";
            x = "$$f";
            X = "!$f";
            o = "open $f";
            D = "delete";
            delete = "delete";
            q = "quit";
            extract = "${config.programs.lf.package}/bin/lfextract $f";
        };
        commands = {
            open = "&open $f";
            q = "quit";
            extract = "${config.programs.lf.package}/bin/lfextract $f";
        };
    };
}
