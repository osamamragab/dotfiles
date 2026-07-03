{ pkgs, ... }:
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
            cleaner = "${pkgs.lf}/bin/lfcleaner";
            previewer = "${pkgs.lf}/bin/lfpreviewer";
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
            extract = "${pkgs.lf}/bin/lfextract $f";
        };
        commands = {
            open = "&open $f";
            q = "quit";
            extract = "${pkgs.lf}/bin/lfextract $f";
        };
    };
}
